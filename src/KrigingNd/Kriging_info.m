function info = Kriging_info(X, Y)
%> @file Kriging_info.m
%=================================================
%> @brief Given N data with dimension numDim, create a handle of Kriging model.
%>
%> @param   X       N-by-numDim matrix, sample(feature) data,   ex: [x1; x2; x3;...; xN]
%> @param   y       N-by-1 vector, response corresponding to X, ex: [y1; y2; y3;...; yN]
%> 
%> @retval  info    Handle of Kriging model.
%=================================================

    info.SigmaSq = -100;

    NAN = isnan(Y);
    X = X(find(~NAN),:);
    Y = Y(find(~NAN));

    sizex = size(X);
    sizes = size(Y);
    
    factor = 0;

    if sizex(1) ~= sizes(1)
        error('Size of position and value not match.\n');
    end

    k = sizex(2);
%     [x, y] = cluster_remove(x, y, 0.001);
    
    sizex = size(X);
    
    global ModelInfo;
    ModelInfo.X = X;
    ModelInfo.y = Y;

    while info.SigmaSq < 0
        UTheta =  1;
        LTheta =  -2;
        DTheta = UTheta-LTheta;
        
        Up     = 2;
        Lp     = 1;
        
        UpperTheta = ones(1,k).* UTheta;
        LowerTheta = ones(1,k).* LTheta;
        
        UpperP = ones(1,k).* Up;
        LowerP = ones(1,k).* Lp;
%         [Theta, MinNegLnLikelihood]   = ga(@likelihood, 2*k,[],[],[],[], [LowerTheta, LowerP], ...
%                                                                          [UpperTheta, UpperP]);
%         ModelInfo.Theta = Theta(1, 1:k);
%         ModelInfo.p     = Theta(1, k+1:end);
%         [~, ModelInfo.Psi, ModelInfo.U] = likelihood(Theta(1, :));
        
        
        option = psoptimset('TolMesh', 1e-12, 'Display', 'off', 'InitialMeshSize', DTheta*0.4);
        Theta = zeros(15, 2*k);
        Like  = zeros(15, 1);
        lhs   = lhsdesign(15, k);
        
        for i = 1:15
            [Theta(i,:), Like(i)] = patternsearch(@likelihood, ...
                                                  [DTheta*lhs(i,:)+LowerTheta, 2*ones(1,k)], [], [], [], [], ...
                                                  [LowerTheta, LowerP], ...
                                                  [UpperTheta, UpperP], [], option);
        end
        [minLike, Idx] = min(Like);
        ModelInfo.Theta = Theta(Idx, 1:k);
        ModelInfo.p     = Theta(Idx, k+1:end);
        [~, ModelInfo.Psi, ModelInfo.U] = likelihood(Theta(Idx, :));
        
        
        n   = sizex(1);
        one = ones(n,1);
        
        if isinf(minLike)
%         if isinf(MinNegLnLikelihood) 
            info.mu     = (one'*(ModelInfo.Psi\Y))/(one'*(ModelInfo.Psi\one));
            Y = ModelInfo.y - info.mu*one;
            info.Inv    = ModelInfo.Psi\Y;
            info.U      = ModelInfo.U;
            info.Psi    = ModelInfo.Psi;
            info.X      = X;
            info.Theta  = ModelInfo.Theta;
            info.p      = ModelInfo.p;
            info.y      = Y;
            
            info.SigmaSq = (Y'*(ModelInfo.Psi\Y))/n;
           
        else
            
            info.mu     = (one'*(ModelInfo.U\(ModelInfo.U'\Y)))/(one'*(ModelInfo.U\(ModelInfo.U'\one)));
            Y = ModelInfo.y - info.mu*one;
            info.Inv    = ModelInfo.U\(ModelInfo.U'\Y);
            info.U      = ModelInfo.U;
            info.Psi    = ModelInfo.Psi;
            info.X      = X;
            info.Theta  = ModelInfo.Theta;
            info.p      = ModelInfo.p;
            info.y      = Y;
            
            info.SigmaSq = (Y'*(ModelInfo.U\(ModelInfo.U'\Y)))/n;
        end
        
    end
end