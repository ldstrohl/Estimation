# linear KF test
# performs single prediction step of linear kalman filter using 2x2 state
# model and full linear observability in measurements. Correct result from
# MATLAB implementation.

import numpy as np
from state import State
from dynamics import LinearDynamics
from filters import KalmanFilter


class Inputs:
    def __init__(self, u, z):
        self.u = u
        self.z = z


# Test Case 1
# Result:
# x = [2.433209;4.475787]
# P = [0.0020, -0.0010; -0.0050 0.0498]


# state model
A = np.array([[1, 3], [4, 2]])
B = np.array([[4, 5]]).T
H = np.array([[1, 0], [0, 2]])

# filter model
R = np.diag([0.01, 0.2])
Q = np.empty_like(A)

# test data
u = np.matrix('3.2')
z = np.array([[2.4, 9]]).T
x0 = np.array([[0, 6]]).T
P0 = np.identity(A.shape[0])


# Perform Test
previous_state = State(x0, P0)
previous_state.u = u
previous_state.z = z
dynamic_model = LinearDynamics(A, B, H)
kalman_filter = KalmanFilter(R, Q)
inputs = Inputs(u, z)

next_state = kalman_filter.update(previous_state, dynamic_model)

print("State: ", next_state.x)
print("Error: ", next_state.P)
print("Measurement: ", previous_state.z)
print("Input: ", previous_state.u)
