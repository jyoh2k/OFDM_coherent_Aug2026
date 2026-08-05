function [ out ] = OFDE(in, params)  

%  Usage      : [ out, phase ] = OFDE(in, params)  
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    if ( params.en == 0)
        out = in ;
        return
    end
    
    [d1, d2] = size( in);    
    Overlap = 2;
    FFTPoint = length(params.freq_resp) ;    
    %% Zero padding to process overlapped FDE(OFDE)
    pad1 = length(params.freq_resp);
    in_pad = [zeros( d1, pad1), in, zeros( d1, FFTPoint)];     
    FFTNum = ceil( (d2+ pad1)*Overlap/FFTPoint);
    out1 = overlap_fft( in_pad, FFTNum, FFTPoint/Overlap, ones(d1,1) * params.freq_resp ); 
    out = out1( :, pad1*3/4+1:pad1*3/4+d2);
end

     
function out = overlap_fft( in_time, fftnum, fftsize, freq_resp)

%  Usage      : out = overlap_fft( in_time, fftnum, fftsize,  DHat, Overlap)
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


    Overlap    = 2;
    for idx=1:fftnum
        AFreq = fft( in_time(:, (idx-1)*fftsize+1: ...
                   (idx-1+Overlap)*fftsize),[], 2); 
        BTime = ifft ( AFreq  .* freq_resp, [], 2 );
        cutting = (Overlap-1) * fftsize/2;
        ATime( :, (idx-1)*fftsize+1:(idx)*fftsize) = BTime(:,cutting+1:cutting+fftsize) ;
    end
    out = ATime;
end
