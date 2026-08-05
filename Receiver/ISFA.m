function H_modified = ISFA( H_in, params)
%  Usage      :  out =  IFFTnAddGI( in, params )
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


%     min_sc = min(params.SubcarrierIndex);
%     max_sc = max(params.SubcarrierIndex);
    H_modified=H_in;
    if ( params.en_ISFA == 0 ) 
        return
    end    
     
    for ii=1:size(H_in,1)
            for jj=1:size(H_in,2)                     
                    H_modified(ii,jj,:) =ISFA1 ( H_in(ii, jj, :), params); 
            end
    end 
    
end




function H_modified = ISFA1( H, params)
    H_modified = H;
    H1 = ISFA_domain( H, params.SubcarrierIndex1, params);
    H2 = ISFA_domain( H, params.SubcarrierIndex2, params); 
    H_modified(1, params.SubcarrierIndex1) = H1(1, params.SubcarrierIndex1) ;
    H_modified(1, params.SubcarrierIndex2) = H2(1, params.SubcarrierIndex2) ;
end


function H_modified = ISFA_domain( H, SubcarrierIndex, params)
    H_modified = H;      
    min_sc =find ( 1:length(SubcarrierIndex) <= params.ISFASize);
    max_sc =find ( 1:length(SubcarrierIndex) > length(SubcarrierIndex)-params.ISFASize);
    neighbor_sc = params.ISFASize * ones(1,length(SubcarrierIndex));
    neighbor_sc(min_sc)  = min_sc-1;
    neighbor_sc(max_sc)  = length(SubcarrierIndex)- max_sc;
    
    neighbor_nsc =  zeros(1,params.NFFT);
    neighbor_nsc(1,SubcarrierIndex) = neighbor_sc;
    for sc=SubcarrierIndex
        H_modified(1,1,sc) = mean(H(1,1,sc+(-neighbor_nsc(sc):neighbor_nsc(sc)))); 
    end           
end

% 
% 
% function H_modified = ISFA1_phase( H, H_in1, param, min_sc, max_sc) % H_in: Original H, H : abs modified input 
% 
%         H_modified = H; 
%         H = H .* exp( -1j*[0:(params.NFFT-1)]*2*pi/params.NFFT*(params.syncpoint));
%         H_in = H_in1 .* exp( -1j*[0:(params.NFFT-1)]*2*pi/params.NFFT*(params.syncpoint));
%         for sc=params.SubcarrierIndex    
% 
%             tmp =sum(abs(params.LTF( max(min_sc, sc-params.ISFASize1):min(max_sc, sc+params.ISFASize1))));
%             real_H = sum( real( H( max(min_sc, sc-params.ISFASize1):min(max_sc, sc+params.ISFASize1))))/tmp;
%             imag_H = sum( imag( H( max(min_sc, sc-params.ISFASize1):min(max_sc, sc+params.ISFASize1))))/tmp;
%             if ( tmp < (1+2* params.ISFASize1) ) 
%                 H_modified(sc) = H(sc);
%             else
%                 H_modified(sc) =  real_H  + 1j* imag_H ;
%             end
%         end
%         for sc=params.SubcarrierIndex    
%             sc_list = max(min_sc, sc-params.ISFASize1)-1+find( params.LTF( max(min_sc, sc-params.ISFASize1):min(max_sc, sc+params.ISFASize1)) ~= 0 );
%             if ( length(sc_list) < (params.ISFASize1 + 3))                    
%                 fit_H = polyfit(sc_list,real(H_in(sc_list)),1);
%                 real_H=fit_H(1) * sc + fit_H(2);
%                 fit_H = polyfit(sc_list,imag(H_in(sc_list)),1);
%                 imag_H=fit_H(1) * sc + fit_H(2);
%                 H_modified(sc) =  real_H  + 1j* imag_H ;
%             end
%         end 
%        H_modified = H_modified .* exp(  1j*[0: (params.NFFT-1)]*2*pi/params.NFFT*(params.syncpoint-params.CPshift));
% end
