function value = Bohachecsky_2(sample)

    % range: [-1, 1] x [-1, 1]
    x = sample(1);
    y = sample(2);

    a = 2;
    b = 0.3;
    c = 3*pi;
    d = 0.4;
    e = 4*pi;

    z = x*x + 2*y*y - b.*(cos(c*x)).*(cos(e*y)) + 0.3;

    value = z;

end
