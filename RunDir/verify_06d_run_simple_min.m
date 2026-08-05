%VERIFY_06D_RUN_SIMPLE_MIN  Step-6D: run_simple path, minimal sim_case
%
%   Mirrors RunDir/run_simple_ofdm_sim.m core:
%     TxMain -> wrap -> Channel(sim_case) -> RxMain_OFDM
%   Uses sim_case=2 (quiet electronics + AWGN), mode=51 SNR point.
%   Skips GUI FrameAnalysis / pause for batch safety.
%
%   >> run('RunDir/verify_06d_run_simple_min.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');
run('Units.m');

fprintf('\n=== verify_06d_run_simple_min (step 6D) ===\n');
nfail = 0;

%% Driver knobs (same names as run_all / run_simple)
sim_case = 2;
mode = 51;                 % SNR sweep mode
num_sim = 1;
X_coor = [20];             % single SNR (dB) point
PhaseNoise = 0;
FiberLen = 0.0001;         % ~0 km
PMD = 0;
CFO = 0;
color = 'bo-'; %#ok<NASGU>

%% Init like run_simple
[sims, params] = Init();
load([SW_PATH 'RunDir/savedState.mat']);
defaultStream = RandStream.getGlobalStream;
defaultStream.State = savedState;

sims.show_constellation = 0;
sims.show_ber = 0;
sims.show_cpr = 0;
sims.show_ce = 0;
sims.show_tpr = 0;
sims.show_sync = 0;
sims.show_psd = 0;
sims.max_num_sim = num_sim;
sims.en_disp_result = 0;
sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];

params.BaudFreq = 42*GHz;
params.RX = 42*GHz;
params.Nbpsc = 4;
params.Nsd = 120;
params.NFFT = 128;
params.dfts.Lbb = 1;
params.TXSampleFreq = params.BaudFreq;
params.RXSampleFreq = params.BaudFreq;
params.AWGSampleFreq = params.TXSampleFreq;
params.OSCFreq = params.RXSampleFreq;
params.NTXStream = 2;
params.NRXStream = params.NTXStream;
params.NLTF = 1;
params.NDataSymbol = 50;     % shorter than run_simple(1000) for gate speed
params.en_bit_alloc = 0;
params.en_power_loading = 0;

params.TXMatchedfilter.en = 3;
params.TXMatchedfilter.alpha = 1.0;
params.searchframe.en = 1;
params.searchfineframe.en = 1;
params.searchframe.th = 0.5;
params.searchfineframe.type = 1;
params.cfr.en = 1;
params.fcfr.en = 1;
params.cpr.en = 1;
params.cpr.bcpr_en = 0;
params.tpr.en = 1;
params.tpr.K1 = -2*pi;
params.tpr.K2 = -0.001;

sims.mode = mode;
sims.X_coor = X_coor;

[sims] = SetChannel_OFDM(sim_case, sims, params);
sims.channel.TXLineWidth = PhaseNoise * MHz;
sims.channel.RXLineWidth = PhaseNoise * MHz;
sims.channel.PMD = PMD * ps;
sims.channel.CarrierFreqOff = CFO * GHz;
sims.channel.fiber_length = FiberLen * km;
sims.channel.enAWGN = 1;

[sims, params] = ReInit(sims, params);

nfail = nfail + check_eq('Lbb', params.dfts.Lbb, 1);
nfail = nfail + check_eq('sim_case', sim_case, 2);
nfail = nfail + check_eq('mode', sims.mode, 51);
fprintf('INFO: NSamplepersymbol=%d  SNRdB target=%g  fiber=%.4g km\n', ...
    params.NSamplepersymbol, X_coor(1), sims.channel.fiber_length/km);

%% TX (same as run_simple)
dataf = DataGen(sims.dataf, params.totalbits, 0);
[txout, txsignal] = TxMain(dataf, sims, params);
txout_ext = [txout(:,end-1001+1:end) txout txout(:,1:2000)];
txout_awg = Resample(txout_ext, params.TXSampleFreq, params.AWGSampleFreq);
channelin = txout_awg;
txsignal.txout_ext = txout_awg;
txsignal.awg_signal = txout_awg;

%% Channel + RxMain (single SNR point)
simseq = 1;
[sims, params] = SweepSim(sims, params, simseq);
defaultStream.State = savedState;
[channelout, sims] = Channel(sims, channelin, sims.channel);
[~, frame] = RxMain_OFDM(channelout(1:params.NRXStream,:), txsignal, sims, params);

if ~isfield(frame, 'fecin') || isempty(frame.fecin)
    fprintf('FAIL: RxMain fecin empty after Channel path\n');
    error('verify_06d failed');
end
fprintf('PASS: Channel+RxMain completed (fecin len=%d)\n', length(frame.fecin));

%% Sync sanity
if isfield(frame, 'fscs') && isfield(frame.fscs, 'MaxPos')
    fprintf('INFO: coarse MaxPos=%s\n', mat2str(frame.fscs.MaxPos));
    fprintf('PASS: coarse sync struct present\n');
else
    fprintf('FAIL: coarse sync missing\n');
    nfail = nfail + 1;
end

%% BER gate (optical front-end + AWGN @ 20 dB — allow margin vs pure AWGN)
[BER, Nerr, Ntot] = calculate_BER(dataf(:).', frame.fecin(:).');
ber_lim = 5e-2;   % first optical-path gate (pure AWGN @20dB was ~6e-4)
fprintf('INFO: BER=%.4e (%d/%d)  limit=%.1e\n', BER, Nerr, Ntot, ber_lim);
if ~(BER < ber_lim)
    fprintf('FAIL: BER too high on run_simple Channel path\n');
    nfail = nfail + 1;
else
    fprintf('PASS: BER=%.4e < %.1e\n', BER, ber_lim);
end

fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_06d_run_simple_min)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_06d_run_simple_min failed');
end
fprintf('----------------------------------------\n\n');

function n = check_eq(name, got, expv)
    if isequal(got, expv)
        fprintf('PASS: %s\n', name);
        n = 0;
    else
        fprintf('FAIL: %s\n  got=%s\n  exp=%s\n', name, mat2str(got), mat2str(expv));
        n = 1;
    end
end
