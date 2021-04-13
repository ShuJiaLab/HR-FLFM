function [imgout,background] = BKGsub_rollingball(img,radius,lightbkg,isparaboloid,ispresmooth)
%BKGSUB_ROLLINGBALL Summary of this function goes here
%   Detailed explanation goes here
% img:              input image
% radius:           The radius of the rolling ball
% lightbkg:
% isparaboloid:
% ispresmooth:      if smooth the img before processing?
%% format parameters
if nargin<2
    error("No enough arguments. The function should have at least two arguments (img, radius).")
elseif nargin<3
    lightbkg = false;
    isparaboloid = false;
    ispresmooth = false;
elseif nargin<4
    isparaboloid = false;
    ispresmooth = false;
elseif nargin<5
    ispresmooth = false;
end
imgclass = string(class(img));
imgdouble = double(img); % Set the image data type as "double"
%% display parameters
[RowOfImg,ColOfImg] = size(img);
disp(['The input image size is ',num2str(RowOfImg),' x ',num2str(ColOfImg),' in type of ',char(imgclass),'.'])
disp(['radius: ',num2str(radius),', light background: ',num2str(lightbkg),','])
disp(['Use paraboloid? : ',num2str(isparaboloid),', Use presmooth? : ',num2str(ispresmooth),'.'])
disp('----------------------------------------')
%% Use presmooth?
if ispresmooth
    filterwindow = 3;
    imgdoubleout = imfilter(imgdouble,ones(filterwindow)/(filterwindow^2),'same');
else
    imgdoubleout = imgdouble;
end
%% Use paraboloid?
if ~isparaboloid
    [balldata,ballwidth,ballshrinkfactor] = rolling_ball(radius);
    ball = {balldata,ballwidth,ballshrinkfactor};
    imgdoubleout = BKGsub_rollingball_core(imgdoubleout,imgclass,ball,lightbkg);
else
    imgdoubleout = BKGsub_slidingparaboloid_core(imgdoubleout,imgclass,radius,lightbkg);
end
background = imgdoubleout;
switch imgclass
    case "double"
        background = imgdoubleout/max(imgdoubleout(:));
    case "uint8"
        background = uint8(imgdoubleout/max(imgdoubleout(:))*255);
    case "uint16"
        background = uint16(imgdoubleout/max(imgdoubleout(:))*65535);
end
%% Setup offset and data
maxvalue = max(imgdouble(:))*double(imgclass=='double')+...
    255*double(imgclass=='uint8')+65535*double(imgclass=='uint16');
% disp([size(imgdouble);size(imgdoubleout)])
imagedata = imgdouble-imgdoubleout+maxvalue*double(lightbkg);
imagedata = imagedata .*double(imagedata>=0);
imagedata = (imagedata-maxvalue).*((imagedata-maxvalue)<=0)+maxvalue;
imgout = imagedata;
switch imgclass
    case "double"
        imgout = imagedata/max(imagedata(:));
        disp("Output: double.")
    case "uint8"
        imgout = uint8(imagedata/max(imagedata(:))*255);
        disp("Output: uint8.")
    case "uint16"
        imgout = uint16(imagedata/max(imagedata(:))*65535);
        disp("Output: uint16.")
end
end