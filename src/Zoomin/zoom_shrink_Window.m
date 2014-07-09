function window_new = zoom_shrink_Window(X, Y, window_old, shrink_ratio, opt_prob)

%         Author      : Yi-Chung Hsu
%         Last Updated: 2014/7/9
%         Desciption  : 
%            Determine a new smaller window and locate the position of edge
%         Usage       :
%               Input:
%                   X, Y: training set;
%                   window_old: 1-by-4info of old window; 
%                   shrink_ratio:
%                   opt_prob: This function works when opt_prob is 'max' or 'min'.


        dim          = size(X, 2);
        length_direc = zeros(dim, 1);
        window_new   = zeros(1, 2*dim);
        
        if strcmp(opt_prob, 'max')
            
            [~, sampleOptIndex] = max(Y);
            for i = 1:dim
                length_direc(i) = (window_old(2*i)-window_old(2*i-1))*shrink_ratio(i);
                window_new(1, 2*i-1) = X(sampleOptIndex, i) - length_direc(i)/2;
                window_new(1, 2*i  ) = X(sampleOptIndex, i) + length_direc(i)/2;
            end
            
        elseif strcmp(opt_prob, 'min')
            
            [~, sampleOptIndex] = min(Y);
            for i = 1:dim
            length_direc(i) = (window_old(2*i)-window_old(2*i-1))*shrink_ratio(i);
            window_new(1, 2*i-1) = X(sampleOptIndex, i) - length_direc(i)/2;
            window_new(1, 2*i  ) = X(sampleOptIndex, i) + length_direc(i)/2;
            end
            
        else
            
            window_new = window_old;
            
        end
        window_new
end
