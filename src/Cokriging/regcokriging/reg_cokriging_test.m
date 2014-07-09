
Xe = rand(5,1)*pi;
Ye = sin(Xe);

Xc = Xe; Yc = Ye;

Info = cokriging_reg(Xe, Xc, Ye, Yc);

out = linspace(0, pi, 1000)';
V   = zeros(1000, 1);
mse = V;
ei  = V;

Info.lambdac
Info.lambdad

for i = 1:1000
    [V(i), mse(i), ei(i)] = cokrigingpredictor(Info, out(i));
end

clf
hold on;


plot(out, V);

for i = 1:size(Xe, 1)
    plot(Xe(i,1), Ye(i), 'o');
end

hold off;