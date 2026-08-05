function [txout, txsignal] =  TxMain( dataf, sims, params) 

    [txout, txsignal] = TxMain_OFDM( dataf, sims, params) ;

% global SC
    % if ( SC == 1 )
    %     [txout, txsignal] = TxMain_SC( dataf, sims, params) ;
    % else
    %     [txout, txsignal] = TxMain_OFDM( dataf, sims, params) ;
    % end 

end
