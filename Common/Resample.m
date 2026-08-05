function [out]     = Resample( in, in_freq, out_freq )

%  Usage      : out = Resample( in, in_freq, out_freq )
%  Function   :
%     1. Rate conversion for different sampling frequency 
%                            such as oscilloscope and DAC      
%     2. Kaiser window filter
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

if ( in_freq == out_freq )
    out = in;
    return;
end

Rate = out_freq /in_freq ;
[p, q] = rat(Rate );

out = resample(in(1,:), p, q);
for istream=2:size(in,1)
    out(istream,:) = resample(in(istream,:), p, q);
end

end 
