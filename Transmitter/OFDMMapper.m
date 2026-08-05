function [out, mapperout]=  OFDMMapper( in,  params )

%  Usage      : [out, mapperout]=  OFDMMapper( in,  params )
%
%  Coherent OFDM mapper
%    1) 비트열 → QAM 심볼
%    2) SubchDataIndex 위치에 주파수 그리드 배치
%       (Pilot/DC/Null은 0 유지 → 이후 AddPilotSymbol에서 Pilot 삽입)
%
%  out       : NFFT 그리드 직렬화 (Pilot=0)
%  mapperout : QAM 심볼 직렬화 (참조/분석용)

    Nd = params.sc.Nd;             % data SC per subchannel (=30)
    Nsubch = params.sc.Nsubch;     % subchannel count (=4)
    if params.Nsd ~= Nsubch * Nd
        error('OFDMMapper:NsdMismatch', ...
            'Nsd (%d) must equal Nsubch*Nd (%d*%d).', ...
            params.Nsd, Nsubch, Nd);
    end

    % --- QAM ---
    if ( params.en_bit_alloc == 1)
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
    else
        mapperout     = QAMMapper( in,  params.mapper);
        % (stream, dataSC, OFDM symbol) — Nsd axis is subchannel-major
        %   [ch1(1:Nd), ch2, ch3, ch4]
        data_symbol = reshape( mapperout, params.NTXStream, params.Nsd, params.NDataSymbol );
    end

    % --- Frequency-grid placement (no DFT precoding) ---
    one_symbol = zeros( params.NTXStream,  params.NFFT, params.NDataSymbol  );
    subch_idx = params.sc.map.SubchDataIndex;

    for itx = 1:params.NTXStream
        for isym = 1:params.NDataSymbol
            for iu = 1:Nsubch
                loc = (iu-1)*Nd + (1:Nd);
                one_symbol(itx, subch_idx{iu}, isym) = data_symbol(itx, loc, isym);
            end
        end
    end

    out=reshape(one_symbol, 1, params.NTXStream * params.NFFT * params.NDataSymbol );

end
