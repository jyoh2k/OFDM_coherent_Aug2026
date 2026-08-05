%VERIFY_05A_NOS_PARAMS  Step-5A: Lbb=1 / SampleFreq=BaudFreq / MF shaping-only
%
%   >> run('RunDir/verify_05a_nos_params.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_05a_nos_params (step 5A) ===\n');
nfail = 0;

[sims, params] = Init();
params.NDataSymbol = 8;
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
params.TXMatchedfilter.en = 3;
params.TXMatchedfilter.alpha = 1.0;
sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];
[sims, params] = ReInit(sims, params);

nfail = nfail + check_eq('Lbb', params.dfts.Lbb, 1);
nfail = nfail + check_eq('NIFFT', params.dfts.NIFFT, 128);
nfail = nfail + check_eq('CP_os', params.dfts.CP_os, 16);
nfail = nfail + check_eq('NSamplepersymbol', params.NSamplepersymbol, 144);
nfail = nfail + check_eq('ifft.NIFFT', params.ifft.NIFFT, 128);
nfail = nfail + check_eq('fft.NIFFT', params.fft.NIFFT, 128);
nfail = nfail + check_eq('ifft.NCP', params.ifft.NCP, 16);
nfail = nfail + check_eq('fft.NCP', params.fft.NCP, 16);
nfail = nfail + check_eq('TXSampleFreq==BaudFreq', params.TXSampleFreq, params.BaudFreq);
nfail = nfail + check_eq('RXSampleFreq==BaudFreq', params.RXSampleFreq, params.BaudFreq);
nfail = nfail + check_eq('RXoversample', params.RXoversample, 1);
nfail = nfail + check_eq('MF sps', params.TXMatchedfilter.sps, 1);
nfail = nfail + check_eq('MF p', params.TXMatchedfilter.p, 1);
nfail = nfail + check_eq('MF q', params.TXMatchedfilter.q, 1);
nfail = nfail + check_eq('MF en', params.TXMatchedfilter.en, 3);
nfail = nfail + check_eq('MF alpha', params.TXMatchedfilter.alpha, 1.0);

% STF must NOT be Lbb-stretched when Lbb=1
stf_len = size(params.sync_pattern, 2);
nfail = nfail + check_eq('NSTFSample', params.NSTFSample, 2 * stf_len);
if params.dfts.Lbb == 1 && stf_len ~= size(params.STF, 2)
    fprintf('FAIL: STF/sync_pattern length mismatch\n');
    nfail = nfail + 1;
else
    fprintf('PASS: STF on native (no upsample) grid, len=%d\n', stf_len);
end

fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_05a_nos_params)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_05a_nos_params failed');
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
