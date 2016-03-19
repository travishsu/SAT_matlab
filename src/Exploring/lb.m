function LowerBound=lb(x, info)
    % Calculates a Kriging prediction at x minus A
    % estimated standard deviations
    %
    %Inputs:
    % x-1 x k vector of design variables
    %
    %Global variables used:
    % ModelInfo.X ¡V n x k matrix of sample locations
    % ModelInfo.y ¡V n x 1 vector of observed data
    % ModelInfo.Theta ¡V 1 x k vector of log(theta)
    % ModelInfo.U ¡V n x n Cholesky factorization of Psi
    % ModelInfo.A ¡V scalar weighting parameter
    % Outputs:
    % LowerBound ¡V scalar lower bound
    
    global ModelInfo
    % extract variables from data structure
    % slower, but (makes code easier to follow)
    X = info.X;
    y = info.y;
    theta = info.Theta;
    mu = info.mu;
%     A = info.A;
    
    % Calculate number of sample points
    n = size(X,1);
    
    one = ones(n,1);
    
    % Calculate sigma ^2
    SigmaSqr = ((y-one*mu)'*(info.Psi\(y-one*mu)))/n;
    
    % Initialize psi to vector of ones
    psi = ones(n,1);
    
    % Fill psi vector
    for i=1:n
        psi(i)=exp(-sum(theta.*abs(X(i,:)-x).^2));
    end
    
    % Calculate prediction
    f = mu+psi'*(info.Psi\(y-one*mu));
    
    % Error
    SSqr = SigmaSqr*(1-psi'*(info.Psi'\psi))
    
    % Lower bound
    LowerBound = f-3*(sqrt(SSqr));
end