def KF(A, B, H, Q, R, u, z, prevState):
    
	xdim = size(A, 1);
    % zdim = size(H, 2);
    if nargin < 8
        x0 = zeros(xdim, 1);
        P = eye(xdim);
    elseif
    nargin < 9
    x0 = zeros(xdim, 1);


	end

	% filter
	xpred = A * x0 + B * u;
	Ppred = A * P * A
	' + Q;
	ytilde = z - H * xpred;
	S = H * Ppred * H
	'+R;
	K = Ppred * H
	'/S;
	x = xpred + K * ytilde;
	P = (eye(2) - K * H) * P;

