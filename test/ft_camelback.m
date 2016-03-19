function value = ft_camelback(sample)

    x = sample(1);
    y = sample(2);
    z = (4 - 2.1*x.^2 + x.^4/3).*x.^2 + x.*y + (-4 + 4*y.^2).*y.^2;
    
    value = z;

end