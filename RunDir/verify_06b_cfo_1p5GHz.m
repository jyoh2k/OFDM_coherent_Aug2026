%VERIFY_06B_CFO_1P5GHZ  Step-6B: RxMain with 1.5 GHz CFO + CFR
%
%   Ideal digital loopback (no optical Channel):
%     TxMain -> cyclic wrap -> CarrierFreqOffset(1.5 GHz) -> RxMain
%   Assumes 6A passed (sync without CFO).
%
%   >> run('RunDir/verify_06b_cfo_1p5GHz.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_06b_cfo_1p5GHz (step 6B) ===\n');
nfail = 0;

CFO_Hz = 1.5e9;   % 1.5 GHz

%% Init (same baseline as 6A + CFR ON)
[sims, params] = Init();
params.NDataSymbol = 20;
params.Nbpsc = 4;
params.en_bit_alloc = 0;
params.en_power_loading = 0;
params.NTXStream = 2;
params.NRXStream = 2;
params.NFFT = 128;
params.dfts.Lbb = 1;
params.BaudFreq = 42e9;
params.TXSampleFreq = params.BaudFreq;
params.RXSampleFreq = params.BaudFreq;
params.AWGSampleFreq = params.TXSampleFreq;
params.OSCFreq = params.RXSampleFreq;
params.RX_IF_band = 0;

params.TXMatchedfilter.en = 0;
params.TXMatchedfilter.alpha = 1.0;
params.TXAGC.en = 0;
params.AGC.en = 1;
params.DCCancel.en = 0;
params.rxskew.en = 0;

params.cpr.en = 0;
params.cpr.bcpr_en = 0;
params.ce.en_ISFA = 0;
params.tpr.en = 0;

params.cfr.en = 1;
params.cfr.CFEtype = 5;
params.cfr.CarrierFreqOff = CFO_Hz;   % reference for exp_phasediff
params.fcfr.en = 0;

params.searchframe.en = 1;
params.searchframe.th = 0;
params.searchfineframe.en = 1;
params.searchfineframe.type = 1;

sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];
[sims, params] = ReInit(sims, params);

fs = params.RXSampleFreq;
cfo_norm = CFO_Hz / fs;
nfail = nfail + check_eq('Lbb', params.dfts.Lbb, 1);
fprintf('INFO: CFO=%.3f GHz, fs=%.3f GHz, norm=%.6f (%.2f subcarriers)\n', ...
    CFO_Hz/1e9, fs/1e9, cfo_norm, CFO_Hz/(fs/params.NFFT));

%% TX + wrap + apply CFO (normalized, same as Channel.m)
dataf = DataGen(sims.dataf, params.totalbits, 0);
[txout, txsignal] = TxMain(dataf, sims, params);

pre = min(1001, size(txout, 2));
post = min(2000, size(txout, 2));
rx_clean = [txout(:, end-pre+1:end), txout, txout(:, 1:post)];
rx_in = CarrierFreqOffset(rx_clean, cfo_norm, 0, 0);
exp_coarse = pre + 1;

%% RxMain
[~, frame] = RxMain_OFDM(rx_in(1:params.NRXStream, :), txsignal, sims, params);

%% Sync still acquired under CFO
if ~isfield(frame, 'fscs') || ~isfield(frame.fscs, 'MaxPos')
    fprintf('FAIL: coarse sync missing under CFO\n');
    nfail = nfail + 1;
else
    maxpos = frame.fscs.MaxPos;
    if abs(maxpos - exp_coarse) > 5
        fprintf('FAIL: coarse MaxPos=%d expected~%d (CFO present)\n', maxpos, exp_coarse);
        nfail = nfail + 1;
    else
        fprintf('PASS: coarse sync MaxPos=%d under CFO (expected~%d)\n', maxpos, exp_coarse);
    end
end

if ~isfield(frame, 'fsfs')
    fprintf('FAIL: fine sync missing under CFO\n');
    nfail = nfail + 1;
else
    fprintf('PASS: fine sync ran under CFO\n');
end

%% CFO estimate
if ~isfield(frame, 'cfrout') || ~isfield(frame.cfrout, 'cfo_est')
    fprintf('FAIL: cfrout.cfo_est missing\n');
    nfail = nfail + 1;
else
    cfo_est = frame.cfrout.cfo_est(1);
    cfo_est_Hz = cfo_est * fs;
    % Allow modest CRT residual (fraction of a subcarrier)
    tol_Hz = 50e6;   % 50 MHz
    if abs(cfo_est_Hz - CFO_Hz) > tol_Hz && abs(cfo_est_Hz + CFO_Hz) > tol_Hz
        % also accept sign flip of estimate vs applied
        fprintf('FAIL: CFO est=%.3f GHz (norm=%.6f), applied=%.3f GHz\n', ...
            cfo_est_Hz/1e9, cfo_est, CFO_Hz/1e9);
        nfail = nfail + 1;
    else
        fprintf('PASS: CFO est=%.3f GHz (applied %.3f GHz, err=%.1f MHz)\n', ...
            cfo_est_Hz/1e9, CFO_Hz/1e9, abs(cfo_est_Hz-CFO_Hz)/1e6);
    end
end

%% BER
[BER, Nerr, Ntot] = calculate_BER(dataf(:).', frame.fecin(:).');
if BER ~= 0
    fprintf('FAIL: BER=%g (%d/%d) with CFO=1.5 GHz\n', BER, Nerr, Ntot);
    nfail = nfail + 1;
else
    fprintf('PASS: BER=0 (%d bits) with CFO=1.5 GHz + CFR\n', Ntot);
end

fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_06b_cfo_1p5GHz)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_06b_cfo_1p5GHz failed');
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
