function [f, s, ExpImp] = cokrigingpredictor_reg(Info, x)
% metric = cokrigingpredictor(x)
%
% Calculates the co-Kriging prediction, RMSE, -log(E[I(x)]) or -log(P[I(x)])
%
% Inputs:
%	x - 1 x k vetor of design variables
%
% Global variables used:
%	Info.Xc - n x k matrix of cheap sample locations
%	Info.yc - n x 1 vector of cheap observed data
%	Info.Xe - n x k matrix of expensive sample locations
%	Info.ye - n x 1 vector of expensive observed data
%   Info.Thetac - 1 x k vector of log(theta) of cheap model
%   Info.Thetad - 1 x k vector of log(theta) of difference model
%   Info.SigmaSqrc - scalar variance of cheap model
%   Info.SigmaSqrd - scalar variance of expensive model
%   Info.rho - scalar scaling parameter
%   Info.UC - nc x nc Cholesky factorisation of C
%   Info.Option - string: 'Pred', 'RMSE', 'NegLogExpImp' or 'NegProbImp'
%
% Outputs:
%	metric - prediction, RMSE, -log(E[I(x)]) or -log(P[I(x)]), determined
%	by Info.option
%
% Copyright 2007 A I J Forrester
%
% This program is free software: you can redistribute it and/or modify  it
% under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any
% later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License and GNU
% Lesser General Public License along with this program. If not, see
% <http://www.gnu.org/licenses/>.

Xe = Info.Xe;
Xc = Info.Xc;
ye = Info.ye;
yc = Info.yc;
ne = size(Xe,1); 
nc = size(Xc,1); 
thetad = 10.^Info.Thetad;
thetac = 10.^Info.Thetac;
p = 2;  % added p definition (February 10)
rho = Info.rho;
one = ones(nc+ne,1);
y   = [yc; ye];
cc  = ones(nc,1);
for i = 1:nc
	cc(i) = rho*Info.SigmaSqrc*exp(-sum(thetac.*abs(Xc(i,:)-x).^p));
end
cd = ones(ne,1);
for i = 1:ne
	cd(i) = rho^2*Info.SigmaSqrc*exp(-sum(thetac.*abs(Xe(i,:)-x).^p))+Info.SigmaSqrd*exp(-sum(thetad.*abs(Xe(i,:)-x).^p));
end
c = [cc;cd];
f = Info.mu+c'*(Info.UC\(Info.UC'\(y-one.*Info.mu))); 
% f = Info.mu+c'*(Info.UC\(Info.UCD\(Info.UC'\(y-one.*Info.mu)))); 
% f = Info.mu+c'*(Info.C\(y-one.*Info.mu)); 


    SSqr = rho^2*Info.SigmaSqrc+Info.SigmaSqrd-c'*(Info.UC\(Info.UC'\c));
    s = abs(SSqr)^0.5;
    yBest = max(ye);

    if SSqr <= 1e-13
        ExpImp = 0;
    else
        EITermOne = (f-yBest)*(0.5+0.5*erf((1/sqrt(2))*((f-yBest)/s)));
        EITermTwo = s*(1/sqrt(2*pi))*exp(-(1/2)*((f-yBest)^2/SSqr));
        ExpImp = EITermOne+EITermTwo; % changed from "ExpImp = log10(EITermOne+EITermTwo+eps);" (September 2009)
    end
        
 


% if strcmp(Info.Option,'Pred') =  = 1
%     metric = f;
% elseif strcmp(Info.Option,'RMSE') =  = 1
%     metric = s;
% elseif strcmp(Info.Option,'NegLogExpImp') =  = 1
%     metric = -ExpImp;
% elseif strcmp(Info.Option,'NegProbImp') =  = 1
%     metric = -ProbImp;
% end



