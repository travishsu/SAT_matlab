function [method, model, record] = createmodel(prob, method)

    if method.shrinkingcriteria.flag
        cut = strsplit(method.shrinkingcriteria.cond);
        c1 = num2str(cell2mat(cut(1)));
        switch c1
            case 'iter'
                model.shrinkingcriteria.flag  = 1;
                method.shrinkingcriteria.iter   = str2num(num2str(cell2mat(cut(2))));
            case 'time'
                model.shrinkingcriteria.flag  = 2;
                method.shrinkingcriteria.period = str2num(num2str(cell2mat(cut(2))));
        end
        
    else
        model.shrinkingcriteria.flag  = 0;
    end
    model.shrinkingcriteria.level = 1;
    
    if ~prob.init.givenflag
        model.data.X = LHD(prob.init.number, prob.dim, prob.searchwindow);
        model.data.Y = zeros(prob.init.number, 1);
        for i = 1:prob.init.number
            model.data.Y(i) = objectivewrapper(model.data.X(i, :), prob);
        end
        model.data.datasize = prob.init.number;
    else
        model.data.X = prob.init.sample;
        model.data.Y = prob.init.response;
        model.data.datasize = size(model.data.X, 1);
    end
    model.currentwindow = prob.searchwindow;
    record.windowhistory = prob.searchwindow;
end
                