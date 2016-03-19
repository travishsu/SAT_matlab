function ei = eiMinimum(y_hat, y, mse)
%> @file eiMinimum.m
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
%> 
%> @retval  ei      expected improvement at that point
%=================================================

    % Best point so far
    y_min = min(y);
    
    % Expected improvement: y, mse, 
    if mse == 0
        ei = 0;
    else
        ei_termone = (y_min-y_hat)*(0.5+0.5*erf((1/sqrt(2))*...
        ((y_min-y_hat)/sqrt(abs(mse)))));
        ei_termtwo = sqrt(abs(mse))*(1/sqrt(2*pi))*exp(-(1/2)*...
        ((y_min-y_hat)^2/mse));
        ei = ei_termone+ei_termtwo;
        
    end
    
end