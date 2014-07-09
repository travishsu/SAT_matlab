function ei = eiMinimum(y_hat, y, mse)

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