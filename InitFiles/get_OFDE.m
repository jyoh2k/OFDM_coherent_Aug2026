function [OFDE]=  get_OFDE ( channel, OFDE  )

    NOFDE = length(OFDE.freq_resp); 
    w = [0:(NOFDE)/2-1 -(NOFDE)/2:-1]   ;
    w0 = w * 0;
    w= 2*pi * OFDE.SampleFreq/NOFDE * w ;
    Overlap = 2;
    FFTPoint = NOFDE/Overlap;
    DHat =1/2*channel.ssmf.Beta2 *( - w .* w + w0 .^2 )*channel.fiber_length ;
    OFDE.freq_resp = exp(1j * DHat);
%     if (  channel.fiber_length == 0 )
%         OFDE.en = 0;
%     end 

end
