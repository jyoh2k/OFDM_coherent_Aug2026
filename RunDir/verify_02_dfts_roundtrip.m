%VERIFY_02_DFTS_ROUNDTRIP  Step-2 gate: QAM + DFT-s + grid (no IFFT/RX)
%
%   >> run('RunDir/verify_02_dfts_roundtrip.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath')); % RunDir
proj_root = fileparts(this_dir);             % project root
cd(proj_root);
run('AddPath.m');

fprintf('\n=== verify_02_dfts_roundtrip: DFT-s TX mapper ===\n');
nfail = 0;

%% Init / ReInit with short frame
[sims, params] = Init();
params.NDataSymbol = 4;
params.Nbpsc = 4;
params.en_bit_alloc = 0;
params.en_power_loading = 0;
params.NTXStream = 2;
params.NFFT = 128;
sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];
[sims, params] = ReInit(sims, params);

map = params.dfts.map;
Nd = params.dfts.Nd;
Nsubch = params.dfts.Nsubch;

nfail = nfail + check_eq('Nsd', params.Nsd, 120);
nfail = nfail + check_eq('Pilot count', numel(params.PilotIndex), 6);
nfail = nfail + check_eq('Nbpsym', params.Nbpsym, 120*params.Nbpsc*params.NTXStream);

%% TX mapper
dataf = DataGen(sims.dataf, params.totalbits, 0);
[grid_serial, qam_serial] = OFDMMapper(dataf, params);

qam = reshape(qam_serial, params.NTXStream, params.Nsd, params.NDataSymbol);
grid = reshape(grid_serial, params.NTXStream, params.NFFT, params.NDataSymbol);

%% Pilot / DC / Null remain zero before AddPilotSymbol
pilot_pwr = max(abs(grid(:, params.PilotIndex, :)), [], 'all');
dc_null_pwr = max(abs(grid(:, [map.DCIndex, map.NullIndex], :)), [], 'all');
if pilot_pwr > 0
    fprintf('FAIL: pilot bins non-zero before AddPilotSymbol (%.3g)\n', pilot_pwr);
    nfail = nfail + 1;
else
    fprintf('PASS: pilot bins zero before AddPilotSymbol\n');
end
if dc_null_pwr > 0
    fprintf('FAIL: DC/Null non-zero (%.3g)\n', dc_null_pwr);
    nfail = nfail + 1;
else
    fprintf('PASS: DC/Null zero\n');
end

%% Round-trip: IDFT-s recovers QAM
max_mse = 0;
for itx = 1:params.NTXStream
    for isym = 1:params.NDataSymbol
        for iu = 1:Nsubch
            X = grid(itx, map.SubchDataIndex{iu}, isym);
            x_hat = ifft(X, Nd) * sqrt(Nd);
            x_ref = qam(itx, (iu-1)*Nd + (1:Nd), isym);
            mse = mean(abs(x_hat - x_ref).^2);
            max_mse = max(max_mse, mse);
        end
    end
end
if max_mse >= 1e-12
    fprintf('FAIL: DFT-s round-trip MSE=%.3e (>=1e-12)\n', max_mse);
    nfail = nfail + 1;
else
    fprintf('PASS: DFT-s round-trip MSE=%.3e\n', max_mse);
end

%% Active data bins occupied; no leakage outside data+pilot+unused
data_pwr = mean(abs(grid(:, params.DataSubcarrierIndex, :)).^2, 'all');
if data_pwr <= 0
    fprintf('FAIL: data bins have zero power\n');
    nfail = nfail + 1;
else
    fprintf('PASS: data bins have power (mean=%.3g)\n', data_pwr);
end

%% AddPilotSymbol fills pilots only
mapper3 = MultiStreamOut(grid_serial, params);
pilotout = AddPilotSymbol(mapper3, params.pilot);
pilot_blk = reshape(pilotout, params.NTXStream, params.NFFT, []);
% Compare first data symbol pilots
p_got = pilot_blk(:, params.PilotIndex, 1);
p_exp = params.PilotSym;
if ~isequal(size(p_got), size(p_exp))
    % PilotSym is NTX x Npilot; extract matching
    fprintf('FAIL: pilot size got %s exp %s\n', mat2str(size(p_got)), mat2str(size(p_exp)));
    nfail = nfail + 1;
else
    perr = max(abs(p_got(:) - p_exp(:)));
    if perr > 1e-12
        fprintf('FAIL: AddPilotSymbol mismatch (max err=%.3e)\n', perr);
        nfail = nfail + 1;
    else
        fprintf('PASS: AddPilotSymbol matches PilotSym\n');
    end
end

%% Subchannel isolation: only one subch excited
x_one = zeros(1, Nd);
x_one(1:Nd) = (1:Nd);
one_symbol = zeros(1, params.NFFT);
one_symbol(1, map.SubchDataIndex{1}) = fft(x_one, Nd) / sqrt(Nd);
leak_ok = true;
for iu = 2:Nsubch
    if max(abs(one_symbol(map.SubchDataIndex{iu}))) > 0
        fprintf('FAIL: leakage into subch%d\n', iu);
        nfail = nfail + 1;
        leak_ok = false;
    end
end
if leak_ok
    fprintf('PASS: no inter-subchannel leakage (synth test)\n');
end

%% Verdict
fprintf('\n----------------------------------------\n');
if nfail == 0
    fprintf('RESULT: PASS (verify_02_dfts_roundtrip)\n');
else
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_02_dfts_roundtrip failed');
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
