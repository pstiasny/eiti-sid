# /usr/bin/env python
# coding: utf-8

import numpy as np
from numpy import matrix

class OptimalSolutionFound:
    pass

class SimplexSolution(object):
    def __init__(self, A, basis_indicies, nonbasis_indicies, costs, right_side):
        self.A = A

        self.B = basis_indicies
        self.N = nonbasis_indicies
        assert set(self.B) & set(self.N) == set(), 'B and N are disjoint'
        assert set(self.B) | set(self.N) == set(xrange(A.shape[1])), \
            'B and N cover all indicies of A'

        AB = A[:, self.B]
        AN = A[:, self.N]
        # solve for a costs vector with basis variables substituted
        # with nonbasis variables
        reduced_costs_N = costs[self.N] - AN.T * AB.I.T * costs[self.B]
        # extend c_n vector with zeroes for basis variables
        self.reduced_costs = extend_with_zeroes(
            A.shape[1], self.N, reduced_costs_N)
        # store the original costs vector
        self.c = costs

        self.b = right_side

    def find_new_basis_var(self):
        min_idx = np.argmin(self.reduced_costs)

        if self.reduced_costs[min_idx] >= 0:
            raise OptimalSolutionFound

        return min_idx

    def find_new_nonbasis_var(self, basis_var_idx):
        ac = self.A[:, basis_var_idx]
        ac[ac<=0] = float('NaN')
        b_norm = np.linalg.solve(self.A[:, self.B], self.b)
        nb_idx = np.nanargmin(np.divide(b_norm, ac))
        return self.B[nb_idx]

    def next_solution(self):
        new_basis_var_idx = self.find_new_basis_var()
        new_nonbasis_var_idx = self.find_new_nonbasis_var(new_basis_var_idx)

        next_B = self.B[:]
        next_B.append(new_basis_var_idx)
        next_B.remove(new_nonbasis_var_idx)

        next_N = self.N[:]
        next_N.append(new_nonbasis_var_idx)
        next_N.remove(new_basis_var_idx)

        return SimplexSolution(self.A, next_B, next_N, self.c, self.b)

    @property
    def is_optimal(self):
        return self.reduced_costs.min() >= 0

    def solve_for_x(self):
        xb = np.linalg.solve(self.A[:, self.B], self.b)

        # solve A_B * x_B = b assuming A_B is a permutation of identity matrix
        #print self.A[:, self.B]
        #xb = self.A[:, self.B].T * right_side

        return extend_with_zeroes(self.A.shape[1], self.B, xb)


def extend_with_zeroes(dim, indicies, vi):
    v = np.mat(np.zeros((dim, 1)))
    v[indicies] = vi
    return v

def append_artificial(mx, row):
    num_rows = mx.shape[0]
    v = matrix([ [1] if i == row else [0] for i in xrange(num_rows) ])
    return np.concatenate((mx, v), 1)


# Normalized definition of the following problem:
#
# min  −1x_1 + 3x_2 − 4x_3
# −1x_1 + 1x_2 + 2x_3 =  −2
#  1x_1 − 2x_2 + 1x_3 <=  2
# −1x_1 + 2x_2 − 2x_3 >= −1
# x >= 0

A = matrix("""
    -1.0  1.0  2.0  0.0  0.0;
     1.0 -2.0  1.0  1.0  0.0;
    -1.0  2.0 -2.0  0.0 -1.0
""")

b = matrix("-2.0; 2.0; -1.0")

A_with_artificial = A
for row in [0, 2]:
    A_with_artificial = append_artificial(A_with_artificial, row)

print 'A with artificial vars ='
print A_with_artificial

B = [5, 3, 6]
N = [0, 1, 2, 4]

c = matrix("0.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0")

phase_one_solution = SimplexSolution(A_with_artificial, B, N, c, b)
iteration = 0
while not phase_one_solution.is_optimal:
    phase_one_solution = phase_one_solution.next_solution()

    iteration += 1
    print '\nIteration #', iteration

    print "reduced_costs' ="
    print phase_one_solution.reduced_costs.T

    print 'B ='
    print phase_one_solution.B
    print 'N ='
    print phase_one_solution.N

print 'x ='
print phase_one_solution.solve_for_x(b)
