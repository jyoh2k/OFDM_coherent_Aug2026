function [out, mapperout]=  OFDMMapper( in,  params )

%  Usage      : [out, mapperout]=  OFDMMapper( in,  params )
%
%  DFT-s-OFDM mapper (기존 OFDMMapper 골격 수정)
%    1) 비트열 → QAM 심볼
%    2) 서브채널별 Nd-point DFT precoding
%    3) SubchDataIndex 위치에 주파수 그리드 배치
%       (Pilot/DC/Null은 0 유지 → 이후 AddPilotSymbol에서 Pilot 삽입)
%
%  out       : NFFT 그리드 직렬화 (DFT-s 적용 후, Pilot=0)
%  mapperout : DFT-s 이전 QAM 심볼 직렬화 (참조/분석용)

    Nd = params.dfts.Nd;           % 서브채널 DFT 크기 (=30)
    Nsubch = params.dfts.Nsubch;   % 서브채널 수 (=4)
    if params.Nsd ~= Nsubch * Nd   % Nsd=120 = 4*30 인지 확인
        error('OFDMMapper:NsdMismatch', ...
            'Nsd (%d) must equal Nsubch*Nd (%d*%d).', ...
            params.Nsd, Nsubch, Nd);
    end

    % --- QAM (기존 분기 유지) ---
    if ( params.en_bit_alloc == 1)  % SC별 bit 수 다를 때
        mapperout = zeros(  params.NTXStream, params.Nsd, params.NDataSymbol );
        in1 = reshape(in, 1, params.Nbpsym, params.NDataSymbol);
        for itx=1:params.NTXStream
            for isd=1:params.Nsd
                mapper_t.Nbitspersymbol = params.Nbpsc_sc(itx,isd);
                mapperout(itx, isd,:) = QAMMapper( in1(1, params.mapper.sc_index_min(itx,isd):params.mapper.sc_index_max(itx,isd), :),  mapper_t);
            end
        end
        data_symbol = reshape( mapperout, params.NTXStream, params.Nsd, params.NDataSymbol );
        mapperout = reshape(mapperout,  1, params.NTXStream * params.Nsd * params.NDataSymbol );
    else                            % 균일 Nbpsc (현재 운용: 16-QAM)
        mapperout     = QAMMapper( in,  params.mapper);  % 비트 → QAM
        % (stream, dataSC, OFDM심볼) — Nsd축은 서브채널 연속 배치
        %   [ch1(1:Nd), ch2, ch3, ch4]
        data_symbol = reshape( mapperout, params.NTXStream, params.Nsd, params.NDataSymbol );
    end

    % --- DFT-s precoding + 주파수 그리드 배치 (신규) ---
    % 기존: one_symbol(:, DataSubcarrierIndex, :) = data_symbol  (QAM 직접 기입)
    % 변경: 서브채널마다 fft(x)/sqrt(Nd) 후 SubchDataIndex{iu}에 기입
    one_symbol = zeros( params.NTXStream,  params.NFFT, params.NDataSymbol  ); % Pilot/DC/Null=0
    subch_idx = params.dfts.map.SubchDataIndex;  % 서브채널별 MATLAB 인덱스 cell

    for itx = 1:params.NTXStream                 % 편광(stream)
        for isym = 1:params.NDataSymbol          % OFDM 심볼
            for iu = 1:Nsubch                    % 서브채널 1..4
                loc = (iu-1)*Nd + (1:Nd);        % data_symbol 내 로컬 30개
                x = data_symbol(itx, loc, isym); % DFT 입력 (시간 영역 QAM)
                X = fft(x, Nd) / sqrt(Nd);       % DFT-s precoding (정규화)
                one_symbol(itx, subch_idx{iu}, isym) = X; % 해당 부반송파에 배치
            end
        end
    end

    % MultiStreamOut이 기대하는 1행 직렬 형태로 변환
    out=reshape(one_symbol, 1, params.NTXStream * params.NFFT * params.NDataSymbol );

end
