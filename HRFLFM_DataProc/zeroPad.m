function xout = zeroPad(xin, zeroImage)

xout = zeroImage;
for cc = 1:size(zeroImage,3)
    xout( 1:size(xin,1), 1:size(xin,2),cc) = xin(:,:,cc);
end