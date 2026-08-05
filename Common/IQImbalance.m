function [AOUT]= IQImbalance( AIN, params, SampleFreq)

%  Usage      : [AOUT]= IQImbalance( AIN, params)
%  Function   :
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    AOUT  = AIN;
    %% IQ amplitude imbalance 
    for ich=1:size(AIN,1)
        AOUT(ich,:)=complex(real(AOUT(ich,:)), ...
                        imag(AOUT(ich,:))* (1+ params.gainim(ich))); 
    end


    %% IQ phase imbalance 
    for ich=1:size(AIN,1)
        AOUT_phase  = AOUT(ich, :)* exp( 1j * params.phaseim(ich) * 2 * pi /360 );
        AOUT(ich,:)=complex(real(AOUT(ich,:)),  imag(AOUT_phase)); 
    end

    %% IQ skew
    for ich=1:size(AIN,1)
        timein = 1:size(AOUT,2);
        timeout = timein + params.iqskew(ich) * (SampleFreq);
        AOUT1 = interp1(timein, imag(AOUT(ich,:)), timeout,  'spline'); 
        AOUT(ich,:)=complex(real(AOUT(ich,:)), AOUT1);
    end 
end 
