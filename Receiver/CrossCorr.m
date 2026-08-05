function [P2, R2, Msym] = CrossCorr( in ,cor_pattern, search_idx, k2  )

%  Usage      : [P2, R2, Msym] = CrossCorr( in ,cor_pattern, search_idx, k2   )
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com  
%  Known bugs :
    InputLength = round( size(in,2));
    CorLen = size(cor_pattern,2);
    EndIdx=InputLength-CorLen;
    P2 = zeros(1,EndIdx);
    R2 = P2; 
%     k2 = 1:(CorLen  );
    for d = search_idx:EndIdx
        P2(d) = sum(abs(sum(real( cor_pattern .* conj(in(:,d-1+k2))),2))+ ... 
                abs(sum(imag( cor_pattern .* conj(in(:,d-1+k2))),2))) ;
        R2(d) = sum(sum(abs(in(:,d+k2)) .^2 ));             
    end   
    Msym =  (abs( P2 ) .^2) ./  (R2 .^2) ;   
        
end
