function [ StrSim ] = SSIM(a,b)
%SSIM Implementation of the similarity comparision in SSIM
%--------------------------------------------------------------------------
% Input:    intensity image a and b; patch size w.
% Output:   struction similarity StrSim. 
%--------------------------------------------------------------------------
% Details can be found in the authors' original paper: 
% Z.Wang, A.Bovik, H.Sheikh and E.Simoncelli, "Image quality assessment: 
% From error visibility to structural similarity," IEEE Transactions on 
% Image Processing, vol. 13, no. 4, pp. 600-612, Apr. 2004.
%--------------------------------------------------------------------------
c = 2e-4;    %small constant
w = 8;       %patch size
h =fspecial('average',[w,w]);
h = h/sum(sum(h));

mu1     = filter2(h, a, 'valid');
mu2     = filter2(h, b, 'valid');
mu1_sq  = mu1.*mu1;
mu2_sq  = mu2.*mu2;
mu1_mu2 = mu1.*mu2;

sigma1_sq = filter2(h, a.*a, 'valid') - mu1_sq;
sigma2_sq = filter2(h, b.*b, 'valid') - mu2_sq;

sigma12 = filter2(h, a.*b, 'valid') - mu1_mu2;
StrSim  = (sigma12 + c)./(sqrt(sigma1_sq.*sigma2_sq)+c);