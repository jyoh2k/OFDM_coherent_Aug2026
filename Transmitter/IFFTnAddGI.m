function [ out ]=  IFFTnAddGI( in, params )

%  Usage      :  out =  IFFTnAddGI( in, params )
%  Function   : Frequency-domain OS IFFT (NIFFT) + CP
%     params here is params.ifft from reinit_ifft
%
%  Author     : Rha, Hae Young. (DFT-s / freq-OS update)

    N = params.NFFT;                 % logical FFT size (128)
    L = params.Lbb;                  % freq OS factor (2)
    NL = params.NIFFT;               % IFFT size (256)
    Nsymbol = ceil(size(in,2) / N);
    Nzeropad = Nsymbol * N - size(in,2);
    Nout = Nsymbol * params.NSamplepersymbol;
    out = zeros(size(in,1), Nout);

    for ich=1:size(in,1)
       power_sc = ones(N,1);
       power_sc(params.SubcarrierIndex,1) = params.power_sc(ich, params.SubcarrierIndex);
       in_pad = [in(ich,:) zeros(1,Nzeropad)];
       in1 = reshape( in_pad, N, Nsymbol ) .* (power_sc * ones(1,Nsymbol));

       ifftout = zeros(NL, Nsymbol);
       for isym = 1:Nsymbol
           ifftout(:, isym) = IFFT_oversampling(in1(:, isym).', N, L).';
       end
       guardout = ifftout(params.CPindex, :);   % CP + body (length NSamplepersymbol)
       out(ich, :) = transpose(guardout(:));
    end

end
