% funkcja pierwotna
f = @(x1,x2) 10*(2*x2.^2-x1).^2+(x2-2).^2;

% gradient
df = @(x) [
  20*x(1) - 40*x(2)^2;
   2*x(2) - 80*x(2)*(x(1) - 2*x(2)^2) - 4
];

% hessian
d2f = @(x) [
        20,                  -80*x(2);
  -80*x(2),  480*x(2)^2 - 80*x(1) + 2
];

% aproksymacja kwadratowa funkcji w punkcie X0
X0 = [-9;6];
F = f(X0(1), X0(2));
DF = df(X0);
D2F = d2f(X0);
af = @(x) F + DF' * (x-X0) + (x-X0)' * D2F * (x-X0) / 2;

[X1, X2] = meshgrid(-100:5:100, -5:0.5:10);
VAF = zeros(size(X1,1), size(X2,2));
for x1 = 1:size(X1,1)
    for x2 = 1:size(X2,2)
        VAF(x1, x2) = af([X1(x1, x2); X2(x1, x2)]);
    end
end

surf(X1, X2, f(X1, X2));
hold on;
mesh(X1, X2, VAF)

% analitycznie wyznaczylem minimum aproksymacji
% daf(X_min) = 0
% D2F*(X_min-X0) + DF = 0
X_min = X0 - (D2F \ DF)
% x0 -> fmin wykreslone kolorem czerwonym
plot3([X0(1); X_min(1)], ...
      [X0(2); X_min(2)], ...
      [F;af(X_min)], ...
      'Color', 'r', 'LineWidth', 4)

xk = [2; -1.2];
X_min = xk - (d2f(xk) \ df(xk));
xkxmin = X_min - xk;
d = xkxmin / length(xkxmin)
% xk -> min daf_xk  wykreslone kolorem zielonym
plot3([xk(1); X_min(1)], ...
      [xk(2); X_min(2)], ...
      [f(xk(1), xk(2));af(X_min)], ...
      'Color', 'g', 'LineWidth', 4)

xlabel x1
ylabel x2
hold off;
