function SNR_BW_dB = snr_bw(SNR_dB, signal_bw, noise_bw)

%  Usage      :SNR_BW_dB = snr_bw(SNR_dB, signal_bw, noise_bw)
%  Function   :
%     1.       0.1nm (12.48 GHz )
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :
     SNR_BW_dB  = SNR_dB + 10*log10(signal_bw / noise_bw);
end 
