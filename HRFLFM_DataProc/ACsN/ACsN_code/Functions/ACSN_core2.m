function [img, sigma,I0] = ACSN_core2(I,NA,Lambda,PixelSize,Gain,Offset,window,Hotspot,Level,Mode,SaveFileName) %#ok<INUSL>


% OTF radius
R = 2*NA/Lambda*PixelSize*size(I,1);
adj = 1.1;
R2 = (.5*size(I,1)*adj);
% multiplicative factor to adjust the sigma of the noise
ratio = sqrt(R2/abs(R-R2));

% rescaling
I0 = (I-Offset)./Gain;
I0(I0<=0) = 1e-6;

%% Remove hot spots
if Hotspot==1
    
    % Fourier filter
    R1 = min(R,size(I0,1)/2);
    [~,high0] = Gaussian_image_filtering(I0,'Step',R1);
    % Median filter
    I1b = padarray(I0,[2 2],'replicate');
    I_med = medfilt2(I1b);
    I_med(1:2,:) = [];
    I_med(:,1:2) = [];
    I_med(end-1:end,:) = [];
    I_med(:,end-1:end) = [];
    
    I0(abs(high0)>abs(mean2(high0)+3.*std2(high0))) = I_med(abs(high0)>abs(mean2(high0)+3.*std2(high0)));
    
    I0(I0<=0) = 1e-6;
end

%% Fourier filter 2
R1 = min(R,size(I0,1)/2);
[~,high0] = Gaussian_image_filtering(I0,'Step',R1);

%% Tiling

size_y = min(window,size(I,1));
size_x = min(window,size(I,2));
size_z = 1;
overlap = 5;

Tiles = im2tiles(I0,overlap,size_x,size_y,size_z);
Tiles_high = im2tiles(high0,overlap,size_x,size_y,size_z);

parfor j = 1:numel(Tiles)
    
    I1 = Tiles{j};
    high = Tiles_high{j};
    
    %% Evaluation of sigma
    [Values, BinCenters] = hist(high(:));
    bins = BinCenters;
    
    [~, first_min] = min(Values);
    a1_est = bins(round(first_min/2));
    a0_est = max(Values);
    
    fo = fitoptions('Method','NonlinearLeastSquares',...
        'StartPoint',[a0_est a1_est]);
    ft = fittype('a0*exp(-(1/2)*((x)/a1)^2)','options',fo);
    [curve] = fit(bins',Values',ft);
    
    a = curve.a1;
    w = 1.5;
    sigma(j) = w*ratio*a; %#ok<*AGROW,SAGROW>
    
    %% normalization
    M1 = max(max(I1));
    M2 = min(min(I1));
    I2 = (I1 - M2)./(M1 -M2);
        
    %% Denoising
    
    % scaling sigma for non-8 bit images
    if (M1-M2)>255
        sigma(j) = sigma(j)/(M1-M2)*255;
    end
    
    
    [~, img0] = Sparse_filtering([],I2,sigma(j),'np');
    
    Tiles{j} = (img0).*(M1-M2)+ M2;
    
end

img = tiles2im(Tiles,overlap);

%%
% Save image (if mode == 'Save')
if strcmp(Mode,'Save')
    options.append = true;
    options.message = false;
    options.big = false;
    
    saveastiff(uint16(img),SaveFileName,options);
end

end