disp 'definicja zadania prymalnego'

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


disp 'przeksztalcenie w postac dualna'
A = A'
b_orig = b;
b = c
c = -b_orig

disp 'dodaje zmienne dopelniajace'
A = [A -eye(2)]
c = [c; 0; 0]

disp 'buduje postac tablicowa'
Y = [
     c'  0;
    -A  -b
]

disp 'wprowadzam do bazy x5 i wyprowadzam x7 - wykonuje operacje na wierszach tabeli'
Y = pivot(Y, 5, 2)

disp 'wprowadzam do bazy x1 i wyprowadzam x8 - wykonuje operacje na wierszach tabeli'
Y = pivot(Y, 1, 3)

Y = pivot(Y, 8, 2)

Y = pivot(Y, 6, 2)

%Y(3, :) = Y(3, :) - Y(2, :)
%Y(2, :) = -Y(2, :) - 2*Y(3, :)
%Y(1, :) = Y(1, :) + 7*Y(2, :) + 9*Y(3, :)

