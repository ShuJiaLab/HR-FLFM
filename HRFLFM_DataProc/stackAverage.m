function [stackFilename,savepath] = stackAverage(stackFilename,savepath,...
                    stackFiletype,stackNumber,stackPreACQFrames,...
                    stackFramesPerLayer,stackStepSize,stackZRange,...
                    stackFrames2DropPerLayer,stackIntEnv)

load('Calibration_Hamamatsu.mat','Offset')
load('intenv.mat','imaxv')
Zpos = 50000-stackZRange;
splittedFileDir = split(string(stackFilename),"\");
splittedFilename = split(splittedFileDir(end),".");
savefolder = [savepath,'\',char(splittedFilename(1)),'\'];
mkdir(savefolder)
if string(stackFiletype) == "dax"
    
elseif string(stackFiletype) == "tif"
    for imindex = stackPreACQFrames+1:1:stackNumber
        seqind = mod(imindex-stackPreACQFrames-1,stackFramesPerLayer);
        if seqind == round(stackFrames2DropPerLayer/2)
            imgsum = double(imread(stackFilename,'Index',imindex));
%             disp([num2str(imindex),', ',num2str(seqind),' | avg starts!'])
        elseif seqind == stackFramesPerLayer-round(stackFrames2DropPerLayer/2)-1
            imgsum = imgsum + double(imread(stackFilename,'Index',imindex));
            imgsum = imgsum/(stackFramesPerLayer-stackFrames2DropPerLayer);
            imgsum = imgsum - Offset;
            if stackIntEnv == true
                intv = sqrt(mean(imaxv(imaxv==Zpos,2:4)))*65535;
                imgmaxv = getMaxv(imgsum);
                imgsum = (imgsum)*(intv)/(imgmaxv);
            end
            imgsum(imgsum<0)=0;
            imgsum = uint16(imgsum);
            imwrite(imgsum,[savefolder,'psf_',num2str(Zpos),'_avg.tif'])
            disp([num2str(imindex),', ',num2str(seqind),' | avg ends at Z = ',num2str(Zpos),' nm!'])
            Zpos = Zpos + stackStepSize;
            if Zpos == 50000+stackZRange
                break
            end
        elseif seqind > round(stackFrames2DropPerLayer/2) && ...
                seqind < stackFramesPerLayer-round(stackFrames2DropPerLayer/2)-1
%             disp([num2str(imindex),', ',num2str(seqind),' | averaging...!'])
            imgsum = imgsum + double(imread(stackFilename,'Index',imindex));
        end
    end
else
    disp('Unsupported stack file type!')
end

