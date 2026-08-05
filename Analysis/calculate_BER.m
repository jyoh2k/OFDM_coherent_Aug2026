function [ BER, Nbiterr, Ntotal, Ndiff] = calculate_BER( TX_ptn, RX_ptn )

%  Usage      : calucate_BER 
%  Function   : BER analysis
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


    Ntotal = min(length(TX_ptn), length(RX_ptn) ); 
%     Ndiff = find(bitxor( TX_ptn(1:Ntotal) , RX_ptn(1:Ntotal)) == 1 );
    Ndiff = find( TX_ptn(1:Ntotal) ~= RX_ptn(1:Ntotal) );
    Nbiterr     = length(Ndiff);    
    BER     = Nbiterr/ Ntotal;      
end
