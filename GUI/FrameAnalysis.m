function [frameout, simout]=  FrameAnalysis( txsignal, frame, params, sims)

%  Usage      : [frameout]=  FrameAnalysis( txsignal, frame, params, sims)
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    frameout     = frame;

    if (  isempty(sims.const_axes{1})  || ~ ishandle(sims.const_axes{1}) )
        [sims.const_axes{1}, sims.const_slider(1), ...
         sims.const_axes{2}, sims.const_slider(2), ...
         sims.psd_axes,      sims.ber_axes,  sims.tau_axes, ...
         sims.cpr_axes,      sims.sync_axes, sims.sync_axes1, ...
         sims.figure_handle] = CO_OFDM(sims, params);
         sims.psdhandle.figure1 = sims.figure_handle;
         sims.evm_text          = sims.figure_handle.edit5_1;
         sims.cpr_text          = sims.figure_handle.cpr_text;
         sims.const_text(1)     = sims.figure_handle.text17;
         sims.const_text(2)     = sims.figure_handle.text19;
         sims.consthandle(1).figure1= sims.figure_handle;
         sims.consthandle(2).figure1= sims.figure_handle;
         sims.consthandle(1).popupmenu1= sims.figure_handle.popupmenu1;
         sims.consthandle(2).popupmenu1= sims.figure_handle.popupmenu2;
         sims.psdhandle.popupmenu1= sims.figure_handle.popupmenu3;
         sims.psd_text = sims.figure_handle.text20;
         sims.dfe_axes{1} = sims.figure_handle.axes2_1;
         sims.dfe_axes1(1) = sims.figure_handle.axes2_2;
         sims.dfe_axes{2} = sims.figure_handle.axes2_3;
         sims.dfe_axes1(2) = sims.figure_handle.axes2_4;
         sims.dfe_axes{3} = sims.figure_handle.axes2_5;
         sims.dfe_axes1(3) = sims.figure_handle.axes2_6;
         sims.dfe_axes{4} = sims.figure_handle.axes2_7;
         sims.dfe_axes1(4) = sims.figure_handle.axes2_8;
         sims.dfe1_axes{1} = sims.figure_handle.axes3_1;
         sims.dfe1_axes1(1) = sims.figure_handle.axes3_2;
         sims.dfe1_axes{2} = sims.figure_handle.axes3_3;
         sims.dfe1_axes1(2) = sims.figure_handle.axes3_4;
         sims.dfe1_axes{3} = sims.figure_handle.axes3_5;
         sims.dfe1_axes1(3) = sims.figure_handle.axes3_6;
         sims.dfe1_axes{4} = sims.figure_handle.axes3_7;
         sims.dfe1_axes1(4) = sims.figure_handle.axes3_8;
         sims.dfe_text(1) = sims.figure_handle.text139;
         sims.dfe_text(2) = sims.figure_handle.text140;
         sims.dfe_text(3) = sims.figure_handle.text141;
         sims.dfe_text(4) = sims.figure_handle.text142;
         sims.dfe1_text(1) = sims.figure_handle.text143;
         sims.dfe1_text(2) = sims.figure_handle.text144;
         sims.dfe1_text(3) = sims.figure_handle.text145;
         sims.dfe1_text(4) = sims.figure_handle.text146;
         set(sims.dfe1_text(1), 'String', ['EVM X Pol '] );
         set(sims.dfe_text(1), 'String', ['Channel 1->1'] );
         set(sims.dfe_text(2), 'String', ['Channel 1->2'] );
         set(sims.dfe_text(3), 'String', ['Channel 2>1'] );
         set(sims.dfe_text(4), 'String', ['Channel 2->2'] );
    end


     params.Nbitspersymbol = params.Nbpsc ;   
     params.NTrainingSymbol = 0;
    [sims, frameout] = TPRAnalysis( sims, params, frameout);
    [sims, frameout] = CPRAnalysis( sims, params, frameout);
    [sims, frameout] = CEAnalysis( sims, params, frameout);
    [sims, frameout] = SyncAnalysis( sims, params, frameout);    
    [sims, frameout] = BERAnalysis( sims, params, frameout, txsignal);
    [sims, frameout] = EVMAnalysis( sims, params, frameout, txsignal);
    [sims] = ShowConstellation( sims, params, frameout);
    [sims ] = ShowPSD( sims, params, frameout);
    frameout.Nbitspersymbol = params.Nbitspersymbol ;     GHz =1e9;
    frameout.receivedclk   =  params.RXSampleFreq/GHz;
    frameout.params = params;
    frameout.txsignal = txsignal;
    set( sims.figure_handle.figure1, 'UserData', frameout);         
    simout = sims;
end
