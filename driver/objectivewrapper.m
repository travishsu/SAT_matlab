function output = objectivewrapper(input, prob)

    dim = prob.dim;
    
    output = 0;
    for i = 1:dim
        output = output + sin(input(i))/i;
    end
    
end