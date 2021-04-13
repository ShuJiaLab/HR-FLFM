clear,clc
close all

load('cmap');
% load('gain');
% load('offset');

NA = 1.45;
Lambda = .680;
PxSize = .065;

% offset = 100;
% gain = 1;
load('./Calibration_Hamamatsu.mat')
% [row,col] = size(imread('../bead004um01FLFscan/dcam_45100.tif'));
%%
savefolder = '../bead004um01FLFscan_acsn_real/';
mkdir(savefolder)
warning off
for ii = 451%:1:550
disp(['Start processing PSF ',num2str(ii*100),'...'])
raw = double(loadtiff(['../bead004um01FLFscan/dcam_',num2str(ii*100),'.tif']));
acsn  = ACSN(raw,NA,Lambda,PxSize,'Offset',Offset,'Gain',Gain); 
% The first time the runtime can be longer if the parallel pool is not already active
% imwrite(uint16(acsn),[savefolder,'dcam_',num2str(ii*100),'.tif'])
disp(['PSF ',num2str(ii*100),'.tif denoised & saved!'])
end
%%
% figure;
% imagesc(imfuse(std(raw,[],3),std(acsn,[],3),'montage','Scaling','joint'));
% colormap(jet); axis off; axis image;
% title('TIRF image of HeLa microtubules - pixel fluctuation');

figure; 
imagesc(imfuse(raw(:,:,1),acsn(:,:,1),'montage'));
colormap(blow); axis off; axis image;
title('TIRF image of HeLa microtubules');