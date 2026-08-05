function [AOUT] = CPR( AIN, phase, params)
%  Usage      :  [AOUT] = CPR( AIN, phase, params, T)
%
%  Function   :
%     Carrier phase compensation
%
%  Port
%     1. AIN        : Original signal
%     2. phase      : Phase to be recovered.
%     3. params     : CPR (carrier phase recovery) parameter
%     4. AOUT       : Compensated signal
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   


    AOUT = AIN  .* (ones(size(AIN,1),1) * exp(-1j * phase(1:size(AIN,2))));

end
