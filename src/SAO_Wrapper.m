function objectiveValue = SAO_Wrapper(x)
    
    % Please replace with your objective function.
    
    % x will be a 1-by-numDim vector, you can transpose or even decompose it to
    % fill your need.
    
    objectiveValue = errsurf_conti([x(1), x(2)]);

end