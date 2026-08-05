function [out]     = RateConversion( in, in_freq, out_freq )

%  Usage      : out = RateConversion( in, in_freq, out_freq )
%  Function   :
%     1. Rate conversion for different sampling frequency 
%                            such as oscilloscope and DAC      
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

if ( in_freq == out_freq )
    out = in;
    return;
end

Rate = in_freq / out_freq ;
time_in=1:length(in);
time_out=1:(Rate):length(in)+(Rate);

out = zeros(size(in,1), length(time_out));

for ii=1:size(in,1)
    tmpI_int = interp1(time_in,real(in(ii, :)), time_out, 'spline');
    tmpQ_int = interp1(time_in,imag(in(ii, :)), time_out, 'spline'); % linear, spline
    out(ii,:) = tmpQ_int *1j +  tmpI_int;
end 
% Remove abnormal last value.
out = out(:,1:end-1);
end 
