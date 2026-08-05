function out  = MZM( V1, V2, MZmod)

%  Usage      : out  = MZM( in, MZmod, G  )
%  Function   :
%     1.       G: Extinction ratio
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


    % Mache-Zender modulator   
    % laser.launch_power/2 ; 
    % power sum of two polarization = laser.launch_power
    % each polarization : laser.launch_power/2 
    out    = ( ...
      exp( 1j*pi/MZmod.Vpi_RF * V1 + 1j*pi*MZmod.Vbias1 /MZmod.Vpi_DC )+ ...
      MZmod.G * exp( 1j*pi/MZmod.Vpi_RF * V2 + 1j*pi*MZmod.Vbias2 /MZmod.Vpi_DC )); 
      out    = out  * 2  /( 1+ MZmod.G);
    
end 
