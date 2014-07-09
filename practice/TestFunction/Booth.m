function z = Booth




[x,y] = meshgrid(-10:20/100:10,-10:20/100:10);

z = (x+2.*y-7).*(x+2.*y-7) + (2.*x+y-5).*(2.*x+y-5);


	
surf(x,y,z);shading interp;
colorbar;xlabel('x');ylabel('y');zlabel('function value')
	
	