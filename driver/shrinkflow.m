function [model, record] = shrinkflow(prob, method, model, record)

    flag = 0;
    
    level = model.shrinkingcriteria.level;
    if model.shrinkingcriteria.flag == 2
        
        maxtime = method.stoppingcriteria.maxtime;
        period  = method.shrinkingcriteria.period;
        if toc > level*(maxtime/period);
            flag = 1;
        end
        
    elseif model.shrinkingcriteria.flag == 1
        
        iter        = model.iter;
        shrinkiter  = method.shrinkingcriteria.iter;
        if mod(iter,shrinkiter) == 0
            flag = 1;
        end
        
    end
    
    if flag
        
        X   = model.data.X;
        Y   = model.data.Y;
        window_current = model.currentwindow;
        ratio          = method.shrinkingcriteria.ratio;
        window_new = zoom_shrink_Window(X, Y, window_current, ratio, prob.goal);
        
        model.currentwindow            = window_new;
        record.windowhistory(end+1, :) = window_new;
        
    end