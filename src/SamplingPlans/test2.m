% Make ModelInfo visible to all functions
global ModelInfo
% Sampling plan
ModelInfo.X=bestlh(10,2,50,25);
% Compute objective function values ¡V in this case using
% the dome.m test function
for i=1:size(ModelInfo.X,1)
ModelInfo.y(i)=dome(ModelInfo.X(i,:));
end
ModelInfo.y=ModelInfo.y';
% Basis function type:
ModelInfo.Code=3;
% Estimate model parameters
rbf
% Plot the predictor
x=(0:0.025:1);
for i=1:length(x)
for j=1:length(x)
M(j,i)=predrbf([x(i) x(j)]);
end
end
contour(x,x,M)