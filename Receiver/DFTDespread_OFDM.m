function out = DFTDespread_OFDM(eq_grid, params)
%DFTDESPREAD_OFDM  Subchannel IDFT-s after frequency-domain equalization
%
%   eq_grid : NTXStream x (NFFT * NDataSymbol)  equalized freq samples
%   out     : NTXStream x (Nsd * NDataSymbol)   time-domain QAM (subch-major)
%
%   For each subchannel: x = ifft(X, Nd) * sqrt(Nd)

    Nd = params.dfts.Nd;
    Nsubch = params.dfts.Nsubch;
    Nsd = params.Nsd;
    NFFT = params.NFFT;
    Nsym = params.NDataSymbol;
    subch_idx = params.dfts.map.SubchDataIndex;

    ntx = size(eq_grid, 1);
    out = zeros(ntx, Nsd * Nsym);
    data_symbol = zeros(ntx, Nsd, Nsym);

    for itx = 1:ntx
        for isym = 1:Nsym
            onesym = eq_grid(itx, (isym-1)*NFFT + (1:NFFT));
            for iu = 1:Nsubch
                X = onesym(subch_idx{iu});
                x = ifft(X, Nd) * sqrt(Nd);
                data_symbol(itx, (iu-1)*Nd + (1:Nd), isym) = x;
            end
        end
    end

    out = reshape(data_symbol, ntx, Nsd * Nsym);
end
