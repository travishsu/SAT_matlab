function value = Booth(sample)

% range: [-10, 10] x [-10, 10]

x = sample(1);
y = sample(2);

z = (x+2.*y-7).*(x+2.*y-7) + (2.*x+y-5).*(2.*x+y-5);
	

value = z;
	