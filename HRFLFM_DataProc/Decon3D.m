function [PSFpath,FLFMpath] = Decon3D(PSFpath,FLFMpath,Reconpath,Iter)
%DECON3D Summary of this function goes here
%   Detailed explanation goes here
load(PSFpath,'FLFPSF');
% for ii = 1:1:size(FLFPSF,3)
%     FLFPSF(:,:,ii) = FLFPSF(:,:,ii)/max(max(FLFPSF(:,:,ii)))*65535;
% end
FLFPSF = single(FLFPSF);
Depth_Size = size(FLFPSF,3);
disp(['PSF [',PSFpath,'] read!',' Total layers: ',num2str(Depth_Size)])
%% load BP PSF
% PSFpath_split = split(PSFpath,"\");
% PSFpath_split{end} = (['WB_',char(PSFpath_split{end})]);
% disp(string(PSFpath_split))
% BPPSFpath = join(string(PSFpath_split),"\");
% load(BPPSFpath,'FLFPSF2');
% FLFPSF2 = single(FLFPSF2);
% disp(['PSF [',BPPSFpath,'] read!'])
%% Generate OTF
global zeroImageEx;
global exsize;

xsize = [size( FLFPSF,1), size( FLFPSF,2)]; % Here we assume the sizes of PSF and FLFM are the same
% Otherwise, You need to replace 'FLFPSF' with 'imcut'(FLFM IMG) variable name
msize = [size(FLFPSF,1), size(FLFPSF,2)];
mmid = floor(msize/2);
exsize = xsize + mmid;
exsize = [ min( 2^ceil(log2(exsize(1))), 128*ceil(exsize(1)/128) ), min( 2^ceil(log2(exsize(2))), 128*ceil(exsize(2)/128) ) ];
zeroImageEx = gpuArray(zeros(exsize, 'single'));
disp(['FFT size is ' num2str(exsize(1)) 'X' num2str(exsize(2))]);
% OTF = [];
% alpha = 0.05;
% beta = 1;
% n = 10;
% if isempty(OTF)
OTF = zeros(size(zeroImageEx,1), size(zeroImageEx,2), size(FLFPSF,3),'single');
INVOTF = zeros(size(zeroImageEx,1), size(zeroImageEx,2), size(FLFPSF,3),'single');
for cc = 1:size(FLFPSF,3)
    OTF(:,:,cc) = getOTFcpu(FLFPSF(:,:,cc));
            INVOTF(:,:,cc) = getOTFcpu(imrotate(FLFPSF(:,:,cc),180));
%     INVOTF(:,:,cc) = WBgetOTFcpu(imrotate(FLFPSF(:,:,cc),180),alpha,beta,n);
%     INVOTF(:,:,cc) = BPgetOTFcpu(imrotate(FLFPSF2(:,:,cc),180));
end
OTF = gpuArray(OTF);
INVOTF = gpuArray(INVOTF);
% end
for ii = 1:1:size(OTF,3)
    OTF(:,:,ii) = OTF(:,:,ii)/max(max(OTF(:,:,ii)));
    INVOTF(:,:,ii) = INVOTF(:,:,ii)/max(max(INVOTF(:,:,ii)));
end
% OTF = OTF/max(max(max(OTF)))*60000;
% INVOTF = INVOTF/max(max(max(INVOTF)))*60000;
disp('************* OTF got! *************');
%% ======================= 3D Reconstruction Start ==================================
FLFMfiles = dir(FLFMpath);
h = split(FLFMpath,'\');
FLFMfolder = [char(h(end-1)),'_',char(h(end))];
h = split(PSFpath,'\');
PSFfolder = char(h(end));
mkdir([Reconpath,'\',PSFfolder(1:end-4),'-',FLFMfolder])
for i = 3:1:length(FLFMfiles)
    if strcmp(FLFMfiles(i).name(end-3:end),'.mat')
        load([FLFMpath,'\',FLFMfiles(i).name],'imcut');
        imcut = single(imcut);
        imcut = imcut/max(max(imcut))*60000;
        disp(['FLFM IMG [',FLFMfiles(i).name,'] read!'])
        
        Xguess  = DeconvRL_3D_GPU_HUA( OTF,INVOTF, Iter, imcut );
        Xguess = gather(Xguess);
        Xguess_norm = Xguess/max(Xguess(:))*65535;
        
        %% Save reconstructed images
        Xguess_norm_re = imresize( Xguess_norm , 275/123);
        for depth_index  = 1:Depth_Size
            if depth_index ==1
                t = Tiff([Reconpath,'\',PSFfolder(1:end-4),'-',FLFMfolder,'\',FLFMfiles(i).name(1:end-4),'iter',num2str(Iter),'.tif'],'w');
            else
                t = Tiff([Reconpath,'\',PSFfolder(1:end-4),'-',FLFMfolder,'\',FLFMfiles(i).name(1:end-4),'iter',num2str(Iter),'.tif'],'a');
            end
            t.setTag('ImageLength', size(Xguess_norm_re,1));
            t.setTag('ImageWidth',  size(Xguess_norm_re,2));
            t.setTag('Photometric', Tiff.Photometric.MinIsBlack);
            t.setTag('Compression', Tiff.Compression.None);
            t.setTag('BitsPerSample', 16);
            t.setTag('SamplesPerPixel', 1);
            t.setTag('PlanarConfiguration', Tiff.PlanarConfiguration.Chunky);
            t.write( uint16(Xguess_norm_re(:,:,depth_index)));
            t.close;
%             disp(depth_index)
        end
    end
end
end
