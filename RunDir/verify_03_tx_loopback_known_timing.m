%VERIFY_03_TX_LOOPBACK_KNOWN_TIMING  Step-3A gate: 128 IFFT+CP, known timing
%
%   Ideal loopback (no channel / no sync search):
%     TxMain(txframe) -> skip STF -> FFT+remove CP -> LTF CE -> EQ
%     -> IDFT-s -> demap -> BER==0
%
%   >> run('RunDir/verify_03_tx_loopback_known_timing.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_03_tx_loopback_known_timing (3A) ===\n');
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
params.dfts.Lbb = 1;             % Step-3A / Step-5: no freq OS
params.TXMatchedfilter.en = 0;   % keep symbol-rate txframe clean
params.cpr.en = 0;
params.cpr.bcpr_en = 0;
params.ce.en_ISFA = 0;           % avoid smoothing on ideal H
params.TXAGC.en = 0;
sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];
[sims, params] = ReInit(sims, params);

map = params.dfts.map;
nfail = nfail + check_eq('NSamplepersymbol', params.NSamplepersymbol, 144);
nfail = nfail + check_eq('Nsd', params.Nsd, 120);

%% --- LTF placement checks ---
ltf = params.LTF;
if any(abs(ltf(map.UnusedIndex)) > 0)
    fprintf('FAIL: LTF non-zero on DC/Null\n');
    nfail = nfail + 1;
else
    fprintf('PASS: LTF zero on DC/Null\n');
end
if any(ltf(params.SubcarrierIndex) == 0)
    fprintf('FAIL: LTF has zero on active bins\n');
    nfail = nfail + 1;
else
    fprintf('PASS: LTF non-zero on all active bins\n');
end
if max(abs(abs(ltf(params.SubcarrierIndex)) - 1)) > 1e-12
    fprintf('FAIL: LTF active bins not unit-magnitude BPSK\n');
    nfail = nfail + 1;
else
    fprintf('PASS: LTF active bins are +/-1\n');
end

%% TX
dataf = DataGen(sims.dataf, params.totalbits, 0);
[txout, txsignal] = TxMain(dataf, sims, params); %#ok<ASGLU>

txframe = txsignal.txframe;
n_stf = params.NSTFSample;
n_ofdm = params.NSymbol * params.NSamplepersymbol;
if size(txframe, 2) < n_stf + n_ofdm
    fprintf('FAIL: txframe too short (%d < %d)\n', size(txframe,2), n_stf+n_ofdm);
    error('verify_03 failed');
end
td = txframe(:, n_stf + (1:n_ofdm));  % known timing: skip STF
fprintf('PASS: known-timing extract (skip STF=%d samples)\n', n_stf);

%% FFT
fft_out = FFTnRemoveGI(td, params.fft);
nfail = nfail + check_eq('FFT out length', size(fft_out,2), params.NSymbol*params.NFFT);

%% LTF CE on ideal channel
[data_f, H, ce] = ChannelEst(fft_out, params.ce); %#ok<ASGLU>
nfail = nfail + check_eq('data_f length', size(data_f,2), params.NDataSymbol*params.NFFT);

% Verify CE by ZF-equalizing the two LTF symbols (not raw H==I;
% AA estimator stores ZF weights that recover TX LTF on ideal channel)
ltf_tx = params.ltf.LTF;   % 2 x (2*NFFT): [LTF LTF; LTF -LTF]
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
idx_act = [params.SubcarrierIndex, params.SubcarrierIndex + params.NFFT];
ltf_mse = mean(abs(ltf_eq(:, idx_act) - ltf_tx(:, idx_act)).^2, 'all');
if ltf_mse >= 1e-10
    fprintf('FAIL: equalized LTF MSE=%.3e\n', ltf_mse);
    nfail = nfail + 1;
else
    fprintf('PASS: equalized LTF matches TX (MSE=%.3e)\n', ltf_mse);
end

%% EQ + IDFT-s + demap
frame = struct();
[eq2_out, pilot, eq_out, frame] = ChannelComp(data_f, H, params, frame); %#ok<ASGLU>
nfail = nfail + check_eq('despread length', size(eq2_out,2), params.Nsd*params.NDataSymbol);

% Round-trip vs TX QAM (mapper2 is pre-DFT QAM, multi-stream)
qam_tx = txsignal.mapper2;
qam_rx = eq2_out;
% mapper2 is NTXStream x (Nsd*NDataSymbol)
if ~isequal(size(qam_tx), size(qam_rx))
    fprintf('FAIL: QAM size TX %s RX %s\n', mat2str(size(qam_tx)), mat2str(size(qam_rx)));
    nfail = nfail + 1;
else
    qam_mse = mean(abs(qam_tx(:) - qam_rx(:)).^2);
    if qam_mse >= 1e-10
        fprintf('FAIL: QAM MSE after IDFT-s = %.3e\n', qam_mse);
        nfail = nfail + 1;
    else
        fprintf('PASS: QAM MSE after IDFT-s = %.3e\n', qam_mse);
    end
end

eq_serial = SingleStreamOut(eq2_out, params);
rx_bits = OFDMDemapper(eq_serial, params);
[BER, Nbiterr, Ntotal] = calculate_BER(dataf, rx_bits);
if BER ~= 0
    fprintf('FAIL: BER=%g (%d / %d)\n', BER, Nbiterr, Ntotal);
    nfail = nfail + 1;
else
    fprintf('PASS: BER=0 (%d bits)\n', Ntotal);
end

%% Verdict
fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_03_tx_loopback_known_timing)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_03_tx_loopback_known_timing failed');
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
