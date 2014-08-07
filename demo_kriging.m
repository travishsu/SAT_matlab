function demo_kriging
    % TRY WINDOW-VERSION 2014/6/10

    %% Basic variables setting
    numDim       = 2;                         % Replace it!
    numInitial   = 8;                         % Replace it!
    maxIteration = 30;                        % Replace it!
    gridsize     = [3, 3];                    % Replace it!

    %% Upper bound and lower bound
    window = [ -5   10   -0   15];           % Replace it!
           % [lbx, ubx, lby, uby]              (NEW method after 6/10)

    %% Initial sampling
    X = LHD(numInitial, numDim, window); % Use LHD if there's no data given by user.

    Y = zeros(numInitial, 1);
    for i = 1:numInitial
        Y(i) = funcEval(X(i, :));      % Replace it!
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

        [X, Y] = cluster_remove(X, Y, 40/100);

        %% Model construction
        model = Kriging_info(X, Y);

        %% Prediction
        for i = 1:gridLen
            [P(i), MSE(i)] = Kriging_pred(G(i,:), model);
            EI(i)          = eiMinimum(P(i), Y, MSE(i));  
        end

        %% EI exploitation and new sample evaluation
        [~, EIMaxIdx] = max(EI);

        x_new = G(EIMaxIdx, :);
        y_new = funcEval(x_new);                   

        %% Appendication
        X = [X; x_new];
        Y = [Y; y_new];


        %% Visualization
    %         visualize(numDim, gridsize, X, Y, G, P);
        visualize_adv(numDim, gridsize, -1, X, Y, G, P, MSE, EI);
        
        %% Shrink Strategy
        window = zoom_shrink_Window(X, Y, window, [0.95, 0.95], -1);
        [X, Y] = zoom_shrink_dropoutside(window, X, Y);
        
    %%
    end
end

%% Function Evaluation
function response = funcEval(sample) % Replace it!
%===========================================
% The test function here is Branin.
%===========================================

    response = Branin(sample(1), sample(2));

end