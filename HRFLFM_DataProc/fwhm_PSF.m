function [FWHMx,FWHMy,FWHMz] = fwhm_PSF(PSF, pixelSize, cFlag, fitFlag)
% Feed back the full width at half maximun of the input PSF
% fwhm.m and mygaussfit.m are needed
% cFlag
%       0: use maximum's position as PSF center position
%       1: use matrix's center position as PSF center position
% fitFlag
%       0: no fitting before calculate FWHM
%       1: spine fitting before calculate FWHM
%       2: gaussian fitting before calculate FWHM
%
if(nargin == 1)
    pixelSize = 1;
    cFlag = 0;
    fitFlag = 0;
end

if(nargin == 2)
    cFlag = 0;
    fitFlag = 0;
end

if(nargin == 3)
    fitFlag = 0;
end

% PSF = PSF - mean(PSF(:));
[Sx,Sy,Sz] = size(PSF);
if((Sx ==1)||(Sy==1)) % 1D input
    x = 1:max(Sx,Sy);
    x = x';
    y = PSF(:);
    FWHMx = fwhm(x, y);
    FWHMy = 0;
    FWHMz = 0;
else
    if(Sz == 1) % 2D input
        if(cFlag)
            indx = floor((Sx+1)/2);
            indy = floor((Sy+1)/2);
        else
            [~, ind] = max(PSF(:)); % find maximum value and position
            [indx,indy] = ind2sub([Sx,Sy],ind(1));
        end
        
        x = 1:Sx;
        x = x';
        y = PSF(:,indy);
        y = y(:);
        if(fitFlag==1)
            xq = 1:0.1:Sx;
            yq = interp1(x, y, xq, 'spline');
            FWHMx = fwhm(xq, yq);
        elseif(fitFlag==2)
            [sig,~,~] = mygaussfit(x,y);
            FWHMx = sig*2.3548;
        else
            FWHMx = fwhm(x, y);
        end
        
        
        x = 1:Sy;
        x = x';
        y = PSF(indx,:);
        y = y(:);
        if(fitFlag==1)
            xq = 1:0.1:Sx;
            yq = interp1(x, y, xq, 'spline');
            FWHMy = fwhm(xq, yq);
        elseif(fitFlag==2)
            [sig,~,~] = mygaussfit(x,y);
            FWHMy = sig*2.3548;
        else
            FWHMy = fwhm(x, y);
        end
        
        FWHMz = 0;
    else % 3D input
        if(cFlag)
            indx = floor((Sx+1)/2);
            indy = floor((Sy+1)/2);
            indz = floor((Sz+1)/2);
        else
            [~, ind] = max(PSF(:)); % find maximum value and position
            [indx,indy,indz] = ind2sub([Sx,Sy,Sz],ind(1));
        end
        
        
        x = 1:Sx;
        x = x';
        y = PSF(:,indy,indz);
        y = y(:);
        if(fitFlag==1)
            xq = 1:0.1:Sx;
            yq = interp1(x, y, xq, 'spline');
            FWHMx = fwhm(xq, yq);
        elseif(fitFlag==2)
            [sig,~,~] = mygaussfit(x,y);
            FWHMx = sig*2.3548;
        else
            FWHMx = fwhm(x, y);
        end
        x = 1:Sy;
        x = x';
        y = PSF(indx,:,indz);
        y = y(:);
        if(fitFlag==1)
            xq = 1:0.1:Sy;
            yq = interp1(x, y, xq, 'spline');
            FWHMy = fwhm(xq, yq);
        elseif(fitFlag==2)
            [sig,~,~] = mygaussfit(x,y);
            FWHMy = sig*2.3548;
        else
            FWHMy = fwhm(x, y);
        end
        
        x = 1:Sz;
        x = x';
        y = PSF(indx,indy,:);
        y = y(:);
        if(fitFlag==1)
            xq = 1:0.1:Sz;
            yq = interp1(x, y, xq, 'spline');
            FWHMz = fwhm(xq, yq);
        elseif(fitFlag==2)
            [sig,~,~] = mygaussfit(x,y);
            FWHMz = sig*2.3548;
        else
            FWHMz = fwhm(x, y);
        end
        %         FWHMz = fwhm(x, y);
    end
end

FWHMx = FWHMx*pixelSize;
FWHMy = FWHMy*pixelSize;
FWHMz = FWHMz*pixelSize;

end

function width = fwhm(x,y)
% Full-Width at Half-Maximum (FWHM) of the waveform y(x)
% and its polarity.
% The FWHM result in 'width' will be in units of 'x'
%
% Rev 1.2, April 2006 (Patrick Egan)

y = y / max(y);
N = length(y);
lev50 = 0.5;
if y(1) < lev50                  % find index of center (max or min) of pulse
    [~,centerindex]=max(y);
    %     Pol = +1;
    %     disp('Pulse Polarity = Positive')
else
    [~,centerindex]=min(y);
    %     Pol = -1;
    %     disp('Pulse Polarity = Negative')
end
i = 2;
while sign(y(i)-lev50) == sign(y(i-1)-lev50)
    i = i+1;
end                                   %first crossing is between v(i-1) & v(i)
interp = (lev50-y(i-1)) / (y(i)-y(i-1));
tlead = x(i-1) + interp*(x(i)-x(i-1));
i = centerindex+1;                    %start search for next crossing at center
while ((sign(y(i)-lev50) == sign(y(i-1)-lev50)) && (i <= N-1))
    i = i+1;
end
if i ~= N
    %     Ptype = 1;
    %     disp('Pulse is Impulse or Rectangular with 2 edges')
    interp = (lev50-y(i-1)) / (y(i)-y(i-1));
    ttrail = x(i-1) + interp*(x(i)-x(i-1));
    width = ttrail - tlead;
else
    %     Ptype = 2;
    %     disp('Step-Like Pulse, no second edge')
    %     ttrail = NaN;
    width = NaN;
end
end