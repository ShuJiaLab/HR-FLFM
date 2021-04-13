function [img, sigma,I1] = ACSN_core(I,NA,Lambda,PixelSize,Gain,Offset,Hotspot,Level,Mode,SaveFileName) %#ok<INUSL>


% OTF radius
R = 2*NA/Lambda*PixelSize*size(I,1);
adj = 1.1;
R2 = (.5*size(I,1)*adj);
% multiplicative factor to adjust the sigma of the noise
ratio = sqrt(R2/abs(R-R2));

% rescaling
I1 = (I-Offset)./Gain;
I1(I1<=0) = 1e-6;

%% Remove hot spots
if Hotspot==1
    
    % Fourier filter
    R1 = min(R,size(I1,1)/2);
    [~,high] = Gaussian_image_filtering(I1,'Step',R1);
    % Median filter
    I1b = padarray(I1,[2 2],'replicate');
    I_med = medfilt2(I1b);
    I_med(1:2,:) = [];
    I_med(:,1:2) = [];
    I_med(end-1:end,:) = [];
    I_med(:,end-1:end) = [];
    
    I1(abs(high)>abs(mean2(high)+3.*std2(high))) = I_med(abs(high)>abs(mean2(high)+3.*std2(high)));
    
    I1(I1<=0) = 1e-6;
end

%% Fourier filter 2
R1 = min(R,size(I1,1)/2);
[~,high] = Gaussian_image_filtering(I1,'Step',R1);

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
w = 1; 
sigma = w*ratio*a; %#ok<SAGROW>

%% normalization
M1 = max(max(I1));
M2 = min(min(I1));
I2 = (I1 - M2)./(M1 -M2);

%% Denoising

% scaling sigma for non-8 bit images
if (M1-M2)>255
    sigma = sigma/(M1-M2)*255;
end


[~, img0] = Sparse_filtering([],I2,sigma,'np');

img = (img0).*(M1-M2)+ M2;



%%
% Save image (if mode == 'Save')
if strcmp(Mode,'Save')
    options.append = true;
    options.message = false;
    options.big = false;
    
    saveastiff(uint16(img),SaveFileName,options);
end

end