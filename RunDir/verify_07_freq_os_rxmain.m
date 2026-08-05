%VERIFY_07_FREQ_OS_RXMAIN  Freq-OS (Lbb=2) RxMain ideal + CFO smoke
%
%   >> run('RunDir/verify_07_freq_os_rxmain.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_07_freq_os_rxmain (Lbb=2) ===\n');
nfail = 0;
CFO_Hz = 1.5e9;

%% Common init helper values
[sims, params] = Init();
params.NDataSymbol = 20;
params.Nbpsc = 4;
params.en_bit_alloc = 0;
params.en_power_loading = 0;
params.NTXStream = 2;
params.NRXStream = 2;
params.NFFT = 128;
params.dfts.Lbb = 2;
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
params.fcfr.en = 0;
params.searchframe.en = 1;
params.searchframe.th = 0;
params.searchfineframe.en = 1;
params.searchfineframe.type = 1;
params.cfr.CFEtype = 5;
params.cfr.CarrierFreqOff = 0;
sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];

%% --- Gate A: no CFO ---
params.cfr.en = 0;
[sims, params] = ReInit(sims, params);
nfail = nfail + check_eq('Lbb', params.dfts.Lbb, 2);
nfail = nfail + check_eq('NIFFT', params.dfts.NIFFT, 256);
nfail = nfail + check_eq('NSamplepersymbol', params.NSamplepersymbol, 288);
nfail = nfail + check_eq('fine cor_length', params.searchfineframe.cor_length, ...
    size(params.sync_pattern,2));
nfail = nfail + check_eq('cfr.Lbb', params.cfr.Lbb, 2);
fprintf('INFO: STF len=%d NSTF=%d\n', size(params.sync_pattern,2), params.NSTFSample);

dataf = DataGen(sims.dataf, params.totalbits, 0);
[txout, txsignal] = TxMain(dataf, sims, params);
pre = min(1001, size(txout,2));
post = min(2000, size(txout,2));
rx0 = [txout(:,end-pre+1:end), txout, txout(:,1:post)];
[~, frame0] = RxMain_OFDM(rx0(1:params.NRXStream,:), txsignal, sims, params);
[BER0, ~, N0] = calculate_BER(dataf(:).', frame0.fecin(:).');
if BER0 ~= 0
    fprintf('FAIL: BER=%g without CFO\n', BER0); nfail = nfail + 1;
else
    fprintf('PASS: BER=0 without CFO (%d bits)\n', N0);
end

%% --- Gate B: CFO 1.5 GHz ---
params.cfr.en = 1;
params.cfr.CarrierFreqOff = CFO_Hz;
[sims, params] = ReInit(sims, params);
dataf = DataGen(sims.dataf, params.totalbits, 0);
[txout, txsignal] = TxMain(dataf, sims, params);
rx0 = [txout(:,end-pre+1:end), txout, txout(:,1:min(post,size(txout,2)))];
cfo_norm = CFO_Hz / params.RXSampleFreq;
rx1 = CarrierFreqOffset(rx0, cfo_norm, 0, 0);
[~, frame1] = RxMain_OFDM(rx1(1:params.NRXStream,:), txsignal, sims, params);
cfo_est_Hz = frame1.cfrout.cfo_est(1) * params.RXSampleFreq;
fprintf('INFO: CFO est=%.3f GHz (applied %.3f)\n', cfo_est_Hz/1e9, CFO_Hz/1e9);
if abs(cfo_est_Hz - CFO_Hz) > 50e6 && abs(cfo_est_Hz + CFO_Hz) > 50e6
    fprintf('FAIL: CFO estimate out of range\n'); nfail = nfail + 1;
else
    fprintf('PASS: CFO estimate within 50 MHz\n');
end
[BER1, ~, N1] = calculate_BER(dataf(:).', frame1.fecin(:).');
if BER1 ~= 0
    fprintf('FAIL: BER=%g with CFO\n', BER1); nfail = nfail + 1;
else
    fprintf('PASS: BER=0 with CFO=1.5 GHz (%d bits)\n', N1);
end

fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_07_freq_os_rxmain)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_07_freq_os_rxmain failed');
end
fprintf('----------------------------------------\n\n');

function n = check_eq(name, got, expv)
    if isequal(got, expv)
        fprintf('PASS: %s\n', name); n = 0;
    else
        fprintf('FAIL: %s\n  got=%s\n  exp=%s\n', name, mat2str(got), mat2str(expv));
        n = 1;
    end
end
