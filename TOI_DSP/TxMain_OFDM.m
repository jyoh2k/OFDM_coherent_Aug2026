function [ txout_if, txsignal ]=  TxMain_OFDM( dataf, sims, params )

%  Usage      : [ ofdmout ]=  TxMain_OFDM( dataf, sims, params )
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    	[mapper1, mapper]    = OFDMMapper( dataf,  params); 

        mapper3   = MultiStreamOut ( mapper1,  params);
   
        mapper2   = MultiStreamOut ( mapper,  params);
      
        pilotout      = AddPilotSymbol( mapper3, params.pilot );

        ltfout        = AddLTF( pilotout, params.ltf );

        ifftout       = IFFTnAddGI(ltfout, params.ifft );  

        txframe       = AddTrainingSymbol ( ifftout,  params ); % Add STF 
                
        txout_filter_ov   = MatchedFilter_OFDM( txframe, params.TXMatchedfilter );
    
        % Sample rate already set by freq-OS IFFT (no 2x time upsample)
        txout         = Resample( txout_filter_ov, params.BaudFreq, params.TXSampleFreq);

        txout_agc      = AGC( txout, params.TXAGC);
        %% 
        if ( params.TX_IF_band == 1 )
            txout_base   =  txout_agc;
            txout_base =   pad_frame ( txout_base, params.TXSampleFreq, params.TX_IFSampleFreq)  ;
            txout_resample   = Resample( txout_base, params.TXSampleFreq, params.TX_IFSampleFreq  );
            txout_if   =  baseband2passband (txout_resample, params.TX_IFSampleFreq,   params.TX_IF_Freq );
        else
            txout_if = txout_agc;
        end
 

    %%
    txsignal.dataf = dataf;
    txsignal.fecout = dataf;
    txsignal.mapper2 = mapper2;
    txsignal.mapper3 = mapper3;
    txsignal.mapper  = mapper ;
    txsignal.txframe  = txframe ;
    txsignal.txout        = txout ;
    txsignal.txout_if     = txout_if;
    txsignal.sync_pattern =  params.sync_pattern;

end
