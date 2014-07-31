function z = Branin(x1,x2)

z = (x2 - 5.1*x1.^2/(4*pi*pi) + 5*x1/pi -6).^2 + 10*(1-1/(8*pi))*cos(x1) + 10;

end