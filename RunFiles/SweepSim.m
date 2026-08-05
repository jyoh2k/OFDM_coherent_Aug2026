function  [sims, params] = SweepSim(  sims, params, simseq)
%  Usage      : [sims, params] = SweepSim(  sims, params, X_coor, sim sequence)
%  Function   :
%     Generate sim, param to sweep the simulation .
%
%     sims.mode 
%     1: SNR, 2: TX bandwidth 3: TX Linewidth 4: Carrier Frequency 5:Jitter
%     6: TimeFreqOff 7: TimePhaseOff, 8: RX Linewidth  
%     10: ETC 11:RX DSP LPF bandwidth 12:  AGC Averag
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    global SW_PATH
    run( [ 'Units.m']); 
    X_coor = sims.X_coor;
    sims.gen_tx = 0 ;
    switch sims.mode 
        case 0
            sims.Xlabel = 'No swep';

        %% Simulation, channel 
        case 51 
            SNRdB =[X_coor(simseq);] ;
            sims.channel.SNRdB_bw = snr_bw(SNRdB, params.BaudFreq, sims.channel.RXSampleFreq);
            sims.Xlabel = 'SNR(dB)';
        case 52
            sims.channel.TXBandwidth = [X_coor(simseq);] ;  
            NBandwidth     = 2 * sims.channel.TXBandwidth / sims.channel.SampleFreq;
            FilterTapNum     = 5;
            sims.channel.TXLPF.Coef = ChBandwidthInit(NBandwidth,FilterTapNum, 0);
            sims.Xlabel = 'Bandwidth (TX)'; 
        case 53
            sims.channel.TXLineWidth = [X_coor(simseq);] ;
            sims.Xlabel = 'Linewidth (TX)';      
        case 54
            sims.channel.CarrierFreqOff = [X_coor(simseq);] ;
            sims.channel.CarrierFreqOff_norm  = ...
                         sims.channel.CarrierFreqOff / sims.channel.SampleFreq;
            sims.Xlabel = 'Carrier frequency offset '; 
        case 55
            sims.channel.Jitter = [X_coor(simseq);] ;
            sims.Xlabel = 'Jitter';     
        case 56
            sims.channel.TimeFreqOff = [X_coor(simseq);] ;
            sims.Xlabel = 'Sampling frequency offset '; 
        case 57
            sims.channel.TimePhaseOff = [X_coor(simseq);] ;
            sims.Xlabel = 'Sampling phase offset(Normalized to sampling period)';     
        case 58
            sims.channel.RXLineWidth = [X_coor(simseq);] ;
            sims.Xlabel = 'Linewidth (RX) ';            

        case 59
            sims.channel.RXMixer.bandwidth  = [X_coor(simseq);] ;
            sims.Xlabel = 'Bandwidth'; 
            sims.channel.RXMixer.NBandwidth    = sims.channel.RXMixer.bandwidth * 2 / sims.channel.RXMixer.SampleFreq ;
            FilterTapNum =5;
            sims.channel.RXMixer.FilterCoef    = ChBandwidthInit( sims.channel.RXMixer.NBandwidth, FilterTapNum, 0); 
        case 60
            sims.channel.fiber_length = [X_coor(simseq);] ;
            [sims.channel]=  get_channel_parameter ( sims.channel );
            [params.OFDE] =  get_OFDE ( sims.channel, params.OFDE  );
            sims.Xlabel = 'Fiber length';
        case 61
            sims.channel.MZmod.launch_power = [X_coor(simseq);] ;
            sims.Xlabel = 'Launch power(W)';
        case 62
            sims.channel.ssmf.power_split2 = [X_coor(simseq);] ;
            [sims.channel]=  get_channel_parameter ( sims.channel );
            sims.Xlabel = 'Fiber Pol rotation(normalized to pi/2)';
        case 63
            sims.channel.RFDriver.gain_dB  = [X_coor(simseq);] ;
            sims.Xlabel = 'RF Driver gain (dB)';
        case 64
            sims.channel.txedfa.gain_dB  = [X_coor(simseq);] ;
            sims.Xlabel = 'gain_dB';
        case 65
            sims.channel.PD.bandwidth =  [X_coor(simseq)] *GHz;
            [sims, params]=  ReInit ( sims, params  );
            sims.Xlabel = 'PD Bandwidth (GHz)';
        case 66
            sims.channel.TXDAC.bandwidth =  [X_coor(simseq)] *GHz;
            [sims, params]=  ReInit ( sims, params  );
            sims.Xlabel = 'DAC Bandwidth (GHz)';
        case 67
            sims.channel.RXADC.bandwidth =  [X_coor(simseq)] *GHz;
            [sims, params]=  ReInit ( sims, params  );
            sims.Xlabel = 'ADC Bandwidth (GHz)';
        case 68
            sims.channel.MZmod.bandwidth =  [X_coor(simseq)] *GHz;
            [sims, params]=  ReInit ( sims, params  );
            sims.Xlabel = 'MZM Bandwidth (GHz)';
        case 69
            sims.channel.TXDAC.gain =  [X_coor(simseq)] ;
            sims.Xlabel = 'DAC gain';

        case 70
            sims.channel.RXMixer.psd_val_dbc_per_hz(4) = [X_coor(simseq);] ; 
            sims.Xlabel = 'psd val dBc per Hz '; 
        case 71
            sims.channel.RXMixer.psd_val_dbc_per_hz(5) = [X_coor(simseq);] ; 
            sims.Xlabel = 'psd val dBc per Hz '; 
        case 72
            sims.channel.RXMixer.psd_val_dbc_per_hz(6) = [X_coor(simseq);] ; 
            sims.Xlabel = 'psd val dBc per Hz '; 
        case 73
            sims.channel.RXMixer.psd_val_dbc_per_hz(7) = [X_coor(simseq);] ; 
            sims.Xlabel = 'psd val dBc per Hz '; 
        case 74
            sims.channel.RXMixer.psd_val_dbc_per_hz(9) = [X_coor(simseq);] ; 
            sims.Xlabel = 'psd val dBc per Hz '; 
        case 75
            params.NTrainingSymbol  = [X_coor(simseq);] ;
            [sims, params]=  ReInit ( sims, params  );
            sims.Xlabel = ' # Training symbols';
        case 76
            sims.channel.TXLineWidth = [X_coor(simseq);] ;
            sims.channel.RXLineWidth = [X_coor(simseq);] ;
            sims.Xlabel = 'Linewidth (TX/RX)';      
        case 77
            sims.channel.PMD         = [X_coor(simseq);] * ps ;
            [sims, params]=  ReInit ( sims, params  );
            sims.Xlabel = 'PMD(ps) ';
        case 78
            sims.channel.iqimb.gainim =  [ (db2mag(X_coor(simseq))-1); ] * ones(1,2) ;
            sims.Xlabel = 'RX I-Q gain imbalance(dB) ';
        case 79
            sims.channel.iqimb.phaseim =  [X_coor(simseq);] * ones(1,2) ;
            sims.Xlabel = 'RX I-Q phase imbalance(degree)';
        case 80
            sims.channel.iqimb.iqskew  = [X_coor(simseq);] * ones(1,2) ;
            sims.Xlabel = 'RX I-Q Skew ';
        case 81
            sims.channel.ssmf.PDLdB       = [X_coor(simseq);] ;
            sims.Xlabel = 'PDL ';
            [sims.channel]=  get_channel_parameter ( sims.channel );
        case 82
            sims.channel.TXDAC.ENob =  [X_coor(simseq)] ;
            sims.Xlabel = 'DAC ENob';
        case 83
            sims.channel.RXADC.ENob =  [X_coor(simseq)] ;
            sims.Xlabel = 'ADC ENob';
        case 84 
            sims.channel.SNRdB = osnr2snr([X_coor(simseq)], sims.channel.RXSampleFreq) ;
            sims.Xlabel = 'OSNR(dB)';
        case 85
            sims.channel.MZmod.Vbias1 = [ X_coor(simseq);] ;
            sims.channel.MZmod.Vbias2 = -[ X_coor(simseq);] ;
            sims.Xlabel = 'MZmod Vbias';
        case 86 
            ROP_dBm =[X_coor(simseq);] ;
            SNRdB = ROP2SNR(ROP_dBm, 100, sims.channel.PD);
            sims.channel.SNRdB_bw = snr_bw(SNRdB, params.BaudFreq, sims.channel.RXSampleFreq);
            sims.Xlabel = 'ROP(dBm)';
        case 87 
            SNRdB   =[X_coor(simseq);] ;
            [sims] = get_launch_power_SNR(sims, params, SNRdB);
            sims.Xlabel = 'ROP(dBm)';

        %% RX DSP parameter
        case 1
            params.dfe.betaf  = [X_coor(simseq);] ;            
            sims.Xlabel = 'DFE betaf'; 
        case 2
            params.LPF.NBandwidth = [X_coor(simseq);] ;
            sims.Xlabel = 'LPF NBandwidth'; 

        case 3 
            params.AGC.avg_out = [X_coor(simseq);] ;
            sims.Xlabel = 'AGC Average'; 

        case 4 
            params.RXMatchedfilter.alpha = [X_coor(simseq);] ;
            resp_sample =8;
            alpha = params.RXMatchedfilter.alpha ;
            os_factor = 2 ;
            params.RXMatchedfilter.time_resp =  SRRC( os_factor,alpha, resp_sample);
            sims.Xlabel = 'Matched filter roll-off factor ';

        case 5
            params.cpr.BLK  = [X_coor(simseq);] ;
            sims.Xlabel = 'CPR BLK';
        case 6
            params.dfe1.betaf  = [X_coor(simseq);] ;
            sims.Xlabel = 'DFE1 betaf';
        case 7
            params.tpr.K1  = [X_coor(simseq);] ;
            sims.Xlabel = 'TPR K1';
        case 8
            params.tpr.K2  = [X_coor(simseq);] ;
            sims.Xlabel = 'TPR K2';
        case 9
            params.cpr.fBLK  = [X_coor(simseq);] ;            
            sims.Xlabel = 'CPR fBLK';    
        case 10
            params.dfe.Nffe = [X_coor(simseq);] ;
            sims.Xlabel = 'DFE NFFE';
            params.dfe = reinit_dfe(params.dfe, params);
        case 11
            params.dfe.betae = [X_coor(simseq);] ;
            sims.Xlabel = 'DFE betae';
        case 12
            params.dfe.betag = [X_coor(simseq);] ;
            sims.Xlabel = 'DFE betag';
        case 13
            params.dfe.W = [X_coor(simseq);] ;
            sims.Xlabel = 'DFE W';
        case 14
            params.dfe.Nfbe = [X_coor(simseq);] ;
            sims.Xlabel = 'DFE NFBE';
            params.dfe = reinit_dfe(params.dfe, params);
        case 15
            params.dfe.Npfe = [X_coor(simseq);] ;
            sims.Xlabel = 'DFE NPFE';
            params.dfe = reinit_dfe(params.dfe, params);
        case 16
            params.dfe.Npbe = [X_coor(simseq);] ;
            sims.Xlabel = 'DFE NPBE';
        case 17
            params.dfe1.lambda  = [X_coor(simseq);] ;
            sims.Xlabel = 'RLS lambda';
        case 18
            params.cpr.STEP  = [X_coor(simseq);] ;            
            sims.Xlabel = 'CPR step';     
        case 19
            params.cpr.fSTEP  = [X_coor(simseq);] ;            
            sims.Xlabel = 'CPR fstep';  
        case 20
            params.LPF.NBandwidth  = [X_coor(simseq);] ;            
            sims.Xlabel = 'Pass2Base LPF ';   
        case 21           
            params.cfr.CarrierFreqOff = [X_coor(simseq);] ;
            sims.Xlabel = 'Given CFO';    
        case 22
            params.dfe.Npostcursor  = [X_coor(simseq);] ;                  
            sims.Xlabel = 'DFE Npostcursor';
            [sims, params]=  ReInit ( sims, params  );
        case 23
            params.rxpreemp.a = [1   X_coor(simseq);] ;
            params.rxpreemp.b = [1 0];
            sims.Xlabel = 'Postemphais Denominator [ 1  a(2)]';
        case 24
            params.rxpreemp.a = [1  0 X_coor(simseq);] ;
            params.rxpreemp.b = [1 0];
            sims.Xlabel = 'Postemphais Denominator [ 1 0  a(3)]';
        case 25    
            params.rxpostemp.b = [1 X_coor(simseq);] ;
            sims.Xlabel = 'RX Post emphasis b numberate '; 
        case 26
            params.stbc.betaf(1)  = [X_coor(simseq);] ;            
            sims.Xlabel = 'STBC betaf'; 
        case 27
            params.stbc.betab  = [X_coor(simseq);] ;            
            sims.Xlabel = 'STBC betab'; 
        case 28
            params.stbc.betaf(2)  = [X_coor(simseq);] ;            
            sims.Xlabel = 'STBC betaf(t)'; 
            %params.stbc.K1  = [X_coor(simseq);] ;            
            %sims.Xlabel = 'STBC K1'; 
        case 29
            params.stbc.K2  = [X_coor(simseq);] ;            
            sims.Xlabel = 'STBC K2'; 
        case 30 
            params.stbc.tau_frac  = [X_coor(simseq);] ;            
            sims.Xlabel = 'STBC TAU FRAC'; 
        case 31
            params.stbc.Nffe = [X_coor(simseq);] ;
            sims.Xlabel = 'STBC NFFE';
            params.stbc.Npostcursor =  round((params.stbc.Nffe-1)/2);
        case 32
            params.stbc.betab2 = [X_coor(simseq);] ;            
            sims.Xlabel = 'STBC betab2';
        case 33
            params.stbc.BPS_range = [X_coor(simseq);] ;            
            sims.Xlabel = 'STBC BPS range';
        case 34
            params.stbc.BPS_step = [X_coor(simseq);] ;            
            sims.Xlabel = 'STBC BPS Step ';
        case 35
            sims.testvector      = [X_coor(simseq);] ;            
            sims.Xlabel = 'Test vector';  
        %% TX DSP parameter
        case 36
            sims.gen_tx = 1 ;
            params.txpreemp.a = [1  0  X_coor(simseq)   ] ;
            params.txpreemp.b = [1 0 0];
            sims.Xlabel = 'TX Preemphais Denominator [ 1  0 a(3)  ]';
        case 37
            sims.gen_tx = 1 ;
            params.txpreemp.b = [1 0 X_coor(simseq);] ;
            params.txpreemp.a = 1;
            sims.Xlabel = 'TX Preemphais Numerator';

        case 38
            sims.gen_tx = 1 ;
            params.precoding.filter = [1   X_coor(simseq);] ;
            sims.Xlabel = 'THP  [  1  a(2)]';
        case 39
            skew_ps          = [X_coor(simseq);]  ;
            params.skew.skew_ps (1)   =  complex(0, skew_ps); 
            sims.Xlabel = 'RX Skew(2) ';
            [sims, params]=  ReInit ( sims, params  );
        case 40 
            skew_ps          = [X_coor(simseq);]  ;
            params.skew.skew_ps (2)   =  complex(skew_ps, imag(params.skew.skew_ps (2)  )); 
            sims.Xlabel = 'RX Skew(3) ';
            [sims, params]=  ReInit ( sims, params  );
        case 41
            skew_ps          = [X_coor(simseq);]  ;
            params.skew.skew_ps (2)   =  complex(real(params.skew.skew_ps (2)), skew_ps  ); 
            sims.Xlabel = 'RX Skew(4) ';
            [sims, params]=  ReInit ( sims, params  );
        case 42
            sims.gen_tx = 1;
            skew_ps              = [X_coor(simseq);]  ;
            params.txskew.skew_ps (1)   =  complex(0, skew_ps) ;  
            sims.Xlabel = 'TX Skew(2) ';
            [sims, params]=  ReInit ( sims, params  );
        case 35
            sims.testvector      = [X_coor(simseq);] ;            
            sims.Xlabel = 'Test vector';  
        %% TX DSP parameter
        case 36
            sims.gen_tx = 1 ;
            params.txpreemp.a = [1  0  X_coor(simseq)   ] ;
            params.txpreemp.b = [1 0 0];
            sims.Xlabel = 'TX Preemphais Denominator [ 1  0 a(3)  ]';
        case 37
            sims.gen_tx = 1 ;
            params.txpreemp.b = [1 0 X_coor(simseq);] ;
            params.txpreemp.a = 1;
            sims.Xlabel = 'TX Preemphais Numerator';

        case 38
            sims.gen_tx = 1 ;
            params.precoding.filter = [1   X_coor(simseq);] ;
            sims.Xlabel = 'THP  [  1  a(2)]';
        case 39
            skew_ps          = [X_coor(simseq);]  ;
            params.skew.skew_ps (1)   =  complex(0, skew_ps); 
            sims.Xlabel = 'RX Skew(2) ';
            [sims, params]=  ReInit ( sims, params  );
        case 40 
            skew_ps          = [X_coor(simseq);]  ;
            params.skew.skew_ps (2)   =  complex(skew_ps, imag(params.skew.skew_ps (2)  )); 
            sims.Xlabel = 'RX Skew(3) ';
            [sims, params]=  ReInit ( sims, params  );
        case 41
            skew_ps          = [X_coor(simseq);]  ;
            params.skew.skew_ps (2)   =  complex(real(params.skew.skew_ps (2)), skew_ps  ); 
            sims.Xlabel = 'RX Skew(4) ';
            [sims, params]=  ReInit ( sims, params  );
        case 42
            sims.gen_tx = 1;
            skew_ps              = [X_coor(simseq);]  ;
            params.txskew.skew_ps (1)   =  complex(0, skew_ps) ;  
            sims.Xlabel = 'TX Skew(2) ';
            [sims, params]=  ReInit ( sims, params  );
        case 43 
            sims.gen_tx = 1;
            skew_ps              = [X_coor(simseq);]  ;
            params.txskew.skew_ps (2)   =  complex(skew_ps,  imag ( params.txskew.skew_ps (2)  ) ) ;
            sims.Xlabel = 'TX Skew(3) ';
            [sims, params]=  ReInit ( sims, params  );
        case 44
            
            sims.gen_tx = 1;
            skew_ps              = [X_coor(simseq);] ;
            params.txskew.skew_ps (2)   =  complex(  real ( params.txskew.skew_ps (2)) ,skew_ps );             
            sims.Xlabel = 'TX Skew(4) ';
            [sims, params]=  ReInit ( sims, params  );
        case 45
            params.searchfineframe.cor_length              = [X_coor(simseq);] ;           
            sims.Xlabel = 'Xcor  length ';

       otherwise 
            disp(['51: SNR, 52: TX bandwidth 53: TX Linewidth 54: Carrier Frequency']);
            disp(['55:Jitter, 56: TimeFreqOff 57: TimePhaseOff, 58: RX Linewidth']);
            disp(['60: ETC 61:RX DSP LPF bandwidth ']);
            disp(['3:  AGC Average']);
            error('Not supported sims.mode');
    end
    sims.X_val = X_coor(simseq);
end 


function dfe = reinit_dfe( dfe, params )
    mapper_list =  params.mapper_list;
    params.Nbitspersymbol = params.Nbitspersymbol;
    params.mapper_list         = QAMMapper2List (  params) ;
    dfe.mapper_list = mapper_list(:);
    dfe.mapper_list =  params.mapper_list;
    dfe.Npostcursor =  round((dfe.Nffe-1)/2);
    filtertap_init = zeros(params.NTXStream * params.NRXStream, dfe.Nffe+dfe.Nfbe);
    filtertap_init((1:params.NRXStream).^2, dfe.Npostcursor+1)=1;
    dfe.filtertap = complex( filtertap_init)  ;
    

    if ( params.load_filtercoef )
        load(params.filter_name) ;
        dfe.filtertap = filtercoef;
    end
    dfe.term_symbol = params.term_symbol  ;
    dfe.NStream     = params.NTXStream;
    dfe.OV          = params.RXoversample;
    dfe.en_block_termination = 0;
    if ( params.pilot.en ~= 0 )
        dfe.en_block_termination = 2; % Termination symbol :first symbol at a block
    end
    dfe.training_seq_size    = params.NTrainingSymbol;
end

function  [sims] = get_launch_power_SNR(sims, params, SNRdB)
    mW =1e-3;
    km =1e3;
     
    sims.channel.PD.noise_power_dBm = SNR2ROP( 0, 100, sims.channel.PD);
    electrical_power_W = db2pow(SNRdB)* db2pow(sims.channel.PD.noise_power_dBm)*mW; 
    electrical_current = electrical_power_W/ sims.channel.PD.resistor ;   % 50 ohm
    optical_power_W = electrical_current /sims.channel.PD.responsivity;
    launch_power  =   optical_power_W * 1/db2pow(-36.8 -(-33.3)+  sims.ROP_cal);
    if ( sims.channel.fiber_length ~= 0)
         launch_power  =  launch_power * db2pow(sims.channel.fiber_length/km * 0.2 );
    end 
    sims.channel.ROP_dBm  =   pow2db(optical_power_W/mW);
    sims.channel.MZmod.launch_power = launch_power;
    cal_BW1 =   snr_bw(SNRdB, params.BaudFreq, sims.channel.SampleFreq) -SNRdB + 4.5 ;
    sims.channel.PD.noise_power_dBm = sims.channel.PD.noise_power_dBm - cal_BW1 ;
    %pow2db(sims.channelout.ROP/1e-3)
end 
