
%% Basic variables setting
numDim       = 1;
numInitial   = 4;
numIteration = 20;
gridsize     = 100;


%% Upper bound and lower bound
lb = 0;
ub = 1;


%% Initial sampling
X = LHD(numInitial, numDim, lb, ub);

Y = zeros(numInitial, 1);
for i = 1:numInitial
    Y(i) = onevar(X(i));
end


%% Prediction region mesh and allocation
gridLen = prod(gridsize);

G   = grid_cut(lb, ub, gridsize);
P   = zeros(gridLen, 1);
MSE = zeros(gridLen, 1);
EI  = zeros(gridLen, 1);

for loop = 1:numIteration
    
%     [X, Y] = cluster_remove(X, Y, 1/100);
    
    %% Model construction
    model = Kriging_info(X, Y);
    
    %% Prediction
    for i = 1:gridLen
        [P(i), MSE(i)] = Kriging_pred(G(i,:), model);
        EI(i)          = eiMinimum(P(i), Y, MSE(i));
    end
    
    %% Choose the new sample
%     [~, idx] = max(MSE);
    [~, idx] = max(abs(MSE)); 
    x_new = G(idx, :);
    X = [X; x_new]; Y = [Y; onevar(x_new)];
   
    %% Visualization
    visualize(numDim, gridsize, X, Y, G, P);
   
end
