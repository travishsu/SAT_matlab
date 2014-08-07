function value = fcnEvaluate(funcell, sample, fdlcell)

    if ~iscell(funcell)
        value = funcell(sample);
    else
        S = size(funcell);
        value = cell(S);
        
        for i = 1:S(1)
            for j = 1:S(2)
                if fdlcell{i, j}
                    value{i, j} = funcell{i, j}(sample);
                end
            end
        end
    end
end