function [X_new, Y_new] = zoom_shrink_dropoutside(window, X, Y)

    % Drop off the samples outside the window
    
    N = size(X,1);
    X_new = X;
    Y_new = Y;
    
    xn = window(1);
    xp = window(2);
    yn = window(3);
    yp = window(4);
    
    for i = N:-1:1
        
        x = X(i,1);
        y = X(i,2);
    
        if (x-xp)*(x-xn) > 0 || (y-yp)*(y-yn) > 0
            X_new(i, :) = [];
            Y_new(i, :) = [];
        end
    
    end
    
    if isempty(Y_new)
        X_new = X;
        Y_new = Y;
    end

end
