
% Start progress bar
textprogressbar('Processing: ');


for frame = 1:size(I,3)
    
    [img(:,:,frame), sigma(frame),I1(:,:,frame)] = ACSN_core(I(:,:,frame),NA,Lambda,PixelSize,Gain,Offset,Hotspot,Level,Mode,SaveFileName);
    
    % Update progress bar
    textprogressbar(frame/size(I,3).*100)
    
end

textprogressbar(' Done!');

if Video(1) ~= 'n'
    
    nf = 5;
    check = zeros(1,size(img,3)-nf);
    
    if Video(1) ~= 'y'
        for ii = 1:size(img,3)-nf
            check(ii) = psnr(img(:,:,ii),mean(img(:,:,ii:ii+nf),3),max(max(img(:,:,ii))));
        end
    end
    
    check = mean(check);
    %         disp(check);
    
    if check < 35 || Video(1) == 'y'
        disp('Please wait... Additional 3D denoising required')
        psd = mean(sigma).*ones(8);
        
        sType = 2;
        
        
        if sum(size(img)>[256 256 20])  % [256 256 20]
            
            size_y = min(200,size(img,1));
            size_x = min(200,size(img,2));
            size_z = min(100,size(img,3));
            overlap = 5;
            
            Tiles = im2tiles(img,overlap,size_x,size_y,size_z);
            for idx = 1:numel(Tiles)
                Tiles{idx} = Video_filtering_t(Tiles{idx},psd,psd,'dct',0,1,sType,'np',0);
            end
            img = tiles2im(Tiles,overlap);
            clear Tiles;
            
        else
            
            img = Video_filtering_t(img,psd,psd,'dct',0,1,sType,'np',0);
            
        end
        
        for i = 1:size(img,3)
            
            M1 = max(max(img(:,:,i)));
            M2 = min(min(img(:,:,i)));
            img(:,:,i) = (img(:,:,i) - M2)./(M1 -M2);
            img(:,:,i) = Video_filtering_xy(img(:,:,i),sigma);
            img(:,:,i) = (img(:,:,i)).*(M1-M2)+ M2;
            
        end
    end
end


for i = 1:size(img,3)
    Qscore(i) = metric(I1(:,:,i),img(:,:,i));
    if QM(1)=='y'
        Qmap(:,:,i) = Quality_Map(img(:,:,i),I1(:,:,i));
    end
end

clear I1

disp('Done!');
