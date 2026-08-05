function map = get_OFDM_SC_map(NFFT, Lbb)
%GET_OFDM_SC_MAP  Coherent OFDM subcarrier map (figure 0-based -> MATLAB 1-based)
%
%   Figure indices are 0 .. NFFT-1.
%   MATLAB / params indices are figure_index + 1.
%
%   Lbb : frequency-domain OS factor (1 = no OS / 128 IFFT, 2 = 256 IFFT)
%
%   Pilot (figure): 1, 32, 63, 65, 96, 127
%   DC (figure): 0
%   Null / Nyquist (figure): 64
%   Data: 4 subchannels x 30 bins between pilots

    if nargin < 1 || isempty(NFFT)
        NFFT = 128;
    end
    if nargin < 2 || isempty(Lbb)
        Lbb = 1;
    end
    if NFFT ~= 128
        error('get_OFDM_SC_map:UnsupportedNFFT', ...
            'Current OFDM map is defined for NFFT=128 only (got %d).', NFFT);
    end
    if ~ismember(Lbb, [1, 2])
        error('get_OFDM_SC_map:UnsupportedLbb', ...
            'Lbb must be 1 or 2 (got %d).', Lbb);
    end

    % --- Figure (0-based) ---
    pilot_0 = [1, 32, 63, 65, 96, 127];
    dc_0 = 0;
    null_0 = 64;

    % Subchannel order matches the design figure (neg then pos side labels)
    %   Subch1: between pilots 65 and 96
    %   Subch2: between pilots 96 and 127
    %   Subch3: between pilots 1 and 32
    %   Subch4: between pilots 32 and 63
    subch_data_0 = {
        66:95
        97:126
        2:31
        33:62
        };

    Nsubch = numel(subch_data_0);
    Nd = numel(subch_data_0{1});

    % --- MATLAB (1-based) ---
    pilot = pilot_0 + 1;
    dc = dc_0 + 1;
    null_sc = null_0 + 1;
    subch_data = cell(Nsubch, 1);
    for iu = 1:Nsubch
        subch_data{iu} = subch_data_0{iu} + 1;
    end
    data = sort([subch_data{:}]);

    occupied = sort([data, pilot]);
    all_sc = 1:NFFT;
    unused = setdiff(all_sc, occupied);  % DC + Null

    map.NFFT = NFFT;
    map.Nsubch = Nsubch;
    map.Nd = Nd;                 % data SC per subchannel
    map.Nsd = numel(data);       % total data SC
    map.Npilot = numel(pilot);
    map.Nnull = 1;
    map.Ndc = 1;

    map.PilotIndex_0 = pilot_0;
    map.DCIndex_0 = dc_0;
    map.NullIndex_0 = null_0;
    map.SubchDataIndex_0 = subch_data_0;

    map.PilotIndex = pilot;
    map.DCIndex = dc;
    map.NullIndex = null_sc;
    map.SubchDataIndex = subch_data;
    map.DataSubcarrierIndex = data;
    map.SubcarrierIndex = occupied;   % data + pilot
    map.UnusedIndex = unused;

    % CP policy: CP=16 @128; with Lbb=2 -> CP_os=32 @256
    map.CP = 16;
    map.Lbb = Lbb;
    map.NIFFT = NFFT * map.Lbb;
    map.CP_os = map.CP * map.Lbb;
    map.NSamplepersymbol = map.NIFFT + map.CP_os;       % 144 or 288
    map.NSamplepersymbol_128 = NFFT + map.CP;           % 144
    map.NSamplepersymbol_256 = NFFT * 2 + map.CP * 2;  % 288
end
