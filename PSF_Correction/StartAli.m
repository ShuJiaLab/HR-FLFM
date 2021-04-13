function alignedimg = StartAli(simimg,expimg)
[~,simmaxi] = max(simimg(:));
[~,expmaxi] = max(expimg(:));
[simrow,simcol] = ind2sub(size(simimg),simmaxi(1));
[exprow,expcol] = ind2sub(size(expimg),expmaxi(1));
alignedimg = circshift(simimg,exprow-simrow,expcol-simcol);
end