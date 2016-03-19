addpath(genpath('./'));


% Configure

prob.dim             = 2;

prob.init.givenflag  = 0;
prob.init.sample     = [];
prob.init.response   = [];
prob.init.number     = 8;

prob.searchwindow   = [ -5   10   -0   15];
prob.goal           = 'min';

method.stoppingcriteria.maxiter        = 20;
method.stoppingcriteria.maxtime        = 3600;

method.gridsize                        = [30, 30];
method.shrinkingcriteria.flag          = 1;
method.shrinkingcriteria.ratio         = [0.5, 0.5];
method.shrinkingcriteria.cond          = 'time 180'; % time 3


SATdriver


