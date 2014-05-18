% definicja problemu
xa = 50;
yb = 100;
dist_a = 3.188636072053379e+02;
dist_b = 2.499479945908749e+02;
dist_c = 3.368590209568388e+02;

circ_a = @(x,y) (x-xa).^2 + y.^2 - dist_a.^2;
circ_b = @(x,y) x.^2 + (y - yb).^2 - dist_b.^2;
circ_c = @(x,y) x.^2 + y.^2 - dist_c.^2;
circ_vec = @(X) [
    circ_a(X(1), X(2));
    circ_b(X(1), X(2));
    circ_c(X(1), X(2));
];


% obliczenia
[opt, fval, info, output, fjac] = fsolve(circ_vec, [200; 200])


% wykresy
circle = @(centerX, centerY, radius) rectangle('Position',[centerX - radius, centerY - radius, radius*2, radius*2], 'Curvature',[1,1]);
axis square;

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

hold off
