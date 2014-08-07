function Info = coKriging_info(Xe, Xc, Ye, Yc)

    global ModelInfo
    ModelInfo.Xe = Xe;
    ModelInfo.Xc = Xc;
    ModelInfo.ye = Ye;
    ModelInfo.yc = Yc;

    k  = size(Xe, 2);
    ne = size(Xe, 1);
    nc = size(Xc, 1);

    upperbound_cheap_p = [ 1*ones(1, k), 2];
    lowerbound_cheap_p = [-2*ones(1, k), 1];

    Paramc = ga(@likelihoodc, k+1,  [], [], [], [], lowerbound_cheap_p, upperbound_cheap_p);

    ModelInfo.Thetac = Paramc(1:end-1);
    ModelInfo.p      = Paramc(end)*ones(1, k);
    p                = ModelInfo.p;

    upperbound_difference_rho = [ 1*ones(1, k),  2];
    lowerbound_difference_rho = [-2*ones(1, k),  0.1];

    Params = ga(@likelihoodd, k+1,[], [], [], [],lowerbound_difference_rho, upperbound_difference_rho);

    ModelInfo.Thetad = Params(1:k);
    ModelInfo.rho    = Params(k+1);

    %     buildcokriging;
    thetad = 10.^Params(1:k);
    thetac = 10.^Paramc(1:end-1);
    rho    = Params(k+1);
    one    = ones(ne+nc,1);
    y      = [Yc; Ye];

    PsicXc=zeros(nc,nc);
    for i=1:nc
        for j=i+1:nc
            PsicXc(i,j)=exp(-sum(thetac.*abs(Xc(i,:)-Xc(j,:)).^p));
        end
    end
    PsicXc = PsicXc+PsicXc'+eye(nc)+eye(nc).*eps;
    ModelInfo.PsicXc=PsicXc;
    
    PsicXe=zeros(ne,ne);
    for i=1:ne
        for j=i+1:ne
            PsicXe(i,j)=exp(-sum(thetac.*abs(Xe(i,:)-Xe(j,:)).^p));
        end
    end
    PsicXe = PsicXe+PsicXe'+eye(ne)+eye(ne).*eps;
    
    PsicXcXe=zeros(nc,ne);
    for i=1:nc
        for j=1:ne
            PsicXcXe(i,j)=exp(-sum(thetac.*abs(Xc(i,:)-Xe(j,:)).^p));
        end
    end

    PsidXe=zeros(ne,ne);
    for i=1:ne
        for j=i+1:ne
            PsidXe(i,j)=exp(-sum(thetad.*abs(Xe(i,:)-Xe(j,:)).^p));
        end
    end
    PsidXe = PsidXe+PsidXe'+eye(ne)+eye(ne).*eps;
    
    muc=(ones(nc,1)'*(PsicXc\Yc))/(ones(nc,1)'*(PsicXc\ones(nc,1)));
    mud=(ones(ne,1)'*(PsidXe\ModelInfo.d))/(ones(ne,1)'*(PsidXe\ones(ne,1)));

    ModelInfo.SigmaSqrc=(Yc-ones(nc,1).*muc)'*(PsicXc\(Yc-ones(nc,1).*muc))/nc;
    ModelInfo.SigmaSqrd=(ModelInfo.d-ones(ne,1).*mud)'*(PsidXe\(ModelInfo.d-ones(ne,1).*mud))/ne;

    ModelInfo.C=[ModelInfo.SigmaSqrc*PsicXc,   rho*ModelInfo.SigmaSqrc*PsicXcXe;
             rho*ModelInfo.SigmaSqrc*PsicXcXe', rho^2*ModelInfo.SigmaSqrc*PsicXe+ModelInfo.SigmaSqrd*PsidXe];

    ModelInfo.mu=(one'*(ModelInfo.C\y))/(one'*(ModelInfo.C\one));
    ModelInfo.invC= ModelInfo.C\(y-one.*ModelInfo.mu);
    Info = ModelInfo;
end
