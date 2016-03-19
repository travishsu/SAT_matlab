classdef SATprob < handle
    
    properties
        objeval
        dim
        number
        searchwindow
        goal
        
        initialsamples
        initialvalues
    end
    
    methods
        
        function prob = SATprob(objeval, dim, number, searchwindow, goal)
            prob.objeval      = objeval;
            prob.dim          = dim;
            prob.number       = number;
            prob.searchwindow = searchwindow;
            prob.goal         = goal;
            
            prob.lhdInit();
           
        end
        
        function evalFromGiven(prob)
            prob.initialvalues  = zeros(prob.number, 1);
            for i = 1:prob.number
                prob.initialvalues(i) = feval(prob.objeval, prob.initialsamples(i, :));
            end 
        end
        
        function lhdInit(prob)
            prob.initialsamples = LHD(prob.number, prob.dim, prob.searchwindow);
            prob.evalFromGiven();
            prob.initialsamples
        end
        
    end
end