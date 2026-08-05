function [P2, R2, Msym, Msym1] = CrossCorr2D( in ,cor_pattern, search_idx, k2  )

%  Usage      : [P2, R2, Msym] = CrossCorr2D( in ,cor_pattern, search_idx, k2   )
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com  
%  Known bugs :


    InputLength = round( size(in,2));
    CorLen = size(cor_pattern,2);
    EndIdx=InputLength-CorLen; 
    Msym = zeros(1, EndIdx);
    Msym1 = zeros(size(in,1)*size(cor_pattern,1), EndIdx); 
    idx1=1;
     for iTx=1:size(in,1)
         for iRx=1:size(cor_pattern,1)
             [P2, R2, Msym1(idx1,:)] = CrossCorr( in(iTx,:), cor_pattern(iRx,:), search_idx, k2  );
             Msym = Msym1(idx1,:) + Msym;
             idx1 = idx1 +1 ;
         end
     end
        
end
