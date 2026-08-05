function SNR_dB = osnr2snr(OSNR_dB, Rs)

%  Usage      : SNR_dB = osnr2snr(OSNR_dB, Rs)
%  Function   :
%     1.       0.1nm (12.48 GHz )
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    OSNR = 10 .^(OSNR_dB/10);
   
    GHz=1e9;
    BRef = 12.48 *GHz; %
    SNR = OSNR * 2*BRef/Rs;
    
    SNR_dB = 10*log10(SNR);
end 
