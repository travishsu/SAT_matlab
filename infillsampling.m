function x_new = infillsampling(prob, method, model)

    Y       = model.data.Y;
    
    info    = model.info;
    gridLen = model.pred.gridLen;
    G       = model.pred.G;
    P       = model.pred.P;
    MSE     = model.pred.MSE;
    EI      = model.pred.EI;
    
    switch prob.goal
        case 'min'
            for i = 1:gridLen
                [P(i), MSE(i)] = Kriging_pred(G(i,:), info);
                EI(i)          = eiMinimum(P(i), Y, MSE(i));
            end

            [~, idx] = max(EI);
        case 'max'
            for i = 1:gridLen
                [P(i), MSE(i)] = Kriging_pred(G(i,:), info);
                EI(i)          = eiMaximum(P(i), Y, MSE(i));
            end

            [~, idx] = max(EI);
    end
    
    x_new = G(idx, :);
    
end