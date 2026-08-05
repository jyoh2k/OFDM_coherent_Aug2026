function [AOUT, PhaseNoise]  = AddPhaseNoise( AIN, SampleTime, LineWidth ) 

%  Usage      : [AOUT, PhaseNoise] = AddPhaseNoise( AIN, SampleTime, LineWidth );    
%  Function   :
%     1. Generate phase noise and apply it into original signal.       
%     2. AIN        : Original signal
%     3. SampleTime : Sample time of signal
%     4. LineWidth  : Linewidth
%     5. AOUT       : Signal with phase noise
%     6. PhaseNoise : Generated phase noise
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


    if ( LineWidth == 0 )
        AOUT =AIN;
        PhaseNoise = zeros(1,size(AIN,2));
    else
        var = 2*pi* LineWidth * SampleTime; 
        a = randn([1 size(AIN,2)] ) * sqrt(var);

        PhaseNoise =cumsum(a);        
        AOUT =  AIN .* ( ones(size(AIN,1), 1) *exp( 1j * PhaseNoise ));
    end
    %% normrnd is changed to randn according to the following equation.
% because nromrnd requires the statistics ... toolbox.
%  normrnd(mu, sigma) = randn * sigma + mu 
%
%     The following is changed to cumsum
%         b = zeros(1 ,length(a));        
%         b(1) = a(1);
%         for ii=2:length(a)
%             b(ii) = b(ii-1) + a(ii);
%         end 
