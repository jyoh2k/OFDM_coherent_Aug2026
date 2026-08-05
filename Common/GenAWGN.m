function AWGN = GenAWGN( AIN, SNRdB) 

%  Usage      : AWGN = GenAWGN( AIN, SNRdB);
%  Function   :
%     1. Generate AWGN noise.
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    AIN = AIN -mean(AIN,2)* ones(1, size(AIN,2));
    signal_energy = mean( AIN .* conj(AIN),2 );
    SNR=10 .^(SNRdB/10);
    No=(signal_energy ./SNR);
    noise= zeros(size(AIN));
    if( isreal(AIN) == 1 )
        for ii=1:size(AIN,1)
            noise(ii,:)=sqrt(No(ii) ) *(randn(1, size(AIN,2)));
        end
    else
        for ii=1:size(AIN,1)
            noise(ii,:)=sqrt(No(ii)/2) *(randn(1, size(AIN,2)) + 1j*randn(1, size(AIN, 2)));
        end
    end
     AWGN =  noise  ; % Complex 
%     AWGN =  noise  ;
end
