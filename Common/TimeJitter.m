function [AOUT, jitter_x] = TimeJitter( AIN, Jitter, DownSample, SampleTime)

%  Usage      : AOUT = TimeJitter( AIN, Jitter, DownSample, SampleTime )    
%
%  Function   :
%     1. Add Jitter effect.         
%     2. AIN        : Original signal
%     3. Jitter     : Jitter variance in the unit of second
%     4. DownSample : Downsampling Rate
%     5. SampleTime : Sample time
%     6. AOUT       : Jittered signal
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


    AOUT =AIN;
    if ( Jitter == 0 )
        jitter_x = 0;
      return;    
    else
        x = 1:DownSample:size(AIN,2 );
        jitter_x =  DownSample*(Jitter/SampleTime) * sqrt(2) * (randn(1, size(x,2)));       
        for ii=1:size(AIN,1)
            AOUT(ii,:) = interp1(x,AIN(ii, x), x + jitter_x,'spline');  
        end
    end
