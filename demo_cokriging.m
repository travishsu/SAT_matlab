function demo_cokriging

    %% Basic variables setting
    numDim           = 2;                           % Replace it!
    numLowInitial    = 4;                           % Replace it!
    numHighInitial   = 4;                           % Replace it!
    maxIteration     = 30;                          % Replace it!
    gridsize         = [50, 50];                    % Replace it!

    %% Upper bound and lower bound
    window = [ -5   10   -0   15];                  % Replace it!
           % [lbx, ubx, lby, uby]                     (NEW method after 6/10)

    %% Initial sampling
    design = LHD(numLowInitial+numHighInitial, numDim, window); % Use LHD if there's no data given by user.
    
    X_L = design(1:numLowInitial, :); 
    Y_L = zeros(numLowInitial, 1);
    for i = 1:numLowInitial
        Y_L(i) = LowfuncEval(X_L(i, :));            % Replace it!
    end

    X_H = design(numLowInitial+1:end, :); 
    Y_H = zeros(numHighInitial, 1);
    for i = 1:numHighInitial
        Y_H(i) = HighfuncEval(X_H(i, :));           % Replace it!
    end
    
    %% Prediction region mesh and allocation (NEW method after 6/10)
%     [gridLen, G, P, MSE, EI] = grid_cut(window, gridsize);


    %% Iteration exploration
    for loop = 1:maxIteration

        %% Dynamic gridsize
        if loop < 10
            gridsize = [5, 5];
        elseif loop < 20
            gridsize = [20, 20];
        elseif loop < 30
            gridsize = [50, 50];
        end
        
        [gridLen, G, P, MSE, EI] = grid_cut(window, gridsize);

        [X_H, Y_H] = cluster_remove(X_H, Y_H, 40/100);
        [X_L, Y_L] = cluster_remove(X_L, Y_L, 40/100);

        %% Model construction
        model = coKriging_info(X_H, X_L, Y_H, Y_L);

        %% Prediction
        for i = 1:gridLen
            [P(i), MSE(i)] = coKriging_pred(G(i,:), model);
            EI(i)          = eiMinimum(P(i), Y_H, MSE(i));  
        end

        %% EI exploitation
        [~, EIMaxIdx] = max(EI);
        x_new = G(EIMaxIdx, :);
        
        %% Choose a fidelity to evaluate
        fidelity = 'high';
        
        switch fidelity
            case 'high'
                y_new = HighfuncEval(x_new);  
                X_H = [X_H; x_new];
                Y_H = [Y_H; y_new];
                
            case 'low'
                y_new = LowfuncEval(x_new);
                X_L = [X_L; x_new];
                Y_L = [Y_L; y_new];
                
            case 'both'
                y_new = HighfuncEval(x_new);  
                X_H = [X_H; x_new];
                Y_H = [Y_H; y_new];
                y_new = LowfuncEval(x_new);
                X_L = [X_L; x_new];
                Y_L = [Y_L; y_new];
                
            otherwise
                error('fidelity tag is illegal! (should be high or low)');       
        end
        
        [X_H, Y_H]
        
        visualize_adv(numDim, gridsize, -1, X_H, Y_H, G, P, MSE, EI);
        
        %% Shrink Strategy
        window = zoom_shrink_Window(X_H, Y_H, window, [0.95, 0.95], -1);
        [X_H, Y_H] = zoom_shrink_dropoutside(window, X_H, Y_H);
        [X_L, Y_L] = zoom_shrink_dropoutside(window, X_L, Y_L);
        
    %%
    end
end

%% Function Evaluation
function response = LowfuncEval(sample) % Replace it!
%===========================================
% The test function here is Branin.
%===========================================

    response = Branin(sample(1), sample(2));

end

%% Function Evaluation
function response = HighfuncEval(sample) % Replace it!
%===========================================
% The test function here is Branin.
%===========================================

    response = Branin(sample(1), sample(2));

end