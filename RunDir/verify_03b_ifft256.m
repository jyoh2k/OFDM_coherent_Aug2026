%VERIFY_03B_IFFT256  Step-3B gate: freq-OS IFFT256+CP32, no time upsample
%
%   >> run('RunDir/verify_03b_ifft256.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_03b_ifft256 (3B) ===\n');
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
params.dfts.Lbb = 2;             % Step-3B: freq-OS on
params.TXMatchedfilter.en = 0;   % Gate3/4: first without pulse shape
params.TXMatchedfilter.alpha = 1.0;  % required for Hanning-sinc (en=3)
params.cpr.en = 0;
params.cpr.bcpr_en = 0;
params.ce.en_ISFA = 0;
params.TXAGC.en = 0;
params.tpr.en = 0;
% Keep DAC rate = OFDM sample rate (no extra Resample x2 from Init defaults)
params.BaudFreq = 42e9;
params.TXSampleFreq = params.BaudFreq;
params.RXSampleFreq = params.BaudFreq;
params.AWGSampleFreq = params.TXSampleFreq;
params.OSCFreq = params.RXSampleFreq;
sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];
[sims, params] = ReInit(sims, params);

%% Gate 1: sizes
nfail = nfail + check_eq('NIFFT', params.dfts.NIFFT, 256);
nfail = nfail + check_eq('CP_os', params.dfts.CP_os, 32);
nfail = nfail + check_eq('Lbb', params.dfts.Lbb, 2);
nfail = nfail + check_eq('NSamplepersymbol', params.NSamplepersymbol, 288);
nfail = nfail + check_eq('ifft.NIFFT', params.ifft.NIFFT, 256);
nfail = nfail + check_eq('fft.NIFFT', params.fft.NIFFT, 256);
nfail = nfail + check_eq('MF sps (no time OS)', params.TXMatchedfilter.sps, 1);
nfail = nfail + check_eq('MF p', params.TXMatchedfilter.p, 1);
nfail = nfail + check_eq('MF q', params.TXMatchedfilter.q, 1);

%% TX
dataf = DataGen(sims.dataf, params.totalbits, 0);
[txout, txsignal] = TxMain(dataf, sims, params); %#ok<ASGLU>
txframe = txsignal.txframe;

% Gate 5 / length: MF must not double length vs txframe body rate
% txframe is pre-MF; txout after MF+Resample. With en=0, lengths match
% aside from STF sharing same sample grid.
n_stf = params.NSTFSample;
n_ofdm = params.NSymbol * params.NSamplepersymbol;
if size(txframe, 2) < n_stf + n_ofdm
    fprintf('FAIL: txframe too short\n');
    nfail = nfail + 1;
else
    fprintf('PASS: txframe length covers STF+OFDM\n');
end

% One OFDM symbol length check via IFFT path alone
one_sc = zeros(1, params.NFFT);
one_sc(params.DataSubcarrierIndex(1)) = 1;
xt = IFFT_oversampling(one_sc, params.NFFT, params.dfts.Lbb);
nfail = nfail + check_eq('IFFT_oversampling length', length(xt), 256);

%% Gate 2: spectrum packing (active energy in logical bins after extract)
td = txframe(:, n_stf + (1:n_ofdm));
fft_out = FFTnRemoveGI(td, params.fft);
% Power on unused bins of a data symbol should be ~0
sym1 = fft_out(1, params.NLTFSymbol*params.NFFT + (1:params.NFFT));
unused_pwr = max(abs(sym1(params.dfts.map.UnusedIndex)));
data_pwr = mean(abs(sym1(params.DataSubcarrierIndex)).^2);
if unused_pwr > 1e-8 * max(1, data_pwr)
    fprintf('FAIL: unused-bin leakage after extract (%.3e)\n', unused_pwr);
    nfail = nfail + 1;
else
    fprintf('PASS: unused bins ~0 after 256->128 extract\n');
end

%% Gate 4: known-timing loopback (MF en=0)
[data_f, H, ce] = ChannelEst(fft_out, params.ce); %#ok<ASGLU>
idx_act = [params.SubcarrierIndex, params.SubcarrierIndex + params.NFFT];
ltf_tx = params.ltf.LTF;
ltf_rx = fft_out(:, 1:params.ce.NLTFSample);
ltf_eq = zeros(size(ltf_rx));
for isym = 1:params.NTXStream
    y = ltf_rx(:, (isym-1)*params.NFFT + (1:params.NFFT));
    xh = zeros(size(y));
    for sc = params.SubcarrierIndex
        xh(:, sc) = H(:, :, sc) * y(:, sc);
    end
    ltf_eq(:, (isym-1)*params.NFFT + (1:params.NFFT)) = xh;
end
ltf_mse = mean(abs(ltf_eq(:, idx_act) - ltf_tx(:, idx_act)).^2, 'all');
if ltf_mse >= 1e-10
    fprintf('FAIL: equalized LTF MSE=%.3e\n', ltf_mse);
    nfail = nfail + 1;
else
    fprintf('PASS: equalized LTF MSE=%.3e\n', ltf_mse);
end

frame = struct();
[eq2_out, pilot, eq_out, frame] = ChannelComp(data_f, H, params, frame); %#ok<ASGLU>
qam_mse = mean(abs(txsignal.mapper2(:) - eq2_out(:)).^2);
if qam_mse >= 1e-10
    fprintf('FAIL: QAM MSE=%.3e (MF off)\n', qam_mse);
    nfail = nfail + 1;
else
    fprintf('PASS: QAM MSE=%.3e (MF off)\n', qam_mse);
end

rx_bits = OFDMDemapper(SingleStreamOut(eq2_out, params), params);
[BER, Nbiterr, Ntotal] = calculate_BER(dataf, rx_bits);
if BER ~= 0
    fprintf('FAIL: BER=%g (%d/%d) MF off\n', BER, Nbiterr, Ntotal);
    nfail = nfail + 1;
else
    fprintf('PASS: BER=0 (%d bits) MF off\n', Ntotal);
end

%% Gate 3: MF en=3 — pulse shape ON, confirm no time-domain x2
params.TXMatchedfilter.en = 3;
params.TXMatchedfilter.alpha = 1.0;  % Init default 0.4 breaks Hanning-sinc loopback
params.BaudFreq = 42e9;
params.TXSampleFreq = params.BaudFreq;
params.RXSampleFreq = params.BaudFreq;
params.AWGSampleFreq = params.TXSampleFreq;
params.OSCFreq = params.RXSampleFreq;
[sims, params] = ReInit(sims, params);
params.cpr.en = 0; params.cpr.bcpr_en = 0; params.ce.en_ISFA = 0;
params.TXAGC.en = 0; params.tpr.en = 0;
nfail = nfail + check_eq('MF sps after reinit', params.TXMatchedfilter.sps, 1);
nfail = nfail + check_eq('MF p after reinit', params.TXMatchedfilter.p, 1);

dataf2 = DataGen(sims.dataf, params.totalbits, 0);
[~, tx2] = TxMain(dataf2, sims, params);
ratio = length(tx2.txout) / max(1, length(tx2.txframe));
if abs(ratio - 2) < 0.1
    fprintf('FAIL: unexpected x2 length (txout/txframe=%.3f)\n', ratio);
    nfail = nfail + 1;
else
    fprintf('PASS: txout/txframe ratio=%.3f (no time OS / no Resample x2)\n', ratio);
end

% MF on OFDM body (TX filter only; no RX match)
ofdm_td = tx2.txframe(:, params.NSTFSample + (1:params.NSymbol*params.NSamplepersymbol));
ofdm_mf = MatchedFilter_OFDM(ofdm_td, params.TXMatchedfilter);
if ~isequal(size(ofdm_mf), size(ofdm_td))
    fprintf('FAIL: MF changed OFDM body size %s -> %s\n', ...
        mat2str(size(ofdm_td)), mat2str(size(ofdm_mf)));
    nfail = nfail + 1;
else
    fprintf('PASS: MF en=3 preserves OFDM body length\n');
end
fft2 = FFTnRemoveGI(ofdm_mf, params.fft);
[data_f2, H2] = ChannelEst(fft2, params.ce);
frame2 = struct();
[eq2, ~, ~, frame2] = ChannelComp(data_f2, H2, params, frame2); %#ok<ASGLU>
qam_mse2 = mean(abs(tx2.mapper2(:) - eq2(:)).^2);
rx_bits2 = OFDMDemapper(SingleStreamOut(eq2, params), params);
[BER2, ~, Ntotal2] = calculate_BER(dataf2, rx_bits2);
fprintf('INFO: MF en=3 alpha=%.1f  QAM MSE=%.3e  BER=%g\n', ...
    params.TXMatchedfilter.alpha, qam_mse2, BER2);
if BER2 ~= 0
    fprintf('FAIL: BER=%g with MF en=3 alpha=1.0 (%d bits)\n', BER2, Ntotal2);
    nfail = nfail + 1;
else
    fprintf('PASS: BER=0 with MF en=3 alpha=1.0 (%d bits)\n', Ntotal2);
end

%% Verdict
fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_03b_ifft256)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_03b_ifft256 failed');
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
