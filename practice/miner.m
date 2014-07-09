close all

X = [];
Y = [];

ll = linspace(1, 200, 200);
[xm, ym] = meshgrid(ll, ll);
zm = 99*ones(200, 200);

for i = 1:20
    
    figure(1); 
    axis([1 200 1 200]);
    x = ginput(1);
    y = errsurf_conti(x);
    X = [X;x]; Y = [Y;y];
    
    
    if i>1
        clf;            
    end
    hold on;
    [Y, idx] = sort(Y);
    X = X(idx, :);
    for j = 1:size(X, 1)
        plot(X(j, 1), X(j, 2), 'o');
        s = sprintf('%d', j);
        text(X(j, 1)+1, X(j, 2)+1, s);
        axis([1 200 1 200]);
    end
    
    [~, idx] = min(Y);
    plot(X(idx, 1), X(idx, 2), 'x'); hold off;
    
    
    figure(2);  axis on; view(3); axis([1, 200, 1, 200, 0, 0.16]); hold on;
    stem3(x(1), x(2), y, 'MarkerFaceColor','g');
    grid on;

end

