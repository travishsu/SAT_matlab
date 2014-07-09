function ei = eiOptimum(y_hat, y, mse, optflag)

    % optflag (+1) : Maximization
    %         (-1) : Minimization
    
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