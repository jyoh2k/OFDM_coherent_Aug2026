%% Initialization, Setup
%  Coherent OFDM single-run body
%  Defaults: Nsd=120, Lbb=2 (freq OS 256 IFFT), SampleFreq=BaudFreq
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
sims.show_psd  = 1;
sims.show_ccdf = 0;  % Set to 0 to disable data-symbol PAPR CCDF
sims.mode      = 0;  
sims.X_coor    = [0];
sims.Ylabel    = 'EVM '; 
sims.max_num_sim              = num_sim;
sims.en_disp_result            = 1; 
sims.dataf.data_file            = [DSP_PATH 'Ptn/prbs15.txt'];
%%
params.BaudFreq = 64*GHz;
params.RX = 64*GHz;
params.Nbpsc = 4 ;
params.Nsd = 120;   % 4 subchannels x 30 data SC
params.NFFT = 128;
params.sc.Lbb = 2;  % freq-OS: 256 IFFT + CP32
% params.sc.Lbb = 1; % no freq OS (128 IFFT)
params.TXSampleFreq = params.BaudFreq;
params.RXSampleFreq = params.BaudFreq;
params.AWGSampleFreq = params.TXSampleFreq;
params.OSCFreq  = params.RXSampleFreq;
params.NTXStream = 2;
params.NRXStream = params.NTXStream;
params.NLTF=  1;
params.NDataSymbol = 500; 
params.en_bit_alloc = 0;
params.en_power_loading =0;
%% TX DSP
params.TXMatchedfilter.en = 3;
params.TXMatchedfilter.alpha = 1.0;
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
if sims.show_ccdf
    txsignal.papr = measure_PAPR_CCDF(txsignal.txout, params);
    fprintf('PAPR (Pol. 1, data symbols): mean %.3f dB, max %.3f dB\n', ...
        txsignal.papr.mean_dB, txsignal.papr.max_dB);
end
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

%% Draw simulation results
draw_new_plot = 0 ;
sims.plot_mode = 3 ;
testcase = [ ', Sim case  ' num2str(sim_case)];
simout.legend = get_legend(sim_case);
simout.color = 'bo:';
str = 'OFDM';
simout.title = [ num2str(2^ params.Nbpsc) '-QAM, '   num2str(round(params.BaudFreq *10 /GHz)/10)  'GB, ' str ];
simout.color = color;

FiberLength = sims.channel.fiber_length/km;
simout.legend = [  'Fiber ' num2str(FiberLength) ' km'];
simout.title =[simout.title  ', FiberLen'];

sims = DrawSimout( simout, sims, params, draw_new_plot);  
