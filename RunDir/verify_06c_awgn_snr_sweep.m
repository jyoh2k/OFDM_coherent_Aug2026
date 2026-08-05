%VERIFY_06C_AWGN_SNR_SWEEP  Step-6C: AWGN-only BER vs SNR (10..20 dB)
%
%   No CFO / fiber / IQ / PN. Digital loopback + AddAWGN.
%   Saves RunDir/verify_06c_awgn_results.mat and .png
%
%   >> run('RunDir/verify_06c_awgn_snr_sweep.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_06c_awgn_snr_sweep (step 6C) ===\n');

SNR_list = 10:20;          % dB
Ntrial = 3;
NDataSymbol = 50;           % more bits for mid-SNR BER

[sims, params] = Init();
params.NDataSymbol = NDataSymbol;
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
params.cfr.en = 0;
params.fcfr.en = 0;
params.searchframe.en = 1;
params.searchframe.th = 0;
params.searchfineframe.en = 1;
params.searchfineframe.type = 1;
sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];
[sims, params] = ReInit(sims, params);

% Fixed TX once (noise added on RX)
load([SW_PATH 'RunDir/savedState.mat']);
defaultStream = RandStream.getGlobalStream;
defaultStream.State = savedState;
dataf = DataGen(sims.dataf, params.totalbits, 0);
[txout, txsignal] = TxMain(dataf, sims, params);
pre = min(1001, size(txout, 2));
post = min(2000, size(txout, 2));
rx_clean = [txout(:, end-pre+1:end), txout, txout(:, 1:post)];

BER = zeros(size(SNR_list));
Nerr = zeros(size(SNR_list));
Ntot = zeros(size(SNR_list));
sync_ok = zeros(size(SNR_list));

for k = 1:numel(SNR_list)
    snr = SNR_list(k);
    nerr_acc = 0;
    ntot_acc = 0;
    sync_acc = 0;
    for it = 1:Ntrial
        % Independent noise each trial
        rng(1000 + k*100 + it);
        [rx_noisy, ~] = AddAWGN(rx_clean, snr, 1);
        [~, frame] = RxMain_OFDM(rx_noisy(1:params.NRXStream,:), txsignal, sims, params);
        [ber_i, nerr_i, ntot_i] = calculate_BER(dataf(:).', frame.fecin(:).');
        nerr_acc = nerr_acc + nerr_i;
        ntot_acc = ntot_acc + ntot_i;
        if isfield(frame, 'fscs') && abs(frame.fscs.MaxPos - (pre+1)) <= 5
            sync_acc = sync_acc + 1;
        end
    end
    BER(k) = nerr_acc / max(ntot_acc, 1);
    Nerr(k) = nerr_acc;
    Ntot(k) = ntot_acc;
    sync_ok(k) = sync_acc / Ntrial;
    fprintf('SNR=%2d dB  BER=%.4e  (%d/%d)  sync=%.0f%%\n', ...
        snr, BER(k), Nerr(k), Ntot(k), 100*sync_ok(k));
end

%% Plot
fig = figure('Name', 'verify_06c AWGN BER', 'Color', 'w');
semilogy(SNR_list, max(BER, 1e-6), 'o-', 'LineWidth', 1.5, 'MarkerSize', 7);
grid on;
xlabel('SNR (dB)');
ylabel('BER');
title(sprintf('DFT-s-OFDM AWGN only (Lbb=1, 16-QAM, %d pol)', params.NTXStream));
ylim([1e-6 1]);
xlim([SNR_list(1)-0.5, SNR_list(end)+0.5]);
legend('Measured BER', 'Location', 'southwest');

out_png = fullfile(this_dir, 'verify_06c_awgn_ber.png');
out_mat = fullfile(this_dir, 'verify_06c_awgn_results.mat');
out_csv = fullfile(this_dir, 'verify_06c_awgn_results.csv');
saveas(fig, out_png);
save(out_mat, 'SNR_list', 'BER', 'Nerr', 'Ntot', 'sync_ok', 'Ntrial', 'NDataSymbol', 'params');
fid = fopen(out_csv, 'w');
fprintf(fid, 'SNR_dB,BER,Nerr,Ntot,sync_ok\n');
for k = 1:numel(SNR_list)
    fprintf(fid, '%d,%.10e,%d,%d,%.4f\n', SNR_list(k), BER(k), Nerr(k), Ntot(k), sync_ok(k));
end
fclose(fid);
fprintf('Saved: %s\n', out_png);
fprintf('Saved: %s\n', out_csv);

% Soft gate: sync should hold; BER should trend down with SNR
nfail = 0;
if any(sync_ok < 1)
    fprintf('FAIL: sync not 100%% at some SNR\n');
    nfail = nfail + 1;
else
    fprintf('PASS: sync 100%% across SNR 10..20\n');
end
% Monotone-ish: BER(20) << BER(10)
if ~(BER(end) < BER(1))
    fprintf('FAIL: BER did not improve from 10 to 20 dB\n');
    nfail = nfail + 1;
else
    fprintf('PASS: BER(20)=%.3e < BER(10)=%.3e\n', BER(end), BER(1));
end

fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_06c_awgn_snr_sweep)\n');
else
    fprintf('RESULT: FAIL (%d check(s))\n', nfail);
    error('verify_06c_awgn_snr_sweep failed');
end
fprintf('----------------------------------------\n\n');
