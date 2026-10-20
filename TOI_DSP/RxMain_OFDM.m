function [eq_out, frame] =  RxMain_OFDM( in, txsignal, sims, params)

%  Usage      : [recovered, frame] =  RxMain_OFDM( in, txsignal, sims, params)
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    if ( params.RX_IF_band == 1 )
        
        [in_dc]    = DCCancel ( params.DCCancel.en, in)   ;
        in_postemphais = OFDE( in_dc, params.OFDE) ;
        in_baseband =  passband2baseband (in_postemphais, params.RX_IFSampleFreq,   params.RX_IF_Freq );
        FilterCoef    = ChBandwidthInit( params.LPF.NBandwidth, 5, 0); % <-- Very important!, To support CFO of 
        in_baseband_lpf = ChBandwidth( in_baseband, FilterCoef, 1);
        in_baseband        = RateConversion( in_baseband_lpf, params.RX_IFSampleFreq, params.RXSampleFreq);
        
    else
        
        [in_rx]     = RateConversion( in, params.OSCFreq, params.RXSampleFreq );
        [in_skew]   = SkewCompensator( in_rx, params.rxskew );
        [in_baseband] = DCCancel(params.DCCancel,in_skew);
        %in_baseband = in_rx;    %test
        
    end

    [in_agc, agcgain]             = AGC( in_baseband, params.AGC);
    %in_agc = in_baseband;   %test

    % figure(3);
    % xxx = [(-1/2):1/(length(in_agc(1,:))-1):1/2]*512;
    % plot(xxx,log10(fftshift(abs(fft((in_agc(1,:)))))));
    % grid on

   [cd_comp] = OFDE(in_agc, params.OFDE);
    cd_comp = in_agc;   %test

    % figure(4);
    % xxx = [(-1/2):1/(length(cd_comp(1,:))-1):1/2]*512;
    % plot(xxx,log10(fftshift(abs(fft((cd_comp(1,:)))))));
    % grid on


    [in_sync, frame.fscs ]        = SearchFrameStart_OFDM( cd_comp, params.searchframe);

    [cfo_recovered, frame.cfrout] = RxCFR( in_sync, params.cfr);
    %cfo_recovered = in_sync;  %test   %phase rot. 발생하여 제거 @20260305
    
    [cfo_sync, frame.fsfs ] = SearchFineFrameStart_Tr( (cfo_recovered), cfo_recovered, params.searchfineframe);
    %cfo_sync = cfo_recovered;  %test
                                           
   [fcfo_sync, frame.fcfrout] = RxCFR( cfo_sync, params.fcfr);
   %fcfo_sync = cfo_sync;

    [fft_out    ]                 = FFTnRemoveGI( fcfo_sync, params.fft);

    [data_out, H, frame.ce]       = ChannelEst ( fft_out,  params.ce);

% out = H;
% w1 = squeeze(out(1,1,:));
% w2 = squeeze(out(1,2,:));
% w3 = squeeze(out(2,1,:));
% w4 = squeeze(out(2,2,:));
% 
% figure(),
% subplot(8,1,1), plot(real(w1)), title('Real(w1)');
% subplot(8,1,2), plot(imag(w1)), title('Imag(w1)');
% subplot(8,1,3), plot(real(w2)), title('Real(w2)');
% subplot(8,1,4), plot(imag(w2)), title('Imag(w2)');
% subplot(8,1,5), plot(real(w3)), title('Real(w3)');
% subplot(8,1,6), plot(imag(w3)), title('Imag(w3)');
% subplot(8,1,7), plot(real(w4)), title('Real(w4)');
% subplot(8,1,8), plot(imag(w4)), title('Imag(w4)');

    [eq2_out, pilot, eq_out2, frame] = ChannelComp ( data_out,  H, params, frame);

    eq_out = SingleStreamOut( eq2_out,  params);

    demapperout                    = OFDMDemapper( eq_out, params);

   %%
   
    frame.agcgain   = agcgain;
    frame.received  =  in_baseband;  
    frame.ADCin  =  in;
    frame.resampledout  =  cfo_sync;
    frame.equalized =  eq_out;
    frame.recovered =  eq_out;
    frame.recovered2 =  eq2_out;
    frame.cfo_recovered_eq =  cfo_sync;
    frame.phase_error_recovered_sync =  eq_out;
    frame.cfo_recovered_sync =  cfo_recovered;
    frame.cfo_recovered  =  cfo_recovered ;
    frame.phase_error_recovered =  eq_out;
    frame.fecin = demapperout;

end 
