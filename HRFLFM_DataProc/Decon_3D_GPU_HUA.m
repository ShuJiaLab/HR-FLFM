clearvars -except H_PSF_Norm_cut_3X3 OTF INVOTF
clc
close all;
H_PSF_Norm_cut_3X3 = [];
% load('Z:/Xuanwen/PetitScholar/LFrecon/original/PSFMatrix_3D/FMLF_PSF_100XNA145_Num71_H_Ht_3X3.mat');
if isempty(H_PSF_Norm_cut_3X3)
    load('./FLFPSF.mat');
    H_PSF_Norm_cut_3X3 = single(FLFPSF(:,:,:));
    clearvars FLFPSF
    Depth_Size   = size(H_PSF_Norm_cut_3X3,3);
%     figure(1000);
%     imshow( uint16(H_PSF_Norm_cut_3X3(:,:,round(Depth_Size/2))*1) );
end
disp(['PSF ','FLFPSF_bead500nm01.mat',' read!'])
% load('Z:/Xuanwen/PetitScholar/LFrecon/original/ProjectionImage_2D/3DMatrix.mat');
global PSFnum
PSFnum = 50000;
load(['./dcam_50000.tif_avg.mat']);
Image_bead_sub_downsampled_norm = single(imcut);
clearvars imcut
% figure(2000);
% imshow( uint16( Image_bead_sub_downsampled_norm(:,:,1)*1 ) )
disp(['FLF_image ','FLF_',num2str(PSFnum),'.mat',' read!'])
%% ======================= Exp Project Image End   ==================================
disp('Data loaded...');
global zeroImageEx;
global exsize;

xsize = [size( Image_bead_sub_downsampled_norm,1), size( Image_bead_sub_downsampled_norm,2)];
msize = [size(H_PSF_Norm_cut_3X3,1), size(H_PSF_Norm_cut_3X3,2)];
mmid = floor(msize/2);
exsize = xsize + mmid;
exsize = [ min( 2^ceil(log2(exsize(1))), 128*ceil(exsize(1)/128) ), min( 2^ceil(log2(exsize(2))), 128*ceil(exsize(2)/128) ) ];
zeroImageEx = gpuArray(zeros(exsize, 'single'));
disp(['FFT size is ' num2str(exsize(1)) 'X' num2str(exsize(2))]);
OTF = [];
if isempty(OTF)
    OTF = zeros(size(zeroImageEx,1), size(zeroImageEx,2), size(H_PSF_Norm_cut_3X3,3),'single');
    INVOTF = zeros(size(zeroImageEx,1), size(zeroImageEx,2), size(H_PSF_Norm_cut_3X3,3),'single');
    for cc = 1:size(H_PSF_Norm_cut_3X3,3)
        OTF(:,:,cc) = getOTFcpu(H_PSF_Norm_cut_3X3(:,:,cc));
        INVOTF(:,:,cc) = getOTFcpu(imrotate(H_PSF_Norm_cut_3X3(:,:,cc),180));
    end
    OTF = gpuArray(OTF);
    INVOTF = gpuArray(INVOTF);
end
disp('************* OTF got! *************');
%% ======================= 3D Reconstruction Start ==================================
% Xguess  = DeconvRL_3D_GPU_HUAint( H_PSF_Norm_cut_3X3, 2, Image_bead_sub_downsampled_norm );
Xguess  = DeconvRL_3D_GPU_HUA( OTF,INVOTF, 20, Image_bead_sub_downsampled_norm );
% Xguess  = DeconvRL_3D_GPU_HUAint( H_PSF_Norm_cut_3X3, 10, Image_bead_sub_downsampled_norm );
Xguess = gather(Xguess);
Xguess_norm = Xguess/max(Xguess(:))*255;

% figure(1003);
% imshow( uint8(Xguess_norm(:,:,51)/max(max(Xguess_norm(:,:,51)))*255) )


%  figure(1004);
%     p1 = patch(isosurface(Xguess_norm,35), 'FaceColor','red','EdgeColor','none');
%     p2 = patch(isocaps(Xguess_norm,35),    'FaceColor','interp','EdgeColor','none');
%     isonormals(Xguess_norm,p1)
%     daspect([.05,.05,0.08]);
%     alpha(0.5)
%     view(3); axis vis3d tight
%     camlight; lighting phong


%%
mkdir('reconstructed')
ReconStack_Folder = './reconstructed/';

for depth_index  = 1:100%round(size( Xguess_norm , 3 )/2)-10:round(size( Xguess_norm , 3 )/2)+10
    Xguess_norm_re = imresize( Xguess_norm , 275/117);
    Temp = Xguess_norm_re( round(size(Xguess_norm_re,1)/2)-100:round(size(Xguess_norm_re,1)/2)+100, ...
        round(size(Xguess_norm_re,2)/2)-100:round(size(Xguess_norm_re,2)/2)+100, depth_index);
%     Temp = Temp/max(Temp(:))*255;
    imwrite( uint8( Temp ), [ReconStack_Folder  'Tiff_3D_50000_iter10.tif'], 'WriteMode', 'append');
%     disp(depth_index)
end
%%======================= 3D Reconstruction End ==================================