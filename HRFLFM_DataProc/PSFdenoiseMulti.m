function opendir = PSFdenoiseMulti(opendir,NA,Lambda)
%PSFDENOISEFUNC Summary of this function goes here
%   Detailed explanation goes here
% load('cmap','blow');
% NA = 1.45;
% Lambda = .680;
PxSize = .065;
load('Calibration_Hamamatsu.mat','Gain','Offset')


mkdir([opendir,'_acsn'])
filepath = dir(opendir);
for i = 3:length(filepath)
    filename = filepath(i).name;
    if strcmp(filename(end-3:end),'.tif')
        raw = double(loadtiff([opendir,'\',char(filename)]));
        try
            acsn  = ACSN(raw,NA,Lambda,PxSize,'Offset',Offset,'Gain',Gain);
        catch
            acsn  = ACSN(raw,NA,Lambda,PxSize,'Offset',100,'Gain',1);
        end
        imwrite(uint16(acsn),[opendir,'_acsn\',char(filename)])
        disp([char(filename),' denoised & saved!'])
    end
end

end

