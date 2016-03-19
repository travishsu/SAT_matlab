function Info = cokriging_reg(Xe, Xc, Ye, Yc)

 Meps = eps;
 while 1    
     global ModelInfo
     ModelInfo.Xe = Xe;
     ModelInfo.Xc = Xc;
     ModelInfo.ye = Ye;
     ModelInfo.yc = Yc;
     
     k = size(Xe, 2);
     
     u =  0*ones(1, k);
     l = -3*ones(1, k);
     while 1
         Paramc = ga(@likelihoodc_reg, k+1, [], [], [], [], [l, -20], [u, -14]);
         change = 0;
         for i = 1:k
             if u(i) - Paramc(i) <= 1e-3
                 l(i) = u(i) - 1;
                 u(i) = u(i) + 1;
                 change = 1;
%              elseif Paramc(i) - l(i) <= 1e-3
%                  u(i) = l(i) + 1;
%                  l(i) = l(i) - 1;
%                  change = 1;
             end
         end
         if ~change
             break;
         end
     end
     ModelInfo.Thetac  = Paramc(1:end-1);
     ModelInfo.lambdac = Paramc(end);
     
     up = [ 0*ones(1, k), -5];
     lp = [-3*ones(1, k),  5];
     while 1
         Params           = ga(@likelihoodd_reg, k+1,[],[],[],[],[lp, -20], [up, -14]);
         change = 0;
         for i = 1:k+1
             if up(i) - Params(i) <= 1e-3
                 lp(i) = up(i) - 1;
                 up(i) = up(i) + 1;
                 change = 1;
%              elseif Params(i) - lp(i) <= 1e-3
%                  up(i) = lp(i) + 1;
%                  lp(i) = lp(i) - 1;
%                  change = 1;
             end
         end
         
         if ~change
             break;
         end
     end
     
     ModelInfo.Thetad  = Params(1:k);
     ModelInfo.rho     = Params(k+1);
     ModelInfo.lambdad = Params(k+2);
     
     Xe=ModelInfo.Xe;
     Xc=ModelInfo.Xc;
     ye=ModelInfo.ye;
     yc=ModelInfo.yc;
     ne=size(Xe,1);
     nc=size(Xc,1);
     thetad=10.^ModelInfo.Thetad;
     thetac=10.^ModelInfo.Thetac;
     p=2;  % added p definition (February 10)
     rho=ModelInfo.rho;
     
     one=ones(ne+nc,1);
     y=[yc; ye];
     PsicXc=zeros(nc,nc);
     for i=1:nc
         for j=i+1:nc
             PsicXc(i,j)=exp(-sum(thetac.*abs(Xc(i,:)-Xc(j,:)).^p));
         end
     end
     ModelInfo.PsicXc=PsicXc+PsicXc'+eye(nc)+eye(nc).*(10.^ModelInfo.lambdac);
     [ModelInfo.UPsicXc, p]=chol(ModelInfo.PsicXc);
     p
     if p>0
         continue;
     end
     
     PsicXe=zeros(ne,ne);
     for i=1:ne
         for j=i+1:ne
             PsicXe(i,j)=exp(-sum(thetac.*abs(Xe(i,:)-Xe(j,:)).^p));
         end
     end
     ModelInfo.PsicXe=PsicXe+PsicXe'+eye(ne)+eye(ne).*(10.^ModelInfo.lambdac);
     [ModelInfo.UPsicXe, p]=chol(ModelInfo.PsicXe);
     p
     if p>0
         continue;
     end
     
     PsicXcXe=zeros(nc,ne);
     for i=1:nc
         for j=1:ne
             PsicXcXe(i,j)=exp(-sum(thetac.*abs(Xc(i,:)-Xe(j,:)).^p));
         end
     end
     ModelInfo.PsicXcXe=PsicXcXe; % Deleted "+[zeros(nc-ne,ne);eye(ne)].*eps" November 2010
     ModelInfo.PsicXeXc=ModelInfo.PsicXcXe';
     
     
     PsidXe=zeros(ne,ne);
     for i=1:ne
         for j=i+1:ne
             PsidXe(i,j)=exp(-sum(thetad.*abs(Xe(i,:)-Xe(j,:)).^p));
         end
     end
     ModelInfo.PsidXe=PsidXe+PsidXe'+eye(ne)+eye(ne).*(10.^ModelInfo.lambdad);
     [ModelInfo.UPsidXe, p]=chol(ModelInfo.PsidXe);
     p
     if p>0
         continue;
     end
     
     ModelInfo.muc=(ones(nc,1)'*(ModelInfo.UPsicXc\(ModelInfo.UPsicXc'\yc)))/(ones(nc,1)'*(ModelInfo.UPsicXc\(ModelInfo.UPsicXc'\ones(nc,1))));
     ModelInfo.d=ye-rho.*yc(end-ne+1:end);
     ModelInfo.mud=(ones(ne,1)'*(ModelInfo.UPsidXe\(ModelInfo.UPsidXe'\ModelInfo.d)))/(ones(ne,1)'*(ModelInfo.UPsidXe\(ModelInfo.UPsidXe'\ones(ne,1))));
     
     ModelInfo.SigmaSqrc=(yc-ones(nc,1).*ModelInfo.muc)'*(ModelInfo.UPsicXc\(ModelInfo.UPsicXc'\(yc-ones(nc,1).*ModelInfo.muc)))/nc;
     ModelInfo.SigmaSqrd=(ModelInfo.d-ones(ne,1).*ModelInfo.mud)'*(ModelInfo.UPsidXe\(ModelInfo.UPsidXe'\(ModelInfo.d-ones(ne,1).*ModelInfo.mud)))/ne;
     
     ModelInfo.C=[ModelInfo.SigmaSqrc*ModelInfo.PsicXc rho*ModelInfo.SigmaSqrc*ModelInfo.PsicXcXe;
         rho*ModelInfo.SigmaSqrc*ModelInfo.PsicXeXc rho^2*ModelInfo.SigmaSqrc*ModelInfo.PsicXe+ModelInfo.SigmaSqrd*ModelInfo.PsidXe];
     sz = size(ModelInfo.C, 1);
     ModelInfo.C = ModelInfo.C + eye(sz).*Meps;
     [ModelInfo.UC, p] = chol(ModelInfo.C);
     if p>0
         min(eig(ModelInfo.C))
         Meps = Meps*10
         continue;
     end
     
     ModelInfo.mu=(one'*(ModelInfo.UC\(ModelInfo.UC'\y)))/(one'*(ModelInfo.UC\(ModelInfo.UC'\one)));
     break;
 end
    Info = ModelInfo;

end
