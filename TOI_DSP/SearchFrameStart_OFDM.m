function [ out, fscs ] = SearchFrameStart_OFDM( in, params )

% if ( params.cfr.CFEtype  == 1 )
%     out = in ;
%     fscs.start_of_frame = 1;
%     return;
% end;
    fscs.start_of_frame = params.start_of_frame;
    fscs.MaxPos         = params.MaxPos;
    fscs.metric         = zeros(1, 1000);
    fscs.phaseoffset    = 0 ;
    out = in (:, 1+size(fscs.start_of_frame,2):end);

    %params.en = 0;  % test
    if ( params.en  == 0 )
        return;
    end


if ( size(params.frame_header,1) ~= 0  )
    cor_pattern         = ones(size(in,1),1)*params.frame_header  ;
    search_range        = floor(params.frame_length * 1.3);
    k2                  = 1: size(cor_pattern,2);
    in1                 = in(:, 1:params.RXoversample:end);

    [P2, R2, Msym]      = CrossCorr( in1(:,1:search_range), cor_pattern, 1, k2  );
    Msym =  (abs( P2 ) .^2) ;
    [MaxVal, MaxPos]    = max(Msym);
    start_of_frame      = (MaxPos - 1+ length(cor_pattern)) * params.RXoversample  + 1 - 5 ; % Margin
    out                 = in(:, start_of_frame:end);

    fscs.start_of_frame = start_of_frame;
    fscs.MaxPos         = MaxPos ;
    fscs.metric         = Msym;
    return;
end 
if ( params.CFEtype  == 1 )
        cor_pattern =  reshape([(params.sync_pattern(1:100));  zeros(1,100 );], 1, []);
        cor_pattern  = TxUpsample( params.sync_pattern(:, 1:70), params.RXoversample, 0 );
        search_range = floor(params.ptn_rep_length * params.RXoversample   )  +15;   
        endidx = min(size(in,2),search_range);
        search_range1 = params.search_offset;
        fscs.phaseoffset =0 ;
%         search_range1 = 400;     
        search_idx = 1;
        k2 = 1: length(cor_pattern);
        [P2, R2, Msym] = CrossCorr2D( in(:,search_range1:1:endidx), cor_pattern, search_idx, k2  );         
        [MaxVal, MaxPos] = max(Msym);
        start_of_frame = ( MaxPos - 1 + params.offset ) * 1  + search_range1;
        out = in (:, start_of_frame:end);
        fscs.start_of_frame = start_of_frame+1;
        fscs.MaxPos = MaxPos  ;
        fscs.metric   = Msym;
    return;
end

if ( params.CFEtype  == 5 )
    CorLen     = size(params.sync_pattern,2)  ;
    Interval   = CorLen;
    search_idx = 1; search_end = min(round(params.frame_length*params.RXoversample+100), size(in,2));
    [P1, R1, Msym, R2] = AutoCorr( in(:,1:params.RXoversample:search_end) ,search_idx, CorLen, Interval  );
%     [MaxVal, MaxPos] = max(Msym);
    [MaxVal, MaxPos] = max(abs(P1).^2);
    if (  params.th  > 0 )
        idx0 =find(Msym > params.th);
        search_end = idx0(1) + params.range  + 2*CorLen + Interval;
        [P1, R1, Msym1, R2] = AutoCorr( in(:,1:params.RXoversample:search_end) ,search_idx, CorLen, Interval  );
        [MaxVal, MaxPos] = max(Msym1);
    end 
    
    start_of_frame = ( MaxPos - 1 ) * params.RXoversample + 1;
    out = in ( :,start_of_frame:end);
    fscs.start_of_frame = MaxPos;
    fscs.MaxPos         = MaxPos ;
    fscs.metric = Msym;
    return;
end
    
end