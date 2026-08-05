function [ out  ]=  MatchedFilter_OFDM( in, params )

%  Usage      : [ out  ]=  MatchedFilter_OFDM( in, params )
%
%  Pulse shaping AFTER IFFT (p=q=1). No time-domain TxUpsample.
%  Sample density comes from IFFT size (Lbb=1 -> 128, Lbb=2 -> 256).
%
%  Author     : Rha, Hae Young. (freq-OS update)

    if ( params.en == 0 )
        out = in;
        return ;
    end

    if ( params.en == 1 )     % SRRC
        params.time_resp = rcosdesign( params.alpha, params.span, params.sps,'sqrt');
    end
    if ( params.en == 2 )     % RC
        params.time_resp = rcosdesign( params.alpha, params.span, params.sps,'normal');
    end
    if ( params.en == 3 )     % Hanning-sinc (time_resp from reinit)
        % params.time_resp already set
    end

    out = zeros(size(in));
    delay = (length(params.time_resp) - 1) / 2;
    for idim=1:size(in,1)
        % p=q=1: filter only, no time oversampling
        out_filter  = upfirdn(in(idim,:), params.time_resp, params.p, params.q );
        out(idim,:) = out_filter( delay + (1:length(in)) );
    end
end
