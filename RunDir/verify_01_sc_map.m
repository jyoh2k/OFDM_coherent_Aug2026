%VERIFY_01_SC_MAP  Step-1 gate: DFT-s subcarrier map integrity
%
%   Run from project root (or any cwd after AddPath):
%     >> run('RunDir/verify_01_sc_map.m')
%   or:
%     matlab -batch "cd('...'); run('AddPath'); run('RunDir/verify_01_sc_map.m')"

clearvars -except SW_PATH DSP_PATH   % 경로 전역변수만 유지하고 워크스페이스 정리
close all                            % 기존 figure 닫기

this_dir = fileparts(mfilename('fullpath')); % 이 파일이 있는 RunDir 경로
proj_root = fileparts(this_dir);             % 프로젝트 루트 (= RunDir의 상위)
cd(proj_root);                               % 루트로 이동 (AddPath 기준)
run('AddPath.m');                            % MATLAB path / SW_PATH 설정

fprintf('\n=== verify_01_sc_map: DFT-s subcarrier map ===\n'); % 시작 로그

map = get_DFTs_SC_map(128, 1);  % default / step-5: no freq OS
nfail = 0;                   % 실패 카운터 초기화

%% Expected figure (0-based) reference
exp_pilot_0 = [1, 32, 63, 65, 96, 127]; % 그림 기준 Pilot (0-based)
exp_dc_0 = 0;                           % 그림 기준 DC
exp_null_0 = 64;                        % 그림 기준 Null(Nyquist)
exp_subch_0 = {                         % 그림 기준 서브채널별 Data 인덱스
    66:95                               % Subch1: pilot 65~96 사이
    97:126                              % Subch2: pilot 96~127 사이
    2:31                                % Subch3: pilot 1~32 사이
    33:62                               % Subch4: pilot 32~63 사이
    };

% --- 0-based / MATLAB(+1) 인덱스 일치 검사 ---
nfail = nfail + check_eq('PilotIndex_0', map.PilotIndex_0, exp_pilot_0);       % Pilot 0-based
nfail = nfail + check_eq('DCIndex_0', map.DCIndex_0, exp_dc_0);                 % DC 0-based
nfail = nfail + check_eq('NullIndex_0', map.NullIndex_0, exp_null_0);           % Null 0-based
nfail = nfail + check_eq('PilotIndex (MATLAB)', map.PilotIndex, exp_pilot_0 + 1); % Pilot MATLAB
nfail = nfail + check_eq('DCIndex (MATLAB)', map.DCIndex, exp_dc_0 + 1);         % DC MATLAB
nfail = nfail + check_eq('NullIndex (MATLAB)', map.NullIndex, exp_null_0 + 1);   % Null MATLAB

for iu = 1:4  % 서브채널 4개 순회
    nfail = nfail + check_eq(sprintf('Subch%d_0', iu), ...           % 서브채널 0-based 일치
        map.SubchDataIndex_0{iu}, exp_subch_0{iu});
    nfail = nfail + check_eq(sprintf('Subch%d MATLAB', iu), ...      % 서브채널 MATLAB(+1) 일치
        map.SubchDataIndex{iu}, exp_subch_0{iu} + 1);
    nfail = nfail + check_eq(sprintf('Subch%d length', iu), ...      % 채널당 Data SC = 30
        numel(map.SubchDataIndex{iu}), 30);
end

% --- 개수 / CP / IFFT 파라미터 검사 ---
nfail = nfail + check_eq('Nsd', map.Nsd, 120);                 % 총 Data SC = 4*30
nfail = nfail + check_eq('Npilot', map.Npilot, 6);             % Pilot 개수
nfail = nfail + check_eq('Nd', map.Nd, 30);                    % 서브채널 DFT 크기
nfail = nfail + check_eq('Nsubch', map.Nsubch, 4);             % 서브채널 수
nfail = nfail + check_eq('CP', map.CP, 16);                    % CP @128
nfail = nfail + check_eq('Lbb (default)', map.Lbb, 1);         % Step5 default: no freq OS
nfail = nfail + check_eq('CP_os (Lbb=1)', map.CP_os, 16);      % CP @128
nfail = nfail + check_eq('NIFFT (Lbb=1)', map.NIFFT, 128);     % no-OS IFFT
nfail = nfail + check_eq('NSamplepersymbol (Lbb=1)', map.NSamplepersymbol, 144);
nfail = nfail + check_eq('NSamplepersymbol_128', map.NSamplepersymbol_128, 144); % 128+16
nfail = nfail + check_eq('NSamplepersymbol_256', map.NSamplepersymbol_256, 288); % 256+32 ref

map2 = get_DFTs_SC_map(128, 2);  % freq-OS reference (step 3B)
nfail = nfail + check_eq('Lbb=2', map2.Lbb, 2);
nfail = nfail + check_eq('CP_os (Lbb=2)', map2.CP_os, 32);
nfail = nfail + check_eq('NIFFT (Lbb=2)', map2.NIFFT, 256);
nfail = nfail + check_eq('NSamplepersymbol (Lbb=2)', map2.NSamplepersymbol, 288);

%% Set integrity
data = map.DataSubcarrierIndex;   % Data SC 인덱스 (MATLAB)
pilot = map.PilotIndex;           % Pilot SC 인덱스 (MATLAB)
if ~isempty(intersect(data, pilot))  % Data/Pilot 교집합이 있으면 실패
    fprintf('FAIL: data/pilot overlap: %s\n', mat2str(intersect(data, pilot)));
    nfail = nfail + 1;
else
    fprintf('PASS: no data/pilot overlap\n');
end

unused_expect = sort([map.DCIndex, map.NullIndex]); % Unused는 DC+Null이어야 함
if ~isequal(sort(map.UnusedIndex), unused_expect)   % Unused 집합 비교
    fprintf('FAIL: UnusedIndex=%s expected=%s\n', ...
        mat2str(map.UnusedIndex), mat2str(unused_expect));
    nfail = nfail + 1;
else
    fprintf('PASS: UnusedIndex == DC+Null\n');
end

union_all = sort([data, pilot, map.UnusedIndex]); % Data+Pilot+Unused 합집합
if ~isequal(union_all, 1:map.NFFT)                % 1:NFFT 전체 커버 여부
    fprintf('FAIL: union of data/pilot/unused is not 1:NFFT\n');
    nfail = nfail + 1;
else
    fprintf('PASS: full coverage of 1:NFFT\n');
end

if numel(unique(data)) ~= numel(data)  % Data 인덱스 중복 검사
    fprintf('FAIL: duplicate data indices\n');
    nfail = nfail + 1;
else
    fprintf('PASS: unique data indices\n');
end

%% Init path smoke check (params.dfts.map)
[sims, params] = Init(); %#ok<ASGLU>  % Init 경로로 params.dfts 생성 확인
if ~isfield(params, 'dfts') || ~isfield(params.dfts, 'map')  % 필드 존재 여부
    fprintf('FAIL: params.dfts.map missing after Init()\n');
    nfail = nfail + 1;
else
    nfail = nfail + check_eq('Init PilotIndex', params.dfts.map.PilotIndex, map.PilotIndex); % Init 맵 일치
    nfail = nfail + check_eq('Init Nsd', params.dfts.map.Nsd, 120);                         % Init Nsd
    nfail = nfail + check_eq('Init params.Nsd', params.Nsd, 120);                            % DFT-s 기본 Nsd
end

%% Optional plot
figure('Name', 'verify_01_sc_map');          % 맵 시각화 figure
stem_mask = zeros(1, map.NFFT);              % SC 타입 표시용 마스크
stem_mask(map.DataSubcarrierIndex) = 1;      % 1 = Data
stem_mask(map.PilotIndex) = 2;               % 2 = Pilot
stem_mask(map.DCIndex) = 3;                  % 3 = DC
stem_mask(map.NullIndex) = 3;                % 3 = Null
stem(0:map.NFFT-1, stem_mask, 'filled');     % 0-based 축으로 stem plot
grid on;
xlabel('Subcarrier index (figure 0-based)');
ylabel('Type (1=data, 2=pilot, 3=DC/Null)');
title('DFT-s SC map');
ylim([0 3.5]);

%% Verdict
fprintf('\n----------------------------------------\n');
if nfail == 0                               % 실패 없으면 PASS
    fprintf('RESULT: PASS (verify_01_sc_map)\n');
else                                        % 하나라도 실패하면 error
    fprintf('RESULT: FAIL (%d check(s) failed)\n', nfail);
    error('verify_01_sc_map failed');
end
fprintf('----------------------------------------\n\n');

function n = check_eq(name, got, expv)      % 값 일치 검사 헬퍼
    if isequal(got, expv)                   % 기대값과 동일하면 PASS
        fprintf('PASS: %s\n', name);
        n = 0;
    else                                    % 다르면 FAIL + got/exp 출력
        fprintf('FAIL: %s\n  got=%s\n  exp=%s\n', name, mat2str(got), mat2str(expv));
        n = 1;
    end
end
