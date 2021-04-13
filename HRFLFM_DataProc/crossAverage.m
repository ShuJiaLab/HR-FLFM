function [selpath,savepath] = crossAverage(selpath,savepath)
%INTRAAVERAGE Summary of this function goes here
%   Detailed explanation goes here
filepath = dir(selpath);
acqpath = [];
for i = 3:length(filepath)
    acq = filepath(i).name;
    if strcmp(acq(1:3),'acq')
        acqpath = [acqpath,string(acq)];
    end
end
filenames = dir([selpath,'\',char(acqpath(1))]);
disp(['Filenumbers: ', num2str(length(filenames))])
imgoffset = 65535;
for i = 3:length(filenames)
%     disp(filenames(i).name)
    imgsum = zeros(size(imread([selpath,'\',char(acqpath(1)),'\',char(filenames(3).name)])));
    for ii = 1:length(acqpath)
        imgsum = imgsum + double(imread([selpath,'\',char(acqpath(ii)),'\',char(filenames(i).name)]));
    end
    imgsum = uint16( imgsum/length(acqpath) );
    imwrite(imgsum,[savepath,'\',char(filenames(i).name),'_avg.tif'])
    disp(['Saved! (.\',char(filenames(i).name),'_avg.tif)'])
end

for i = 3:length(filenames)
    img = double(imread([savepath,'\',char(filenames(i).name),'_avg.tif']));
    load('Calibration_Hamamatsu.mat','Offset')
    img = img - Offset;
    img(img<0)=0;
    img = uint16(img);
    imwrite(img,[savepath,'\',char(filenames(i).name),'_avg.tif'])
end
end

