function [P1, R1, Msym, R2] = AutoCorr( in ,search_idx, CorLen, Interval  )

%  Usage      : [P1, R1, Msym, R2] = AutoCorr( in ,search_idx, CorLen, Interval  )
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : miroandi@kaist.ac.kr   
%  Known bugs :

        k = 1:CorLen;
        InputLength = round( size(in,2)); 
        EndIdx=InputLength-2*CorLen;
        P1=zeros(1, EndIdx);
        R1=zeros(1, EndIdx);
        Msym=zeros(1, EndIdx);
        R2=zeros(1, EndIdx);
        for isample=search_idx :(EndIdx - Interval)
            P1(isample)= sum(sum( in(:,isample+k) .* conj(in(:,isample+ Interval + k ))));
            R1(isample) = sum(sum (abs( in (:, isample +k )) .^2 ));  
        end
        Msym =  (abs( P1 ) .^2) ./  (R1 .^2) ;   
        R2 =   (abs( in) .^2 );   
        
end
