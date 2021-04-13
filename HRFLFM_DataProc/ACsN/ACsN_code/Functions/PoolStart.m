if isempty(gcp)
    distcomp.feature('LocalUseMpiexec', false);
    c = parcluster;
    pool = parpool(c.NumWorkers);
end