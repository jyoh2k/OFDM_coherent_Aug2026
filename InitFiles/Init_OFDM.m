function [sims, params]=  Init_OFDM ( sims, params  )

global SW_PATH
run( ['Units.m']);

if nargin < 1
    BitPerSymbol = 4;
    sims.T = 0; 
    sims.const_axes={'' '' '' ''};
    sims.plot_axes={'' '' '' '' '' '' '' '' '' '' };
    sims.cpr_axes='';
    sims.cpr_axes1='';
    sims.ter_axes='';
    sims.plothandle='';
    sims.sync_axes ='';
    sims.psd_axes ='';
    sims.psdhandle='';
    sims.ber_axes ='';
    sims.evm_text ='';
    params.Nbpsc    = BitPerSymbol;    
end


sims.show_constellation = 0;
sims.show_cpr  = 0;
sims.show_tpr  = 0;
sims.show_sync = 0;
sims.show_psd  = 0;
sims.show_ber  = 0;
sims.show_ce   = 0;
sims.show_ccdf = 0;  % 1: plot PAPR CCDF for data symbols (first polarization)

 
sims.en_disp_result = 1;
sims.max_num_sim    = 1 ;
sims.logfile   = [SW_PATH '/Results/Log/', datestr(now,'ddmmm'), '.txt'];
sims.comment   = '';
sims.mode        = 0; % 0: No sweep
sims.X_val       = 0; % 
sims.store_data     = 0; 
sims.Xlabel      = 'SNR'; % 
sims.run_mode    = 1; % 1: Simulation, 0: Test mode 
sims.plot_mode   = 1; % 1: BER, 
sims.plot_str{1} = 'BER';
sims.plot_str{2} = 'EVM';
sims.plot_str{3} = 'MSEE(Phase)';
sims.print_tx_testvector = 0;
sims.print_rx_testvector = 0;
sims.one_panel           = 0;


%%  Generator
sims.dataf_filename             = [ 'prbs15.txt'];
sims.dataf.data_file            = [SW_PATH 'Ptn/' sims.dataf_filename];
sims.dataf.useprbsdata          = 1; % random data  
sims.txdata_file                = [SW_PATH 'Ptn/TxPtn.mat'];
sims.txdata_filename            = ['TxPtn.mat'];
sims.gen_tx                     = 0;

%%  DSP parameters

params.frame_header              = [];
params.NDataSymbol               = 1000 ; % Number of symbols
params.FEC_mode                  = 0; % 0: disable FEC, 1: RS, 2: LDPC(ETRI)
params.BaudFreq                  = (56 *GHz);
params.ssb                       = 0; 
params.modulation_format         = 1; 
params.modulation_format_str1{1} = 'OFDM';
params.modulation_format_str1{2} = 'DMT';
params.modulation_format_str1{3} = 'OCDM';

params.QAM_factor                = 2; 
params.GrayMap                   = 1; 
params.big_end_map               = 0; 
params.iq_sep                    = 0;
params.fixed_type                = 0; % 'emul';
params.fixed_sim                 = 0;
params.blind_mode                = 0;

%%  Transmitter
params.TXSampleFreq      = params.BaudFreq * 2;
params.AWGSampleFreq     = (120*GHz);
params.AWGResampleMethod = 1;
params.AWGcorrection     = 1;
params.NTXStream         = 2;      % Number of transmitted stream 
params                   = init_ofdm(params);
params.rs                = init_rs();
params.interleaver       = init_interleaver();
params.pilot             = init_pilot( );
params.tpr               = init_tpr( );
params.cpr               = init_cpr( );
params.ovsample_method   = 1; %  1: repetition, 0: zeropadding
params.ps                = init_ps();
params.mapper            = init_mapper();
params.TXMatchedfilter   = init_matched_filter();
params.spmpre            = init_spmpre();
params.TXAGC.avg_out     = 0.125;
params.TXAGC.en          = 1;
params.awglpf.en         = 0;
params.awglpf.cutoff     = 60*GHz;
params.TXmapping         = 1;
params.txskew            = init_skew( );

%%  Receiver ;
params.RXoversample      = 1; % Not valid anymore.
params.RXSampleFreq      = params.BaudFreq * params.RXoversample  ;
params.OSCFreq           = (100 *GHz);
params.RXmapping         = 1;
params.NRXStream         = 1;

params.TX_IF_band        = 0;
params.TX_IF_Freq        = 22 *GHz;
params.TX_IFSampleFreq   = 100 *GHz;
params.RX_IF_band        = 0;
params.RX_IF_Freq        = 22 *GHz;
params.RX_IFSampleFreq   = 100 *GHz;
params.LPF.NBandwidth    = 0.42;


% Matched filter
params.RXMatchedfilter   = init_matched_filter();
params.demap             = init_demapper();
params.AGC.avg_out       = 0.5;
params.AGC.avg_out       = 4.5;
params.AGC.en            = 1;
params.DCCancel.en       = 0;
params.OFDE              = init_OFDE() ;
params.rxskew            = init_skew() ;
params.cfr               = init_cfr( );
params.fcfr              = init_cfr( );
params.fec               = init_fec( );
params.ce                = init_ce( );
params.searchframe       = init_searchframe() ;
params.searchfineframe   = init_searchfineframe();
params.fixed_sim         = 0;


%% channel
channel.eb2b             = 0;
channel.Oversample       = 1;
channel.SampleFreq       = (200*GHz); 
channel.PhaseOffset      = 0 * pi/2;
channel.CarrierFreqOff   = 0*GHz ; %  0.5 % 
channel.CarrierFreqDrift = 0 ; 
channel.Jitter           = 0 *  0.5 * ps;
channel.TimeFreqOff      = 0 * 1 * ppm;
channel.TimePhaseOff     = 0 * 0.5;
channel.TXLineWidth      = 0 * 200 * kHz;
channel.RXLineWidth      = 0 * 200 * kHz;
channel.enAWGN           = 0;
channel.enASENoise       = 0;
channel.SNRdB            = 24;
channel.OSNRdB           = 40;
channel.multifading.filtertap     = 31;
channel.multifading.delays = [ 0*ps  110*ps];
channel.carrier_frequency  = 275*GHz;
channel.multifading.en     = 0;
channel.AGC.avg_out        = 0.6;
channel.AGC.en             = 1;
channel.Npol               = 2;
channel.fiber_length       = 0*km;

%% System components

TXDAC   = init_DAC( channel.SampleFreq );
RFDriver= init_RFAmp (channel.SampleFreq );
MZmod   = init_MZmod( channel.SampleFreq );
fiber   = init_ssmf( channel.SampleFreq );
dcf     = init_dcf ( channel.SampleFreq );
edfa    = init_edfa( channel.SampleFreq );
txedfa  = init_edfa( channel.SampleFreq );
PD      = init_PD  ( channel.SampleFreq );
TIA     = init_TIA ( channel.SampleFreq );
RFAmp   = init_RFAmp (channel.SampleFreq );
RXADC   = init_ADC ( channel.SampleFreq );
iqimb   = init_IQimbalance (  );

channel.TXSampleFreq =  params.TXSampleFreq;
channel.RXSampleFreq =  params.RXSampleFreq;
channel.PMDtype =  1; %  0:calc from PDM coef. 1:External setting
channel.PMD =  0*ps; %10*ps;

%%

sims.channel  = channel;
sims.channel.TXDAC     = TXDAC;
sims.channel.RFDriver  = RFDriver;
sims.channel.MZmod     = MZmod;
sims.channel.ssmf      = fiber;
sims.channel.dcf       = dcf;
sims.channel.edfa      = edfa;
sims.channel.txedfa    = txedfa;
sims.channel.PD        = PD;
sims.channel.TIA       = TIA;
sims.channel.RFAmp     = RFAmp;
sims.channel.RXADC     = RXADC;
sims.channel.iqimb     = iqimb;
sims.channel.txiqimb   = iqimb;

end
%% ------------------------------------------  

function params=  init_ofdm(params) 
    params.NFFT = 128;
    params.CP_ratio = 1/8;
    params.LTF_type = 1; % [ A, -A; A, A] type
    params.NLTF = 1; 
    params.NTXStream = 2;
    params.sc1 = 2; 
    params.en_bit_alloc = 0;
    params.en_power_loading = 0;

    % Coherent OFDM SC map (NFFT=128 design figure)
    % Lbb=1: 128 IFFT; Lbb=2: freq-OS 256 IFFT
    params.sc.Nsubch = 4;
    params.sc.Nd = 30;            % data SC per subchannel
    params.sc.Lbb = 1;
    params.sc.CP = 16;            % CP at NFFT=128 grid
    params.sc.map = get_OFDM_SC_map(params.NFFT, params.sc.Lbb);
    params.sc.CP_os = params.sc.map.CP_os;
    params.sc.NIFFT = params.sc.map.NIFFT;
    params.Nsd = params.sc.map.Nsd;   % 120
    params.Nbpsc_sc = params.Nbpsc * ones(params.NTXStream, params.Nsd);
    params.power_sc = 1 * ones(params.NTXStream, params.Nsd);
end 

function fec=  init_rs() 
    fec.en            = 0;
    fec.N=1023;          % Codeword length
    fec.K=979;           % Message length
    fec.S=fec.K - 465;   % Shortened message length
    fec.M=10;            % Modulation order
end 

function interleaver=  init_interleaver() 
    interleaver.en      = 0;
    global SW_PATH
    interleaver.fecperm = dlmread([SW_PATH 'InitFiles/RandPerm14688_reg_12x1224.txt' ]); 
end 

function txpreemp=  init_preemp() 
    txpreemp.en       = 0;
    txpreemp.a        = 1;  
    txpreemp.b        = [ 1 -0.1];
    txpreemp.mod      = 1;  % 1 : Modulo  disable , others: Modulo (-mod, mod]
end 

function pilot = init_pilot ()
    pilot.data_file            = [];
    pilot.useprbsdata          = [];
    pilot.en        = 3;
    pilot.Nbitspersymbol = 2;
    pilot.GrayMap  = 1;
    pilot.rate         = 32/31;% params.block_size/(params.block_size -1);

end


function [Matchedfilter]=  init_matched_filter() 

    alpha = 1.0;  
    resp_sample = 16;
    os_factor = 2 ;
    %Matchedfilter.freq_resp = ones( 1, 512);
    Matchedfilter.freq_resp = fftshift(RRC_f( os_factor, alpha, resp_sample)) ;
    Matchedfilter.time_resp =  SRRC( os_factor,alpha, resp_sample);
    Matchedfilter.en        = 0;
    Matchedfilter.alpha = alpha;
    Matchedfilter.resp_sample = resp_sample ;
    Matchedfilter.span        = resp_sample ;
    Matchedfilter.sps         = 4 ;
    Matchedfilter.FWHM        = 1 ;
end

function spmpre =  init_spmpre() 
    spmpre.en = 0;
    spmpre.gain = 1;
end

function [OFDE]=  init_OFDE() 
    OFDE.freq_resp = ones( 1, 512);
    OFDE.en        = 0;
end

function [skew]=  init_skew(  )
    skew.en = 0 ;
    skew.en_est = 0 ;
    skew.sft = complex(0);
    skew.sft(2,1) = complex(0);
    skew.gainim(2,1) = (0);
    skew.phaseim(2,1) = (0);
end


function [cfr]=  init_cfr( )
    cfr.PRL         = 512*10;
    cfr.OV          = 2;
    cfr.BLK         = 64 ;% phase estimation block size ( # of samples  )
    cfr.STEP        = 64; % phase estimation block window slide
    cfr.en          = 1;
    cfr.CFEtype     = 5;        
    cfr.CFEtype_str1{1} = 'Phase difference';
    cfr.CFEtype_str1{2} = 'Training symbol - repetition';
    cfr.CFEtype_str1{5} = 'CRT ';
    cfr.PCtype     = 3;
    cfr.exp_phasediff = 0;
    cfr.CarrierFreqOff = 0 ;
    cfr.CRTrep = 1;
    cfr.CRT2   = 16;
end

function [ce]=  init_ce( )
    ce.en          = 1;
    ce.en_ISFA     = 1;
    ce.ISFASize     = 2;
end

function mapper = init_mapper(  )
    mapper.Nbitspersymbol = 4;
    mapper.GrayMap        = 1;
    mapper.QAM_factor     = 2;
    mapper.big_end_map    = 0;
    mapper.fixed_bit      = 1;
    mapper.write_tv       = 0;
    mapper.iq_sep         = 0;
end

function demapper = init_demapper(  )
    demapper.type          = 1; % 1: Hard decision 2:,3: Bit-metric decoding 
    demapper.type_str1{1} = 'Hard';
    demapper.type_str1{2} = 'BIMD';
    demapper.type_str1{3} = 'BMD';
    demapper.GrayMap      = 1;
    demap.big_end_map    = 0;
    demapper.fixed_bit    = 1;
end


function [tpr]=  init_tpr(  )
%  Timing phase recovery
   tpr.en             = 1;
   tpr.L               = 5;   % Number of timing error recovering block( Interpolator) filter taps
   global FIXED_ARCHITECTURE
   if ( FIXED_ARCHITECTURE == 1)
        tpr.L = 2;
   end
   tpr.OV            =    2; %RXoversample ;   
   tpr.PRL           = 256 ;   %  1. for parallelism modelling  2. For faster simulation
   tpr.tau_init      = 0;      % Initial value of phase error  
   tpr.K1            = -2e-2 * 1;   %  Propotional coefficient of loopfilter
   tpr.K2            = -1e-4 * 1 ;   %  Integral coefficient of loopfilter
   tpr.TPEtype       = 1;     
   %tpr.TPEtype_str1{1} = 'Gardner';
   %tpr.TPEtype_str1{2} = 'Early-Late';
   %tpr.TPEtype_str1{5} = 'Square Timing Recovery';
   tpr.settling_time = 0;
   tpr.cal_init_tpr  = 0;
   tpr.seperate_tpr  = 0;
   tpr.T             = 0;
   tpr.fixed_bit     = 1;
end

function [cpr]=  init_cpr( )
    cpr.en          = 1;
    cpr.bcpr_en     = 1;
    cpr.PRL         = 128 ;
    cpr.K1          = 1 ;
    cpr.K2          = 0 ;
end

function searchframe   = init_searchframe() 
    searchframe.en    = 0;
    searchframe.search_offset    = 1500; % For stable search
    searchframe.start_of_frame   = 1; 
    searchframe.frame_header     = []; 
    searchframe.MaxPos           = 1; 
    searchframe.th               = 0; 
end 

function searchfineframe   = init_searchfineframe()
    searchfineframe.en= 0;
    searchfineframe.type = 0;
    searchfineframe.search_range1= 1;
    searchfineframe.search_range= 64;
    searchfineframe.cor_length = 144;
    searchfineframe.start_of_frame = 1;
    searchfineframe.MaxPos = 1;
    searchfineframe.fixed_bit = 1;
end


function ps  = init_ps(  )
    ps.en            = 0;
    ps.n             = 1;
    ps.entropy       = 2.5;
    ps.k             = 1;
    ps.num_dm_block_per_fec = 1;
    ps.signbit       = 0;
end

function fec = init_fec(  )
    fec.subsystemType = 'QPSK 5/6';
    fec.en            = 0;
    fec.max_iter      = 50;
    fec.FEC_mode      = 0; % DVB-S2
    fec.n             = 1;
    fec.k             = 1;
end

function DAC = init_DAC( SampleFreq )
    GHz = 1e9;
    DAC.SampleFreq      = SampleFreq;  
    DAC.en               = 1+1j;  
    DAC.ENob             = 4.3;
    DAC.nonoise          = 0; 
    DAC.gain             = 1/2;
    DAC.T.signed         = 1;
    DAC.T.wordl          = 6;
    DAC.T.fracl          = 4;
    DAC.T.round          = 1;
    DAC.T.sat            = 1;
    DAC.bandwidth        = 1 * 26 * GHz; % Baseband bandwidth 
    DAC.bandwidth_en     = 0;
end

function MZmod = init_MZmod( SampleFreq ) 
    GHz = 1e9;
    mW = 1e-3;
    MZmod.type         = 'IQMZM';
    MZmod.Vpi_DC       = 4 ;
    MZmod.Vpi_RF       = 4 ;
    MZmod.Vbias1       = 2 ; % 1: Intensity modulation 
    MZmod.Vbias2       = -2 ; % -1: Intensity modulation 
    MZmod.launch_power = 0.1 *mW;
    MZmod.bandwidth    = 1 * 40 * GHz; % Baseband bandwidth 
    MZmod.bandwidth_en = 1;
    MZmod.SampleFreq        = SampleFreq;
    MZmod.ERdB  = 100;
    MZmod.G  = 1;
end

function fiber = init_ssmf( SampleFreq )
    nm = 1e-9;
    km = 1e3;
    um = 1e-6;
    ps = 1e-12;
    W  = 1;
    c  = 2.99e8;
    Z0 = 377;
 
    fiber.lambda0      = 1550*nm; %m
    AlphadB            = 1*0.2 /km;        
    fiber.CD           = 17   ;                                        % ps/nm/km
    fiber.DeltaH       = 1*km  ;                              % m 
    fiber.fiber_length = 10 *km ;                      % Fiber length 
    fiber.Overlap      = 2 ;
    fiber.FFTSize      = 0;
    fiber.Beta2        = (-1)*fiber.lambda0^2/(2*pi*c)*fiber.CD*1e-6 ;  % 2nd order dispersion
    fiber.Beta         = 0 ;                                 % 1st order dispersion
    fiber.Alpha        = 1*AlphadB/(log10(exp(1))*10) ;        % Loss(dB/m)/10/Log10(e)
    fiber.Gamma        = 1*-1*1.2/W/km ;                      % Nonlinear effect,  /W/m 0.6~2.4   
    fiber.Aeff         =  80*um^2;                            % Effective area.
    fiber.n2           = 26e-21 ;                               % n2.
    fiber.n            = 1.5 ;                                   % Not used.
    fiber.centered     = 1;                               % Carrier frequency is center of bandwidth 
                                                   % PMD related parameters
    fiber.Dp           = 1 *2* 1*ps/sqrt(km);                   % First order PMD coefficient Dp  
    fiber.power_split1 = 1;                            % Power splitting ratio of polarization (Transmit side)
    fiber.power_split2 = 0.7;                          % Power splitting ratio of polarization (Receiver)
    fiber.DGD          = 1*0.1*ps/km;                          % average DGD value /km, 0.1 ps/km
 
    fiber.Npol         = 2 ;                                  % Polarization diversity
    fiber.tolerance    = 1e-5; 
    fiber.maxiter      = 1;
 
    fiber.SampleTime   = 1/SampleFreq;
    %fiber.SampleTime   = 1/channel.SampleFreq ;
    fiber.DeltaT       = fiber.SampleTime ;   
    fiber.PMD = fiber.Dp * sqrt( fiber.fiber_length ) ;    
    fiber.PDLdB = 0;
end 

function dcf = init_dcf( SampleFreq )
    c  = 2.99e8;
    km = 1e3;
    dcf = init_ssmf( SampleFreq );
    dcf.CD= -39  ;                                   % ps/nm/km
    dcf.Beta2 = (1)*dcf.lambda0^2/(2*pi*c)*dcf.CD*1e-6 ;  % 2nd order dispersion
    dcf.Beta  = 0 ;                                 % 1st order dispersion
    dcf.Alpha = (0.25 /km)/(log10(exp(1))*10) ;        % Loss(dB/m)/10/Log10(e)
    dcf.DeltaH = 1*km ;
    %dcf.Leff   = (1 - exp (- dcf.Alpha * dcf.fiber_length ))/dcf.Alpha;
    dcf.fiber_length = 0;
end

function edfa  = init_edfa( SampleFreq )
    km = 1e3;
    nm = 1e-9;
    fiber.lambda0      = 1550*nm; %m
    c = 2.99e8;  % Speed of light 
    h =6.6e-34;  % Plank constant, J.s
    edfa.SampleFreq  = SampleFreq; 
    edfa.length      = 80* km ; %400* km
    edfa.hv          = h*c/fiber.lambda0;
    edfa.gain_dB     = 0 ;
    edfa.NF_dB       = 5.5 ; 
    edfa.nonoise     = 0;
end

function PD  = init_PD( SampleFreq )
    GHz = 1e9;
    mW  = 1e-3;
    ps  = 1e-12;
    PD.SampleFreq        = SampleFreq;
    PD.max_output_power_dBm  = 7; % dBm 
    PD.responsivity      = 0.1; % 0.02 A/W 
    PD.resistor          = 100 ; % Ohm
    PD.noise_power_dBm   = -70;  % Opt 2 electric part noise including electri amplifier
    PD.nonoise           = 0;
    PD.gain_dB           = 0;
    PD.NF_dB             = 0;
    PD.CMRR              = db2mag(-18); % dBe 
    PD.RIN_dB             = -140 ; % -140 dB/Hz
    PD.IRND                =  30*ps;  % pA/sqrt(Hz) Differential input referred noise spectral density 

    PD.PLO               = db2pow(12)*mW; % 12dBm
    PD.passband          = 0;
    PD.bandwidth         = 1 * 40 * GHz; % Baseband bandwidth 
    PD.bandwidth_en      = 1;
    PD.thermal_noise     = 10e-12; % Unit: A/sqrt(Hz)
    PD.en_DCCancel       = 1;

end

function TIA  = init_TIA( SampleFreq )
    GHz = 1e9;
    TIA.SampleFreq      = SampleFreq;
    TIA.gain_dB         = 15 ;
    TIA.NF_dB           = 10 ;   
    TIA.nonoise         = 0;
    TIA.bandwidth       = 1 * 70 * GHz; % Baseband bandwidth 
    TIA.bandwidth_en    = 1;
end


function RFAmp   = init_RFAmp ( SampleFreq )
    GHz = 1e9;
    RFAmp.SampleFreq      = SampleFreq;
    RFAmp.gain_dB         = 37 ;
    RFAmp.NF_dB           = 10 ;   
    RFAmp.nonoise         = 0;
    RFAmp.bandwidth       = 1 * 40 * GHz; % Baseband bandwidth 
    RFAmp.bandwidth_en    = 0;
    RFAmp.V_sat           = 0;
end


function iqimb = init_IQimbalance ( )

    iqimb.gainim           = [0 0];
    iqimb.phaseim          = [0 0];
    iqimb.iqskew           = [0 0];
end

function ADC = init_ADC ( SampleFreq ) 

    GHz = 1e9;
    ADC.SampleFreq       = SampleFreq;
    ADC.en               = 1+1j;  
    ADC.BIT              = 6; 
    ADC.ENob             = 5.3;
    ADC.gain             = 1;
    ADC.nonoise          = 0;  
    ADC.T.signed         = 1;
    ADC.T.wordl          = 6;
    ADC.T.fracl          = 5;
    ADC.T.round          = 1;
    ADC.T.sat            = 1;
    ADC.bandwidth        = 1 * 26 * GHz; % Baseband bandwidth 
    ADC.bandwidth_en     = 1;

end

