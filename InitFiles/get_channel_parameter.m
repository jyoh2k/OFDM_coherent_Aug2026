function [channel]=  get_channel_parameter ( channel )

    % Fiber Optic Channel
     channel.span =  ceil((channel.fiber_length/channel.edfa.length));
     channel.last_length =  channel.fiber_length -( channel.span-1)*channel.edfa.length;
     if ( channel.Npol == 1) 
         channel.ssmf.PMD = 0;
         channel.dcf.PMD = 0;
         channel.rx_power_split = ...
            [ sqrt(channel.ssmf.power_split2),    sqrt(1-channel.ssmf.power_split2);];

     else 
        if ( channel.PMDtype == 0 )
            channel.ssmf.PMD = channel.ssmf.Dp * sqrt(channel.fiber_length ) ;
        else
            channel.ssmf.PMD = channel.PMD;
        end 
        channel.ssmf.PMD = channel.ssmf.PMD  / (channel.span); 
        PDL  = db2mag(channel.ssmf.PDLdB);

         channel.rx_power_split = ...
            [ cos(channel.ssmf.power_split2 *3.14/2),    sin(channel.ssmf.power_split2 *3.14/2)/ PDL; ...
             -sin(channel.ssmf.power_split2 *3.14/2) ,    cos(channel.ssmf.power_split2 *3.14/2) /PDL;];

     end 
end
