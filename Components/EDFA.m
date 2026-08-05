function out = EDFA ( in, params)

%  Usage      : out = EDFA ( in, edfa )
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :
    if ( params.gain_dB == 0 )
        out = in ;
        return;
    end
    
    gain =  10^(params.gain_dB/20) ;
    
    if ( params.nonoise == 1)
        out =in*gain ;
    else
        noise_figure= 10^(params.NF_dB /10);
        gain1 =  10^(params.gain_dB/10) ;
        noise_density= params.hv*( noise_figure*gain1-1)*params.SampleFreq/2;
        noise=sqrt( noise_density/2 )*(randn(size(in)) + 1j*randn(size(in)));
        out =in*gain + noise;
    end
end 
