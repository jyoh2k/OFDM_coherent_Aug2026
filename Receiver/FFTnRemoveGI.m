function [ out ]=  FFTnRemoveGI( in, params )

%  Usage      :  [ out ]=  FFTnRemoveGI( in, params )
%  Function   : Remove CP, NIFFT-point FFT, extract logical NFFT bins
%     params here is params.fft from reinit_fft
%
%  Author     : Rha, Hae Young. (DFT-s / freq-OS update)

    N = params.NFFT;          % logical (128)
    L = params.Lbb;           % OS factor (2)
    NL = params.NIFFT;        % 256
    NSample = params.NSymbol * params.NSamplepersymbol;
    Nout = params.NSymbol * N;
    out = zeros(size(in,1), Nout);

    for ich=1:size(in,1)
       in1 = reshape( in(ich, 1:NSample), params.NSamplepersymbol, params.NSymbol );
       fftin  = in1(params.index, :);          % NL x NSymbol
       fftout = fft(fftin, [], 1);             % NIFFT-point FFT

       % Inverse of IFFT_oversampling packing; undo L scale
       X = zeros(N, params.NSymbol);
       X(1:N/2, :) = fftout(1:N/2, :) / L;
       X(N/2+1:N, :) = fftout(NL-N/2+1:NL, :) / L;
       out(ich, :) = reshape(X, 1, Nout);
    end

end
