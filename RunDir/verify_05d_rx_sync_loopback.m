%VERIFY_05D_RX_SYNC_LOOPBACK  Step-5D: frame sync on Lbb=1 ideal digital loopback
%
%   Pads txframe, runs SearchFrameStart (CFEtype=5), then FFT/CE/EQ/BER.
%   Does not exercise optical Channel impairments.
%
%   >> run('RunDir/verify_05d_rx_sync_loopback.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_05d_rx_sync_loopback (step 5D) ===\n');
nfail = 0;

[sims, params] = Init();
params.NDataSymbol = 20;
params.Nbpsc = 4;
params.en_bit_alloc = 0;
params.en_power_loading = 0;
params.NTXStream = 2;
params.NRXStream = 2;
params.dfts.Lbb = 1;
params.BaudFreq = 42e9;
params.TXSampleFreq = params.BaudFreq;
params.RXSampleFreq = params.BaudFreq;
params.AWGSampleFreq = params.TXSampleFreq;
params.OSCFreq = params.RXSampleFreq;
params.TXMatchedfilter.en = 0;
params.TXMatchedfilter.alpha = 1.0;
params.cpr.en = 0;
params.cpr.bcpr_en = 0;
params.ce.en_ISFA = 0;
params.TXAGC.en = 0;
params.tpr.en = 0;
params.cfr.en = 0;           % isolate frame sync first
params.fcfr.en = 0;
params.searchframe.en = 1;
params.searchframe.th = 0.5;
params.searchfineframe.en = 0;
sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];
[sims, params] = ReInit(sims, params);

nfail = nfail + check_eq('Lbb', params.dfts.Lbb, 1);
nfail = nfail + check_eq('NSamplepersymbol', params.NSamplepersymbol, 144);

dataf = DataGen(sims.dataf, params.totalbits, 0);
[~, tx] = TxMain(dataf, sims, params);
txframe = tx.txframe;

% Match run_simple wrap style so STF autocorrelation sees real samples (not zeros)
pre = min(1001, size(txframe, 2));
post = min(2000, size(txframe, 2));
rx_in = [txframe(:, end-pre+1:end), txframe, txframe(:, 1:post)];
exp_pos = pre + 1;   % start of the middle (true) frame copy

% th=0: take global peak (more stable for short ideal loopback)
params.searchframe.th = 0;
[in_sync, fscs] = SearchFrameStart_OFDM(rx_in, params.searchframe);
sof = fscs.start_of_frame;
maxpos = fscs.MaxPos;
% CFEtype=5: out starts at MaxPos; expect peak at true frame start
if abs(maxpos - exp_pos) > 2
    fprintf('FAIL: sync MaxPos=%d sof=%d expected~%d\n', maxpos, sof, exp_pos);
    nfail = nfail + 1;
else
    fprintf('PASS: SearchFrameStart MaxPos=%d (expected~%d)\n', maxpos, exp_pos);
end

% Decode from sync output (skip STF)
n_stf = params.NSTFSample;
n_body = params.NSymbol * params.NSamplepersymbol;
if size(in_sync, 2) < n_stf + n_body
    fprintf('FAIL: synced buffer too short (%d < %d)\n', size(in_sync,2), n_stf+n_body);
    nfail = nfail + 1;
else
    td = in_sync(:, n_stf + (1:n_body));
    fft_out = FFTnRemoveGI(td, params.fft);
    [data_f, H] = ChannelEst(fft_out, params.ce);
    frame = struct();
    [eq2, ~, ~, frame] = ChannelComp(data_f, H, params, frame); %#ok<ASGLU>
    rx_bits = OFDMDemapper(SingleStreamOut(eq2, params), params);
    [BER, Nerr, Ntot] = calculate_BER(dataf, rx_bits);
    if BER ~= 0
        fprintf('FAIL: BER=%g (%d/%d) after sync loopback\n', BER, Nerr, Ntot);
        nfail = nfail + 1;
    else
        fprintf('PASS: BER=0 (%d bits) after SearchFrameStart\n', Ntot);
    end
end

fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_05d_rx_sync_loopback)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_05d_rx_sync_loopback failed');
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
