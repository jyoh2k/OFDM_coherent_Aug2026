function out = baseband2passband(in,freq,  carrier_freq)

    carrier =  ( ones(size(in,1),1) * exp ( 2*pi* 1j * carrier_freq/freq  * [0:size(in,2)-1]));
    signal = in .* carrier ;
    out = signal + conj(signal);

end