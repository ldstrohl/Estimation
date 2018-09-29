# linear KF test
# performs single prediction step of linear kalman filter using 2x2 state
# model and full linear observability in measurements. Correct result from
# MATLAB implementation.

import numpy as np
from filters import KF

class State:
    def __init__(self, x0, p0):
        self.x = x0
        self.P = p0

class DynamicModel:
    def __init__(self,a,b,h):
        # state transition matrices
        self.A = a
        self.B = b
        # measurement state matrix
        self.H = h

class FilterParams:
    def __init__(self, r, q):
        self.R = r
        self.Q = q

# Test Case 1
# Result:
# x = [2.433209;4.475787]
# P = [0.0020, -0.0010; -0.0050 0.0050]

# state model
A = np.array([[1, 3], [4, 2]])
B = np.array([[4, 5]]).T
H = np.array([[1, 0], [0, 2]])

# filter model
R = np.diag([0.01, 0.2])
Q = np.empty_like(A)

# test data
u = 3.2
z = np.array([[2.4, 9]]).T
x0 = np.array([[0, 6]]).T
P0 = np.identity(A.shape[0])



# Perform Test
prevState = State(x0, P0)
dynModel = DynamicModel(A, B, H)
filtParams = FilterParams(R, Q)


nextState = KF(prevState, dynModel, filtParams)

print("State: ", nextState.x)
print("Error: ", nextState.P)
