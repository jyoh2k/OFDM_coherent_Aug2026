function [osignal_bw] =  MZMmod( esignal, params )
% MZM 
   if ( strcmp( params.type, 'IMMZM') )
    osignal  = MZM( -real(esignal), real(esignal), params);
   end 
   
   if (strcmp( params.type, 'IQMZM') )
        osignal  = MZM( -real(esignal),  real(esignal), params);
        osignal  = osignal +1j* MZM( -imag(esignal),  imag(esignal), params);
%         osignal  = - osignal;
   end 
      
   if ( strcmp( params.type, 'DDMZM')  )
        osignal  = MZM( real(esignal), imag(esignal), params);
   end    

   osignal = osignal * sqrt(params.launch_power);% * sqrt( 377 /1.5 /80e-6); 
   
   osignal_bw = ChBandwidth( osignal, params.FilterCoef, params.bandwidth_en);
   
end
