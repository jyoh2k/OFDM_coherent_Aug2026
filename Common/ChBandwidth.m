
function AOUT = ChBandwidth( AIN,FiltCoef, En)

%  Usage      : AOUT = ChBandwidth( AIN, FiltCoef, En)
%
%  Function   :
%     1. Bandwidth effect modelling using a filter.
%     2. AIN        : Original signal
%     3. FilterCoef : Filter coefficients
%     4. En         : Enable/Disable bandwidth effect
%     5. AOUT       : Output Signal 
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    [d1, d2] = size( AIN );
    AOUT     = zeros(d1, d2);    

    if ( En == 0 )
        AOUT  = AIN ;
    else
        AOUT  = AIN ;
        for jj=1:d1
            inr =  [ real(AIN(jj,:)) ];
            ini =  [ imag(AIN(jj,:)) ];
            filteroutr = filter(  FiltCoef.b,  FiltCoef.a, inr );
            filterouti = filter(  FiltCoef.b,  FiltCoef.a, ini );
            filteridx = round((size(FiltCoef.b,2)+1)/2)+round((size(FiltCoef.a,2)+1)/2);
            filteroutr = filteroutr(1,filteridx:end-filteridx);
            filterouti = filterouti(1,filteridx:end-filteridx);
%             filteroutr = filtfilt(  FiltCoef.b,  FiltCoef.a, inr );
%             filterouti = filtfilt(  FiltCoef.b,  FiltCoef.a, ini );
            AOUT(jj,filteridx:end-filteridx) = complex( filteroutr, filterouti);   
        end 
         
    end
end
