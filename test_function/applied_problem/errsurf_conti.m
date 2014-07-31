function es = errsurf_conti(X)
%     X
    x = X(1); y = X(2);
    load matlab.mat;
    if x > 201 || x < 1 || y > 201 || y < 1
        es = 100; return;
    end
    
    if x == 201 && y == 201
        es = data(201, 201); return;
    end
    
    x0 = floor(x); x1 = x0 + 1;
    y0 = floor(y); y1 = y0 + 1;
    
    if x == 201
        es = (y1-y)*data(201, y0) + (y-y0)*data(201, y1); return;
    end
    if y == 201
        es = (x1-x)*data(x0, 201) + (x-x0)*data(x1, 201); return;
    end
    
    es_0 = (x1-x)*data(x0, y0)+(x-x0)*data(x1, y0);
    es_1 = (x1-x)*data(x0, y1)+(x-x0)*data(x1, y1);
    
    es = (y1-y)*es_0 + (y-y0)*es_1;
    
end