function cmp = rainbow(n)
%RAINBOW Summary of this function goes here
%   Detailed explanation goes here

% ch_red = [];
ch_red1 = (0:1:32) /(-64) + 0.5;
ch_red2 = (33:1:159) * 0;
ch_red3 = (160:1:224) /64 - 160/64;
ch_red4 = (225:1:320) * 0 +1;

ch_red = [ch_red1,ch_red2,ch_red3,ch_red4]';
ch_red = imresize(ch_red,[n,1],'bilinear');

% ch_green = [];
ch_green1 = (0:1:31) * 0;
ch_green2 = (32:1:96) /64 - 32/64;
ch_green3 = (97:1:223) * 0 +1;
ch_green4 = (224:1:288) /(-64) + 288/64;
ch_green5 = (289:1:320) * 0;
ch_green = [ch_green1,ch_green2,ch_green3,ch_green4,ch_green5]';
ch_green = imresize(ch_green,[n,1],'bilinear');

% ch_blue = [];
ch_blue1 = (0:1:95) * 0 + 1;
ch_blue2 = (96:1:160) /(-64) + 160/64;
ch_blue3 = (161:1:287) * 0 ;
ch_blue4 = (288:1:320) / 64 - 288/64;
ch_blue = [ch_blue1,ch_blue2,ch_blue3,ch_blue4]';
ch_blue = imresize(ch_blue,[n,1],'bilinear');

cmp = [ch_red,ch_green,ch_blue];
cmp = min(cmp,1);
end

