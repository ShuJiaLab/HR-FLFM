function Xguess = DeconvRL_4D_GPU_MARAR( OTF,INVOTF, maxIter, FLFimg )

% global zeroImageEx;
% global exsize;
% 
% xsize = [size( FLFimg,1), size( FLFimg,2)];
% msize = [size(PSF,1), size(PSF,2)];
% mmid = floor(msize/2);
% exsize = xsize + mmid;
% exsize = [ min( 2^ceil(log2(exsize(1))), 128*ceil(exsize(1)/128) ), min( 2^ceil(log2(exsize(2))), 128*ceil(exsize(2)/128) ) ];
% zeroImageEx = gpuArray(zeros(exsize, 'single'));
% disp(['FFT size is ' num2str(exsize(1)) 'X' num2str(exsize(2))]);
% 
% OTF = zeros(size(zeroImageEx,1), size(zeroImageEx,2), size(PSF,3),'single');
% INVOTF = zeros(size(zeroImageEx,1), size(zeroImageEx,2), size(PSF,3),'single');
% for cc = 1:size(PSF,3)
%     OTF(:,:,cc) = getOTFcpu(PSF(:,:,cc));
%     INVOTF(:,:,cc) = getOTFcpu(imrotate(PSF(:,:,cc),180));
% end
% disp('************* OTF got! *************');
FLFimg = gpuArray(FLFimg);

time_sum = 0;
Xguess = BackwardProj( INVOTF, FLFimg );

for i = 1:maxIter
    tic;
    FXguess       = ForewardProj(OTF, Xguess);
    fptime = toc;
    Project_Error = FLFimg./FXguess;
    Xguess_Error  = BackwardProj( INVOTF, Project_Error );
%     Xguess_Error(isnan(Xguess_Error)==1)=0;
    bptime = toc;
    Xguess        = Xguess .* Xguess_Error;
    Xguess(isnan(Xguess))=0;
    ttime = toc;
    time_sum  = ttime + time_sum;
    disp(['iter ' num2str(i) '|' num2str(maxIter) ', Fore: ' num2str(fptime) ' secs, ' ...
        'Back: ' num2str(bptime-fptime) ' secs, round: ' num2str(ttime) ' secs, ' ...
        'total: ' num2str(time_sum) ' secs.']);
end

end

function BackProj = BackwardProj(INVOTF,FLFimg)
global zeroImageEx;
FLFsize = size(FLFimg);
FLFimg = zeroPad(FLFimg, zeroImageEx);
BackProj = gpuArray.zeros(FLFsize(1), FLFsize(2), size(INVOTF,3) , size(INVOTF,4), 'single');
% time0 = toc;
for dd = 1:size(INVOTF,4)
    for cc = 1:size(INVOTF,3)   
        tempOTF = gpuArray(INVOTF(:,:,cc,dd));
        tempProj = real(ifft2(tempOTF.*fft2(FLFimg)));
        tempProj = tempProj(1:FLFsize(1),1:FLFsize(2));
        BackProj(:,:,cc,dd) = tempProj;
    end
end
% disp(toc - time0)
end

function ForeProj = ForewardProj(OTF,OBJimg)
global zeroImageEx;
OBJsize = size(OBJimg);
ForeProj = gpuArray.zeros(OBJsize(1), OBJsize(2),'single');
for dd = 1:size(OTF,4)
    for cc = 1:size(OTF,3) 
        tempOTF = gpuArray(OTF(:,:,cc,dd));
        OBJpad = zeroPad(OBJimg(:,:,cc,dd),zeroImageEx);
        tempProj = real(ifft2(tempOTF.*fft2(OBJpad)));
        ForeProj = ForeProj + tempProj(1:OBJsize(1), 1:OBJsize(2));
    end
end
end