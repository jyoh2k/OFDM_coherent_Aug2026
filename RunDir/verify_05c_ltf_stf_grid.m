%VERIFY_05C_LTF_STF_GRID  Step-5C: LTF/STF on 144-sample (Lbb=1) grid
%
%   >> run('RunDir/verify_05c_ltf_stf_grid.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_05c_ltf_stf_grid (step 5C) ===\n');
nfail = 0;

[sims, params] = Init();
params.NDataSymbol = 16;
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
sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];
[sims, params] = ReInit(sims, params);

map = params.dfts.map;
Lbb = params.dfts.Lbb;
nfail = nfail + check_eq('Lbb', Lbb, 1);
nfail = nfail + check_eq('NSamplepersymbol', params.NSamplepersymbol, 144);

%% LTF
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

%% STF: no zero-insert stretch when Lbb=1
stf = params.sync_pattern;
nfail = nfail + check_eq('STF streams', size(stf,1), params.NTXStream);
nfail = nfail + check_eq('NSTFSample', params.NSTFSample, 2*size(stf,2));
nfail = nfail + check_eq('searchframe.sync_pattern len', ...
    size(params.searchframe.sync_pattern,2), size(stf,2));

% Dense (non-strided) pattern expected: many consecutive nonzeros
nz_frac = mean(abs(stf(1,:)) > 0);
if nz_frac < 0.5
    fprintf('FAIL: STF looks sparse (nz_frac=%.2f) — unexpected Lbb stretch?\n', nz_frac);
    nfail = nfail + 1;
else
    fprintf('PASS: STF dense on Lbb=1 grid (nz_frac=%.2f)\n', nz_frac);
end

%% Frame structure + BER
dataf = DataGen(sims.dataf, params.totalbits, 0);
[~, tx] = TxMain(dataf, sims, params);
txframe = tx.txframe;
n_stf = params.NSTFSample;
n_ltf = params.NLTFSample;
n_data = params.NDataSample;
need = n_stf + n_ltf + n_data;
nfail = nfail + check_eq('NLTFSample', n_ltf, params.NLTFSymbol * 144);
if size(txframe,2) < need
    fprintf('FAIL: txframe short (%d < %d)\n', size(txframe,2), need);
    nfail = nfail + 1;
else
    fprintf('PASS: txframe covers STF+LTF+Data (%d samples)\n', need);
end

stf_region = txframe(:, 1:n_stf);
stf_ref = [params.sync_pattern, params.sync_pattern];
if max(abs(stf_region(:) - stf_ref(:))) > 1e-12
    fprintf('FAIL: txframe STF region != [sync sync]\n');
    nfail = nfail + 1;
else
    fprintf('PASS: txframe starts with [STF STF]\n');
end

td = txframe(:, n_stf + (1:(n_ltf+n_data)));
fft_out = FFTnRemoveGI(td, params.fft);
[data_f, H] = ChannelEst(fft_out, params.ce);
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

fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_05c_ltf_stf_grid)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_05c_ltf_stf_grid failed');
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
