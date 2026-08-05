function result = measure_PAPR_CCDF(tx_signal, params)
%MEASURE_PAPR_CCDF Measure and plot PAPR CCDF for first-polarization data.
%
%   tx_signal : TX waveform after matched filtering, before AGC/channel
%   params    : OFDM parameters after ReInit
%
%   Only data OFDM symbols are measured. STF and LTF samples are excluded.
%   CCDF(z) = number of symbols with PAPR > z / number of data symbols.

    if isempty(tx_signal) || size(tx_signal, 1) < 1
        error('measure_PAPR_CCDF:EmptySignal', ...
            'TX signal must contain at least one polarization.');
    end

    nsym_sample = params.NSamplepersymbol;
    data_start = params.NSTFSample + params.NLTFSample + 1;
    data_count = params.NDataSymbol * nsym_sample;
    data_end = data_start + data_count - 1;

    if size(tx_signal, 2) < data_end
        error('measure_PAPR_CCDF:SignalTooShort', ...
            'TX signal has %d samples; %d are required through the data region.', ...
            size(tx_signal, 2), data_end);
    end

    % First polarization only: one column per OFDM data symbol.
    data_signal = tx_signal(1, data_start:data_end);
    data_symbol = reshape(data_signal, nsym_sample, params.NDataSymbol);

    power_symbol = abs(data_symbol).^2;
    avg_power = mean(power_symbol, 1);
    peak_power = max(power_symbol, [], 1);
    papr_dB = 10*log10(peak_power ./ avg_power);

    z_dB = 0:0.1:16;
    ccdf = zeros(size(z_dB));
    for iz = 1:numel(z_dB)
        ccdf(iz) = sum(papr_dB > z_dB(iz)) / params.NDataSymbol;
    end

    figure('Name', 'OFDM PAPR CCDF - Polarization 1');
    semilogy(z_dB, ccdf, 'b-', 'LineWidth', 2);
    grid on;
    xlabel('PAPR threshold z_0 (dB)');
    ylabel('Pr(PAPR > z_0)');
    title(sprintf('OFDM data-symbol PAPR CCDF (Pol. 1, N=%d)', ...
        params.NDataSymbol));
    xlim([z_dB(1) z_dB(end)]);
    ylim([max(1/params.NDataSymbol, 1e-5) 1]);

    result.papr_dB = papr_dB;
    result.z_dB = z_dB;
    result.ccdf = ccdf;
    result.mean_dB = mean(papr_dB);
    result.max_dB = max(papr_dB);
    result.polarization = 1;
    result.NDataSymbol = params.NDataSymbol;
end
