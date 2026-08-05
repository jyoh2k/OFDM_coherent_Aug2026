function  Nbpsc_sc = load_bit_alloc(params)

Nbpsc_sc = params.Nbpsc_sc;
if (params.NFFT == 128 )
    Nbpsc_sc(1, 65:69) =2; 
end


end 