function ROP_dBm =  SNR2ROP(SNR_dB, SNRQ_dB, params )

%  Usage      : ROP_dBm =  SNR2ROP(SNR_dB, params )
%    params: coherent receiver parameter
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Reference]
%      https://www.sciencedirect.com/topics/engineering/coherent-receiver 
%
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    mW =1e-3;
    SNR = db2pow(SNR_dB);
    SNRQ = db2pow(SNRQ_dB);
     
    PCW = params.PLO;  % LO power
    RIN = db2pow(params.RIN_dB);
    BW_eq = params.bandwidth; % Effective noise bandwidth of the receiver 
    R = params.responsivity ;
    CMRR = params.CMRR;
    i_TIA = params.IRND ;
    q = 1.6e-19 ; % C
    
    sigma_th_2      = i_TIA ^2 * BW_eq /8/R^2;
    sigma_shot_2  = q * BW_eq /2/R;
    sigma_nLO_2 = RIN * BW_eq /2 ;    
 
                             
    ROP  = ( sigma_th_2 /PCW +    PCW * sigma_nLO_2  * CMRR + sigma_shot_2 ) ./(1./SNR - 1/SNRQ); 
    ROP_dBm = pow2db(ROP/mW );
end 
