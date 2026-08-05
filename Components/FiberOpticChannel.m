function AOUT =  FiberOpticChannel( AIN, params ) 

%  Usage      : AOUT =  FiberOpticChannel( AIN, params ) 
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    if ( params.fiber_length  == 0 )        
        AOUT = AIN;
        return;
    end 

    [d1, d2] = size(AIN);

    if ( d1 == 1 )
    	AIN = [AIN; zeros(1, length(AIN));];
    end
    
    fiber_in = AIN;

    for Nfiber=1:(params.span-1)
        params.ssmf.FiberLength = params.edfa.length;

        fiber_out  = NLSE_2Pol( fiber_in, params.ssmf) ;
        fiber_in   = EDFA( fiber_out, params.edfa) ;
    end 
    if ( params.last_length  ~= 0 )
        params.ssmf.FiberLength=params.last_length;
        fiber_out  = NLSE_2Pol( fiber_in, params.ssmf) ;
        fiber_in   = fiber_out;
    end
    if ( params.dcf.fiber_length ~= 0 )
        fiber_out  = NLSE_2Pol( fiber_in, params.dcf ) ;
        fiber_in   = fiber_out;
    end
    
    %params.rx_power_split = [1 0; 0 1];
    fiber_out = params.rx_power_split * fiber_in;
    %disp(params.rx_power_split);
    %fiber_out = fiber_in;

    AOUT = fiber_out(1:d1, :) ;
        
end
