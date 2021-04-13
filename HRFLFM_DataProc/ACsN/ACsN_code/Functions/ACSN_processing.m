% Start progress bar
textprogressbar('Processing: ');


for frame = 1:size(I,3)
    
    [img(:,:,frame), sigma(frame),I1] = ACSN_core(I(:,:,frame),NA,Lambda,PixelSize,Gain,Offset,Hotspot,Level,Mode,SaveFileName);
    
    if QM(1)=='y'
        Qmap(:,:,frame) = Quality_Map(img(:,:,frame),I1);
    end
    
    Qscore(frame) = metric(I1(:,:,frame),img(:,:,frame));
    
    % Update progress bar
    textprogressbar(frame/size(I,3).*100)
    
    
end

clear I1

textprogressbar(' Done!');
