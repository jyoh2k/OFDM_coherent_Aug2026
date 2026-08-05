function [out]     = SkewCompensator( in, params )

%  Usage      : out = SkewCompensator( in, params )
%  Function   : 
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

if ( params.en == 0 )
    out = in;
    return;
end

 
d1=length(in);
in=[in in(:,1:100)];
time_in=1:length(in);

out = zeros(size(in,1), length(time_in));

for ii=1:size(in,1)
    time_out=time_in +real(params.sft(ii));
    tmpI_int =  interp1(time_in,real(in(ii, :)), time_out, 'spline');
    time_out=time_in +imag(params.sft(ii));
    tmpQ_int = interp1(time_in,imag(in(ii, :)), time_out, 'spline'); % linear, spline
    out(ii,:) = tmpQ_int *1j +  tmpI_int;
end 
out = out(:, 1:d1);


    %% IQ amplitude imbalance 
    for ich=1:size(out,1)
        out(ich,:)=complex(real(out(ich,:)), ...
                        imag(out(ich,:))* (1+ params.gainim(ich))); 
    end


    %% IQ phase imbalance 
    for ich=1:size(out,1)
        out_phase  = out(ich, :)* exp( 1j * params.phaseim(ich) * 2 * pi /360 );
        out(ich,:)=complex(real(out(ich,:)),  imag(out_phase)); 
    end

    
end 
