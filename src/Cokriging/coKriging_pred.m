function [f_hat, mse] = coKriging_pred(x, Info)

    Xe = Info.Xe;
    Xc = Info.Xc;
    ye = Info.ye;
    yc = Info.yc;
    
    ne = size(Xe,1); 
    nc = size(Xc,1); 
    
    thetad = 10.^Info.Thetad;
    thetac = 10.^Info.Thetac;
    
    p = Info.p;  % added p definition (February 10)
    
    rho = Info.rho;
    
    SigmaSqrc = Info.SigmaSqrc;
    SigmaSqrd = Info.SigmaSqrd;
    
    one = ones(nc+ne,1);
    y   = [yc; ye];
    cc  = ones(nc,1);
    for i = 1:nc
        cc(i) = rho*SigmaSqrc*exp(-sum(thetac.*abs(Xc(i,:)-x).^p));
    end
    cd = ones(ne,1);
    for i = 1:ne
        cd(i) = rho^2*SigmaSqrc*exp(-sum(thetac.*abs(Xe(i,:)-x).^p))+SigmaSqrd*exp(-sum(thetad.*abs(Xe(i,:)-x).^p));
    end
    c = [cc;cd];
    % f = Info.mu+c'*(Info.UC\(Info.UC'\(y-one.*Info.mu)));
    
    f_hat = Info.mu+c'*Info.invC;
    
    SSqr = rho^2*SigmaSqrc+SigmaSqrd-c'*(Info.C\c) + ((1-one'*(Info.C\c))^2)/(one'*(Info.C\one));
    mse = abs(SSqr)^0.5;
        
end


