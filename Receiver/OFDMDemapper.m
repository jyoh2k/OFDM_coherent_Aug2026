
function [out]=  OFDMDemapper( in,  params )

%  Usage      : [out]=  OFDMDemapper( in,  params )
%  Function   :
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

 
    if ( params.en_bit_alloc == 1)
        data_symbol = reshape( in, params.NTXStream, params.Nsd, params.NDataSymbol);
        out1 = zeros( params.Nbpsym, params.NDataSymbol);
        for itx=1:params.NTXStream
            for isd=1:params.Nsd 
                demap_t.Nbitspersymbol = params.Nbpsc_sc(itx,isd);
                in1 = reshape(  data_symbol(itx, isd, :),1, params.NDataSymbol);
                out1(params.mapper.sc_index_min(itx,isd):params.mapper.sc_index_max(itx,isd), :) =  ...
                    reshape(QAMDemapper( in1,  demap_t),   params.Nbpsc_sc(itx,isd) , params.NDataSymbol); 
            end 
        end 
        out = reshape(out1, 1,  params.Nbpsym * params.NDataSymbol);
    else
        data_symbol = reshape( in, 1, params.NTXStream * params.Nsd * params.NDataSymbol); 
        out     = QAMDemapper( data_symbol,  params.demap); 
    end 
     
     
end 

