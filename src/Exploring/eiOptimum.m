function ei = eiOptimum(y_hat, y, mse, optflag)

%> @file eiOptimum.m
%=================================================
%> @brief Measure the expected improvement for minimization
%>
%> Given a prediction at observation point, and its corresponding mean
%> sqaure error, also give responses of all data to this function, this
%> function measure the expected improvement at the observation point
%>
%> @param   y_hat   prediction at a point
%> @param   y       N-by-1 vector, responses of current data set (training set)
%> @param   mse     mean square error at that point
%> @param   optflag 1 for maximization and -1 for minimization
%> 
%> @retval  ei      expected improvement at that point
%=================================================
    
    y_hat = y_hat*optflag;
    y     = y*optflag;

    % Best point so far
    y_max = max(y);
    
    % Expected improvement: y, mse, 
    if mse == 0
        ei = 0;
    else
        ei_termone = (y_hat-y_max)*(0.5+0.5*erf((1/sqrt(2))*((y_hat-y_max)/sqrt(abs(mse)))));
        ei_termtwo = sqrt(abs(mse))*(1/sqrt(2*pi))*exp(-(1/2)*((y_hat-y_max)^2/mse));
        ei = ei_termone + ei_termtwo;
    end
    
end