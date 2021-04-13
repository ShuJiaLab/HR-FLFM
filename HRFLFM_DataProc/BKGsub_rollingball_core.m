function imgout = BKGsub_rollingball_core(img,imgclass,ball,lightbkg)
%BKGSUB_ROLLINGBALL_CORE Summary of this function goes here
%   Detailed explanation goes here
maxvalue = max(img(:))*double(imgclass=='double')+255*double(imgclass=='uint8')+65535*double(imgclass=='uint16');
if lightbkg
    img = maxvalue-img;
end
smallimg = imresize(img,1/ball{3});
%% roll ball
[Height,Width] = size(img);
[sHeight,sWidth] = size(smallimg);
zball = ball{1};
ballwidth = ball{2};
radius = floor(ballwidth/2);
% temp = zeros();
smallimg_ext = padarray(smallimg,[radius,radius],'symmetric','both');
smallimg_dst = 0.*smallimg;
% z_reg = 0;
for ii = 1:sHeight
    for jj = 1:sWidth
        z = min(min(smallimg_ext(ii:ii+ballwidth-1,jj:jj+ballwidth-1)-zball));
%         if z~=0
%             z_reg = z;
%         end
        smallimg_dst(ii,jj) = max(max(z+zball));   
    end
end
%% enlarge image
img = imresize(smallimg_dst,[Height,Width]);
maxvalue = max(img(:))*double(imgclass=='double')+...
    255*double(imgclass=='uint8')+65535*double(imgclass=='uint16');
if lightbkg
    img = maxvalue-img;
end
imgout = img;
end
