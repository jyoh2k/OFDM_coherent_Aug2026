%VERIFY_06A_RXMAIN_IDEAL_LOOPBACK  Step-6A: full RxMain, ideal digital loopback
%
%   TX -> cyclic wrap -> RxMain_OFDM (no optical Channel).
%   Lbb=1, SampleFreq=BaudFreq.
%   Coarse sync ON; fine sync ON (needed to skip STF before FFT).
%   CFO / AWGN / impairments OFF.
%
%   >> run('RunDir/verify_06a_rxmain_ideal_loopback.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_06a_rxmain_ideal_loopback (step 6A) ===\n');
nfail = 0;

%% Init
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
params.cfr.en = 0;            % 6B
params.fcfr.en = 0;

params.searchframe.en = 1;
params.searchframe.th = 0;    % global peak (stable for short ideal wrap)
params.searchfineframe.en = 1;
params.searchfineframe.type = 1;

sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];
[sims, params] = ReInit(sims, params);

nfail = nfail + check_eq('Lbb', params.dfts.Lbb, 1);
nfail = nfail + check_eq('NSamplepersymbol', params.NSamplepersymbol, 144);
nfail = nfail + check_eq('RXoversample', params.RXoversample, 1);

%% TX + cyclic wrap (same idea as run_simple)
dataf = DataGen(sims.dataf, params.totalbits, 0);
[txout, txsignal] = TxMain(dataf, sims, params);

pre = min(1001, size(txout, 2));
post = min(2000, size(txout, 2));
rx_in = [txout(:, end-pre+1:end), txout, txout(:, 1:post)];
exp_coarse = pre + 1;
fprintf('INFO: wrap pre=%d post=%d, txout len=%d, rx_in len=%d\n', ...
    pre, post, size(txout,2), size(rx_in,2));

%% Full RxMain
[eq_out, frame] = RxMain_OFDM(rx_in(1:params.NRXStream, :), txsignal, sims, params); %#ok<ASGLU>

if ~isfield(frame, 'fecin') || isempty(frame.fecin)
    fprintf('FAIL: frame.fecin missing after RxMain\n');
    error('verify_06a failed');
end
fprintf('PASS: RxMain returned fecin length=%d\n', length(frame.fecin));

%% Coarse sync position
if ~isfield(frame, 'fscs') || ~isfield(frame.fscs, 'MaxPos')
    fprintf('FAIL: frame.fscs.MaxPos missing\n');
    nfail = nfail + 1;
else
    maxpos = frame.fscs.MaxPos;
    if abs(maxpos - exp_coarse) > 5
        fprintf('FAIL: coarse MaxPos=%d expected~%d\n', maxpos, exp_coarse);
        nfail = nfail + 1;
    else
        fprintf('PASS: coarse MaxPos=%d (expected~%d)\n', maxpos, exp_coarse);
    end
end

%% Fine sync fired
if ~isfield(frame, 'fsfs')
    fprintf('FAIL: frame.fsfs missing (fine sync)\n');
    nfail = nfail + 1;
else
    fprintf('PASS: fine sync ran (start_of_frame=%s)\n', mat2str(frame.fsfs.start_of_frame));
end

%% BER
[BER, Nerr, Ntot] = calculate_BER(dataf(:).', frame.fecin(:).');
if BER ~= 0
    fprintf('FAIL: BER=%g (%d/%d)\n', BER, Nerr, Ntot);
    nfail = nfail + 1;
else
    fprintf('PASS: BER=0 (%d bits) via full RxMain\n', Ntot);
end

%% Optional: MF shaping-only still BER=0
params2 = params;
params2.TXMatchedfilter.en = 3;
[sims2, params2] = ReInit(sims, params2);
dataf2 = DataGen(sims2.dataf, params2.totalbits, 0);
[txout2, tx2] = TxMain(dataf2, sims2, params2);
rx2 = [txout2(:, end-pre+1:end), txout2, txout2(:, 1:min(post,size(txout2,2)))];
[~, frame2] = RxMain_OFDM(rx2(1:params2.NRXStream,:), tx2, sims2, params2);
[BER2, Nerr2, Ntot2] = calculate_BER(dataf2(:).', frame2.fecin(:).');
if BER2 ~= 0
    fprintf('FAIL: BER=%g with MF en=3 (%d/%d)\n', BER2, Nerr2, Ntot2);
    nfail = nfail + 1;
else
    fprintf('PASS: BER=0 with MF en=3 shaping-only (%d bits)\n', Ntot2);
end

fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_06a_rxmain_ideal_loopback)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_06a_rxmain_ideal_loopback failed');
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
