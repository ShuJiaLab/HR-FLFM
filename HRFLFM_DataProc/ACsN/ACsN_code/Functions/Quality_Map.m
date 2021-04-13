function [Qmap] = Quality_Map(img,ref)


blockSize = 32;

size_y = min(blockSize,size(img,1));
size_x = min(blockSize,size(img,2));
size_z = 1;

Tiles_img = im2tiles(img,size_x,size_y,size_z);
Tiles_ref = im2tiles(ref,size_x,size_y,size_z);



for idx = 1:numel(Tiles_img)
      
    n1 = metric(255.*nrm(Tiles_ref{idx}),255.*nrm(Tiles_img{idx}));
    Tiles_img{idx} = n1.*ones(size(Tiles_img{idx}));
    
end

Qmap = cell2mat(Tiles_img);

end