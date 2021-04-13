% @matrix  data
% @OUTPUT Dataset output

% @ Float(label="NA", description="Numerical Aperture") NA
% @ Float(label="Lambda (nm)", description="Wavelength") lambda
% @ Float(label="Pixel Size (nm)", description="effective Pixel Size") px

% @ String(choices={"auto", "yes", "no"}, style="radioButtonHorizontal") Video

% @ String(label="Offset Choice", choices={"File (.mat)", "File (.tiff)", "Value"}, style="radioButtonHorizontal") OffsetChoice
% @ File(label="Select a file:" , description="Select a file with the offset map", style="extensions:tiff/tif") OffsetFile
% @ Float(label="Offset", description="Average offset value") OffsetValue

% @ String(label="Gain Choice", choices={"File (.mat)", "File (.tiff)", "Value"}, style="radioButtonHorizontal") GainChoice
% @ File(label="Select a file:" , description="Select a file with the gain map", style="extensions:tiff/tif") GainFile
% @ Float(label="Gain", description="Average offset value") GainValue

% @ String(label="Parallel CPU", choices={"yes", "no"}, style="radioButtonHorizontal") ParChoice

% offset
%disp(OffsetChoice)
if OffsetChoice(1) == 'F'
    if OffsetChoice(8) == 'm'
        clear offset;
        f = load(char(OffsetFile));
        offset = f.offset;
    else
        clear offset;
        offset = double(imread(char(OffsetFile)));
    end
else
    clear offset;
    offset = double(OffsetValue);
    %disp(offset)
end

% gain
%disp(GainChoice)
if GainChoice(1) == 'F'
    if GainChoice(8) == 'm'
        clear gain;
        g = load(char(GainFile));
        gain = g.gain;
    else
        clear gain;
        gain = double(imread(char(GainFile)));
    end
else
    clear gain;
    gain = double(GainValue);
    %disp(gain)
end

% parallel
%disp(ParChoice)
if ParChoice(1) == 'n'
    Mode = 'Normal';
else
    Mode = 'Parallel';
    %disp(parallel)
end


% parameter conversion

px = px*1e-3;
lambda = lambda*1e-3;

% main
input = double(data);       % convert to double
clc
output = ACSN(input,NA,lambda,px,'Video',Video,'Offset',offset,'Gain',gain,'Mode',Mode);
