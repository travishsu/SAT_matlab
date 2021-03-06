function [y, mse] = Kriging_pred(x, info)
%> @file Kriging_pred.m
%=================================================
%> Based on (info) generated in Kriging_info, this function predict the value
%> (y) and mean square error (mse) at (x)
%>
%> @param   x       Position where value user want to predict.
%> @param   info    Kriging model handle constructed by Kriging_info.
%> 
%> @retval  y       Prediction value at x
%> @retval  mse     Mean square error at x
%=================================================

    Inv     = info.Inv;
    mu      = info.mu;
    X       = info.X;
    theta   = 10.^info.Theta;
    p       = info.p;
    SigmaSq = info.SigmaSq;
    U       = info.U;
    
    n   = size(X, 1);    
    
    psi = ones(n,1);

    for i = 1:n
    	psi(i) = exp(-sum(theta.*(abs(X(i,:)-x).^p)));
    end
    
    one = ones(n,1);
    mse = SigmaSq*(1-psi'*(info.Psi\psi)); % +((1-one'*(info.Psi\psi))/(one'*(info.Psi\one))));
%     mse = SigmaSq*(1-psi'*(U\(U'\psi)));
        
    y = mu + psi'*Inv;

end