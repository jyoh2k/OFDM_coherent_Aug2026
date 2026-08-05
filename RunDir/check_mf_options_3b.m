%CHECK_MF_OPTIONS_3B  Ideal known-timing loopback vs TXMatchedfilter.en
%  No AWGN, no sync search (STF skipped). Compare MF en = 0,1,2,3.
%
%  >> run('RunDir/check_mf_options_3b.m')

clearvars -except SW_PATH DSP_PATH
close all

this_dir = fileparts(mfilename('fullpath'));
proj_root = fileparts(this_dir);
cd(proj_root);
run('AddPath.m');

fprintf('\n=== check_mf_options_3b: ideal loopback vs MF.en ===\n');
fprintf('Conditions: no AWGN, known timing (STF skip), no RX matched filter\n\n');

mf_list = [0 1 2 3];
mf_name = {'OFF', 'SRRC', 'RC', 'Hanning-sinc'};

for k = 1:numel(mf_list)
    en = mf_list(k);
    [sims, params] = Init();
    params.NDataSymbol = 20;
    params.Nbpsc = 4;
    params.en_bit_alloc = 0;
    params.en_power_loading = 0;
    params.NTXStream = 2;
    params.NRXStream = 2;
    params.NFFT = 128;
    params.BaudFreq = 42e9;
    params.TXSampleFreq = params.BaudFreq;
    params.RXSampleFreq = params.BaudFreq;
    params.AWGSampleFreq = params.TXSampleFreq;
    params.OSCFreq = params.RXSampleFreq;
    params.TXMatchedfilter.en = en;
    params.TXMatchedfilter.alpha = 1.0;
    params.TXMatchedfilter.span = 16;
    params.cpr.en = 0;
    params.cpr.bcpr_en = 0;
    params.ce.en_ISFA = 0;
    params.TXAGC.en = 0;
    params.tpr.en = 0;
    sims.dataf.data_file = [DSP_PATH 'Ptn/prbs15.txt'];
    [sims, params] = ReInit(sims, params);

    dataf = DataGen(sims.dataf, params.totalbits, 0);
    [~, tx] = TxMain(dataf, sims, params);

    % OFDM body only, apply same MF used in TX (for en>0 body already in txframe
    % is pre-MF; apply MF explicitly so en path is controlled)
    n_stf = params.NSTFSample;
    n_ofdm = params.NSymbol * params.NSamplepersymbol;
    ofdm_td = tx.txframe(:, n_stf + (1:n_ofdm));
    ofdm_mf = MatchedFilter_OFDM(ofdm_td, params.TXMatchedfilter);

    fft_out = FFTnRemoveGI(ofdm_mf, params.fft);
    [data_f, H] = ChannelEst(fft_out, params.ce);
    frame = struct();
    [eq2, ~, ~, frame] = ChannelComp(data_f, H, params, frame); %#ok<ASGLU>
    qam_mse = mean(abs(tx.mapper2(:) - eq2(:)).^2);
    rx_bits = OFDMDemapper(SingleStreamOut(eq2, params), params);
    [BER, Nerr, Ntot] = calculate_BER(dataf, rx_bits);

    fprintf('MF.en=%d (%s):  NSample/sym=%d  len(txframe)=%d  len(MF body)=%d\n', ...
        en, mf_name{k}, params.NSamplepersymbol, size(tx.txframe,2), size(ofdm_mf,2));
    fprintf('           QAM MSE=%.3e   BER=%g  (%d/%d bit errors)\n\n', ...
        qam_mse, BER, Nerr, Ntot);
end

fprintf('Note: RX has no matched filter / no AWGN / known timing.\n');
fprintf('BER>0 with en>0 is TX pulse-shape ISI unless RX uses the matched filter.\n');
