function AOUT = CarrierFreqOffset( AIN, FreqOff, FreqDrift , PhaseOffset)

%  Usage      : OUT = CarrierFreqOffset( AIN, FreqOff )
%
%  Function   :
%     1. Add carrier frquency offset        
%     2. AIN        : Original signal
%     3. FreqOff    : Frequency offset
%     4. FreqDrift  : Frequency Drift ( Not implemented yet)
%     5. PhaseOffset : Carrier  phase offset
%     1. AOUT       : Signal with AWGN noise
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    if ( FreqOff ~= 0 )
        phaseoff1 = 2*pi*FreqOff*(1:length(AIN)) + PhaseOffset ;
        AOUT  = AIN .* (ones(size(AIN,1), 1) *exp( phaseoff1 * 1i));
    else
        AOUT  = AIN .* ((ones(size(AIN)) *exp( PhaseOffset * 1i)));
    end
end 
