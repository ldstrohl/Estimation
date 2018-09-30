# class containing data for estimation problem
import numpy as np


class State:
    u = 0
    z = np.matrix('0; 0')

    def __init__(self, x0, p0):
        self.x = x0
        self.P = p0
    # @classmethod
    # def New(cls,*args, **kwargs):
    #     return State(*args, **kwargs)
