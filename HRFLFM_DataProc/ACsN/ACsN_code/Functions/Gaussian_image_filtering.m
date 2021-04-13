%---------------------------------------------------------%
%--Gaussian High pass and Low pass filter--------------------%
%---------------------------------------------------------%


function [low,high] = Gaussian_image_filtering(I,varargin)
% clc
% close all
% clear all
%
% RGB=imread('Your Image');
%
% I=rgb2gray(RGB); % convert the image to grey

R=10; % filter size parameter
Mode = 'Gauss';
if ~isempty(varargin{1})
    Mode = varargin{1};
end

if ~isempty(varargin{2})
    R = varargin{2};
end

A = fft2(double(I)); % compute FFT of the grey image
A1=fftshift(A); % frequency scaling


% Gaussian Filter Response Calculation

[M N]=size(A); % image size

X=0:N-1;
Y=0:M-1;
[X Y]=meshgrid(X,Y);
Cx=0.5*N;
Cy=0.5*M;

Lo = zeros(size(A));
Hi = ones(size(A));

switch Mode
    
    case 'Gauss'
        Lo=exp(-((X-Cx).^2+(Y-Cy).^2)./(2*R).^2);
        Hi=1-Lo; % High pass filter=1-low pass filter
    
    case 'Step' % Step-like filter
        
        Lo(((X-Cx).^2+(Y-Cy).^2)<=(R.^2)) = 1 ;
        Hi = 1-Lo;

end

% Filtered image=ifft(filter response*fft(original image))

J=A1.*Lo;
J1=ifftshift(J);
B1=ifft2(J1);

K=A1.*Hi;
K1=ifftshift(K);
B2=ifft2(K1);


low = abs(B1);
high = abs(B2);

%----visualizing the results----------------------------------------------

% figure(1)
% imshow(I);colormap gray
% title('original image','fontsize',14)
%
% figure(2)
% imshow(abs(A1),[-12 300000]), colormap gray
% title('fft of original image','fontsize',14)
%
%
% figure(3)
% imshow(abs(B1),[12 290]), colormap gray
% title('low pass filtered image','fontsize',14)
%
%
% figure(4)
% imshow(abs(B2),[12 290]), colormap gray
% title('High pass filtered image','fontsize',14)
%
% figure(5)
%    mesh(X,Y,Lo)
%    axis([ 0 N 0 M 0 1])
%    h=gca;
%    get(h,'FontSize')
%    set(h,'FontSize',14)
%    title('Gaussiab LPF H(f)','fontsize',14)
%
%
% figure(6)
%    mesh(X,Y,Hi)
%    axis([ 0 N 0 M 0 1])
%    h=gca;
%    get(h,'FontSize')
%    set(h,'FontSize',14)
%    title('Gaussian HPF H(f)','fontsize',14)
%

%-------------------------------------------------------------------------

end