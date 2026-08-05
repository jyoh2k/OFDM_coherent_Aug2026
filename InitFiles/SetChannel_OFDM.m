function [sims]=  SetChannel_OFDM( sim_case, sims, params )
%  Usage      : [sims]=  SetChannel(sim_case,  sims, params)
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :
    
    
    GHz = 1e9;
    MHz = 1e6;
    kHz = 1e3;
    ppm = 1e-6;
    ps = 10^-12;
    mW  = 1e-3;
    km  = 1e3;
    

    BW = 0.7;
    % IQGain =0; 
    % IQPhase=0;
    % RxIQSkew=0;
    % TxIQSkew=0;
    % TxPN=0;
    % RxPN=0;
    % CFO=0;
    % SFO=0;
    % Jitter = 0;
    % FiberLen =0.0001;
    % PMD=0;
    % DACNo=1;
    % ADCNo=1;
    % ENob=4;

    % BW = 0.4;  %(80%)
    % IQGain =1; 
    % IQPhase=5;
    % RxIQSkew=0.5;
    % TxIQSkew=0.5;
    % TxPN=0.3;
    % RxPN=0.3;
    % CFO=3000;
    % SFO=20;
    % Jitter = 0.65;
    % FiberLen = 10;   %?�재 OFDE???�략
    % PMD=10;
    % DACNo=0;
    % ADCNo=0;
    % ENob=4;

    %% Channel
    sims.ROP_cal = 0;
    sims.channel.MZmod.launch_power =  5*mW;
    sims.channel.CarrierFreqOff   = 0*500*MHz ; 
    sims.channel.TimeFreqOff      = 0*10*ppm;
    sims.channel.TimePhaseOff     = 0 * -0.5; 
    sims.channel.Jitter           = 0.0*ps; 
    % sims.channel.AGC.avg_out      = 0.6;
    sims.channel.enAWGN           = 1;
    sims.channel.TXLineWidth      = 0 * 500 * kHz;
    sims.channel.RXLineWidth      = 0 * 500 * kHz;
    
    if ( params.Nbpsc == 2 && params.NTXStream == 1)
        sims.channel.TXDAC.bandwidth  = 35.5*GHz;
    else 
        sims.channel.TXDAC.bandwidth  = 17*GHz;
    end
    sims.channel.TXDAC.bandwidth_en = 0;
    sims.channel.TXDAC.ENob  = 4;
    sims.channel.TXDAC.T.wordl = 0;
    sims.channel.TXDAC.T.fracl = 4;
    sims.channel.RFDriver.gain_dB =  2;
    sims.channel.RFDriver.bandwidth_en =  0;
    sims.channel.MZmod.bandwidth_en = 0;
    if ( params.Nbpsc == 2 && params.NTXStream == 1)
        sims.channel.MZmod.bandwidth  = 35*GHz;
    else
        sims.channel.MZmod.bandwidth  = 20*GHz;
    end
    sims.channel.PD.bandwidth_en  = 0;
    sims.channel.PD.bandwidth  = 42*GHz;
    %sims.channel.PD.noise_power_dBm =  -30;
    sims.channel.RXADC.bandwidth_en  = 0;
    if ( params.Nbpsc == 2 && params.NTXStream == 1)
        sims.channel.RXADC.bandwidth  = 33.5*GHz;
    else
        sims.channel.RXADC.bandwidth  = 13.5*GHz;
        sims.channel.RXADC.bandwidth_en  = 0;
    end
    sims.channel.RXADC.ENob  = 4;
    sims.channel.RXADC.T.wordl = 0;
    sims.channel.RXADC.T.fracl = 4;
    
    sims.channel.fiber_length     = 0 *km;
    sims.channel.ssmf.power_split2 = 0.35;
    sims.channel.PMD = 0 * 2*ps;
    sims.channel.iqimb.gainim = zeros(2,1) * (db2mag(1) - 1); % 1 dB
    sims.channel.iqimb.phaseim = zeros(2,1) * 2.5; %  2.5degree
    sims.channel.iqimb.iqskew =zeros(2,1) *  0.75*ps;
    
    sims.channel.SNRdB = 17.2424;
    sims.channel.SNRdB = 15;
    sims.channel.TXDAC.nonoise =1; 
    sims.channel.RXADC.nonoise =1; 
    %%
    if ( sim_case  == 1)
        params.TXMatchedfilter.en = 0;
        params.RXMatchedfilter.en = 0;
    %     params.TXMatchedfilter.alpha = 0.5;
    %     params.RXMatchedfilter.alpha = 0.5;
        sims.channel.RFDriver.nonoise = 1;
        sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1;
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1; 
        params.tpr.en=0;
        params.cfr.en= 0;
        params.cpr.en= 0;
    end
    %%
    if ( sim_case  == 2) 
    %     params.TXMatchedfilter.en = 0;
    %     params.RXMatchedfilter.en = 0;
        sims.channel.RFDriver.nonoise = 1;
        sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1; 
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1;  
        sims.channel.SNRdB = 16;
    end
    
    %%
    
    if ( sim_case  == 3)    
        sims.channel.PD.NF_dB = 0;
        sims.channel.TXDAC.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.SNRdB = 14.75 + 0.5 ;
        sims.channel.RFDriver.nonoise = 1;
        sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1; 
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1; 
    end 
    if ( sim_case  == 4)    
        sims.channel.PD.NF_dB = 0;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.SNRdB = 14.85 + 0.5  ;
        sims.channel.RFDriver.nonoise = 1;
        sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1; 
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1; 
    end 
    if ( sim_case  == 5)        
        sims.channel.PD.NF_dB = 0;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.SNRdB = 14.93 + 0.5  ;
        sims.channel.RFDriver.nonoise = 1;
        sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1; 
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1;  
    end
    if ( sim_case  == 6)      
        sims.channel.PD.NF_dB = 0;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 16.2  ;
        sims.channel.RFDriver.nonoise = 1;
        sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1; 
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1;  
    end
    %%
    if ( sim_case  == 7)            
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 16.2  ;
    end
    %%
    if ( sim_case  == 8)            
        sims.channel.PD.NF_dB = 0;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 15.34 + 0.5  ; 
        sims.channel.SNRdB = 16.2  ;
    end
    %%
    
    if ( sim_case  == 9)             % IQ gain   
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 16.7  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1); % 1 dB
    end
     
    if ( sim_case  == 10)            % IQ phase imbalance 
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 15.34 + 0.5  ; 
        sims.channel.SNRdB = 17   ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; %  5 degre
    end
     
     
    if ( sim_case  == 11)            % IQ skew
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 15.34 + 0.5  ; 
        sims.channel.SNRdB = 17  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; %  5 degre
        sims.channel.iqimb.iqskew =ones(2,1) * RxIQSkew *ps;
        sims.channel.txiqimb.iqskew =ones(2,1) * TxIQSkew *ps;
    end    
     
    % if ( sim_case  == 12 )            %  Phase noise
    %     sims.channel.PD.NF_dB = 6;
    %     sims.channel.TXDAC.bandwidth_en = 1;
    %     sims.channel.RXADC.bandwidth_en = 1; 
    %     sims.channel.MZmod.bandwidth_en = 1; 
    %     sims.channel.PD.bandwidth_en = 1; 
    %     sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
    %     sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
    %     sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
    %     sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
    %     sims.channel.SNRdB = 15.61  ; 
    %     sims.channel.SNRdB = 17.6  ; 
    %     sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1); % 1 dB
    %     sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; %  5 degre
    %     sims.channel.iqimb.iqskew =ones(2,1) * RxIQSkew *ps;
    %     sims.channel.txiqimb.iqskew =ones(2,1) * TxIQSkew *ps;
    %     sims.channel.TXLineWidth      = TxPN *   MHz;
    %     sims.channel.RXLineWidth      = RxPN *   MHz;
    % end
     
    if ( sim_case  == 12 )            %  CFO
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 16.0 + 0.5  ; 
        sims.channel.SNRdB = 18  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1);
        sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; 
        sims.channel.iqimb.iqskew =ones(2,1) * RxIQSkew *ps;
        sims.channel.txiqimb.iqskew =ones(2,1) * TxIQSkew *ps;
        % sims.channel.TXLineWidth      = TxPN *   MHz;
        % sims.channel.RXLineWidth      = RxPN *   MHz;
        sims.channel.CarrierFreqOff   =  CFO*MHz ; 
    end
     
    %%
    
    if ( sim_case  == 13 )            %  
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 0;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 16 + 0.5  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(1) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * 5; %  5 degre
        sims.channel.iqimb.iqskew =ones(2,1) *  0.75*ps;
        sims.channel.TXLineWidth      = 1 *   MHz;
        sims.channel.RXLineWidth      = 1 *   MHz;
        sims.channel.CarrierFreqOff   =  1800*MHz ; 
    end
    
    if ( sim_case  == 14 )            %  
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 0; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth =  1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth =   1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 16 + 0.5  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(1) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * 5; %  5 degre
        sims.channel.iqimb.iqskew =ones(2,1) *  0.75*ps;
        sims.channel.TXLineWidth      = 1 *   MHz;
        sims.channel.RXLineWidth      = 1 *   MHz;
        sims.channel.CarrierFreqOff   =  1800*MHz ; 
    end
    
    if ( sim_case  == 15 )            %  
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 0; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth =    1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 16 + 0.5  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(1) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * 5; %  5 degre
        sims.channel.iqimb.iqskew =ones(2,1) *  0.75*ps;
        sims.channel.TXLineWidth      = 1 *   MHz;
        sims.channel.RXLineWidth      = 1 *   MHz;
        sims.channel.CarrierFreqOff   =  1800*MHz ; 
    end
    
    if ( sim_case  == 16 )            %  
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 0; 
        sims.channel.TXDAC.bandwidth =  1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 7.84 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 2 * 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 16 + 0.5  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(1) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * 5; %  5 degre
        sims.channel.iqimb.iqskew =ones(2,1) *  0.75*ps;
        sims.channel.TXLineWidth      = 1 *   MHz;
        sims.channel.RXLineWidth      = 1 *   MHz;
        sims.channel.CarrierFreqOff   =  1800*MHz ; 
    end
    %%
    
    if ( sim_case  == 17 )            %  
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 11.5 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 1.1 * 9.1* GHz;
        sims.channel.SNRdB = 16 + 0.5  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(1) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * 5; %  5 degre
        sims.channel.iqimb.iqskew =ones(2,1) *  0.75*ps;
        sims.channel.TXLineWidth      = 1 *   MHz;
        sims.channel.RXLineWidth      = 1 *   MHz;
        sims.channel.CarrierFreqOff   =  1800*MHz ; 
    end
    
    %%
    if ( sim_case  == 18 )            %  CFO
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 11.5 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 1.1 * 11 * GHz;
        sims.channel.SNRdB = 17.6  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(1) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * 5; %  5 degre
        sims.channel.iqimb.iqskew =ones(2,1) *  0.75*ps;
        sims.channel.TXLineWidth      = 1 *   MHz;
        sims.channel.RXLineWidth      = 1 *   MHz;
        sims.channel.CarrierFreqOff   =  1800*MHz ; 
    end
    %%
    if ( sim_case  == 19 )            %  SFO 
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 11.5 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 1.1 * 11 * GHz;
        sims.channel.SNRdB = 17.6  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1);
        sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; 
        sims.channel.iqimb.iqskew =ones(2,1) * RxIQSkew *ps;
        sims.channel.txiqimb.iqskew =ones(2,1) * TxIQSkew *ps;
        % sims.channel.TXLineWidth      = TxPN *   MHz;
        % sims.channel.RXLineWidth      = RxPN *   MHz;
        sims.channel.CarrierFreqOff   =  CFO*MHz ; 
        sims.channel.TimeFreqOff      =  SFO*ppm;
    end
      
    
    if ( sim_case  == 20 )            %  Jitter 
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 11.5 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 1.1 * 11 * GHz;
        sims.channel.SNRdB = 17.6  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1);
        sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; 
        sims.channel.iqimb.iqskew =ones(2,1) * RxIQSkew *ps;
        sims.channel.txiqimb.iqskew =ones(2,1) * TxIQSkew *ps;
        % sims.channel.TXLineWidth      = TxPN *   MHz;
        % sims.channel.RXLineWidth      = RxPN *   MHz;
        sims.channel.CarrierFreqOff   =  CFO*MHz ; 
        sims.channel.TimeFreqOff      =  SFO*ppm;
        sims.channel.Jitter           = Jitter*ps; 
    end
      
    
    if ( sim_case  == 21)            %  Fiber length 20km
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 11.5 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 1.1 * 11 * GHz;
        sims.channel.SNRdB = 17.6  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1);
        sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; 
        sims.channel.iqimb.iqskew =ones(2,1) * RxIQSkew *ps;
        sims.channel.txiqimb.iqskew =ones(2,1) * TxIQSkew *ps;
        sims.channel.TXLineWidth      = TxPN *   MHz;
        sims.channel.RXLineWidth      = RxPN *   MHz;
        sims.channel.CarrierFreqOff   =  CFO*MHz ; 
        sims.channel.TimeFreqOff      =  SFO*ppm;
        sims.channel.Jitter           = Jitter*ps; 
        sims.channel.fiber_length     = FiberLen *km;
        sims.channel.RFDriver.nonoise = 1;
        sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1;
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1; 
    %     sims.channel.MZmod.launch_power =  7*mW;
    end
    
    
    if ( sim_case  == 22 )            %  PMD
        % sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        % sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        % sims.channel.RXADC.bandwidth = 1.1 * 11.5 * GHz;
        % sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        % sims.channel.PD.bandwidth = 1.1 * 11 * GHz;
        % sims.channel.SNRdB = 17.6  ; 
        % sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1);
        % sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; 
        % sims.channel.iqimb.iqskew =ones(2,1) * RxIQSkew *ps;
        % sims.channel.txiqimb.iqskew =ones(2,1) * TxIQSkew *ps;
        % sims.channel.TXLineWidth      = TxPN *   MHz;
        % sims.channel.RXLineWidth      = RxPN *   MHz;
        % sims.channel.CarrierFreqOff   =  CFO*MHz ; 
        % sims.channel.TimeFreqOff      =  SFO*ppm;
        % sims.channel.Jitter           = Jitter*ps; 
        %sims.channel.fiber_length     = FiberLen *km;
        % sims.channel.PMD = PMD *ps;
    end

        if ( sim_case  == 23 )            %  Phase Noise
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 11.5 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 1.1 * 11 * GHz;
        sims.channel.SNRdB = 17.6  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1);
        sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; 
        sims.channel.iqimb.iqskew =ones(2,1) * RxIQSkew *ps;
        sims.channel.txiqimb.iqskew =ones(2,1) * TxIQSkew *ps;
        sims.channel.CarrierFreqOff   =  CFO*MHz ; 
        sims.channel.TimeFreqOff      =  SFO*ppm;
        sims.channel.Jitter           = Jitter*ps; 
        sims.channel.fiber_length     = FiberLen *km;
        sims.channel.PMD = PMD *ps;
        sims.channel.TXLineWidth      = TxPN *   MHz;
        sims.channel.RXLineWidth      = RxPN *   MHz;
    end
    
    if ( sim_case  == 24 )            %  DAC
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 11.5 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 1.1 * 11 * GHz;
        sims.channel.SNRdB = 18.4 ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1);
        sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; 
        sims.channel.iqimb.iqskew =ones(2,1) * RxIQSkew *ps;
        sims.channel.txiqimb.iqskew =ones(2,1) * TxIQSkew *ps;
        sims.channel.TXLineWidth      = TxPN *   MHz;
        sims.channel.RXLineWidth      = RxPN *   MHz;
        sims.channel.CarrierFreqOff   =  CFO*MHz ; 
        sims.channel.TimeFreqOff      =  SFO*ppm;
        sims.channel.Jitter           = Jitter*ps; 
        sims.channel.fiber_length     = FiberLen *km;
        sims.channel.PMD = PMD *ps;
        sims.channel.TXDAC.nonoise =DACNo; 
        sims.channel.TXDAC.T.wordl =0; 
        sims.channel.TXDAC.T.fracl =4; 
        sims.channel.TXDAC.ENob = ENob;
    end
    if ( sim_case  == 25 )            %  ADC
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 11.5 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 1.1 * 11 * GHz;
        sims.channel.SNRdB = 19 ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1);
        sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; 
        sims.channel.iqimb.iqskew =ones(2,1) * RxIQSkew *ps;
        sims.channel.txiqimb.iqskew =ones(2,1) * TxIQSkew *ps;
        sims.channel.TXLineWidth      = TxPN *   MHz;
        sims.channel.RXLineWidth      = RxPN *   MHz;
        sims.channel.CarrierFreqOff   =  CFO*MHz ; 
        sims.channel.TimeFreqOff      =  SFO*ppm;
        sims.channel.Jitter           = Jitter*ps; 
        sims.channel.fiber_length     = FiberLen *km;
        sims.channel.PMD = PMD *ps;
        sims.channel.TXDAC.nonoise =DACNo; 
        sims.channel.TXDAC.T.wordl =0; 
        sims.channel.TXDAC.T.fracl =4; 
        sims.channel.TXDAC.ENob = ENob;
        sims.channel.RXADC.nonoise =ADCNo; 
         sims.channel.RXADC.T.wordl =0;
        sims.channel.RXADC.T.fracl =4; 
        sims.channel.RXADC.ENob = ENob;
    end
    
    if ( sim_case  == 26 )            %  All impairment, no AWGN      
        sims.channel.enAWGN           = 0;
        sims.channel.RFDriver.nonoise = 1;
        sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1;
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1; 
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 11.5 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 1.1 * 11 * GHz;
        sims.channel.SNRdB = 25  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(1) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * 5; %  5 degre
        sims.channel.iqimb.iqskew =ones(2,1) *  0.75*ps;
        sims.channel.TXLineWidth      = 1 *   MHz;
        sims.channel.RXLineWidth      = 1 *   MHz;
        sims.channel.CarrierFreqOff   =  1800*MHz ; 
        sims.channel.TimeFreqOff      =  20*ppm;
        sims.channel.fiber_length     = 20 *km; 
        sims.channel.Jitter           = 0.65*ps; 
        sims.channel.PMD = 7 *ps;
        sims.channel.TXDAC.nonoise =0; 
        sims.channel.TXDAC.T.wordl =6; 
        sims.channel.RXADC.nonoise =0; 
        sims.channel.RXADC.T.wordl =6; 
        params.cpr.fBLK = 16;
        params.cpr.fSTEP = 16;
        params.dfe.betaf = 0.006;
    end
    if ( sim_case  == 27 )            %  PMD
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 11.5 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 1.1 * 11 * GHz;
        sims.channel.SNRdB = 25  ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(1) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * 5; %  5 degre
        sims.channel.iqimb.iqskew =ones(2,1) *  0.75*ps;
        sims.channel.TXLineWidth      = 1 *   MHz;
        sims.channel.RXLineWidth      = 1 *   MHz;
        sims.channel.CarrierFreqOff   =  1800*MHz ; 
        sims.channel.TimeFreqOff      =  20*ppm;
        sims.channel.fiber_length     = 20 *km;
    %     sims.channel.MZmod.launch_power =  7*mW;
        sims.channel.Jitter           = 0.65*ps; 
        sims.channel.PMD = 7 *ps;
        sims.channel.TXDAC.nonoise =0; 
        sims.channel.TXDAC.T.wordl =6; 
        sims.channel.RXADC.nonoise =0; 
        sims.channel.RXADC.T.wordl =6; 
        params.cpr.fBLK = 16;
        params.cpr.fSTEP = 16;
        params.dfe.betaf = 0.006;
    end
    %%
    
    if ( sim_case  == 30) 
        sims.channel.RFDriver.nonoise = 1;
    %     sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1; 
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1; 
        sims.channel.MZmod.launch_power =  5 *mW;
        sims.channel.fiber_length     = 0 *km;
    end
    %%
    if ( sim_case  == 31) 
        sims.channel.RFDriver.nonoise = 1;
    %     sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1; 
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1; 
        sims.channel.MZmod.launch_power =  5*mW;
        sims.channel.fiber_length     = 20 *km;
    end
    %%
    if ( sim_case  == 32) 
        sims.channel.RFDriver.nonoise = 1;
    %     sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1; 
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1; 
        sims.channel.MZmod.launch_power =  8*mW;
        sims.channel.fiber_length     = 80 *km;
    end
    %%
    if ( sim_case  == 33 || sim_case  == 34 || sim_case  == 35 ) 
        sims.channel.RFDriver.nonoise = 1;
        sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1; 
        params.rxpostemp.en = 0;
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(IQGain) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * IQPhase; %  5 degre
        sims.channel.iqimb.iqskew =ones(2,1) *  IQSkew *ps;
    end
    if ( sim_case  == 36 )            %  IQ Skew 
        sims.channel.PD.NF_dB = 6;
        sims.channel.TXDAC.bandwidth_en = 1;
        sims.channel.RXADC.bandwidth_en = 1; 
        sims.channel.MZmod.bandwidth_en = 1; 
        sims.channel.PD.bandwidth_en = 1; 
        sims.channel.TXDAC.bandwidth = 1.1 * 7.55 * GHz;
        sims.channel.RXADC.bandwidth = 1.1 * 11.5 * GHz;
        sims.channel.MZmod.bandwidth = 1.1 * 7.975* GHz;
        sims.channel.PD.bandwidth = 1.1 * 11 * GHz;
        sims.channel.SNRdB = 19 ; 
        sims.channel.iqimb.gainim = ones(2,1) * (db2mag(1) - 1); % 1 dB
        sims.channel.iqimb.phaseim = ones(2,1) * 5; %  5 degre
        sims.channel.iqimb.iqskew =ones(2,1) *  IQSkew *ps;
        sims.channel.txiqimb.iqskew =ones(2,1) * TxIQSkew *ps;
        sims.channel.TXLineWidth      =     1 *   MHz;
        sims.channel.RXLineWidth      =     1 *   MHz;
        sims.channel.CarrierFreqOff   =   1800*MHz ; 
        sims.channel.TimeFreqOff      =  20*ppm;
        sims.channel.fiber_length     = 20 *km;
        sims.channel.Jitter           = 0.65*ps; 
        sims.channel.PMD = 7 *ps;
        sims.channel.TXDAC.nonoise =0; 
        sims.channel.TXDAC.T.wordl =4; 
        sims.channel.RXADC.nonoise =0; 
        sims.channel.RXADC.T.wordl =4; 
    end
    
    if ( sim_case  == 37) 
    %     params.TXMatchedfilter.en = 0;
    %     params.RXMatchedfilter.en = 0;
        sims.channel.RFDriver.nonoise = 1;
        sims.channel.PD.nonoise = 1;
        sims.channel.RFAmp.nonoise =1; 
        sims.channel.TXDAC.nonoise =1; 
        sims.channel.RXADC.nonoise =1;  
        sims.channel.SNRdB = 16;
        %sims.channel.TimeFreqOff  = 20 *ppm;  
        sims.channel.TXLineWidth      = 0.3 *   MHz;
        sims.channel.RXLineWidth      = 0.3 *   MHz;
    end
    
    %% Baud Rate fixed (flow1)
    % sims.channel.TXDAC.bandwidth = 0.75 * params.BaudFreq  ;
    % sims.channel.RXADC.bandwidth = 0.75 * params.BaudFreq ;
    % sims.channel.MZmod.bandwidth =  0.8 * params.BaudFreq;
    % sims.channel.PD.bandwidth = 0.8 * params.BaudFreq;
    sims.channel.TXDAC.bandwidth = 0.99 * params.BaudFreq  ; % 80 % Baud rate
    sims.channel.RXADC.bandwidth = BW  * params.BaudFreq ;
    sims.channel.MZmod.bandwidth =  0.99 * params.BaudFreq;
    sims.channel.PD.bandwidth = BW * params.BaudFreq;

    % sims.channel.TXDAC.bandwidth = 0.5 * params.BaudFreq  ; % 80 % Baud rate
    % sims.channel.RXADC.bandwidth = BW  * params.BaudFreq ;
    % sims.channel.MZmod.bandwidth =  0.5 * params.BaudFreq;
    % sims.channel.PD.bandwidth = BW * params.BaudFreq;
    % sims.channel.PD.NF_dB = 0;
    % sims.channel.TXDAC.bandwidth_en = 0;
    % sims.channel.RXADC.bandwidth_en = 0;
    % sims.channel.MZmod.bandwidth_en = 0;
    % sims.channel.PD.bandwidth_en = 0;
    % sims.channel.PD.nonoise = 1;
    % sims.channel.MZmod.nonoise = 1;
    % sims.channel.RFAmp.nonoise =1; 
    % sims.channel.TXDAC.nonoise =1; 
    % sims.channel.RXADC.nonoise =1;  


    %%
    if ( sims.mode == 51 )
        sims.channel.PD.nonoise = 1;
        sims.channel.enAWGN  =1;
    else 
        sims.channel.PD.nonoise = 0;
        sims.channel.enAWGN  =0;
    end
end
