function AOUT =  DAC1( AIN,  params)

%  Usage      : AOUT_bw =  DAC1( AIN, params )
%  Function   :
%     1.       Gain -> Bandwidth effect  ->  Bit width -> ENob Noise 
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    BIT = params.T.wordl;
    
    AIN = params.gain *AIN ;
    %% Bit resolution   
    if ( BIT <= 0 )
         AOUT = AIN;
    else      
        AOUTr  = fie_r( real(AIN), params.T); 
        AOUTi  = fie_r( imag(AIN), params.T); 
        if ( isreal(AIN))
            AOUT =AOUTr; 
        else
            AOUT = complex(AOUTr, AOUTi); 
        end
    end 
    
    
    %% Bandwidth effect   
    AOUT_bw = AOUT;
    if ( params.bandwidth_en == 1 )
        [AOUT_ov]     = RateConversion( AOUT, 1, 2); % 2 oversampling 
        AOUT_ov_bw    = ChBandwidth( AOUT_ov, params.FilterCoef, params.bandwidth_en);
        [AOUT_bw]  = RateConversion( AOUT_ov_bw, 2, 1); % 2-downsampling
        AOUT_bw = AOUT_bw(:, 1:size(AIN,2));
    end
    %% Noise   
        if ( params.T.signed == 1 )
            LIM = (2^(params.T.wordl -1)-1)/ 2^(params.T.fracl) ;
        else
            LIM = (2^(params.T.wordl) - 1 )/ 2^(params.T.fracl)  ;
        end
        
        SNR = ENob2SNR( params.ENob ); 
%         SNRdB = mag2db(SNR);
%         AWGN = GenAWGN( AIN, SNRdB) 
        if ( isreal(AIN)) 
            Noise = LIM / 10^(SNR/10) *(randn(1, size(AIN,2)) );
        else 
            Noise = LIM / 10^(SNR/10) *(randn(size(AIN,1), size(AIN,2)) );
            Noise = Noise + LIM / 10^(SNR/10) *(randn(size(AIN,1), size(AIN,2)) ) * 1j ;
        end

        if ( params.nonoise == 0 )
            AOUT = AOUT + Noise;
        end    
    
end 