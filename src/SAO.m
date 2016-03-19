function [solObj, sol]  = ...
    SAO(numDim,     ... % Dimension of your objective function.
        numInitial, ... % 0: User-defined initial N: N initials by LHD
        optflag,    ... % (+1): maximization (-1): minimization
        maxLoop,    ... % Max number of search iteration
        Initial,    ... % Necessary if numInitial 0
        lowerbound, ... % Search lower bound in every dimension.
        upperbound) ... % Search upper bound in every dimension.
        
    

    if (size(lowerbound, 1) ~= numDim) || (size(upperbound, 1) ~= numDim)
        error('Boundary vectors doesnt match, they must be equal to [numDim].');
    end
    
    %% Initial Sampling
    if ~numInitial
        sampleX = Initial;
        sampleX = dim_correction(sampleX, numDim, 0);
        numInitial = size(sampleX, 1);
    else
        if numDim == 1
            sampleX = linspace(lowerbound, upperbound, numInitial)';
        else
            sampleX = LHD(numInitial, numDim, lowerbound, upperbound);
        end
        
        sampleY = zeros(numInitial, 1);
    end
    
    for i = 1:numInitial
        sampleY(i) = SAO_Wrapper(sampleX(i, :));
    end
    
    %% Grid Meshing and allocation
    
    factor        = .01;
    gridSize      = 100;
    
    grid = grid_cut(lowerbound, upperbound, gridSize);
    
    prediction    = zeros(gridSize^numDim, 1);
    predictionMSE = prediction;
    predictionEI  = prediction;
    sampleXNew    = zeros(1, numDim);
    
    %% Search iteration
    for loop = 1:maxLoop
        
%         scalingFactor = dynamic_scaling(sampleX, factor);
        scalingFactor = factor;
        
        sampleX = sampleX*scalingFactor;
        grid    = grid*scalingFactor;
        
        model = Kriging_info(sampleX, sampleY);
        for i = 1:gridSize^numDim
            observationPoint = zeros(1, numDim);
            for j = 1:numDim
                observationPoint(j) = grid(i, j);
            end
            [prediction(i), predictionMSE(i)] = Kriging_pred(observationPoint, model);
            predictionEI(i) = eiOptimum(prediction(i), sampleY, predictionMSE(i), optflag);
        end
        sampleX = sampleX/scalingFactor;
        grid    = grid/scalingFactor;
        
        [~, maxIdx] = max(predictionEI);
        
        % Visualization on 1-D
        visualize_adv(numDim, gridSize, optflag, sampleX, sampleY, grid, prediction, predictionMSE, predictionEI);
%         visualize(numDim, gridSize, sampleX, sampleY, grid, prediction);

        for i = 1:numDim
            sampleXNew(i) = grid(maxIdx, i);
        end
        sampleYNew = SAO_Wrapper(sampleXNew);
        
        [sampleX, sampleY] = XY_updating(sampleX, sampleY, sampleXNew, sampleYNew);
    end
    
    %% Answer extraction
    if optflag>0
        [solObj, solIdx] = max(sampleY);
    else
        [solObj, solIdx] = min(sampleY);
    end
    sol = sampleX(solIdx, :);
    
end


