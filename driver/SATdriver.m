% Driver
% Inherit variables from configure.m

[method, model, record] = createmodel(prob, method);


tic; 
for loop = 1:method.stoppingcriteria.maxiter
    
    if toc > method.stoppingcriteria.maxtime
        break;
    end
    
    [model.pred.gridLen, model.pred.G, model.pred.P, model.pred.MSE, model.pred.EI] = grid_cut(model.currentwindow, method.gridsize);
    
    model.iter = loop;
    model.info  = Kriging_info(model.data.X, model.data.Y);
    
    if toc > method.stoppingcriteria.maxtime
        break;
    end
    
    x_new = infillsampling(prob, method, model);
    y_new = objectivewrapper(x_new, prob);
    
    model.data.X(end+1, :) = x_new;
    model.data.Y(end+1, :) = y_new;
    
    if toc > method.stoppingcriteria.maxtime
        break;
    end
    
    [model, record] = shrinkflow(prob, method, model, record);
    
    if toc > method.stoppingcriteria.maxtime
        break;
    end
    
end
    
    
    