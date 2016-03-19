    clear
    gr = linspace(0, 1, 100);
    [gridx, gridy] = meshgrid(gr);
    gridx = gridx(:);
    gridy = gridy(:);
    predV = zeros(10000, 1);
    mse   = predV;
    ei    = predV;

    N  = 14;
    Xe = lhsdesign(N, 2)
    
    figure(1); clf; hold on;
    for i = 1:N
        plot(Xe(i,1), Xe(i,2), 'o');
%         Ye(i,1) = testfcn2d(Xe(i, :));
        if i==3
            Ye(i,1) = 5;
        elseif i==2
            Ye(i,1) = 3.5;
        elseif i==1
            Ye(i) = 4;
        else
            Ye(i,1) = 0;
        end
    end
    hold off;
    
    Xc = Xe;
    Yc = Ye;
    
%     Xe = Xe(1:10,:);
%     Ye = Ye(1:10,:);
    
    Info = cokriging(Xe, Xc, Ye, Yc);
    
    for i = 1:10000
        [predV(i), mse(i), ei(i)] = cokrigingpredictor(Info, [gridx(i), gridy(i)]);
    end
    
    Info
    
    gridx = reshape(gridx, 100, 100);
    gridy = reshape(gridy, 100, 100);
    predV = reshape(predV, 100, 100);
    mse   = reshape(mse  , 100, 100);
    ei    = reshape(ei   , 100, 100);
    
    figure(2); 
    subplot(2,2,1);
    mesh(gridx, gridy, predV)
    subplot(2,2,4);
    mesh(gridx, gridy, mse)
    subplot(2,2,3);
    mesh(gridx, gridy, ei)