function info = Kriging_info(x, y)

    % I: x=[x1;x2;x3;...]
    %    S=[S1;S1;S1;...]
    info.SigmaSq = -100;

    NAN = isnan(y);
    x = x(find(~NAN),:);
    y = y(find(~NAN));

    sizex = size(x);
    sizes = size(y);
    
    factor = 0;

    if sizex(1) ~= sizes(1)
        error('Size of position and value not match.\n');
    end

    k = sizex(2);
%     [x, y] = cluster_remove(x, y, 0.001);
    
    sizex = size(x);
    
    global ModelInfo;
    ModelInfo.X = x;
    ModelInfo.y = y;

    while info.SigmaSq < 0
        UTheta =  .5;
        LTheta =  -2;
        DTheta = UTheta-LTheta;
        
        Up     = 2.5;
        Lp     = 1;
        
        UpperTheta = ones(1,k).* UTheta;
        LowerTheta = ones(1,k).* LTheta;
        
        UpperP = ones(1,k).* Up;
        LowerP = ones(1,k).* Lp;
        %         [ModelInfo.Theta, MinNegLnLikelihood]   = ga(@likelihood,k,[],[],[],[], LowerTheta,UpperTheta);
        
        option = psoptimset('TolMesh', 1e-12, 'Display', 'off', 'InitialMeshSize', DTheta*0.4);
        Theta = zeros(15, 2*k);
        Like  = zeros(15, 1);
        lhs   = lhsdesign(15, k);
        
        for i = 1:15
            [Theta(i,:), Like(i)] = patternsearch(@likelihood, [DTheta*lhs(i,:)+LowerTheta, 2*ones(1,k)], [], [], [], [], [LowerTheta, LowerP], [UpperTheta, UpperP], [], option);
        end
        [minLike, Idx] = min(Like);
        ModelInfo.Theta = Theta(Idx, 1:k);
        ModelInfo.p     = Theta(Idx, k+1:end);
        [NegLnLike, ModelInfo.Psi, ModelInfo.U] = likelihood(Theta(Idx, :));
        
        
        n   = sizex(1);
        one = ones(n,1);
        
        if isinf(minLike)
            info.mu     = (one'*(ModelInfo.Psi\y))/(one'*(ModelInfo.Psi\one));
            Y = ModelInfo.y - info.mu*one;
            info.Inv    = ModelInfo.Psi\Y;
            info.U      = ModelInfo.U;
            info.Psi    = ModelInfo.Psi;
            info.X      = x;
            info.Theta  = ModelInfo.Theta;
            info.p      = ModelInfo.p;
            info.y      = y;
            
            info.SigmaSq = (Y'*(ModelInfo.Psi\Y))/n;
           
        else
            
            info.mu     = (one'*(ModelInfo.U\(ModelInfo.U'\y)))/(one'*(ModelInfo.U\(ModelInfo.U'\one)));
            Y = ModelInfo.y - info.mu*one;
            info.Inv    = ModelInfo.U\(ModelInfo.U'\Y);
            info.U      = ModelInfo.U;
            info.Psi    = ModelInfo.Psi;
            info.X      = x;
            info.Theta  = ModelInfo.Theta;
            info.p      = ModelInfo.p;
            info.y      = y;
            
            info.SigmaSq = (Y'*(ModelInfo.U\(ModelInfo.U'\Y)))/n;
        end
        
    end
end