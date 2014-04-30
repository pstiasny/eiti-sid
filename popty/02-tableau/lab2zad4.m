disp 'definicja zadania prymalnego'

% min -2x1
%  1x1 + 1x2  <= 7
%  2x1 + 1x2  <= 9
%  1x1 + 0x2  <= 3
% -1x1 - 1x2  <= -6
%  3x1 + 1x2  <= 10
% -4x1 - 2x2  <= -15
% X > 0

c = [-2; 0]

A = [
  1  1;
  2  1;
  1  0;
 -1 -1;
  3  1;
 -4 -2;
]

b = [7; 9; 3; -6; 10; -15]

if exist('glpk')
    % wygeneruj referncyjne rozwiazanie za pomoca wbudowanej funkcji glpk
    [XOPT, FOPT, STATUS] = glpk(c, A, b, [], [], 'UUUUUU', 'CC')
    % sprawdz poprawnosc postaci dualnej
    [XOPTd, FOPTd, STATUSd] = glpk(-b, A', -c, [], [], 'LL', 'CCCCCC', -1)
    assert(eq(FOPTd, FOPT))
end


disp 'przeksztalcenie w postac dualna'

% min 7y1 + 9y2 + 3y3 - 6y4 + 10y5 - 15y6
%   1y1 + 2y2 + 1y3 - 1y4 + 3y5 - 4y6 >=  2
%   1y1 + 1y2 + 0y3 - 1y4 + 1y5 - 2y6 >=  0
% Y > 0
A = A'
b_orig = b;
b = -c
c = b_orig


disp 'dodaje zmienne dopelniajace'
% min 7y1 + 9y2 + 3y3 - 6y4 + 10y5 - 15y6
%   1y1 + 2y2 + 1y3 - 1y4 + 3y5 - 4y6 - 1y7       = 2
%   1y1 + 1y2 + 0y3 - 1y4 + 1y5 - 2y6       - 1y8 = 0
% Y > 0
A = [A -eye(2)]
c = [c; 0; 0]

disp 'buduje postac tablicowa'
Y = [
     c'  0;
    -A  -b  % odwracam znaki aby uzyskac rozwiazanie bazowe
]

iter = 1;
while any(Y(1, 1:end-1) < 0)
    iter
    if iter > 10
        error('przekroczono limit iteracji')
    end

    [~, new_basis] = min(Y(1, 1:end-1))
    ac = Y(2:end, new_basis)
    assert(any(ac > 0))
    ac(ac<=0) = NaN;
    [~, new_nonbasis] = min(Y(2:end, end) ./ ac)
    Y = pivot(Y, new_basis, new_nonbasis + 1)

    iter = iter + 1;
end

fval = Y(1, end)
if exist('FOPT')
    assert(eq(fval, FOPT))
end
