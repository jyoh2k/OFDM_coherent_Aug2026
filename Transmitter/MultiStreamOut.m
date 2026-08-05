function dataout = MultiStreamOut ( datain,  params )

%  Usage        dataout = MultiStreamOut ( datain,  params, T )
%
%  Function   :
%     1.   Single Stream -> MultiStream
%     2.   datain : Single stream
%     3.   params   : parameters 
%     4.   T        : Reserved for fixed sim.
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

[d1, d2] = size ( datain);
if ( d1 == 0 )
    dataout = datain;
    return;
end
if ( mod( d2,  params.NTXStream ) ~= 0 )
    error(' The number of bit stream should be the integer multiples of the  number of streams');
end

dataout = reshape( datain, params.NTXStream, size(datain,2)/params.NTXStream);

end
