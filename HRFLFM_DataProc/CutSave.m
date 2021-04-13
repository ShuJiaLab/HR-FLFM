function selpath = CutSave(selpath,boundmat)
%CUTSAVE Summary of this function goes here
%   Detailed explanation goes here
filepath = dir(selpath);
filenames = [];
for i = 3:length(filepath)
    filename = filepath(i).name;
    if strcmp(filename(end-3:end),'.tif')
        filenames = [filenames,string(filename)];
    end
end
mkdir([selpath,'_cut\'])
for i = 1:length(filenames)
%     disp([selpath,'_cut\',char(filenames(i))])
    try
        img = imread([selpath,'\',char(filenames(i))]);
        imgout = img(boundmat(1):boundmat(2),boundmat(3):boundmat(4));
        imwrite(imgout,[selpath,'_cut\',char(filenames(i))])
        disp(['Saved! (.\..._cut\',char(filenames(i))])
    catch
        disp(['Image Unsaved :-( ',num2str(i)])
    end
end

end

