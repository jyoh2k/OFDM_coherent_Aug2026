function [simout]=  SimAnalysis( sims, simout, frameout, simnum )

%  Usage      : [frameout]=  SimAnalysis( sims, simout, frameout, simnum)
%  Function   :
%     1. Get statistics for a simulation set.

%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    if ( simnum < 2 )
        sims.max_num_sim =1;
        simout.codedBERBER = zeros(1, sims.max_num_sim );
        simout.BER = zeros(1, sims.max_num_sim );
        simout.EVM = zeros(1, sims.max_num_sim ) ;
        simout.MSFE = zeros(1, sims.max_num_sim ) ; % Mean square CFO estimation error 
        simout.MSPE = zeros(1, sims.max_num_sim ) ; % Mean square Phase stimation error 
        simout.MSTE = zeros(1, sims.max_num_sim ) ; % Mean square TEE estimation error 
        simout.Nbiterr = zeros(1, sims.max_num_sim ) ; % The number of error bits   per each sim
        simout.Ntotal = zeros(1, sims.max_num_sim ) ; %  Total number of bits per sim
    end 
    simout.Nbiterr(simnum) = sum( frameout.Nbiterr) ;
    simout.codedBER(simnum) = sum( frameout.codedBER) ;
    simout.Ntotal(simnum) = sum( frameout.Ntotal) ;
    simout.BER(simnum) = mean( frameout.BER) ;
    simout.EVM(simnum) = mean( frameout.EVM) ;
    simout.MSFE(simnum) = (frameout.fee(1) )^2 ;
    simout.MSPE(simnum) =  (frameout.pee   );
    simout.MSTE(simnum) = (frameout.tee(1) ) ;
    simout.meanout =[ mean(simout.BER),  mean(simout.EVM), ...
                      mean(simout.MSFE), mean(simout.MSPE), ...
                      mean(simout.MSTE)];
    simout.Totframe = simnum;
    
    

end
