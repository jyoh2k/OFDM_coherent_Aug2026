function dataout = SingletreamOut( datain,  params)

%  Usage        dataout = SingleStreamOut ( datain,  params)
%
%  Function   :
%     1.   Multi Stream -> Single Stream
%     2.   datain : Multi stream
%     3.   params   : parameters 
%     4.   T        : Reserved for fixed sim.
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


dataout = reshape( datain, 1, size(datain,2)*size(datain,1));
% NFrameSymbol = params.totalbits / params.Nbitspersymbol ;
% dataout = dataout(:,1:NFrameSymbol);

end
