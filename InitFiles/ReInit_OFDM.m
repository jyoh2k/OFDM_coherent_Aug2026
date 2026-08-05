function [sims, params]=  ReInit_OFDM( sims, params  )
    
    global SW_PATH
    run( [ 'Units.m']);
    
    %% simulation 
    sims.Ylabel = sims.plot_str{sims.plot_mode};

    % DFT-s map first so Nsd / bit accounting match the SC layout
    % Preserve params.dfts.Lbb if set before ReInit (1=no freq OS, 2=256 IFFT)
    if ~isfield(params, 'dfts') || ~isfield(params.dfts, 'Lbb') || isempty(params.dfts.Lbb)
        params.dfts.Lbb = 1;
    end
    params.dfts.map = get_DFTs_SC_map(params.NFFT, params.dfts.Lbb);
    params.dfts.Nsubch = params.dfts.map.Nsubch;
    params.dfts.Nd = params.dfts.map.Nd;
    params.dfts.CP = params.dfts.map.CP;
    params.dfts.Lbb = params.dfts.map.Lbb;
    params.dfts.CP_os = params.dfts.map.CP_os;
    params.dfts.NIFFT = params.dfts.map.NIFFT;
    params.Nsd = params.dfts.map.Nsd;

    params.Nbpsc_sc = params.Nbpsc * ones(params.NTXStream, params.Nsd);
    if ( params.en_bit_alloc == 1)
        params.Nbpsc_sc  = load_bit_alloc(params) ;
    end

    %% pattern
    file_length  = length(importdata( sims.dataf.data_file ));
    params.Nbpsym = sum(sum(params.Nbpsc_sc(:, 1:params.Nsd))); %  # of bit per symbol
    params.ptn_rep_length = lcm( file_length, params.Nbpsym)/params.Nbpsym;

    %%  DSP
    params.mapper            = reinit_mapper( params.mapper,  params );
    params = get_STF( params );
    params = get_LTF( params );

    params.power_sc = 1 * ones(params.NTXStream, params.NFFT);
    if ( params.en_power_loading == 1)
        params.power_sc  = load_power_load(params) ;
    end
        
    params.TXoversample      = params.TXSampleFreq /  params.BaudFreq;
    params.RXoversample      = params.RXSampleFreq /  params.BaudFreq;
    params.ADCSampleFreq     = params.RXSampleFreq; 
    if ( params.ps.en == 1 )
        params.GrayMap = 0;
    end
    
    params                   = get_frame_length(params);
    params                   = get_awg_pad(params);

    params.mapper_list         = QAMMapper2List (  params.mapper) ;
    params.pilot   = reinit_pilot(params.pilot, params);
    params.ltf     = reinit_ltf  (params);
    params.ifft    = reinit_ifft  (params);
    params.spmpre  = reinit_spmpre( params.spmpre,  params, sims );
    params.fec = reinit_fec( params.fec, params );
    params.ps = reinit_ps( params.ps, params );
    params.TXMatchedfilter = reinit_txmatched_filter( params.TXMatchedfilter, params);
    
    params.fft    = reinit_fft  (params);
    params.ce     = reinit_ce  (params.ce, params);
    params.tpr    = reinit_tpr  (params.tpr, params);
    params.cpr    = reinit_cpr  (params.cpr, params);
    params.rxskew            = reinit_rxskew( params.rxskew,  params );
    params.demap             = reinit_demapper( params.demap,  params );
     
    params.awglpf.AWGSampleFreq        = params.AWGSampleFreq; 
    params.searchframe = reinit_searchframe( params.searchframe, params );
    params.searchfineframe = reinit_searchfineframe( params.searchfineframe, params );
    params.cfr  = reinit_cfr( params.cfr, params);
    params.fcfr = reinit_fcfr( params.fcfr, params);
    
    %%  Channel
    params.TX_IFSampleFreq   = params.AWGSampleFreq;
    params.RX_IFSampleFreq   = params.OSCFreq;
    sims.channel.TXSampleFreq =  params.BaudFreq * params.TXoversample; % params.AWGSampleFreq;
    sims.channel.RXSampleFreq =  params.BaudFreq * params.RXoversample; %params.OSCFreq;

    params.OFDE.SampleFreq = params.RXSampleFreq;
    params.OFDE = get_OFDE (sims.channel, params.OFDE);

    % if ( params.NTXStream == 1 )
    %      sims.channel.Npol = 1 ;
    % end

    
    sims.channel = get_channel_parameter( sims.channel );

    sims.channel.CarrierFreqOff_norm  = sims.channel.CarrierFreqOff / sims.channel.SampleFreq;
    sims.channel.SNRdB_bw          = snr_bw(sims.channel.SNRdB,...
                                        params.BaudFreq,...
                                        sims.channel.RXSampleFreq);
    
    % Bandwidth 
    sims.channel.TXDAC             = reinit_DAC1(sims.channel.TXDAC, params);
    sims.channel.RFDriver          = reinit_BW (sims.channel.RFDriver);
    sims.channel.MZmod             = reinit_BW (sims.channel.MZmod);
    sims.channel.PD                = reinit_PD( sims.channel.PD );
    sims.channel.RXADC             = reinit_ADC1(sims.channel.RXADC, params);
    sims.channel.RFAmp             = reinit_BW (sims.channel.RFAmp);

    if ( params.modulation_format  == 2 )
           
    end
    
    if ( sims.run_mode ==  1 )
      run_mode_str = 'Sim';
    else
      run_mode_str = 'Test';
    end
    
    if ( sims.channel.fiber_length  ~= 0 )
        sims.channel.MZmod.launch_power = 1e-3 * 1 /4;
        params.OFDE.en = 1;
    else
        params.OFDE.en = 0;
    end
    
    sims.channel.RXMixer.MixingFreq = params.RX_IF_Freq;
    sims.channel.RXSampleFreq = params.RX_IFSampleFreq;
    sims.channel.TXSampleFreq = params.TXSampleFreq;
    if (  params.TX_IF_band == 1)
        params.TX_IFSampleFreq =  params.AWGSampleFreq;
        sims.channel.TXSampleFreq =  params.TX_IFSampleFreq;
    end

    snr    = db2mag(sims.channel.SNRdB);
    snr    = snr * params.RXSampleFreq / sims.channel.RXSampleFreq ;
    sims.channel.SNRdB = mag2db(snr);

    %% Analysis, log 

    sims.BERanalysis.nbin = params.Nsd * 10;
    sims.logfile =[SW_PATH '/Results/Log/', run_mode_str, '_', ...
                   datestr(now,'ddmmm'), '.txt'];

end

%% ------------------------------------------  

function params = get_frame_length(params)
    %if ( params.fec.en == 1 )
        %fec_frame_symbol     =  lcm(params.fec.n * params.QAM_factor, params.Nbitspersymbol);
        %fec_frame_symbol     =  lcm(fec_frame_symbol, params.block_size/params.blkterm.rate);
        %fec_frame_symbol     = fec_frame_symbol/params.Nbitspersymbol;
        %num_fec_frame        = ceil(params.NDataSymbol /params.blkterm.rate/fec_frame_symbol);
        %params.NDataSymbol   = num_fec_frame * fec_frame_symbol * params.blkterm.rate ;
        %params.NSymbol       = params.NDataSymbol  + params.NTrainingSymbol ;
    %end
    %if ( params.fec.en == 0 )
        %fec_frame_symbol     =  lcm( params.QAM_factor, params.Nbitspersymbol);
        %fec_frame_symbol     =  lcm(fec_frame_symbol, params.block_size/params.blkterm.rate);
        %fec_frame_symbol     = fec_frame_symbol/params.Nbitspersymbol;
        %num_fec_frame        = ceil(params.NDataSymbol /params.blkterm.rate/fec_frame_symbol);
        %params.NDataSymbol   = num_fec_frame * fec_frame_symbol * params.blkterm.rate ;
        %params.NSymbol       = params.NDataSymbol  + params.NTrainingSymbol ;
        %params.fec.k= params.fec.n ;
    %end
    %if ( params.ps.en == 1)
        %rate = (params.ps.k * params.ps.num_dm_block_per_fec +params.ps.signbit )/params.fec.k ;
    %else
        %rate = 1;
    %end
    rate = 1;
    params.totalbits        =  params.NDataSymbol * params.Nbpsym;
    params.databits         = params.totalbits;
    % samples/symbol = NIFFT + CP_os (144 if Lbb=1, 288 if Lbb=2)
    params.NSamplepersymbol = params.dfts.NIFFT + params.dfts.CP_os;
    params.NLTFSymbol       = params.NTXStream * params.NLTF ;
    params.NLTFSample       = params.NLTFSymbol * params.NSamplepersymbol ;
    params.NFrameSymbol     = params.NSTFSample + params.NLTFSample + ...
                              params.NDataSymbol * params.NSamplepersymbol ;
    params.NFrameSample     = params.NFrameSymbol * params.RXoversample;
    params.NDataSample      = params.NDataSymbol * params.NSamplepersymbol ;
    params.NSymbol          = params.NDataSymbol + params.NLTFSymbol ;
end

function params = get_awg_pad(params)
    if ( isa(params.AWGSampleFreq, 'integer') == 0 || isa(params.AWGSampleFreq, 'integer') == 0)
        params.awg_pad = 0;
        return;
    end 
    gcd1 = gcd(params.AWGSampleFreq, params.TXSampleFreq);
    txunit = params.TXSampleFreq/gcd1;
    awgunit=params.AWGSampleFreq/gcd1 * 128;
    pad1 = ceil(params.NFrameSample/txunit) * txunit - params.NFrameSample;
    NFrameSample_TX = params.NFrameSample + (params.Npreamble +96)  * 2 + pad1;
    NFrameSample_AWG = NFrameSample_TX * params.AWGSampleFreq/params.TXSampleFreq;
    NFrameSample_AWG = ceil(NFrameSample_AWG/awgunit) * awgunit ;
    pad2 = NFrameSample_AWG *params.TXSampleFreq/params.AWGSampleFreq -NFrameSample_TX ;
    params.awg_pad = pad1 + pad2;
end


function [Matchedfilter]= reinit_txmatched_filter(Matchedfilter, params)
    % Pulse shaping only (p=q=1). Rate/OS comes from IFFT Lbb, not MF.
    Matchedfilter.sps         = 1;
    Matchedfilter.p           = 1;
    Matchedfilter.q           = 1;
    if ( Matchedfilter.en == 3 )
        Matchedfilter.time_resp   = hanning_windowed_sync(params,Matchedfilter);
    end
end

function time_resp = hanning_windowed_sync(params, filter)
    % Refereence : Abdoli, Javad, Ming Jia, and Jianglei Ma. "Filtered OFDM..."
    % Designed on current IFFT grid (NIFFT / CP_os; Lbb=1 or 2)
    T  = params.dfts.NIFFT * filter.sps ;
    CP = params.dfts.CP_os * filter.sps ;
    Tw = T/2;
    time_index   = [-Tw/2:1:Tw/2];
    hanning_window = 0.5 * [ 1 + cos( 2 * pi * time_index / Tw)];
    sinc_filter = sinc( time_index * 16 * filter.alpha/ CP );
    time_resp = hanning_window .* sinc_filter;
end

function [Matchedfilter]= reinit_rxmatched_filter(Matchedfilter, params)
    Matchedfilter.p           = Matchedfilter.sps /params.RXoversample;
    Matchedfilter.q           = Matchedfilter.p ;
    os_factor = 2;
    Matchedfilter.time_resp =  SRRC( os_factor,Matchedfilter.alpha, Matchedfilter.resp_sample);
end



function cfr = reinit_cfr( cfr, params);
    cfr.OV            = params.RXoversample;
    cfr.sync_pattern  = params.STF;
    cfr.Lbb           = params.dfts.Lbb;   % for CRT CFE grid (freq-OS STF)
    cfr.exp_phasediff = params.cfr.CarrierFreqOff  / ( params.RXSampleFreq ) * 2 * pi;
end


function fcfr = reinit_fcfr( fcfr, params);
    fcfr.OV           = params.RXoversample;
    fcfr.CFEtype      = 2;        
    fcfr.sync_pattern = zeros(1, params.NTXStream * params.NSamplepersymbol);
    if ( params.NLTF == 1 )
        fcfr.en       = 0;
    end 
end

 
function pilot  = reinit_pilot( pilot, params )
    pilot.pilot_index = params.PilotIndex;
    pilot.pilot_symbol = params.PilotSym;
    pilot.block_size_in   = params.Nsd ;
    pilot.block_size_out  = params.Nsd + length(pilot.pilot_index);
    pilot.block_size_in   = params.NFFT;
    pilot.block_size_out  = params.NFFT;
    pilot.rate         =  pilot.block_size_out/(pilot.block_size_in);
end 

function ltf  = reinit_ltf(  params )
    LTF = params.LTF ;
    %LTF = sqrt(1/sum(params.LTF .* params.LTF)) * params.LTF;
    if ( params.NTXStream == 2 )
        if (  params.LTF_type == 1 ) 
             LTF = [LTF LTF;  ...
                        LTF  -LTF;];
        end 
    end
    if ( params.NTXStream == 1 )
         LTF = LTF; 
    end
    ltf.SubcarrierIndex1 = params.SubcarrierIndex1;
    ltf.SubcarrierIndex2 = params.SubcarrierIndex2;
    ltf.LTF = repmat(LTF, 1, params.NLTF);
end 

function ifft    = reinit_ifft  (params)
    N = params.NFFT;
    L = params.dfts.Lbb;
    NL = params.dfts.NIFFT;
    NCP = params.dfts.CP_os;
    ifft.NSamplepersymbol = params.NSamplepersymbol;
    ifft.NFFT    = N;
    ifft.Lbb     = L;
    ifft.NIFFT   = NL;
    ifft.NCP     = NCP;
    ifft.CPindex = [(NL - NCP + 1):NL  1:NL];
    ifft.power_sc  = params.power_sc;
    ifft.SubcarrierIndex = params.SubcarrierIndex;
end

function fft    = reinit_fft  (params)
    N = params.NFFT;
    L = params.dfts.Lbb;
    NL = params.dfts.NIFFT;
    NCP = params.dfts.CP_os;
    fft.NSamplepersymbol = params.NSamplepersymbol;
    fft.NSymbol  = params.NSymbol;
    fft.NFFT    = N;
    fft.Lbb     = L;
    fft.NIFFT   = NL;
    fft.NCP     = NCP;
    syncpoint = 1;
    % Drop CP then take NIFFT body samples
    fft.index = [(NCP - syncpoint) + (1:NL)];
    fft.syncpoint = syncpoint;
end

function ce     = reinit_ce  (ce, params)
    ce.SubcarrierIndex = params.SubcarrierIndex ;
    ce.SubcarrierIndex1 = params.SubcarrierIndex1;
    ce.SubcarrierIndex2 = params.SubcarrierIndex2;
    ce.NFFT  = params.NFFT ;
    ce.LTF   = params.LTF ;
    ce.syncpoint   = params.fft.syncpoint ;
    ce.NTXStream   = params.NTXStream ;
    ce.NLTF        = params.NLTF ;
    ce.NLTFSample   = params.NTXStream * params.NFFT;
    ce.NTXStream    = params.NTXStream ;
    ce.PRL       = params.NFFT;
end 

function tpr    = reinit_tpr (tpr, params)
   tpr.PRL = params.NFFT;
   tpr.NFFT = params.NFFT;
end 

function cpr    = reinit_cpr (cpr, params)
   cpr.PRL = params.NFFT;
   cpr.BLK = params.NFFT;
end 

function sync = reinit_searchframe( sync, params )
    sync.sync_pattern   = params.STF;
    sync.offset         = 7;
    sync.NFrameSymbol   = params.NFrameSymbol;
    sync.CFEtype        = params.cfr.CFEtype;
    sync.ptn_rep_length = params.ptn_rep_length;
    sync.RXoversample   = params.RXoversample;
 %  sync.frame_header   = params.STF;
    sync.frame_length   = params.NFrameSample;
    sync.range          = size(sync.sync_pattern,2) /2;
end

function finesync = reinit_searchfineframe( finesync, params )
    finesync.sync_pattern   = params.sync_pattern;
    finesync.NFrameSample   = params.NFrameSample;
    finesync.NFrameSymbol   = params.NFrameSymbol;
    if ( params.modulation_format == 3 || params.modulation_format == 2 )
    %finesync.offset         = params.dfe.Npostcursor + params.tpr.L -1;
    finesync.offset         =  1;
    else
    %finesync.offset         = params.dfe.Npostcursor + params.tpr.L ;
    finesync.offset         =  0;
    end
    finesync.offset         =  finesync.offset  + size(params.sync_pattern,2);
    % Match correlator length to (possibly Lbb-stretched) STF
    finesync.cor_length     = size(params.sync_pattern, 2);
    finesync.CFEtype        = params.cfr.CFEtype;
    finesync.ptn_rep_length = params.ptn_rep_length;
    finesync.RXoversample   = params.RXoversample;
end

function ps = reinit_ps( ps, params )
    pas_bit    = params.Nbpsc /params.QAM_factor - 1;
    ps.QAM_factor            = params.QAM_factor ;
    
    level      = 2^(pas_bit );
    code_size  = params.fec.n/(pas_bit + 1)  ; %symbol
    num_dm_block_per_fec = 1;
    if ( params.QAM_factor == 2 )
        B_level = sqrt(length(params.mapper_list));
        mapper_list =real(params.mapper_list(1:B_level:end));
    else
        mapper_list =real(params.mapper_list(1:end));
    end
    ps.mapper_list = reshape( mapper_list, 1, length(mapper_list));
    ps.Nbpsc = params.Nbpsc;
    
    if ( ps.en == 0 )
        ps.k = params.fec.k ;
        ps.n = params.fec.k ;
        ps.signbit = 0 ;
        ps.entropy       = params.Nbpsc /params.QAM_factor;
        type_seq = ones(1, 2^(params.Nbpsc/params.QAM_factor));
        ps.type_seq = type_seq + 1j * type_seq;
        ps.level   = level;
        ps.num_dm_block_per_fec=1;
        return;
    end 
    while ( code_size > 10000 )
        code_size = code_size / 2;
        num_dm_block_per_fec = num_dm_block_per_fec* 2;
    end
    rate       = ps.entropy - 1;
    ps.ccdm      = ccdm( level, code_size, rate, 30);
    ps.n            = ps.ccdm.n;
    ps.k            = ps.ccdm.k;
    ps.signbit = params.fec.k  - ps.n * num_dm_block_per_fec * pas_bit;  
    ps.level   = level;
    ps.num_dm_block_per_fec  = num_dm_block_per_fec ;
    type_seq = ps.ccdm.type_seq;
    type_seq = [type_seq(end:-1:1); type_seq;]'; 
    if ( params.QAM_factor == 1)
        ps.type_seq = type_seq;
    else
        ps.type_seq = type_seq + 1j * type_seq;   
    end
end 

function mapper = reinit_mapper( mapper, params  )
    if ( params.en_bit_alloc == 1)
        mapper.sc_index_min  = zeros(params.NTXStream, params.Nsd);
        mapper.sc_index_max  = zeros(params.NTXStream, params.Nsd);
        idx1=1;
        for isd=1:params.Nsd 
            for itx=1:params.NTXStream
                idx2 = idx1 + params.Nbpsc_sc(itx, isd);
                mapper.sc_index_min(itx,isd) = idx1;
                mapper.sc_index_max(itx,isd) = idx2-1;
                idx1 = idx2 ;
            end
        end
    else
        mapper.Nbitspersymbol = params.Nbpsc;
    end
end 


function [skew]=  reinit_rxskew( skew, params  )
    if ( skew.en == 2 )
        ps  = 1e-12;
        skew_ps(1) = 0+1j*ps;
        skew.sft(1,1) = skew_ps(1)  *  params.RXSampleFreq;
    end
end


function demap = reinit_demapper( demap, params  )
    % demap.type : 1: Hard decision, 2: , 3: Bit-metric decoding 
    if ( params.QAM_factor == 2 )
        demap.B_level = sqrt(length(params.mapper_list));
        mapper_list = real(params.mapper_list(1:demap.B_level:end));
    else
        demap.B_level = (length(params.mapper_list));
        mapper_list = params.mapper_list;
    end
    demap.mapper_list = reshape( mapper_list, 1, length(mapper_list));
    demap.type_seq = params.ps.type_seq;
    demap.Nbitspersymbol = params.Nbpsc;
    demap.QAM_factor = params.QAM_factor;
    demap.GrayMap    = params.GrayMap;
    demap.big_end_map= params.big_end_map;
end

function fec = reinit_fec( fec1, params )

    fec1.NTXStream = params.NTXStream * params.QAM_factor; 
    fec1.NRXStream = params.NRXStream * params.QAM_factor; 
    if ( fec1.en  == 0 )
       fec = fec1;
       fec.code_rate = 1;
       fec.FEC_mode  = 1;
       return;
    end
    if ( fec1.FEC_mode  == 0 )
        maxNumLDPCIterations = fec1.max_iter;
        subsystemType = fec1.subsystemType;
        EsNodB        = 30; % Meaningless
        fec = getParamsDVBS2Demo(subsystemType, EsNodB, maxNumLDPCIterations);
        fec.code_rate = fec.LDPCCodewordLength / fec.BCHMessageLength;
        fec.k = fec.BCHMessageLength;
        fec.n = fec.LDPCCodewordLength;
        fec.subsystemType = fec1.subsystemType;
        fec.max_iter = fec1.max_iter;
    end
    if ( fec1.FEC_mode  == 1 ) % RS 
        fec.N=255;
        fec.K=237;
        fec.S=161;
        fec.M=8;
        S = fec.K - fec.S;
        fec.k=fec.M * (fec.K -S);
        fec.n=fec.M * (fec.N -S);
        fec.code_rate = fec.n/fec.k;
    end
    %– RS(544, 514, 15) over GF(210) – 100GBASE-KP4
    %– RS(528, 514, 7) over GF(210) – 100GBASE-KR4
    if ( fec1.FEC_mode  == 4 ) % RS , KP4
        fec.N=544;
        fec.K=514;
        fec.M=10;
        S = fec.K - fec.S;
        fec.k=fec.M * (fec.K -S);
        fec.n=fec.M * (fec.N -S);
        fec.code_rate = fec.n/fec.k;
    end
    if ( fec1.FEC_mode  == 5 ) % RS , KR4
        fec.N=528;
        fec.K=514;
        fec.M=10;
        S = fec.K - fec.S;
        fec.k=fec.M * (fec.K -S);
        fec.n=fec.M * (fec.N -S);
        fec.code_rate = fec.n/fec.k;
    end
    fec.en = 1;
    fec.FEC_mode = fec1.FEC_mode;    
    fec.NTXStream = params.NTXStream * params.QAM_factor; 
    fec.NRXStream = params.NRXStream * params.QAM_factor; 
end

function DAC = reinit_DAC( DAC, params)
%   DAC.SampleFreq = params.TXSampleFreq;  
    DAC.FilterCoef = get_bandwidth_coef (1, DAC);
end


function DAC = reinit_DAC1( DAC, params)
    DAC.SampleFreq = params.AWGSampleFreq;
    DAC.FilterCoef = get_bandwidth_coef (0, DAC);
end

function dev = reinit_BW( dev)
    dev.FilterCoef = get_bandwidth_coef (1, dev);
end


function PD  = reinit_PD( PD )
    mV = 1e-3;
    PD.FilterTapNum =5 ;
    PD.max_output_power= 10^(PD.max_output_power_dBm/10)*mV ;
    PD.max_current     = sqrt(PD.max_output_power /PD.resistor); % RF power = R*I^2 ;
    PD.FilterCoef = get_bandwidth_coef (1, PD);
end

function ADC = reinit_ADC( ADC, params)
    ADC.SampleFreq = params.OSCFreq;
    ADC.FilterCoef = get_bandwidth_coef (1, ADC);
end

function ADC = reinit_ADC1( ADC, params)
    ADC.SampleFreq = params.OSCFreq;
    ADC.FilterCoef = get_bandwidth_coef (0, ADC);
end

function FilterCoef = get_bandwidth_coef (baseband, params)
    FilterTapNum  =5;
    mul_factor = 1;
    if ( baseband == 1 )
        mul_factor = 2;
    end
    NBandwidth = params.bandwidth * mul_factor / params.SampleFreq ;
    FilterCoef      = ChBandwidthInit(NBandwidth,FilterTapNum, 0);
end

function params = get_LTF( params )
    Nsd = params.Nsd / 2;
    if ( params.NFFT == 2048 )
        PilotIndex1 = [  128   256   448   640   768    ] ;      
        PilotSym = [  -1 1 1 1 -1 1 -1 -1 -1 1 ];
        
        LTF_2048 = [	 ...
              1,-1, 1,-1,-1, 1,-1,-1,-1, 1,-1,-1, 1, 1, 1, 1, 1, 1,-1, 1, 1, 1, 1, 1,-1,-1, 1,-1, 1,-1, 1, 1 ,...
            1,-1, 1, 1,-1,-1, 1, 1,-1, 1, 1, 1,-1, 1,-1,-1, 1, 1,-1, 1, 1, 1, 1,-1,-1,-1,-1,-1,-1,-1, 1,-1 ,...
            1,-1,-1,-1, 1,-1,-1,-1,-1, 1,-1,-1, 1, 1, 1, 1,-1,-1, 1, 1, 1, 1,-1, 1, 1,-1,-1,-1,-1, 1,-1,-1 ,...
            1, 1, 1, 1,-1, 1, 1, 1, 1,-1, 1,-1,-1, 1, 1,-1,-1, 1,-1, 1,-1,-1,-1, 1,-1, 1, 1, 1,-1,-1, 1, 1 ,...
            -1, 1, 1,-1,-1, 1, 1,-1, 1,-1,-1, 1, 1,-1, 1, 1,-1, 1,-1,-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,-1, 1,-1 ,...
            -1,-1, 1, 1, 1,-1,-1, 1,-1,-1,-1,-1, 1, 1,-1, 1, 1, 1,-1,-1, 1,-1,-1, 1,-1,-1, 1, 1,-1, 1, 1,-1 ,...
            -1,-1, 1, 1, 1, 1,-1, 1, 1, 1, 1, 1, 1, 1, 1,-1, 1,-1, 1,-1, 1, 1,-1, 1, 1, 1, 1, 1,-1,-1,-1,-1 ,...
            1,-1,-1, 1, 1, 1, 1, 1, 1, 1,-1, 1, 1, 1, 1,-1,-1, 1, 1,-1,-1, 1,-1,-1,-1, 1,-1, 1, 1, 1, 1,-1 ,...
            1, 1, 1, 1, 1,-1,-1,-1,-1, 1,-1,-1,-1,-1, 1,-1,-1,-1,-1,-1,-1, 1,-1,-1, 1,-1,-1, 1,-1,-1, 1,-1 ,...
            -1, 1, 1, 1,-1,-1, 1,-1, 1, 1,-1, 1,-1, 1, 1, 1,-1, 1,-1,-1,-1,-1,-1,-1, 1, 1,-1,-1,-1,-1, 1, 1 ,...
            -1,-1, 1, 1,-1, 1,-1,-1, 1,-1,-1, 1,-1, 1,-1,-1, 1,-1,-1,-1,-1, 1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1 ,...
            1,-1,-1,-1,-1, 1, 1, 1, 1, 1,-1,-1, 1, 1, 1, 1, 1,-1,-1, 1,-1, 1,-1,-1,-1,-1, 1, 1, 1, 1,-1,-1 ,...
            -1, 1, 1,-1,-1,-1,-1, 1, 1, 1,-1,-1, 1, 1,-1, 1, 1,-1,-1,-1, 1,-1, 1, 1,-1, 1, 1,-1,-1, 1,-1,-1 ,...
            -1, 1,-1, 1,-1,-1,-1,-1, 1, 1,-1,-1,-1,-1,-1, 1, 1,-1, 1, 1,-1, 1,-1, 1, 1,-1,-1,-1,-1,-1, 1,-1 ,...
            -1,-1,-1,-1,-1,-1, 1,-1,-1,-1, 1, 1, 1, 1,-1, 1,-1,-1,-1,-1, 1, 1,-1,-1,-1,-1,-1,-1, 1,-1,-1,-1 ,...
            1,-1, 1, 1, 1, 1,-1, 1,-1,-1,-1,-1, 1,-1,-1, 1, 1, 1, 1, 1, 1,-1, 1,-1,-1,-1,-1, 1,-1,-1,-1, 1 ,...
            1,-1, 1, 1, 1, 1,-1,-1, 1, 1,-1, 1, 1,-1,-1,-1, 1,-1, 1,-1,-1, 1, 1, 1,-1,-1,-1, 1,-1, 1, 1, 1 ,...
            -1, 1,-1, 1,-1, 1, 1, 1, 1,-1, 1, 1, 1,-1, 1, 1,-1, 1,-1, 1,-1,-1, 1, 1, 1, 1, 1, 1,-1, 1,-1, 1 ,...
            -1, 1, 1, 1,-1, 1, 1, 1,-1,-1,-1,-1, 1, 1, 1,-1, 1,-1, 1,-1,-1,-1, 1, 1, 1,-1, 1,-1,-1, 1,-1, 1 ,...
            -1, 1, 1, 1, 1, 1,-1, 1, 1, 1, 1,-1,-1,-1, 1, 1, 1,-1,-1,-1, 1,-1, 1, 1, 1,-1, 1,-1, 1, 1,-1, 1 ,...
            -1, 1, 1, 1, 1, 1, 1, 1,-1,-1, 1, 1,-1, 1,-1, 1, 1, 1, 1, 1, 1,-1,-1,-1, 1, 1,-1,-1, 1,-1, 1,-1 ,...
            -1,-1, 1,-1,-1, 1,-1,-1,-1, 1,-1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1, 1,-1, 1,-1,-1, 1,-1,-1, 1 ,...
            1,-1, 1,-1,-1, 1,-1, 1,-1, 1,-1,-1,-1, 1, 1,-1, 1, 1,-1,-1, 1,-1, 1, 1, 1, 1, 1, 1,-1, 1, 1, 1 ,...
            -1,-1,-1,-1,-1,-1, 1,-1, 1, 1,-1, 1,-1,-1,-1, 1,-1,-1,-1, 1, 1, 1, 1, 1,-1, 1,-1,-1,-1, 1, 1, 1 ,...
            1, 1,-1, 1,-1,-1,-1, 1,-1,-1,-1,-1, 1, 1,-1, 1, 1,-1, 1,-1, 1,-1,-1,-1, 1,-1,-1, 1, 1, 1, 1,-1 ,...
            -1, 1, 1, 1, 1,-1,-1,-1, 1, 1, 1, 1, 1,-1, 1,-1, 1, 1, 1, 1, 1,-1, 1,-1,-1,-1, 1,-1, 1, 1, 1,-1 ,...
            1, 1, 1, 1, 1,-1,-1, 1, 1, 1,-1, 1, 1, 1,-1, 1, 1, 1, 1,-1, 1,-1,-1, 1,-1, 1,-1, 1, 1,-1,-1,-1 ,...
            -1, 1,-1, 1, 1,-1, 1,-1,-1,-1, 1,-1,-1, 1,-1,-1,-1,-1, 1, 1,-1,-1,-1, 1, 1, 1, 1, 1,-1,-1,-1, 1 ,...
            -1,-1, 1, 1,-1,-1, 1,-1, 1, 1, 1, 1,-1, 1,-1,-1, 1, 1, 1,-1,-1, 1, 1, 1,-1, 1, 1,-1,-1, 1,-1,-1 ,...
            1,-1,-1,-1,-1, 1, 1,-1, 1,-1, 1,-1, 1,-1,-1,-1,-1,-1,-1, 1, 1,-1,-1, 1,-1,-1,-1, 1,-1, 1,-1, 1 ,...
            1,-1,-1,-1,-1,-1, 1, 1,-1, 1,-1,-1,-1, 1, 1, 1, 1,-1, 1,-1, 1,-1,-1, 1, 1,-1,-1,-1, 1, 1,-1, 1 ,...
            -1, 1,-1, 1, 1,-1,-1, 1,-1, 1,-1,-1, 1,-1, 1, 1,-1, 1, 1, 1,-1, 1, 1, 1, 1, 1, 1,-1,-1,-1,-1, 1 ,...
            1, 1,-1, 1, 1,-1, 1, 1, 1,-1,-1,-1, 1, 1, 1,-1, 1,-1,-1, 1,-1,-1, 1,-1, 1,-1,-1,-1, 1, 1, 1,-1 ,...
            -1, 1, 1, 1, 1, 1,-1, 1, 1, 1, 1,-1,-1, 1, 1,-1,-1, 1, 1,-1, 1,-1,-1,-1,-1, 1,-1,-1,-1, 1, 1,-1 ,...
            -1,-1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1, 1,-1, 1, 1, 1,-1,-1,-1, 1,-1, 1,-1,-1,-1,-1,-1,-1,-1, 1 ,...
            -1, 1, 1,-1, 1, 1,-1,-1, 1, 1, 1, 1,-1,-1, 1, 1, 1,-1, 1,-1,-1, 1, 1,-1, 1,-1,-1,-1,-1, 1, 1,-1 ,...
            1, 1,-1,-1, 1, 1,-1,-1,-1,-1,-1, 1, 1, 1, 1,-1,-1, 1, 1, 1, 1, 1,-1, 1, 1,-1, 1, 1, 1,-1,-1,-1 ,...
            1,-1, 1,-1, 1, 1,-1, 1,-1, 1,-1, 1, 1,-1,-1, 1, 1,-1, 1, 1, 1,-1, 1,-1, 1, 1, 1,-1, 1,-1,-1,-1 ,...
            -1, 1,-1,-1,-1,-1,-1,-1,-1, 1,-1, 1, 1,-1,-1,-1,-1, 1, 1, 1, 1,-1,-1,-1,-1,-1, 1, 1,-1,-1,-1, 1 ,...
            1, 1,-1,-1,-1, 1,-1,-1,-1, 1,-1,-1, 1, 1,-1,-1, 1, 1, 1,-1, 1, 1,-1,-1,-1,-1,-1, 1,-1,-1,-1,-1 ,...
            -1,-1, 1,-1,-1, 1, 1, 1,-1,-1, 1,-1, 1,-1, 1, 1,-1, 1,-1,-1,-1, 1,-1,-1,-1,-1, 1, 1, 1,-1, 1, 1 ,...
            1,-1, 1,-1,-1, 1, 1,-1,-1,-1,-1,-1,-1,-1,-1, 1,-1, 1, 1, 1,-1, 1,-1, 1, 1, 1,-1,-1, 1, 1,-1, 1 ,...
            1, 1, 1, 1, 1, 1,-1,-1, 1, 1, 1,-1,-1, 1,-1,-1, 1,-1,-1,-1,-1, 1,-1,-1, 1,-1, 1, 1, 1,-1,-1, 1 ,...
            1,-1,-1, 1, 1,-1, 1,-1, 1,-1, 1, 1,-1,-1, 1,-1,-1, 1,-1, 1, 1,-1,-1, 1, 1, 1,-1, 1,-1,-1, 1,-1 ,...
            -1, 1, 1,-1, 1, 1,-1, 1, 1, 1,-1, 1,-1,-1, 1,-1, 1,-1,-1,-1, 1,-1,-1, 1, 1, 1, 1,-1, 1,-1, 1, 1 ,...
            1,-1,-1, 1, 1, 1,-1, 1,-1,-1, 1, 1, 1,-1, 1, 1, 1,-1,-1,-1,-1, 1, 1, 1, 1,-1,-1,-1,-1,-1,-1, 1 ,...
            1, 1,-1,-1,-1, 1, 1,-1, 1,-1,-1, 1, 1, 1, 1,-1, 1, 1,-1,-1, 1, 1,-1, 1,-1,-1, 1, 1,-1, 1,-1, 1 ,...
            -1,-1,-1,-1,-1,-1, 1,-1,-1,-1, 1,-1,-1,-1, 1, 1, 1,-1, 1,-1,-1, 1, 1, 1, 1,-1, 1, 1, 1,-1, 1,-1 ,...
            1,-1,-1, 1, 1, 1, 1,-1, 1,-1,-1, 1,-1, 1, 1,-1, 1, 1, 1, 1, 1,-1, 1, 1, 1,-1,-1,-1,-1,-1,-1,-1 ,...
            -1, 1, 1, 1,-1,-1,-1,-1,-1,-1, 1, 1, 1, 1, 1,-1,-1, 1, 1, 1,-1,-1, 1,-1,-1, 1,-1,-1,-1, 1, 1, 1 ,...
            1,-1, 1,-1,-1,-1,-1, 1, 1,-1,-1, 1, 1,-1, 1, 1,-1, 1,-1, 1,-1,-1, 1, 1,-1, 1,-1, 1, 1, 1, 1, 1 ,...
            1,-1, 1,-1, 1,-1, 1,-1, 1,-1,-1,-1,-1, 1, 1, 1,-1,-1, 1, 1, 1, 1,-1, 1, 1,-1,-1, 1, 1,-1,-1, 1 ,...
            1, 1, 1, 1,-1,-1, 1, 1,-1, 1, 1, 1, 1, 1,-1, 1,-1,-1,-1, 1,-1,-1,-1,-1, 1, 1,-1, 1, 1, 1, 1, 1 ,...
            -1, 1, 1,-1, 1,-1, 1, 1,-1, 1, 1,-1,-1, 1, 1, 1,-1, 1, 1,-1, 1, 1, 1,-1,-1, 1, 1,-1, 1, 1,-1, 1 ,...
            1, 1,-1, 1,-1,-1,-1,-1, 1, 1,-1, 1, 1, 1,-1, 1,-1,-1, 1, 1,-1, 1, 1,-1, 1,-1,-1, 1,-1,-1,-1,-1 ,...
            -1, 1, 1,-1,-1, 1,-1,-1, 1,-1, 1, 1,-1,-1, 1,-1, 1, 1, 1,-1, 1,-1,-1, 1,-1, 1,-1,-1,-1,-1, 1,-1 ,...
            1, 1,-1,-1,-1, 1, 1, 1,-1,-1,-1, 1, 1,-1,-1,-1,-1,-1,-1, 1,-1, 1, 1, 1,-1,-1,-1, 1,-1,-1,-1,-1 ,...
            1, 1, 1,-1, 1, 1, 1, 1,-1,-1,-1,-1, 1,-1,-1, 1,-1,-1,-1,-1,-1,-1, 1,-1,-1, 1, 1,-1,-1, 1, 1, 1 ,...
            1, 1, 1, 1, 1,-1, 1,-1,-1, 1,-1, 1,-1,-1,-1, 1,-1,-1, 1, 1, 1, 1,-1,-1, 1, 1,-1, 1,-1,-1,-1, 1 ,...
            -1,-1, 1, 1,-1,-1,-1, 1, 1,-1,-1, 1,-1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1, 1, 1, 1,-1, 1, 1, 1, 1,-1 ,...
            1, 1,-1,-1, 1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 1, 1, 1,-1, 1, 1,-1, 1, 1, 1, 1, 1, 1,-1,-1, 1,-1, 1 ,...
            -1, 1, 1, 1,-1, 1, 1,-1,-1,-1, 1, 1, 1,-1,-1, 1,-1,-1,-1, 1,-1,-1,-1,-1,-1, 1, 1, 1, 1,-1, 1, 1 ,...
            -1, 1,-1, 1,-1,-1,-1,-1, 1,-1,-1,-1,-1,-1, 1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 1,-1, 1, 1, 1,-1, 1,-1 ,...
            -1,-1, 1, 1, 1, 1, 1, 1, 1,-1, 1, 1, 1, 1,-1, 1, 1, 1,-1, 1, 1, 1, 1,-1, 1,-1, 1, 1, 1, 1, 1, 1 ...
     ];
    
        LTF  =  [ LTF_2048 ];
    end 
    if ( params.NFFT == 1024 )
        %PilotIndex1 = [  64   128   224   320   384 ];   
        PilotSym    = [ -1  1 1 1 -1 -1 -1 1 1  -1 ];
        PilotIndex1 = [    64   128   192   256   320];
        
        LTF_1024 = [	 ...
      1   -1   1   1   1   1  -1   1   1  -1   1  -1   1   1   1   1 ...
       1   1   1   1   1   1   1   1   1   1   1  -1   1   1   1  -1 ...
      -1  -1   1  -1  -1  -1  -1   1  -1   1   1  -1   1   1   1   1 ...
       1   1   1   1   1   1   1   1   1   1  -1   1  -1  -1  -1   1 ...
       1  -1  -1   1  -1  -1  -1   1   1   1  -1   1   1  -1   1  -1 ...
       1  -1  -1   1   1  -1   1  -1   1   1  -1   1  -1  -1   1   1 ...
       1  -1  -1   1  -1  -1  -1   1  -1   1   1  -1  -1  -1   1   1 ...
      -1  -1  -1  -1   1   1   1   1   1   1  -1  -1   1   1   1  -1 ...
      -1   1  -1   1  -1   1  -1  -1  -1  -1   1  -1   1  -1  -1   1 ...
       1   1   1  -1   1  -1  -1   1  -1  -1   1  -1  -1  -1   1  -1 ...
      -1   1  -1   1  -1  -1  -1  -1  -1   1   1  -1  -1   1  -1   1 ...
      -1  -1  -1  -1   1   1  -1  -1  -1  -1  -1  -1  -1  -1  -1  -1 ...
      -1   1  -1   1  -1  -1   1  -1   1  -1   1   1  -1   1  -1  -1 ...
      -1  -1  -1   1  -1  -1   1   1   1   1   1   1   1   1  -1  -1 ...
       1  -1   1   1  -1  -1  -1   1  -1  -1  -1   1  -1   1  -1  -1 ...
       1   1   1   1  -1   1  -1  -1  -1  -1  -1   1  -1   1   1  -1 ...
      -1  -1   1   1  -1   1   1  -1   1  -1   1   1   1   1   1   1 ...
       1  -1  -1   1  -1   1  -1  -1  -1   1   1  -1  -1   1   1  -1 ...
      -1   1   1  -1   1  -1   1   1   1  -1  -1   1   1  -1  -1   1 ...
       1   1  -1  -1   1   1   1   1   1   1   1  -1  -1   1  -1  -1 ...
       1  -1   1  -1   1  -1   1  -1  -1   1   1  -1  -1   1  -1   1 ...
       1   1   1   1   1   1   1   1  -1   1   1   1  -1   1   1   1 ...
       1  -1   1  -1  -1  -1  -1   1   1   1   1  -1   1  -1  -1   1 ...
      -1  -1   1   1  -1   1   1  -1  -1  -1   1  -1   1   1  -1   1 ...
       1   1   1  -1   1   1   1  -1   1   1  -1  -1  -1  -1  -1  -1 ...
      -1  -1  -1  -1  -1  -1  -1   1   1   1   1   1   1   1  -1   1 ...
       1  -1  -1   1  -1   1  -1  -1   1   1  -1  -1   1  -1  -1   1 ...
      -1  -1  -1  -1  -1   1  -1  -1  -1   1   1   1   1   1  -1   1 ...
       1   1  -1  -1  -1  -1  -1  -1  -1  -1   1  -1  -1   1  -1   1 ...
       1   1   1   1  -1   1  -1  -1   1  -1  -1   1   1   1  -1   1 ...
       1   1   1   1  -1   1  -1  -1   1  -1   1  -1  -1   1   1   1 ...
      -1   1   1   1  -1   1   1   1  -1   1  -1  -1   1   1   1  -1 ...
       1  -1   1  -1   1   1   1   1  -1  -1   1  -1   1  -1  -1  -1 ...
       1   1  -1  -1   1   1  -1   1  -1  -1  -1  -1  -1  -1   1  -1 ...
       1  -1   1  -1  -1   1   1  -1  -1  -1  -1   1  -1  -1   1  -1 ...
       1   1  -1   1  -1  -1   1   1   1  -1  -1  -1   1  -1  -1  -1 ...
       1  -1  -1  -1   1   1   1  -1   1  -1  -1  -1   1   1  -1   1 ...
      -1   1   1  -1   1  -1   1  -1  -1  -1  -1   1  -1   1   1  -1 ...
       1   1   1  -1  -1  -1  -1  -1   1   1  -1  -1   1   1   1   1 ...
      -1  -1   1   1   1   1   1  -1  -1   1   1  -1   1  -1  -1   1 ...
       1   1   1  -1  -1   1   1  -1  -1  -1  -1  -1  -1   1   1  -1 ...
       1   1   1   1   1  -1  -1   1  -1  -1   1  -1   1   1   1   1 ...
       1   1  -1  -1  -1  -1  -1  -1  -1   1   1   1   1   1   1  -1 ...
      -1  -1  -1   1   1   1  -1   1   1  -1   1   1   1   1   1   1 ...
       1  -1   1  -1  -1   1  -1   1  -1  -1   1   1   1   1   1  -1 ...
      -1  -1  -1   1  -1   1  -1  -1   1   1  -1  -1   1   1   1   1 ...
       1   1   1   1   1  -1   1  -1  -1  -1  -1  -1  -1   1   1   1 ...
       1  -1  -1   1  -1   1  -1  -1  -1  -1   1  -1   1  -1   1  -1 ...
       1  -1  -1   1  -1   1   1   1   1  -1  -1  -1  -1   1  -1  -1 ...
       1  -1   1  -1   1  -1  -1   1   1  -1   1  -1   1   1   1  -1 ...
       1  -1  -1   1  -1   1   1   1   1   1  -1   1  -1  -1   1   1 ...
      -1   1  -1  -1   1   1  -1   1  -1   1  -1  -1   1  -1   1  -1 ...
       1   1   1  -1  -1  -1  -1  -1   1   1  -1   1   1   1   1   1 ...
       1  -1   1  -1  -1   1   1  -1   1  -1  -1   1  -1  -1  -1   1 ...
       1  -1  -1  -1   1  -1  -1   1  -1  -1   1   1   1  -1   1   1 ...
       1   1   1   1   1   1  -1   1  -1  -1   1   1  -1  -1  -1   1 ...
      -1  -1  -1  -1   1  -1   1   1   1  -1   1   1   1  -1   1   1 ...
      -1   1  -1   1   1  -1   1  -1  -1   1   1   1   1  -1  -1  -1 ...
       1  -1  -1  -1   1  -1   1  -1   1  -1   1   1   1  -1  -1   1 ...
      -1  -1  -1  -1   1  -1   1   1  -1   1  -1   1  -1  -1   1  -1 ...
      -1   1  -1   1  -1  -1  -1   1  -1   1  -1  -1  -1  -1   1  -1 ...
       1  -1   1   1  -1  -1   1   1   1   1   1   1  -1  -1   1  -1 ...
       1   1  -1   1  -1  -1  -1  -1  -1  -1   1   1  -1  -1  -1   1 ...
      -1  -1  -1   1  -1  -1   1   1   1   1   1   1  -1   1  1 -1  ...
     ];
    
        LTF  =  [ LTF_1024];
    end 
    if ( params.NFFT == 512 )
        PilotIndex1 = [  32   64  112   160   192    ];   
        PilotSym = [ -1  1 1 1 -1 -1 -1 1 1  -1 ];
        PilotIndex1 = [   32    64    96   128   160 ];   
        PilotSym = [ -1  1 1 1 -1 -1 -1 1 1  -1 ];
      
        LTF_512 = [	 ...
              0  0  0 -1  1 -1 -1 -1  1 -1 -1  1  1 -1  1 -1 ...
             -1  1 -1  1  1  1  1  1  1  1  1 -1 -1  1  1  1 ...
             -1  1  1  1  1 -1  1 -1 -1 -1 -1  1  1 -1 -1 -1 ...
              1 -1 -1  1 -1 -1  1 -1  1 -1 -1 -1  1  1  1  1 ...
              1 -1 -1  1  1 -1 -1  1 -1  1 -1 -1  1  1  1  1 ...
             -1  1 -1  1  1  1 -1  1  1  1 -1 -1 -1 -1 -1 -1 ...
              1  1  1  1  1  1 -1 -1  1 -1  1  1 -1 -1  1 -1 ...
             -1  1  1 -1 -1 -1 -1 -1  1  1  1 -1  1 -1 -1  1 ...
             -1  1 -1  1 -1  1  1 -1 -1 -1  1  1  1  1  1  1 ...
              1  1  1  1  1 -1  1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
              1 -1 -1  1 -1  1  1  1 -1 -1 -1  1 -1 -1  1 -1 ...
              1  1 -1 -1  1 -1 -1  1  1  1  1 -1 -1 -1 -1 -1 ...
             -1  1 -1 -1 -1  1  1  1  1  1 -1  1  1  1  1  1 ...
              1  1  1  1  1  1 -1  1  1 -1  1 -1  1 -1  1 -1 ...
              1  1 -1 -1  1  1  1 -1  1  1 -1  1 -1 -1  1  1 ...
             -1 -1 -1  1 -1 -1  1 -1  1  1 -1  0  0  0  0  0 ...
              0  0  0  0  0 0 -1 -1 -1 -1 -1 -1  1  1  1  1 ...
              1 -1  1  1 -1 -1  1  1  1 -1  1 -1  1 -1 -1 -1 ...
             -1 -1  1 -1 -1 -1 -1  1  1  1  1  1 -1 -1  1 -1 ...
              1 -1 -1 -1 -1  1  1 -1 -1  1 -1 -1 -1 -1 -1  1 ...
              1 -1 -1 -1  1 -1 -1  1 -1  1  1 -1  1  1 -1 -1 ...
             -1 -1  1 -1 -1  1  1  1 -1 -1  1 -1 -1  1 -1 -1 ...
             -1  1 -1  1  1 -1  1  1 -1  1 -1  1  1  1 -1 -1 ...
             -1  1 -1  1  1 -1 -1  1 -1 -1  1  1 -1 -1  1  1 ...
             -1  1 -1  1  1  1  1  1  1  1 -1  1  1 -1 -1  1 ...
              1  1  1  1  1 -1  1  1 -1 -1 -1 -1  1  1 -1 -1 ...
              1 -1 -1  1  1 -1 -1  1  1  1 -1  1 -1 -1 -1 -1 ...
             -1 -1  1 -1 -1  1  1 -1 -1 -1  1  1  1  1  1  1 ...
             -1 -1 -1  1 -1  1 -1 -1  1  1 -1 -1 -1  1  1 -1 ...
              1 -1  1  1 -1 -1  1  1 -1 -1  1 -1 -1  1  1 -1 ...
             -1 -1 -1  1  1 -1 -1  1  1  1 -1 -1 -1 -1  1  1 ...
             -1  1 -1  1  1  1 -1  1  1  1 -1  1  1 -1  0  0 ...
     ];
        LTF  =  LTF_512;
    end 
    if (params.NFFT == 256 ) 
        PilotIndex1 = [ 12 36 60 84 ];      
        PilotSym = [-1 1 -1 1 1 -1 -1 1];
        
          LTF_256 = [ ...
              0, -1,  1, -1, -1, -1,  1,  1, -1,  1, -1,  1, -1,  1,  1, -1, ...
              1, -1, -1, -1,  1,  1, -1, -1,  1, -1, -1,  1,  1, -1, -1,  1, ...
             -1, -1,  1,  1, -1,  1,  1, -1,  1,  1, -1, -1,  1,  1,  1, -1, ...
              1, -1, -1, -1,  1, -1,  1, -1,  1, -1, -1, -1,  1, -1,  1, -1, ...
             -1,  1, -1, -1, -1,  1, -1, -1,  1, -1,  1, -1,  1, -1,  1,  1, ...
              1,  1, -1, -1, -1, -1, -1,  1, -1,  1, -1, -1,  1,  1, -1,  1, ...
              1,  1,  1,  1,  1,  1, -1, -1,  1, -1, -1,  1, -1, -1,  1,  1, ...
             -1,  1, -1,  1, -1, -1, -1,  1,  1,  1, -1,  1,  1,  1, -1,  1,  ...
              1, -1, -1,  1, -1,  1, -1, -1,  1, -1, -1,  1, -1,  1,  1,  1,  ...
             -1,  1,  1,  1, -1,  1,  1,  1, -1, -1, -1, -1, -1,  1, -1, -1, ...
             -1,  1,  1, -1,  1, -1, -1, -1,  1,  1,  1, -1,  1,  1, -1, -1, ...
              1, -1,  1,  1,  1, -1, -1,  1, -1, -1,  1,  1, -1,  1, -1, -1, ...
             -1,  1,  1,  1, -1, -1,  1, -1, -1, -1,  1, -1, -1,  1,  1,  1, ...
              1,  1, -1, -1,  1, -1,  1, -1, -1,  1,  1,  1,  1, -1, -1,  1, ...
              1,  1, -1, -1, -1, -1, -1, -1,  1,  1,  1, -1, -1,  1,  1, -1, ...
             -1,  1, -1,  1, -1,  1, -1, -1,  1, -1,  1, -1, -1, -1,  1,  -1 ...
           ];
       
        LTF  =  LTF_256;
    end
    
    if ( params.NFFT == 128 )
        % DFT-s-OFDM SC map (figure 0-based + 1 for MATLAB)
        if ~isfield(params, 'dfts') || ~isfield(params.dfts, 'map')
            if ~isfield(params, 'dfts')
                params.dfts = struct();
            end
            if ~isfield(params.dfts, 'Lbb') || isempty(params.dfts.Lbb)
                params.dfts.Lbb = 1;
            end
            params.dfts.map = get_DFTs_SC_map(params.NFFT, params.dfts.Lbb);
        end
        map = params.dfts.map;
        PilotSym = [-1 -1 1 1 1 -1];   % 6 pilots
        LTF_128 = [0, 1, -1, 1, 1,-1, 1,1,-1,-1, 1, 1,-1, 1,-1,1, ...
                    1, 1, 1, 1, 1,-1,-1,1, 1,-1, 1,-1, 1, 1, 1,1, ...
                    1, 1,-1,-1, 1, 1,-1,1,-1, 1,-1,-1,-1,-1,-1,1, ...
                    1,-1,-1, 1,-1, 1,-1,1, 1, 1, 1,-1,-1,-1, -1,1, ...
                   -1, 1, -1, 1, 1,-1, 1,1,-1,-1, 1, 1,-1, 1,-1,1, ...
                    1, 1, 1, 1, 1,-1,-1,1, 1,-1, 1,-1, 1, 1, 1,1, ...
                    1, 1,-1,-1, 1, 1,-1,1,-1, 1,-1,-1,-1,-1,-1,1, ...
                    1,-1,-1, 1,-1, 1,-1,1, 1, 1, 1,-1,-1,-1, 1,-1 ];

        params.PilotIndex = map.PilotIndex;
        params.DataSubcarrierIndex = map.DataSubcarrierIndex;
        params.SubcarrierIndex = map.SubcarrierIndex;
        params.Nsd = map.Nsd;
        params.SubcarrierIndex1 = map.SubcarrierIndex(map.SubcarrierIndex <= params.NFFT/2);
        params.SubcarrierIndex2 = map.SubcarrierIndex(map.SubcarrierIndex > params.NFFT/2);

        % LTF: no DFT-s (training stays on frequency grid as BPSK)
        % Reuse LTF_128 where non-zero; fill remaining active bins with +/-1
        params.LTF = zeros(1, params.NFFT);
        for k = 1:length(params.SubcarrierIndex)
            idx = params.SubcarrierIndex(k);
            if LTF_128(idx) ~= 0
                params.LTF(idx) = LTF_128(idx);
            else
                params.LTF(idx) = 2*mod(k, 2) - 1;
            end
        end

        params.PilotSym = PilotSym;
        if ( params.NTXStream == 2 )
            params.PilotSym = [PilotSym; -PilotSym;];
        end
        params.sync_pattern = params.sync_pattern * ...
            sqrt(length(params.SubcarrierIndex))/params.NFFT;
        return;
    end

    if ( params.NFFT == 64 )
        PilotIndex1 = [ 8 16 ];
        PilotSym = [ -1   1 1   -1 ];
        LTF_64   = [ 0, -1, -1, 1, 1,-1, 1,1,-1,-1, 1, 1,-1, 1,-1,1, ...	 
                    1,-1,-1, 1,-1, 1,-1,1, 1, 1, 1,-1,-1,-1,-1,0, ...	 
                    0, -1, -1, 1, 1,-1, 1,1,-1,-1, 1, 1,-1, 1,-1,1, ...	 
                    1,-1,-1, 1,-1, 1,-1,1, 1, 1, 1,-1,-1,-1,-1,0 ];
    
        LTF =  LTF_64 ;
    end 
    
    
    if ( params.NFFT == 32 )
        PilotIndex1 = [ 4 12 ]; 
        PilotSym = [ -1   1 1   -1 ];
        
        LTF_32 = [  0, -1, -1, 1, 1,-1, 1,1,-1,-1, 1, 1,-1, 1,-1,1, ...	 
                    1, -1,-1, 1,-1, 1,-1,1, 1, 1, 1,-1,-1,-1,-1,0 ];
    
        LTF =  LTF_32 ;
    end 

    SubcarrierIndex1 = [params.sc1 + (1: (length(PilotIndex1) + Nsd))];

        
    SubcarrierIndex2 = [ sort(-SubcarrierIndex1)];
    params.LTF =  zeros(size(LTF));
    SubcarrierIndex =[SubcarrierIndex1+1 params.NFFT+SubcarrierIndex2+1];
    params.LTF([SubcarrierIndex])= LTF(SubcarrierIndex);
    params.SubcarrierIndex1 = SubcarrierIndex1;
    params.SubcarrierIndex2 = SubcarrierIndex2;
    params.SubcarrierIndex1 = SubcarrierIndex1+1;
    params.SubcarrierIndex2 = params.NFFT+SubcarrierIndex2+1;
    params.SubcarrierIndex  = SubcarrierIndex ;
    params.PilotSym = PilotSym;
    if ( params.NTXStream == 2 )
        params.PilotSym = [PilotSym; -PilotSym;];
        %params.PilotSym = [PilotSym; PilotSym;];
    end
    params.PilotIndex = [PilotIndex1 -PilotIndex1 + params.NFFT] +1;
    params.DataSubcarrierIndex = setdiff(params.SubcarrierIndex,params.PilotIndex);
    params.Nsd = length(params.DataSubcarrierIndex) ;    
    params.sync_pattern = params.sync_pattern * sqrt(length(SubcarrierIndex))/params.NFFT;

end

function params = get_STF( params )

    if ( params.cfr.CFEtype == 2 )
        cfo_sync16_ptn = [ ...
           1  0  0  0  1  1  0  1  1  0  1  1  1  0  1 ...
           0  0  1  1  1  1  0  0  0  0  0  1  1  0  0 ...
           1  1  1  1  1  0  1  1  1  1  1  0  0  0  0 ...
           1  1  0  1  0  0  0  1  0  1  1  1  0  1  0 ...
           0  0  1  0];
        sync_pattern =  QAMMapper ( cfo_sync16_ptn,  params, '' );
    end

    if ( params.cfr.CFEtype == 5 )
        sync_pattern1 = get_sync_pattern_crt(params, 1);
        sync_pattern2 = get_sync_pattern_crt(params, 2);
        if ( params.NTXStream == 1 )
            sync_pattern3= [sync_pattern1;]; 
        else
            sync_pattern3= [sync_pattern1; sync_pattern2;]; 
        end  
        sync_pattern = repmat(sync_pattern3, 1, params.cfr.CRTrep);
    end

    % Match freq-domain OS sample grid (Lbb): stretch STF without redesigning CRT
    if isfield(params, 'dfts') && isfield(params.dfts, 'Lbb') && params.dfts.Lbb > 1
        sync_pattern = TxUpsample(sync_pattern, params.dfts.Lbb, 0);
    end

    params.STF = sync_pattern ;
    params.NSTFSample = size(sync_pattern,2) * 2;  % AddTrainingSymbol repeats twice
    params.sync_pattern = sync_pattern;

end

function sync_pattern = get_sync_pattern_crt( params, chidx)

        cfo_sync16_ptn = rand(1, params.Nbpsc * 16) > 0.5;
        cfo_sync9_ptn = rand(1, params.Nbpsc * 9) > 0.5;
        sync16_pattern = ...
            [-0.9487 - 0.3162i  -0.9487 + 0.3162i  ...
              0.3162 - 0.9487i   0.9487 - 0.3162i  ...
             -0.3162 + 0.3162i   0.9487 + 0.3162i ...
             -0.3162 - 0.9487i  -0.9487 - 0.9487i  ...
              0.3162 + 0.9487i  -0.9487 + 0.9487i  ...
             -0.3162 - 0.3162i  -0.3162 + 0.9487i ...
              0.3162 + 0.3162i   0.9487 + 0.9487i ...
              0.3162 - 0.3162i   0.9487 - 0.9487i];
        if( chidx == 2 )
        	sync16_pattern = circshift( sync16_pattern,2,2);
	end
        params.mapper.Nbitspersymbol = params.Nbpsc; 
        %sync16_pattern  =  QAMMapper ( cfo_sync16_ptn,  params, '' );
        sync9_pattern   =  QAMMapper ( cfo_sync9_ptn,  params.mapper, '');    
        if (  params.Nbpsc == 2) 
            if( chidx == 1 )
                cfo_sync16_ptn = [ ...
                   1  0  0 0 1 1 0 0 0 0 0 1 0 0 0  ...
                   0 1 0 0 1 1 0 0 1 1 1 0 1 0 1  ...
                   1 1 ];
               
               cfo_sync9_ptn = [ ... 
                   1 1 0 0 0 1 0 0 1 1 0 1 1 0 1  ...
                   1 0 1];
            end
            if( chidx == 2 )
                cfo_sync16_ptn = [ ...
                    0 0 1 0 1 1 1 1 0 0 0 0 0 0 0  ...
                    0 1 1 0 1 0 1 1 1 0 0 0 1 1 1  ...
                    0 0];
                cfo_sync9_ptn = [ ...
                   1 0 1 1 1 0 1 1 1 1 0 1 1 0 1  ...
                   1 0 0];
            end
            sync16_pattern  =  QAMMapper ( cfo_sync16_ptn,  params.mapper, '' );
            sync9_pattern   =  QAMMapper ( cfo_sync9_ptn,  params.mapper, '' );   
        end
        sync16_pattern  = [sync16_pattern sync16_pattern sync16_pattern ];
        sync16_patterns = [sync16_pattern sync16_pattern sync16_pattern ];
        sync9_patterns  = [sync9_pattern sync9_pattern ...
                           sync9_pattern sync9_pattern ];
        sync9_patterns  = [sync9_patterns sync9_patterns ];
        sync_pattern    = [sync9_patterns sync16_patterns];
        sync_pattern    = sync_pattern(1:9*16);
        sync_pattern = sync_pattern / sqrt(mean(abs(sync_pattern) .^2));
        %if ( params.cfr.CRT2  == 8 )
        %    sync_pattern    = [sync9_patterns(1:36) sync16_patterns];
        %    sync_pattern1   = sync_pattern(1:9*8);
        %else
        %    sync_pattern    = [sync9_patterns(1:72) sync16_patterns];
        %    sync_pattern1   = sync_pattern(1:9*16);
        %end
end

function spmpre  = reinit_spmpre  (spmpre, params, sims)
    [pwr_mul, LP_dB] = GetLaunchPwr( sims );
    span =1;
    Leff =   (1 - exp (- sims.channel.ssmf.Alpha*  sims.channel.edfa.length))/sims.channel.ssmf.Alpha;
    gain =   pwr_mul * sims.channel.ssmf.Gamma* Leff * span;
    spmpre.gain = gain;
end 


function [pwr_mul, LP_dB] = GetLaunchPwr( sims)

%  Usage      : [pwr_mul, LP_dB] = GetLaunchPwr(laser, sims, MZmod, txedfa )
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : miroandi@kaist.ac.kr   
%  Known bugs :

    mW = 1e-3;
    pwr_mul= sqrt(sims.channel.MZmod.launch_power)* sims.channel.TXDAC.gain ;
    pwr_mul = pwr_mul * 128; %sim.dacout ;
    pwr_mul = pwr_mul *  pi/ sims.channel.MZmod.Vpi_RF/sqrt(2)* db2mag(sims.channel.txedfa.gain_dB);
    pwr_mul = (pwr_mul )^2 ;
    LP_dB = 10*log10(pwr_mul) - 9.4857  ;
end

