close all

load('cmap');
load('gain');
load('offset');

NA = 1.45;
Lambda = .680;
PxSize = .065;

%%
raw = double(loadtiff('TIRF_01_10ms.tif'));
% raw = double(loadtiff('TIRF_01_05ms.tif'));
% raw = double(loadtiff('TIRF_02_10ms.tif'));
% raw = double(loadtiff('TIRF_02_05ms.tif'));

acsn  = ACSN(raw,NA,Lambda,PxSize,'Offset',offset,'Gain',gain); 
% The first time the runtime can be longer if the parallel pool is not already active

%%
figure;
imagesc(imfuse(std(raw,[],3),std(acsn,[],3),'montage','Scaling','joint'));
colormap(jet); axis off; axis image;
title('TIRF image of HeLa microtubules - pixel fluctuation');

figure; 
imagesc(imfuse(raw(:,:,1),acsn(:,:,1),'montage'));
colormap(blow); axis off; axis image;
title('TIRF image of HeLa microtubules');

