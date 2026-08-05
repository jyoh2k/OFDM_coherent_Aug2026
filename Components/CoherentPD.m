function [esignal_bw, ROP_dBm] =  CoherentPD( osignal,  params)

%  Usage      : esignal =  CoherentPD( osignal,  params)
%  Function   :
%     1.       
%  Reponsivity = quantum_efficiency * electon_charge / ( h_Plank * freq )
%              ~ quantum_efficiency * lambda (um unit)/ 1.23985 
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

%     %% PD 
%     if ( params.passband  == 1  )
%         current = (params.responsivity  * abs(osignal).^2 );
%     else
%         current = (params.responsivity  * real(osignal).^2 );
%         current = current + 1j *(params.responsivity  * imag(osignal).^2 );
%     end
%     current_sat = min( params.max_current, real(current));
%     current_sat = current_sat + 1j * min( params.max_current, imag(current));
%     esignal = params.resistor * ( current_sat );
    
    current = (params.responsivity  * osignal );
    esignal = current *  params.resistor ;  

    %% TIA 
    esignal = esignal * db2mag(params.gain_dB);
    
    %% Bandwidth effect
    esignal_bw = ChBandwidth( esignal, params.FilterCoef, params.bandwidth_en);
    
   %% Add AWGN noise : shot noise in the detector
    if ( params.nonoise == 0  )
        opt2ele_noise = AddNoise( esignal_bw, params.noise_power_dBm);
        if ( params.passband  == 0  )
            esignal_bw = esignal_bw + (opt2ele_noise) ;
        else
            esignal_bw = esignal_bw + real(opt2ele_noise)*sqrt(2);
        end
    end
    
    %%
    ROP_dBm =pow2db(mean( mean( abs(osignal ).^2))/1e-3);    
end
