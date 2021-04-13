% Read File
if ischar(I)
    
    FileName = I;
    clear I;
    
    disp('Loading...');
    I = loadtiff(FileName);
    I = double(I);
    
end

% Default parameters
default = {1,1,1,0,'Fast',[ 'ACSN_' datestr(now,'yyyymmdd_HHMMSS') '.tif'],'auto',64,0.5,'no'};

Gain = default{1};
Offset = default{2};
Hotspot = default{3};
Level = default{4};
Mode = default{5};
SaveFileName = default{6}; % experimental
Video = default{7};
Window = default{8};
alpha = default{9};    % experimental
QM = default{10};    % experimental

for idx = 1:2:length(varargin)
    switch varargin{idx}
        
        case 'Gain'
            Gain = varargin{idx+1};
        case 'Offset'
            Offset = varargin{idx+1};
        case 'Hotspot'
            Hotspot = varargin{idx+1};
        case 'Level'
            Level = varargin{idx+1};
        case 'Mode'
            Mode = varargin{idx+1};
        case 'SaveFileName'
            SaveFileName = varargin{idx+1};
        case 'Video'
            Video = varargin{idx+1};
        case 'Window'
            Window = varargin{idx+1};
            Window = max(32,Window);
            Window = min(256,Window);
        case 'Alpha'
            alpha = varargin{idx+1};
            alpha = max(0.1,alpha);
            
        case 'QualityMap'
            QM = varargin{idx+1};
    end
end


if length(Offset)==1
    Offset = Offset.*ones(size(I(:,:,1)));
end

if length(Gain)==1
    Gain = Gain.*ones(size(I(:,:,1)));
end

Gain(Gain<1) = 1; % the pixel values of the selected gain map should be greater than 1.

%
clear textprogressbar
