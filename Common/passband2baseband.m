function out =  passband2baseband (in,freq,  carrier_freq)

%     input = baseband * (exp(1i * carrier_freq) + exp(-1i * carrier_freq) )/2;
%     input * cos(carrier_freq) 
    carrier =  ( ones(size(in,1),1) * cos ( 2*pi*   carrier_freq/freq  * [0:size(in,2)-1]));
    signalr = in .* carrier ;
    carrier =  ( ones(size(in,1),1) * sin (-2*pi*   carrier_freq/freq  * [0:size(in,2)-1]));
    signali = in .* carrier ;
    out = complex(real(signalr), real(signali));
%     out = signalr + 1j* signali;
end