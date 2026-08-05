function  [sims, frame] = BERAnalysis( sims, params, frame, txsignal, ichidx )

%  Usage      : frame = BERAnalysis( sims, params, frame) 
%  Function   : BER analysis
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :
   
     if ( nargin < 5)
         ichidx = 1;
     end 

     global SC
     if SC == 1
        tail = params.Nbitspersymbol * 125;
     else
         tail = params.Nbpsym;
     end
     
%     head = params.Nbitspersymbol_Tr * params.NTrainingSymbol * params.NTXStream+ 1;
    head = 1;
    Tx_uncoded = txsignal.fecout(:,head:end-tail) ;          % Tx FEC output    
    Rx_uncoded = frame.fecin(:,head:end-tail);               % Rx FEC input

    
    [frame.BER, frame.Nbiterr, frame.Ntotal, Ndiff] = calculate_BER_mode( params.blind_mode, Tx_uncoded, Rx_uncoded, params.NTrainingSymbol );
 
    %% Coded BER
    if ( params.fec.en == 1)
        tail = params.Nbitspersymbol * 125;
        head =  params.trainingbits+1;
        Tx_coded = txsignal.dataf(head:end-tail) ;           
        Rx_coded = frame.dataf(head:end-2-tail);             
        [frame.codedBER, frame.codedNbiterr, frame.codedNtotal, Ndiff] = calculate_BER( Tx_coded, Rx_coded );
    else
        frame.codedBER =frame.BER;
        frame.codedNbiterr =  frame.Nbiterr ;
        frame.codedNtotal = frame.Ntotal;
    end
    %% EVM
    head = params.NTrainingSymbol ;    
    tail = 100;
    signal    = frame.recovered(:, head+1:end-tail);
    ideal_tx  = txsignal.mapper(:, head+1:end-tail);

    if ( size(frame.recovered2,1) == 1)
        [EVM_dB, error_const_idx, cmp_length] = calculate_EVM(params, signal, ideal_tx );
        error_const_idx = error_const_idx + head;
        frame.error_const_idx{1} = error_const_idx;
        frame.EVM = EVM_dB;
        frame.EVM_ch = EVM_dB;
    end 
    
    if ( size(frame.recovered2,1) ~= 1)
        frame.error_const_idx   =[];
        for ich=1: size(frame.recovered2,1)
                signal    = frame.recovered2(ich, head+1:end-tail);
                ideal_tx  = txsignal.mapper2(ich, head+1:end-tail);

                [EVM_dB, error_const_idx, cmp_length] = calculate_EVM(params, signal, ideal_tx );
                error_const_idx = error_const_idx+ head;
                frame.EVM_ch(ich) = EVM_dB;
                 frame.error_const_idx{ich} =    error_const_idx ;
        end
        frame.EVM = mean(frame.EVM_ch);
       
    end
    %%
    upper_right_data = complex( max(real(params.mapper_list)),  max(imag(params.mapper_list))); 
    [mapper_list ,mapper_list1, upper_right_data ]=  TxMapperList (  params ) ;
    frame.mapper_tx2 = txsignal.mapper2 ;
    frame.upper_right_data = upper_right_data;

%%
%     frame.txout    = txsignal.txout_ext;
    error_const_idx = frame.error_const_idx{ichidx};
    frame.txsignal    = txsignal;
    frame.txoutclk = params.TXSampleFreq;
    if (sims.show_ber == 0 )
        return ;
    end

    if (  isempty(sims.ber_axes)   || ~ ishandle(sims.ber_axes) )
        [sims.ber_axes, sims.ber_text]=BERFigure();
    end
    nbin = sims.BERanalysis.nbin   ; 
    head = params.NTrainingSymbol ;
    tail     = (params.NTrainingSymbol + cmp_length );
    bin_size = floor ( cmp_length/ nbin);
    xb=[head:bin_size: tail] ;
    idx = 1;
    for ii= xb  
        nb(idx) =  length(intersect( find( error_const_idx < ( ii + bin_size)), find(error_const_idx > ( ii - 1))));
        idx = idx +1 ;
    end
 
    
    bar(sims.ber_axes, xb, nb, 1, 'y');
    %set(sims.ber_text, 'String', 'Error distribution');
    if ( version('-release') ~= '2014a' )
        xticklabels(sims.ber_axes,round(xb/500)*500);
    end
    xlim  (sims.ber_axes, [1  xb(1)+cmp_length]);% cmp_length ]);  
    default_color(sims.ber_axes);
    
end


 function [ BER, Nbiterr, Ntotal, Ndiff] = calculate_BER_mode( blind_mode, TX_ptn, RX_ptn, ptn_length )
     if ( blind_mode == 1)
         RX_ptn1=reshape(RX_ptn,2,size(RX_ptn,2)/2);
         [BER, Nbiterr, Ntotal, Ndiff] = PRBS_sync_func_refsave(RX_ptn1,ptn_length);
     else
         [BER, Nbiterr, Ntotal, Ndiff] = calculate_BER( TX_ptn, RX_ptn ); 
     end
 end
