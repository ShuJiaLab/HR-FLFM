
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This function has been adapted from the algorithm described in:
%
% [1] M. Maggioni, E. Sánchez-Monge, A. Foi, "Joint removal of random and
%     fixed-pattern noise through spatiotemporal video filtering", IEEE 
%     Transactions on Image Processing, vol.23, no.10, pp. 4282-4296, Oct. 2014
%     http://doi.org/10.1109/TIP.2014.2345261
% 
% [2] M. Maggioni, G. Boracchi, A. Foi, and K. Egiazarian, "Video denoising,
%     deblocking, and enhancement through separable 4-D nonlocal spatiotem-
%     poral transforms," IEEE Transactions on Image Processing, vol. 21,
%     no. 9, pp. 3952-3966, Sep. 2012.  http://doi.org/10.1109/TIP.2012.2199324
%
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2011-2014    All rights reserved.
% This work should only be used for nonprofit purposes.
% Any unauthorized use of the provided software and files for industrial
% or profit-oriented activities is expressively prohibited.
% By using these files, you implicitly agree to all the terms of the
% TUT limited license included in the package and available at
% http://www.cs.tut.fi/~foi/legal_notice.html
% Please read the TUT limited license before you proceed with using these
% files.
%
% AUTHORS:
%     Enrique Sánchez-Monge  < esm _at_ noiselessimaging.com >
%     Matteo Maggioni  < matteo.maggioni _at_ tut.fi >
%     Alessandro Foi  < alessandro.foi _at_ tut.fi >
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

