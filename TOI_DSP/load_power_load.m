function  power_sc = load_power_load(params)

power_sc = zeros(params.NTXStream, params.NFFT);
power_sc(1,params.SubcarrierIndex) = params.power_sc(params.NTXStream,params.SubcarrierIndex);
if (params.NFFT == 128 )
    power_sc(1, params.SubcarrierIndex(20:30)) =1.5; 
end


end 
