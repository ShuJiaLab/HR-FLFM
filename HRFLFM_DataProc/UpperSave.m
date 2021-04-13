function selpath = UpperSave(selpath,filename,img,suffix)
%CUTSAVE Summary of this function goes here
%   Detailed explanation goes here

mkdir([selpath,'_',suffix,'\'])
%     disp([selpath,'_cut\',char(filenames(i))])
    try
        imwrite(img,[selpath,'_',suffix,'\',char(filename)])
        disp(['Saved! (.\..._',suffix,'\',char(filename)])
    catch
        disp('Image Unsaved :-( ')
    end
end

