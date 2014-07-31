function z = Bohachecsky_2


a=2;
b=0.3;
c=3*pi;
d=0.4;
e=4*pi;

[x,y] = meshgrid(-1:1/100:1,-1:1/100:1);

z = x*x+2*y*y-...
    b.*(cos(c*x)).*(cos(e*y))+...
    0.3;

	
surf(x,y,z);shading interp;
colorbar;xlabel('x');ylabel('y');zlabel('function value')
	
	