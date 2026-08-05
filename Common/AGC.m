function [out, gain] = AGC( in, params )

%  Usage      : [out, gain] = AGC(in, params )
%  Function   :
%     1. Gain control to meet optimum ADC gain.
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    if ( params.en == 0 )
        out = in ;
        gain = 1;
        return
    end
    avg_in = mean(abs(in).^2, 2);
    avg_in = mean(avg_in);
    gain2 = params.avg_out ./avg_in  ;
    gain = sqrt(gain2);
%     out = in .* ( gain * ones(1, size(in,2)))   ;
    out = in * gain;
    
end