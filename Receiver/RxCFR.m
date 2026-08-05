function [AOUT, cfrout] = RxCFR( AIN, params)  

%  Usage      :  AOUT = RxCFR( AIN, params, T )   
%
%  Function   :
%     Carrier frequency offset compensation 
%
%  Port  :
%     1. AIN        : Original signal
%     2. params     : CFR parameter
%     3. T          : Reserved for fixed sim.
%     4. AOUT       : Recovered signal
%     5. cfrout     : Recovered phase error (For debugging use)
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :
        

    [d1, d2] = size( AIN);
    DLY         = 0;
    phase       = zeros(1, d2 ) ;
    cpe_blk     = zeros(1, d2 ) ;
    acc_error   = zeros(1, d2 ) ;
    PRL         = params.PRL; 
    AOUT        = zeros(1,  d2 );
    
    %% Carrier frequency offset estimation and recovery
    if ( params.en     == 1)
        [cfeout] = CFE( AIN, params);
        cfophase = cfeout.phasediff(1) * [0:1:length(AIN)-1];
        AIN_cfo  = CPR( AIN, cfophase, params);        
    else
        cfophase = params.exp_phasediff * [0:1:length(AIN)-1];
        AIN_cfo  = CPR( AIN, cfophase, params);        
    end
    
    %% compensate initial phase offset 
    AOUT = AIN_cfo;
 
    cfrout.cfe           = cfophase ;
    cfrout.cfo_est       = ( cfophase(2) - cfophase(1) )   /pi /2;
    
end
