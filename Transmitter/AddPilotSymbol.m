function [out]=  AddPilotSymbol( in,  params )

%  Usage      : [out]=  AddPilotSymbol( in,  params )
%  Function   :
%     1. A pilot symbol is attached in every block.
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    if ( params.en == 0 )
        out = in ;
        return
    end

    
   if ( params.en == 1 )
        [d1,d2]=size(in);
        bl = params.block_size_in;
        num_block = ceil(length(in) / bl);
        idx1 = [1:params.block_size_out:num_block*  params.block_size_out];
        idx =setdiff([1:num_block * params.block_size_out], idx1);
        out(:, idx(1:d2)) = in;
        out(:, idx1     ) = params.pilot_symbol;
   end
    
   if ( params.en == 2 )
        [d1,d2]=size(in);
        bl = params.block_size_in;
        num_block = ceil(length(in) / bl);
        idx1 = [1:params.block_size_out:num_block*  params.block_size_out];
        idx =setdiff([1:num_block * params.block_size_out], idx1);
        if ( 1 ) 
            if ( params.Nbitspersymbol > 1) 
                pilotbits    = DataGen( params, length(idx1) * params.Nbitspersymbol * d1,  0 );
            else
                pilotbits    = DataGen( params, length(idx1) * 2 * d1,  0 );
                pilotbits1 = zeros(1,2* length(pilotbits));
                pilotbits1(1,1:2:end) = pilotbits;
                pilotbits  = pilotbits1;
            end
        else 
            pilotbits    = DataGen( params, length(idx1) * params.Nbitspersymbol * d1,  0 );
        end 
        pilot_symbol   = QAMMapper(pilotbits, params);
        params.NTXStream = d1;
        pilot_symbol2   = MultiStreamOut ( pilot_symbol,  params );
        out(:, idx(1:d2)) = in;
        out(:, idx1     ) = pilot_symbol2;
   end
   
   

   if ( params.en == 3 ) % for OFDM
        out = in;
        [d1,d2]=size(in); 
        for ipilot=1:length(params.pilot_index)
            idx1 = [params.pilot_index(ipilot):params.block_size_out:d2];            
            out(:, idx1) = params.pilot_symbol(:, ipilot) * ones(1, length(idx1));
        end
   end
   
    
   if ( params.en == 4 )
        [d1,d2]=size(in);
        bl = params.block_size_in;
        num_block = ceil(length(in) / bl);
        idx1 = [1:params.block_size_out*2:num_block*  params.block_size_out]; 
        idx1= reshape([idx1; idx1+1;],1,size(idx1,2)*2);
        idx =setdiff([1:num_block * params.block_size_out], idx1);
        if ( 1 ) 
            if ( params.Nbitspersymbol > 1) 
                pilotbits_1    = DataGen( params, params.period * params.Nbitspersymbol,  100 );
                tilenum =  ceil ( length(idx1) /params.period);
                pilotbits = repmat(pilotbits_1, [1, tilenum ]);
                pilotbits = pilotbits(1,1:length(idx1) * params.Nbitspersymbol);
            else
                pilotbits    = DataGen( params, length(idx1) * 2,  0 );
                pilotbits1 = zeros(1,2* length(pilotbits));
                pilotbits1(1,1:2:end) = pilotbits;
                pilotbits  = pilotbits1;
            end
        else 
            pilotbits    = DataGen( params, length(idx1) * params.Nbitspersymbol,  0 );
        end 
        pilot_symbol   = QAMMapper(pilotbits, params);
        params.stbc.en = d1-1;
        pilot_symbol2  = STBCEnc( pilot_symbol,  params.stbc );
        out(:, idx(1:d2)) = in;
        out(:, idx1     ) = pilot_symbol2;
   end

end
