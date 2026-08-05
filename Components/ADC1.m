function AOUT =  ADC1( AIN, params) 

%  Usage      : AOUT =  ADC( AIN, params )
%  Function   :
%     1.       Gain -> Bandwidth effect  ->  Bit width -> Noise 
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :
 
    BIT = params.T.wordl;
    
    AIN =  params.gain * AIN ;
    %% Bandwidth effect 
    AIN_bw = AIN;
    if ( params.bandwidth_en == 1 )
        [AIN_ov]     = RateConversion( AIN, 1, 2); % 2 oversampling 
        AIN_ov_bw    = ChBandwidth( AIN_ov, params.FilterCoef, params.bandwidth_en);
        [AIN_bw]  = RateConversion( AIN_ov_bw, 2, 1); % 2-downsampling
        AIN_bw = AIN_bw(:, 1:size(AIN,2));
    end
        
     %% Bit resolution   
    if ( BIT <= 0 )
         AOUT = AIN_bw;
    else     
        if ( isreal(AIN) == 1 )
            AOUT  = fie_r( real(AIN_bw), params.T); 
        else
            AOUTr  = fie_r( real(AIN_bw), params.T); 
            AOUTi  = fie_r( imag(AIN_bw), params.T); 
            AOUT = complex(AOUTr, AOUTi);
        end
    end 
    
   %% Noise 
    SNR = ENob2SNR( params.ENob ); 
    if ( params.T.signed == 1 )
        LIM = (2^(params.T.wordl -1)-1)/ 2^(params.T.fracl) ;
    else
        LIM = (2^(params.T.wordl) - 1 )/ 2^(params.T.fracl)  ;
    end
    Noise = LIM / 10^(SNR/10) *(randn(size(AIN,1), size(AIN,2)) );
    if ( isreal(AIN) ==  0 )
        Noise = Noise + LIM / 10^(SNR/10) *(randn(size(AIN,1), size(AIN,2)) ) * 1j;
    end
    if ( params.nonoise == 0 )
        AOUT = AOUT + Noise;
    end 
end 
