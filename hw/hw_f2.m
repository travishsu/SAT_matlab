function z = hw_f2(X)

% Variable: 2
% Range:    [-1, 2] x [-1, 0]


x = X(1); y = X(2);
z = (4 - 2.1*x.^2 + x.^4/3).*x.^2 + x.*y + (-4 + 4*y.^2).*y.^2;