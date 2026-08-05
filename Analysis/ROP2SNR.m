function SNR_dB =  ROP2SNR(ROP_dBm, SNRQ_dB, params )

%  Usage      : SNR_dB =  ROP2SNR(ROP, params )
%   params: coherent receiver parameter
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Reference]
%      https://www.sciencedirect.com/topics/engineering/coherent-receiver 
%
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    mW =1e-3;
    PS = db2pow(ROP_dBm) * mW;
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
 
    
    denominator =  sigma_th_2 /PCW +  ...
                                 PCW * sigma_nLO_2  * CMRR +...
                                 sigma_shot_2  + ...
                                 PS /SNRQ ;
                             
    SNR = PS ./ denominator;     
    SNR_dB = pow2db(SNR);
end 