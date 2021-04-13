%% CAMERA CALIBRATION
% This script evaluates the offset and gain maps of a digital camera
% according to the procedure reported in [1]. Other useful information for
% an accurate gain calibration can be found in [2].
%
% Please, be aware that some sCMOS cameras have two gain regimes (low and
% high intensity), in which case two different gain maps should be
% produced. Refer to the camera manual or manufacturer's website for more
% specific information about your device.
%
% [1] Huang, F., Hartwich, T., Rivera-Molina, F. et al. Video-rate
%     nanoscopy using sCMOS camera–specific single-molecule localization
%     algorithms. Nat Methods 10, 653–658 (2013).
%     https://doi.org/10.1038/nmeth.2488
%
% [2] James R. Janesick, Photon Transfer, SPIE (2007)
%     https://doi.org/10.1117/3.725073 

%% Offset and Variance

% Offset and Variance calibration is performed evaluating respectively
% average and variance of one or more data stacks acquired with no light
% entering the camera.

% This code assumes that all data stacks for Offset and Variance
% calibration share the same initials. However this can be changed by
% modifying the argument of dir function.
[file,path] = uigetfile('*.tif*');
if isequal(file,0)
    disp('User selected Cancel');
    return
else
    D = dir([path, file(1:4), '*.tif*']);
    L = length(D);
    for i = 1:L
        disp(['Loading ', fullfile(path,D(i).name)]);
        im = double(loadtiff(fullfile(path,D(i).name)));
        Offset(:,:,i) = mean(im,3); %#ok<*SAGROW>
        Variance(:,:,i) = var(im,[],3);
    end
end

Offset = mean(Offset,3);
Variance = mean(Variance,3);

save('Camera_Calibration','Offset','Variance');

%% Gain calibration

% Here the code assumes that the data for gain calibration have been saved
% in different folders, one for each different illumination intensity and in
% .tiff files that begin with 'Gain'. However, this can be changed by modifying
% the argument of the dir function.
    
% N is the number of light levels used for gain calibration
N = 10; 

G = zeros(size(Offset,1),size(Offset,2),N);
V = zeros(size(Offset,1),size(Offset,2),N);
        
for i = 1:N
    [file,path] = uigetfile('*.tif*');
    if isequal(file,0)
        disp('User selected Cancel');
        return
    else
        D = dir([path, file(1:4), '*.tif*']);
        L = length(D);
        
        G_temp = zeros(size(Offset,1),size(Offset,2),L);
        V_temp = zeros(size(Offset,1),size(Offset,2),L);
        
        for k = 1:L
            im = double(loadtiff(fullfile(path,D(k).name)));
            G_temp(:,:,k) = mean(im,3);
            V_temp(:,:,k) = var(im,[],3);
        end
        
        G(:,:,i) = mean(G_temp,3);
        V(:,:,i) = mean(V_temp,3);
        
        clear G_temp V_temp
    end
end

row = size(G,1);
col = size(G,2);
Gain = zeros(row,col);

for i = 1:row
    for j = 1:col
        
        A = (squeeze(V(i,j,:) - Variance(i,j)));
        
        B = (squeeze(G(i,j,:) - Offset(i,j)));
        
        Gain(i,j) = lsqminnorm(B,A);
        
    end
end

save('Camera_Calibration','Gain','-append');
