function [AOUT, TimingDelay]= SamplingFreqOffset( AIN, FreqOff, TimeOff )

%  Usage      : AOUT = SamplingFreqOffset( AIN, FreqOff, timeoff )
%  Function   :
%     1. Add sampling clock frquency, timing offset        
%     2. AIN        : Original signal
%     3. FreqOff    : Frequency offset
%     4. AOUT       : Signal with AWGN noise
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

AOUT = AIN;

if ( FreqOff == 0 && TimeOff == 0 )
    TimingDelay = 0;
    return;
end
    
filterlength = 31 ;  % Number of Tap ;; Dont change.
filterlength_2 = (filterlength-1)/2 ;

if ( FreqOff == 0 )
    timing_delay = -TimeOff ;
    tim_filter_coef = sinc(timing_delay + (1:filterlength) - filterlength_2 );
    [d1, d2] =size(AIN);
    AIN1 = [AIN, zeros(d1, filterlength)];

    for idim=1:d1
        AOUT1 = conv( AIN1(idim,:), tim_filter_coef );
        AOUT(idim,:) = AOUT1(1, filterlength_2-1+(1:d2));     
    end
    TimingDelay = timing_delay * ones( d1, d2) ;
else 
    margin = 110;
    timing_delay = (TimeOff +FreqOff*( 0:1:length(AIN)+margin));
    timing_delay_int = floor(timing_delay);
    timing_delay_frac = timing_delay - timing_delay_int;
    if (  abs(timing_delay(end)) >= margin  )
        error(' Timing Delay due to sampling frequency offset is too high');
    end

    [d1, d2] =size(AIN);
    AIN1 =  [zeros(d1,filterlength_2), AIN, ...
             zeros(d1,filterlength+max(0, -min(timing_delay_int)))];

    AOUT =   zeros(d1,d2);
    for iSample=1:d2 + max( timing_delay_int(end), 0) 
        tim_filter = sinc(timing_delay_frac (iSample) + (1:filterlength) - filterlength_2 );
        for np=1:d1
                AOUT(np,iSample) = sum(tim_filter .* AIN1(np, iSample- timing_delay_int(iSample)+(1:filterlength)));
        end
    end 
    TimingDelay = timing_delay ;

end
end
