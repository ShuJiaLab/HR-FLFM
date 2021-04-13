function [dx,dy] = AliDispFunc(simimg,expimg,optmizer, metric)
[~,simmaxi] = max(simimg(:));
[~,expmaxi] = max(expimg(:));
[simrow,simcol] = ind2sub(size(simimg),simmaxi(1));
[exprow,expcol] = ind2sub(size(expimg),expmaxi(1));
dx0 = expcol(1)-simcol(1);
dy0 = exprow(1)-simrow(1);
% simimgMAXshifted = circshift(simimg,[dy0,dx0]);
% SimRegAdjInitR = imregister(simimgMAXshifted, expimg, 'similarity', optmizer, metric);
% % tformSimilarity = imregtform(simimgMAXshifted, imgexp, 'similarity', optmizer, metric);
% 
% x = 1:1:size(simimg,2);
% y = 1:1:size(simimg,1);
% [X,Y] = meshgrid(x,y);
% cx0 = sum(X.*simimg,'all')/sum(simimg,'all');
% cy0 = sum(Y.*simimg,'all')/sum(simimg,'all');
% % disp([cx0,cy0])
% cx = sum(X.*SimRegAdjInitR,'all')/sum(SimRegAdjInitR,'all');
% cy = sum(Y.*SimRegAdjInitR,'all')/sum(SimRegAdjInitR,'all');
% % disp([cx,cy])
% 
% dx = round(cx-cx0);
% dy = round(cy-cy0);
dx = dx0;
dy = dy0;
end

