function out_bw = Amplifier ( in, params)

%  Usage      : out_bw = Amplifier ( in, params )
%  Function   :
%     1. Gain       
%     2. Nonlinear effect       
%     3. Noise
%     4. Bandwidth effct
%
%  - Nonlinear effect of amplifier is modeled with tanh function
%  - noise_figure  = P,,NOUT,, - (-174dBm/Hz + 10 * log10(BW) + Gain)
%   ( https://www.maximintegrated.com/en/app-notes/index.mvp/id/2875, gain method )
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    % Gain of 1 means no amplifier.
    if ( params.gain_dB == 0 )
        out_bw = in ;
        return;
    end
    
    gain =  10^(params.gain_dB/20) ;
    mW =1e-3;
    if ( params.nonoise == 1)
        out =in*gain ;
    else
        if ( params.bandwidth_en ==  1)
            BW                = params.bandwidth ;
        else
            BW                = params.SampleFreq ;
        end
        noise_density_dBm = params.NF_dB + (-174  + 10 * log10(BW) + params.gain_dB);
        noise_density     = 10^(noise_density_dBm/10) * mW; 
        if (isreal(in))
            noise             = sqrt( noise_density )*randn(size(in)) ;
        else
            noise             = sqrt( noise_density/2 )*(randn(size(in)) + 1j*randn(size(in))) ;
        end
        if ( params.V_sat <= 0 )
        	out               = in * gain + noise;
        else 
        	out               = params.V_sat * tanh(in * gain/params.V_sat) + noise;
        end
    end
    
    out_bw = ChBandwidth( out, params.FilterCoef, params.bandwidth_en);
end 
