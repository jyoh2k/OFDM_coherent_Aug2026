%VERIFY_04_LTF_STF  Step-4 gate: preamble/LTF on DFT-s + freq-OS grid
%
%   >> run('RunDir/verify_04_ltf_stf.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_04_ltf_stf (step 4) ===\n');
nfail = 0;

%% Init
[sims, params] = Init();
params.NDataSymbol = 16;
params.Nbpsc = 4;
params.en_bit_alloc = 0;
params.en_power_loading = 0;
params.NTXStream = 2;
params.NRXStream = 2;
params.dfts.Lbb = 2;   % Step-4 was written for freq-OS grid
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

map = params.dfts.map;
Lbb = params.dfts.Lbb;

%% alpha default
nfail = nfail + check_eq('TXMatchedfilter.alpha', params.TXMatchedfilter.alpha, 1.0);

%% --- LTF checks ---
ltf = params.LTF;
if any(abs(ltf(map.UnusedIndex)) > 0)
    fprintf('FAIL: LTF energy on DC/Null\n');
    nfail = nfail + 1;
else
    fprintf('PASS: LTF zero on DC/Null\n');
end
if any(ltf(params.SubcarrierIndex) == 0)
    fprintf('FAIL: LTF zero on an active bin\n');
    nfail = nfail + 1;
else
    fprintf('PASS: LTF covers all active bins\n');
end
if max(abs(abs(ltf(params.SubcarrierIndex)) - 1)) > 1e-12
    fprintf('FAIL: LTF not unit BPSK on active bins\n');
    nfail = nfail + 1;
else
    fprintf('PASS: LTF is +/-1 on active bins (no DFT-s)\n');
end

% MIMO LTF packing: [A A; A -A]
ltf_mat = params.ltf.LTF;
nfail = nfail + check_eq('ltf.LTF size', size(ltf_mat), [2, 2*params.NFFT]);
if max(abs(ltf_mat(1,1:params.NFFT) - ltf)) > 1e-12 || ...
   max(abs(ltf_mat(1,params.NFFT+(1:params.NFFT)) - ltf)) > 1e-12 || ...
   max(abs(ltf_mat(2,1:params.NFFT) - ltf)) > 1e-12 || ...
   max(abs(ltf_mat(2,params.NFFT+(1:params.NFFT)) + ltf)) > 1e-12
    fprintf('FAIL: MIMO LTF is not [A A; A -A]\n');
    nfail = nfail + 1;
else
    fprintf('PASS: MIMO LTF = [A A; A -A]\n');
end

%% --- STF checks (CRT pattern stretched by Lbb) ---
stf = params.sync_pattern;
nfail = nfail + check_eq('STF streams', size(stf,1), params.NTXStream);
if mod(size(stf,2), Lbb) ~= 0
    fprintf('FAIL: STF length not multiple of Lbb=%d\n', Lbb);
    nfail = nfail + 1;
else
    fprintf('PASS: STF length multiple of Lbb\n');
end
nfail = nfail + check_eq('NSTFSample', params.NSTFSample, 2*size(stf,2));

% Zero-insertion check: odd (0-based even MATLAB?) samples after upsample
% TxUpsample type0: out(:,1:L:end)=in  => nonzeros on indices 1,1+L,...
nz_pos = find(abs(stf(1,:)) > 0);
if any(mod(nz_pos-1, Lbb) ~= 0)
    fprintf('FAIL: STF not on Lbb-strided grid (zero-insert)\n');
    nfail = nfail + 1;
else
    fprintf('PASS: STF uses Lbb zero-insertion grid\n');
end

%% --- Frame structure ---
dataf = DataGen(sims.dataf, params.totalbits, 0);
[~, tx] = TxMain(dataf, sims, params);
txframe = tx.txframe;
n_stf = params.NSTFSample;
n_ltf = params.NLTFSample;
n_data = params.NDataSample;
need = n_stf + n_ltf + n_data;
if size(txframe,2) < need
    fprintf('FAIL: txframe short (%d < %d)\n', size(txframe,2), need);
    nfail = nfail + 1;
else
    fprintf('PASS: txframe covers STF+LTF+Data (%d samples)\n', need);
end

% STF region equals [sync sync]
stf_region = txframe(:, 1:n_stf);
stf_ref = [params.sync_pattern, params.sync_pattern];
if max(abs(stf_region(:) - stf_ref(:))) > 1e-12
    fprintf('FAIL: txframe STF region != [sync sync]\n');
    nfail = nfail + 1;
else
    fprintf('PASS: txframe starts with [STF STF]\n');
end

%% STF autocorrelation peak (repetition)
% Correlate first half with sliding window on STF region
half = size(params.sync_pattern, 2);
seg = stf_region(1, :);
c = abs(xcorr(seg, params.sync_pattern(1,:)));
[cmax, imax] = max(c);
% Expected peak when aligned to first copy and second copy
if cmax <= 0
    fprintf('FAIL: STF xcorr peak invalid\n');
    nfail = nfail + 1;
else
    fprintf('PASS: STF xcorr has peak (max=%.3g)\n', cmax);
end

%% LTF CE + short BER (known timing, MF off)
td = txframe(:, n_stf + (1:(n_ltf+n_data)));
fft_out = FFTnRemoveGI(td, params.fft);
[data_f, H] = ChannelEst(fft_out, params.ce);
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
    fprintf('FAIL: LTF CE MSE=%.3e\n', ltf_mse);
    nfail = nfail + 1;
else
    fprintf('PASS: LTF CE MSE=%.3e\n', ltf_mse);
end

frame = struct();
[eq2, ~, ~, frame] = ChannelComp(data_f, H, params, frame); %#ok<ASGLU>
rx_bits = OFDMDemapper(SingleStreamOut(eq2, params), params);
[BER, ~, Ntot] = calculate_BER(dataf, rx_bits);
if BER ~= 0
    fprintf('FAIL: BER=%g after LTF/STF frame\n', BER);
    nfail = nfail + 1;
else
    fprintf('PASS: BER=0 (%d bits) with STF+LTF frame\n', Ntot);
end

%% Verdict
fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_04_ltf_stf)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_04_ltf_stf failed');
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
