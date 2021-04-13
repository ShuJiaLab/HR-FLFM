function [selpath,savepath] = intraAverage(selpath,savepath)
%INTRAAVERAGE Summary of this function goes here
%   Detailed explanation goes here
filepath = dir(selpath);
filenames = [];
for i = 3:length(filepath)
    filename = filepath(i).name;
    if strcmp(filename(end-3:end),'.tif')
        filenames = [filenames,string(filename)];
    end
end

imgtot = zeros(size(imread([selpath,'\',char(filenames(1))])));
for i = 1:length(filenames)
    imgtot = imgtot + double(imread([selpath,'\',char(filenames(i))]));
end
imgtot = uint16( imgtot/max(max(imgtot)) * 65535 );
S = split(selpath,'\');
imwrite(imgtot,['Saved! (',savepath,'\',char(S{end}),'_averaged.tif)'])
end

