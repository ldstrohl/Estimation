# module of dynamics models for state estimation
class LinearDynamics:
    def __init__(self, a, b, h):
        # state transition matrices
        self.A = a
        self.B = b
        # measurement state matrix
        self.H = h
