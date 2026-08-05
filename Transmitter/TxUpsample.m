function [ out  ]=  TxUpsample( in, oversample, type )

%  Usage      : [ out  ]=  TxUpsample( in, oversample, type )
%
%  Function   :
%     1. out :output of transmitter
%     2. in : input 
%     3. oversample : oversample
%     4. type : oversample type ( 0:zeropadding  , 1:repetition)
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    out   = zeros(size(in,1),size(in,2)*oversample);
    if ( type == 1 )
        for ii=1:oversample
            out( :, ii:oversample:end) = in;
        end
    else
        out(:,1:oversample:end) = in;
    end
    

end
