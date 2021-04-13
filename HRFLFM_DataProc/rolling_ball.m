function [data,width,shrink_factor] = rolling_ball(radius)
%myFun - This function is to generate the ball.
%
% Syntax: [data,width,shrink_factor] = rolling_ball(radius)
%
% Long description
    
% data = [];
% width = 0;
% Setup the shrink factor and arc_trim_per values
%
if radius<=10
    shrink_factor = 1;
    arc_trim_per = 24;
elseif radius<=30
    shrink_factor = 2;
    arc_trim_per = 24;
elseif radius<=100
    shrink_factor = 4;
    arc_trim_per = 32;
else
    shrink_factor = 8;
    arc_trim_per = 40;
end

small_ball_radius = max(radius / shrink_factor,1);
r_square = small_ball_radius^2;

x_trim = arc_trim_per * small_ball_radius/100;

half_width = round(small_ball_radius-x_trim);

width = 2 * half_width + 1;

x = 0:1:(width-1);
y = 0:1:(width-1);
[X,Y] = meshgrid(x,y);
X_val = X-half_width;
Y_val = Y-half_width;
data = sqrt(max(r_square-X_val.^2-Y_val.^2,0));


end