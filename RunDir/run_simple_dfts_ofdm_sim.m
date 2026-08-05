%% Initialization, Setup
%  DFT-s-OFDM single-run body (called from RunSimSet/run_all_dfts_ofdm_sim.m)
%  Defaults: Nsd=120, Lbb=2 (freq OS 256 IFFT), SampleFreq=BaudFreq, MF shaping-only (en=3)
global SW_PATH
run( ['Units.m']);

if ( exist('sims') == 0) 
    [sims, params]=  Init (    );        
    load ([SW_PATH 'RunDir/savedState.mat']);
else
    [sims, params]=  Init ( sims, params  );
end

load ([SW_PATH 'RunDir/savedState.mat']);
defaultStream = RandStream.getGlobalStream;
defaultStream.State = savedState;
%%
sims.show_constellation = 1;
sims.show_ber  =1;
sims.show_cpr  = 1;
sims.show_ce  = 1;
sims.show_tpr  = 1;
sims.show_sync = 1;
sims.show_psd  = 0;
sims.show_tx_psd = 1;   % TX output PSD right after TxMain (noise-free)
sims.mode      = 0;  
sims.X_coor    = [0];
sims.Ylabel    = 'EVM '; 
sims.max_num_sim              = num_sim;
sims.en_disp_result            = 1; 
sims.dataf.data_file            = [DSP_PATH 'Ptn/prbs15.txt'];
%%
params.BaudFreq = 64*GHz;  % Option A: >200 Gb/s including frame overhead
params.RX = 64*GHz;
params.Nbpsc = 4 ;
params.Nsd = 120;   % DFT-s: 4 subchannels x 30 data SC
params.NFFT = 128;
params.dfts.Lbb = 2;   % freq-OS: 256 IFFT + CP32; STF time-OS x2 in get_STF
% params.dfts.Lbb = 1; % no freq OS (128 IFFT) — use feature branch without OS
% params.Nsd = 170;
% params.NFFT = 256;
% params.Nsd = 340;
% params.NFFT = 512;
% params.Nsd = 680;
% params.NFFT = 1024;
params.TXSampleFreq = params.BaudFreq;
params.RXSampleFreq = params.BaudFreq;
params.AWGSampleFreq = params.TXSampleFreq;
params.OSCFreq  = params.RXSampleFreq;
params.NTXStream = 2;
params.NRXStream = params.NTXStream;
params.NLTF=  1; % 2:Frame synchronization problem
params.NDataSymbol = 1000; 
params.en_bit_alloc = 0;
params.en_power_loading =0;
%% TX DSP
% params.TXMatchedfilter.en = 2;
% params.TXMatchedfilter.alpha = 0.02;
params.TXMatchedfilter.en = 0;
params.TXMatchedfilter.alpha = 1;
%% RX DSP
params.searchframe.en = 1;
params.searchfineframe.en = 1;
params.searchframe.th = 0.5;
params.searchfineframe.type = 1;
params.cfr.en = 1;
params.fcfr.en = 1;
params.cpr.en = 1;
params.cpr.bcpr_en=0;
params.tpr.en =  1; 
 
params.tpr.K1 = -2*pi;
params.tpr.K2 = -0.001;

%% Channel
sims.mode      = mode;
sims.X_coor    = X_coor;

[sims] = SetChannel_OFDM(sim_case, sims, params);
% Spectrum inspection: keep noise floor low for RX PSD (GUI ShowPSD)
% TX PSD itself is plotted before Channel (no AWGN).
sims.channel.SNRdB = 20;
% sims.channel.CarrierFreqOff   = 0*500*MHz ; 
% sims.channel.TimeFreqOff      = 0*10*ppm; 
% sims.channel.enAWGN           = 1;
% sims.channel.SNRdB                = 27;
% sims.channel.TXLineWidth      =  0* 100 * kHz;
% sims.channel.RXLineWidth      =  0 * 100 * kHz; 
% sims.channel.SampleFreq = params.AWGSampleFreq ;
%%
% sims.mode      = 8;
% sims.X_coor      = [  -1e-4 -5e-4  -1e-3 -5e-3 -1e-2 -5e-2    ];%[-1:-1:-10];
% % sims.X_coor      = -5e-3 ;
% params.tpr.K1 = -2;
% params.tpr.K2 = -1e-3;
% sims.mode      = 6;
% sims.X_coor      = [    -5  :-1:-20]; 
% params.tpr.K2 = 0;
% sims.channel.TimeFreqOff   = 0*ppm;
sims.channel.TXLineWidth = PhaseNoise * MHz;
sims.channel.RXLineWidth = PhaseNoise * MHz;
sims.channel.PMD = PMD *ps;
sims.channel.CarrierFreqOff = CFO * GHz;
sims.channel.fiber_length = FiberLen *km;

%%
[sims, params]=  ReInit ( sims, params  );  
%% Main body 
dataf     = DataGen( sims.dataf, params.totalbits, 0 );
[txout, txsignal] = TxMain( dataf, sims, params) ;

txout_ext         = [txout(:,end-1001+1:end)  txout txout(:,1:2000)  ]; 
[txout_awg]    = Resample( txout_ext, params.TXSampleFreq, params.AWGSampleFreq);
channelin  = [ txout_awg(:,1:end)] ;
txsignal.txout_ext = txout_awg;
txsignal.awg_signal = txout_awg;

%%
simout.out = zeros(1,2); 
for simseq=1:length(sims.X_coor)
    [sims, params]     = SweepSim(  sims, params, simseq);
    defaultStream.State = savedState;
    for simnum=1:sims.max_num_sim  
        [channelout, sims] = Channel(sims, channelin, sims.channel);
        % TX output PSD (after MF/AGC, before optical channel / AWGN)
        % Best place for TX spectrum: noise-free, Fs = Baud/TX sample rate
        % if isfield(sims, 'show_tx_psd') && sims.show_tx_psd
        %     figure('Name', 'PSD ', 'Color', 'w');
        %     Fs_tx = params.TXSampleFreq;
        %     [Pxx, F] = pwelch(channelout(1,:), [], [], [], Fs_tx, 'centered');
        %     XdB=20*log10(abs(Pxx));
        %     plot(F/1e9, XdB-max(XdB), 'b-', 'LineWidth', 1.2);
        %     grid on;
        %     xlabel('Frequency (GHz)');
        %     ylabel('PSD (dB/Hz)');
        %     title(sprintf(['TX output PSD  |  Lbb=%d, Fs=%.0f GHz, MF.en=%d, ' ...
        %                    'channel SNRdB=%.0f (RX path)'], ...
        %         params.dfts.Lbb, Fs_tx/1e9, params.TXMatchedfilter.en, ...
        %         sims.channel.SNRdB));
        %     xlim([-Fs_tx/2, Fs_tx/2]/1e9);
        % end
        [recovered, frame] = RxMain_OFDM( channelout(1:params.NRXStream,:), txsignal, sims, params); 
        [frameout, sims]   = FrameAnalysis( txsignal, frame, params, sims);
        simout             = SimAnalysis( sims, simout, frameout, simnum );    
        sims.en_disp_result =2;
        if(sims.mode ~= 51)
            sims.X_val = sims.channelout.ROP_dBm;
        end
        ROP_dBm(1, simseq) = sims.X_val;
        disp_result(simout, frameout, sims, params);  
    end
    sims.en_disp_result =1;
    simout.out(simseq, 1) = mean(simout.BER);
    simout.out(simseq, 2) = mean(simout.EVM);
    simout.out(simseq, 3) = mean(simout.BER);
    disp_result(simout, frameout, sims, params);    
    pause(1);
end

if (sims.mode == 87)
    sims.X_coor = ROP_dBm(1, 1:length(sims.X_coor));
end

%% Draw  s1imulation results
draw_new_plot = 0 ;
sims.plot_mode = 3 ;
%sim_case = 0;
testcase = [ ', Sim case  ' num2str(sim_case)];
simout.legend = [   num2str(2^ params.Nbpsc) '-QAM, ' ...
                   num2str(params.NTXStream)  ' TX,'...
                  'Baud Rate '  num2str(round(params.BaudFreq *10 /GHz)/10) testcase ];
simout.legend = get_legend(sim_case);
simout.color = 'bo:';
simout.title = [ 'BER   ' testcase ];

str = 'DFTs-OFDM';

simout.title = [ num2str(2^ params.Nbpsc) '-QAM, '   num2str(round(params.BaudFreq *10 /GHz)/10)  'GB, ' str ];
%simout.color = get_color(sim_case);
simout.color = color;

% if ( sim_case == 9  || sim_case == 33 )
%     IQGain = mag2db(sims.channel.iqimb.gainim(1)+1);
%     simout.legend = [   'IQ Gain '  num2str(IQGain) ' dB' ];
%      simout.title =[simout.title  ', IQGain'];
% end  
% if ( sim_case == 10 || sim_case == 34 )
%     IQPhase =  sims.channel.iqimb.phaseim(1);
%     simout.legend = [  'IQ Phase '  num2str(IQPhase) ];
%      simout.title =[simout.title  ', IQPhase'];
% end  
% if ( sim_case == 11 || sim_case == 35 || sim_case == 36 )
%     IQSkew = sims.channel.iqimb.iqskew(1)/ps;
%     simout.legend = [   'IQ Skew ' num2str(IQSkew)  ' ps'];
%     simout.title =[simout.title  ', IQSkew'];
% end  
% if ( sim_case == 12 )
%     CarrierFreqOff = sims.channel.CarrierFreqOff/MHz;
%     simout.legend = [  'CFO '  num2str(CarrierFreqOff) ' MHz'];
%     simout.title =[simout.title  ', CarrierFreqOff'];
% end  
% if ( sim_case == 19 )
%     SamplingOff = sims.channel.TimeFreqOff/ppm;
%     simout.legend = [   'SFO ' num2str(SamplingOff) ' ppm'];
%     simout.title =[simout.title  ', SamplingOff'];
% end  
% if ( sim_case == 20 )
%     Jitter = sims.channel.Jitter/ps;
%     simout.legend = [  'Jitter ' num2str(Jitter) ' ps'];
%     simout.title =[simout.title  ', Jitter'];
% end  
% if ( sim_case == 21 )
    FiberLength = sims.channel.fiber_length/km;
    simout.legend = [  'Fiber ' num2str(FiberLength) ' km'];
    simout.title =[simout.title  ', FiberLen'];
% end  
% if ( sim_case == 22 )
    % PMD = sims.channel.PMD/ps;
    % simout.legend = [  'PMD ' num2str(PMD) ' ps' ];
    % simout.title =[simout.title  ', PMD'];
% end  
% if ( sim_case == 23 )
    % PhaseNoise = sims.channel.TXLineWidth/MHz;
    % simout.legend = [   'Phase Noise ' num2str(PhaseNoise) ' MHz'];
    % simout.title =[simout.title  ', LineWidth'];
% end  
% if ( sim_case == 24 )
%     ENob =sims.channel.TXDAC.ENob;
%     simout.legend = [   'DAC, ENob ' num2str(ENob) ];
%     simout.title =[simout.title  ', TXDAC'];
% end  
% if ( sim_case == 25 )
%     ENob =sims.channel.RXADC.ENob;
%     simout.legend = [   'ADC, ENob ' num2str(ENob) ];
%     simout.title =[simout.title  ', RXADC'];
% end  

% if ( params.dfe.skewcomp_en == 2)
% %     simout.color = 'ys-';
% %     simout.legend = [simout.legend ', Widely linear'];
%     simout.title =[simout.title  ', Widely linear'];
% end 
% if ( params.dfe.skewcomp_en == 1)
% %     simout.legend = [simout.legend ', Real 4x4'];
% %     simout.color = 'cs-';
%     simout.title =[simout.title  ', Real 4x4'];
% end 
% if ( params.dfe.skewcomp_en == 0)
% %     simout.legend = [simout.legend ', No skew comp'];
% %     simout.color = 'ms-';
% %     simout.title =[simout.title  ', No skew '];
% end 
sims = DrawSimout( simout, sims, params, draw_new_plot);  
%sims.plot_mode = 2 ;
%sims = DrawSimout( simout, sims, params, draw_new_plot);  
%%
% ParameterSet( 'pushbutton1_Callback',  'Parameter', sims, params);
