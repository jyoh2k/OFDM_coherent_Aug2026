function [xt, time] = IFFT_oversampling(X, N, L)
%IFFT_OVERSAMPLING  Frequency-domain zero-padding IFFT (L-times)
%
%   X : 1 x N frequency-domain vector (logical NFFT bins)
%   L : oversampling factor (e.g. 2 -> NIFFT = 2N)
%   xt: 1 x (N*L) time-domain vector
%
%   Layout: [X(1:N/2)  zeros(1, N*(L-1))  X(N/2+1:N)]

    if nargin < 3, L = 1; end
    NL = N * L;
    T = 1 / NL;
    time = 0:T:1-T;
    X = X(:).';
    xt = L * ifft([X(1:N/2) zeros(1, NL-N) X(N/2+1:end)], NL);
end
