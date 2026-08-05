function [AOUT, sims] = Channel( sims, AIN, channel )

%  Usage      : [AOUT] = Channel( AIN, channel )
%  Function   :
%     1. Channel with CFO, SFO, STO, linewidth, and jitter
%     2. AIN        : Original signal
%     3. AOUT       : Signal with phase noise
%     4. channel    : Parameter for simsple channel
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


    AIN                      = DAC1 ( AIN,     channel.TXDAC);  
    AIN_up                   = Resample( AIN,  channel.TXSampleFreq,  channel.SampleFreq);

    AIN_up                   = Amplifier( AIN_up,     channel.RFDriver );
    esignal_in               = AIN_up;
    AIN_up                   = MZMmod   ( AIN_up,     channel.MZmod );
%     AIN_up                   = EDFA     ( AIN_up,     channel.txedfa);
    AIN_up                   = IQImbalance( AIN_up, channel.txiqimb, channel.SampleFreq);
    [AIN_up, sims.txpn]      = AddPhaseNoise( AIN_up, 1/channel.SampleFreq, channel.TXLineWidth );

    mzm_out               = AIN_up;
    fiber_in                 = AIN_up;

    % figure(1);
    % xxx = [(-1/2):1/(length(fiber_in(1,:))-1):1/2]*256;
    % plot(xxx,log10(fftshift(abs(fft((fiber_in(1,:)))))));
    % grid on

    % disp('Fiber Length: '); 
    % channel.fiber_length

     [AIN_up]                 = FiberOpticChannel( AIN_up, channel );

    fiber_out                = AIN_up;

    % figure(2);
    % xxx = [(-1/2):1/(length(fiber_out(1,:))-1):1/2]*256;
    % plot(xxx,log10(fftshift(abs(fft((fiber_out(1,:)))))));
    % grid on;
    % pause(1);

%     AIN_up = mzm_out;
    [AIN_up]                 = CarrierFreqOffset( AIN_up, ...
                                   channel.CarrierFreqOff_norm,...
                                   channel.CarrierFreqDrift,...
                                   channel.PhaseOffset);
    [AIN_up, sims.rxpn]      = AddPhaseNoise( AIN_up, 1/channel.SampleFreq, channel.RXLineWidth);
%     [AIN_up]                 = TimeJitter( AIN_up, channel.Jitter, 1, 1/channel.SampleFreq);
%     [AIN_up, TimingDelay]    = SamplingFreqOffset(AIN_up, channel.TimeFreqOff, channel.TimePhaseOff);  
    
    
    fiber_out_sfo                = AIN_up;
% Coherent receiver model 
    [AIN_up, sims.channelout.ROP_dBm]                   = CoherentPD( AIN_up,  channel.PD);
    pd_out                   = AIN_up;
    AIN_up                   = Amplifier  ( AIN_up,  channel.RFAmp);

%     AIN_up = esignal_in;
    esignal_adc              = AIN_up; 
%     AIN_up                   = IQImbalance( AIN_up, channel.iqimb, channel.SampleFreq);
    AIN_dn                   = RateConversion( AIN_up, channel.SampleFreq, channel.RXSampleFreq);
    AIN_dn                   = IQImbalance( AIN_dn, channel.iqimb, channel.RXSampleFreq);
    
    [AIN_dn]                 = TimeJitter( AIN_dn, channel.Jitter, 1, 1/channel.RXSampleFreq);
    [AIN_dn, TimingDelay]    = SamplingFreqOffset(AIN_dn, channel.TimeFreqOff, channel.TimePhaseOff);  

    % AGC for ADC (Simulation) 
    AIN_dn                   = AGC( AIN_dn, channel.AGC);
    AIN_dn                   = ADC1( AIN_dn,  channel.RXADC);
    [AIN_dn, AWGN]           = AddAWGN( AIN_dn, channel.SNRdB_bw, channel.enAWGN );   
    AOUT                     = AIN_dn;

    %% Analysis

    sims.channelout.DAC_in     = esignal_in;
    sims.channelout.fiber_out  = fiber_out;
    sims.channelout.fiber_in   = fiber_in;
    sims.channelout.pd_out     = pd_out;
    sims.channelout.ADC_out    = esignal_adc;
    sims.channelout.SampleFreq = channel.SampleFreq;

end
