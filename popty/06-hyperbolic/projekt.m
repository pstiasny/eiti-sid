% definicja problemu
xa = 50;
yb = 100;
dist_a = 3.188636072053379e+02;
dist_b = 2.499479945908749e+02;
dist_c = 3.368590209568388e+02;

opt = [143; 305];


% wykresy
circle = @(centerX, centerY, radius)...
    rectangle('Position', [
        centerX - radius, centerY - radius, radius*2, radius*2],...
    'Curvature',[1,1]);
R = -4:0.1:4;
hyperbola_ew = @(x0, y0, a, b, style) plot(...
    -a*cosh(R) + x0, b*sinh(R) + y0, style,...
    a*cosh(R)  + x0, b*sinh(R) + y0, style);
hyperbola_ns = @(x0, y0, a, b, style) plot(...
    b*sinh(R) + x0,  a*cosh(R) + y0, style,...
    b*sinh(R) + x0, -a*cosh(R) + y0, style);

plot(xa, 0, 'r*')
hold on
text(xa, 0, 'A')
plot(0, yb, 'r*')
text(0, yb, 'B')
plot(0, 0, 'r*')
text(0, 0, 'C')

circle(xa, 0,  dist_a)
circle(0,  yb, dist_b)
circle(0,  0,  dist_c)

plot(opt(1), opt(2), 'r*')
text(opt(1), opt(2), 'OPT')
axis([-50 400 -50 400]);
print -depsc circles.eps

for a = 1:2:20
    b = sqrt((xa/2).^2 - a.^2);
    hyperbola_ew(xa/2, 0, a, b, 'b');
end
a_ew = abs(dist_a - dist_c) / 2
b_ew = sqrt((xa/2).^2 - a_ew.^2)
hyperbola_ew(xa/2, 0, a_ew, b_ew, 'r');
print -depsc hyperbolas_ew.eps

a_ns = abs(dist_b - dist_c) / 2
b_ns = sqrt((yb/2).^2 - a_ns.^2)
hyperbola_ns(0, yb/2, a_ns, b_ns, 'g');
print -depsc hyperbolas_ns.eps


% obliczenia
diary fvalopt.log
circ_a = @(x,y) (x-xa).^2 + y.^2 - dist_a.^2;
minfun = @(X) [
    (X(1)-xa/2).^2 ./ a_ew.^2 - X(2).^2 ./ b_ew.^2 - 1;
    (X(2)-yb/2).^2 ./ a_ns.^2 - X(1).^2 ./ b_ns.^2 - 1;
    circ_a(X(1), X(2))
];
[fsolve_opt, fval, ~, output, ~] = fsolve(minfun, [200; 200])
diary off

diary fminopt.log
dminfun = @(x,y) [
2*(2*x - 2*xa)*((x - xa)^2 - dist_a^2 + y^2) + (4*x*(x^2/b_ns^2 - (y - yb/2)^2/a_ns^2 + 1))/b_ns^2 - (2*(2*x - xa)*(y^2/b_ew^2 - (x - xa/2)^2/a_ew^2 + 1))/a_ew^2;
4*y*((x - xa)^2 - dist_a^2 + y^2) + (4*y*(y^2/b_ew^2 - (x - xa/2)^2/a_ew^2 + 1))/b_ew^2 - (2*(2*y - yb)*(x^2/b_ns^2 - (y - yb/2)^2/a_ns^2 + 1))/a_ns^2
];

OPTIONS=optimset('gradobj','on');
[xopt_num,fval_num,~,output_num] = fminunc({ (@(X) minfun(X)' * minfun(X)), (@(X) dminfun(X(1), X(2))) }, [200; 200], OPTIONS)
diary off

hold off
