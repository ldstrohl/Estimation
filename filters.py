# module containing estimation filters

import numpy as np
from state import State


class KalmanFilter:
    def __init__(self, r, q):
        self.r = r
        self.q = q

    def update(self, previous_state, dynamic_model):
        x0 = previous_state.x
        P0 = previous_state.P

        A = dynamic_model.A
        B = dynamic_model.B
        H = dynamic_model.H

        u = previous_state.u
        z = previous_state.z

        # filter
        x_pred = A @ x0 + B @ u
        P_pred = A @ P0 @ A.T + self.q
        meas_error = z - H @ x_pred
        S = H @ P_pred @ H.T+self.r
        try:
            K = np.linalg.solve(S.T, (P_pred @ H.T).T).T
        except:
            K = np.zeros_like(A)
        x = x_pred + K * meas_error
        P = (np.identity(2) - K @ H) @ P_pred

        return State(x, P)
