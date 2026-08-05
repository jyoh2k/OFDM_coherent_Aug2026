%VERIFY_05B_LOOPBACK_KNOWN_TIMING  Step-5B: Lbb=1 known-timing BER=0
%
%   Ideal loopback (skip STF, no sync): TX -> FFT -> CE -> EQ -> IDFT-s -> demap
%   MF en=0 for clean symbol-rate path; shaping checked separately in 5A/5C.
%
%   >> run('RunDir/verify_05b_loopback_known_timing.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_05b_loopback_known_timing (step 5B) ===\n');
nfail = 0;

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
params.TXMatchedfilter.en = 0;
params.TXMatchedfilter.alpha = 1.0;
params.cpr.en = 0;
params.cpr.bcpr_en = 0;
params.ce.en_ISFA = 0;
params.TXAGC.en = 0;
params.tpr.en = 0;
sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];
[sims, params] = ReInit(sims, params);

nfail = nfail + check_eq('NSamplepersymbol', params.NSamplepersymbol, 144);
nfail = nfail + check_eq('Lbb', params.dfts.Lbb, 1);

dataf = DataGen(sims.dataf, params.totalbits, 0);
[~, txsignal] = TxMain(dataf, sims, params);

txframe = txsignal.txframe;
n_stf = params.NSTFSample;
n_ofdm = params.NSymbol * params.NSamplepersymbol;
if size(txframe, 2) < n_stf + n_ofdm
    fprintf('FAIL: txframe too short (%d < %d)\n', size(txframe,2), n_stf+n_ofdm);
    error('verify_05b failed');
end
td = txframe(:, n_stf + (1:n_ofdm));
fprintf('PASS: known-timing extract (skip STF=%d, body=%d)\n', n_stf, n_ofdm);

fft_out = FFTnRemoveGI(td, params.fft);
nfail = nfail + check_eq('FFT out length', size(fft_out,2), params.NSymbol*params.NFFT);

[data_f, H] = ChannelEst(fft_out, params.ce);
nfail = nfail + check_eq('data_f length', size(data_f,2), params.NDataSymbol*params.NFFT);

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
idx_act = [params.SubcarrierIndex, params.SubcarrierIndex + params.NFFT];
ltf_mse = mean(abs(ltf_eq(:, idx_act) - ltf_tx(:, idx_act)).^2, 'all');
if ltf_mse >= 1e-10
    fprintf('FAIL: equalized LTF MSE=%.3e\n', ltf_mse);
    nfail = nfail + 1;
else
    fprintf('PASS: equalized LTF MSE=%.3e\n', ltf_mse);
end

frame = struct();
[eq2_out, ~, ~, frame] = ChannelComp(data_f, H, params, frame); %#ok<ASGLU>
nfail = nfail + check_eq('despread length', size(eq2_out,2), params.Nsd*params.NDataSymbol);

qam_mse = mean(abs(txsignal.mapper2(:) - eq2_out(:)).^2);
if qam_mse >= 1e-10
    fprintf('FAIL: QAM MSE after IDFT-s = %.3e\n', qam_mse);
    nfail = nfail + 1;
else
    fprintf('PASS: QAM MSE after IDFT-s = %.3e\n', qam_mse);
end

rx_bits = OFDMDemapper(SingleStreamOut(eq2_out, params), params);
[BER, Nbiterr, Ntotal] = calculate_BER(dataf, rx_bits);
if BER ~= 0
    fprintf('FAIL: BER=%g (%d / %d)\n', BER, Nbiterr, Ntotal);
    nfail = nfail + 1;
else
    fprintf('PASS: BER=0 (%d bits)\n', Ntotal);
end

% Optional: MF shaping-only does not change length when SampleFreq=BaudFreq
params_mf = params;
params_mf.TXMatchedfilter.en = 3;
[sims_mf, params_mf] = ReInit(sims, params_mf); %#ok<ASGLU>
dataf2 = DataGen(sims.dataf, params_mf.totalbits, 0);
[txout_mf, tx_mf] = TxMain(dataf2, sims, params_mf);
nfail = nfail + check_eq('MF out length == txframe', size(txout_mf,2), size(tx_mf.txframe,2));

fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_05b_loopback_known_timing)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_05b_loopback_known_timing failed');
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
