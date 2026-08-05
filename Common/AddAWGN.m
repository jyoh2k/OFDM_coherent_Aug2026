function [AOUT, AWGN] = AddAWGN( AIN, SNRdB, En) 

%  Usage      : AOUT = AddAWGN( AIN, SNRdB);
%
%  Function   :
%     1. Generate AWGN noise and add it into original signal       
%     2. AIN        : Original signal
%     3. SNRdB      : SNR in dB
%     4. AOUT       : Signal with AWGN noise
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    active_data = 1:size(AIN,2);
    AWGN = GenAWGN( AIN(:,active_data), SNRdB);

    if ( En == 0 )
        AOUT =  AIN ;
    else
        AOUT =  AIN + AWGN;
    end

end
