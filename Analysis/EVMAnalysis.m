function  [sims, frame] = EVMAnalysis( sims, params, frame, txsignal)

%  Usage      : frame = EVMAnalysis( sims, params, frame) 
%  Function   : EVM  analysis
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :
       
    %% EVM 
   [txout_if, txsignal1] =TxMain(frame.fecin, sims, params);
    signal    = frame.recovered2(:, 1:end );
    ideal_tx  = txsignal.mapper2(:, 1:end);    
    ideal_rx  = txsignal1.mapper(:, 1:end);
    EVM_sc = zeros(params.NTXStream, params.NFFT);
    DataSubcarrierIndex = [  (params.DataSubcarrierIndex( params.Nsd/2+1:end) ) ...
                                                (params.DataSubcarrierIndex(1:params.Nsd/2) -1) ...
                                               ];
    for ich = 1:params.NTXStream
        for idx=1:(params.Nsd)
            signal_sc = signal(idx:params.Nsd:end);
            ideal_tx_sc = ideal_tx(idx:params.Nsd:end);
            ideal_rx_sc = ideal_rx(idx:params.Nsd:end);
            
            mapper_t.Nbitspersymbol = params.Nbpsc_sc(ich,idx);
            params.mapper_list         = QAMMapperList (  mapper_t) ;
            [EVM_dB, error_const_idx, cmp_length] = calculate_EVM(params, signal_sc, ideal_tx_sc,ideal_rx_sc );
            EVM_sc(ich, DataSubcarrierIndex(idx)) = EVM_dB;
        end
    end 
     
    frame.EVM_sc = EVM_sc;     
    frame.EVM = mean(mean(EVM_sc(:,params.DataSubcarrierIndex)));
    %%
    
        for iaxes=1:params.NTXStream
            if (  isempty(sims.dfe1_axes{iaxes})   || ~ ishandle(sims.dfe1_axes{iaxes}))
                [sims.dfe1_axes{iaxes}, sims.dfe1_text(iaxes), sims.dfe1_axes1(iaxes)]=TPRFigure();
            end

                str = get_string( iaxes, params.NTXStream );
                set(sims.dfe1_text(iaxes), 'String', ['EVM  ', str] );
            %% Estimated channel 
            SubEVMAnalysis(  sims.dfe1_axes{iaxes}, DataSubcarrierIndex, EVM_sc(iaxes,:), params );
            SubEVMAnalysis1(  sims.dfe1_axes1(iaxes), DataSubcarrierIndex, EVM_sc(iaxes,:), params );
        end
        
            for iaxes=1:params.NTXStream
            if (  isempty(sims.dfe1_axes{iaxes})   || ~ ishandle(sims.dfe1_axes{iaxes}))
                [sims.dfe1_axes{iaxes}, sims.dfe1_text(iaxes), sims.dfe1_axes1(iaxes)]=TPRFigure();
            end

                str = get_string( iaxes, params.NTXStream );
                set(sims.dfe1_text(iaxes+2), 'String', ['Bit alloc, Power loading  ', str] );
            %%
            bar(sims.dfe1_axes{iaxes+2}, params.Nbpsc_sc(iaxes,:),1,'y');
            bar(sims.dfe1_axes1(iaxes+2), params.power_sc(iaxes,params.SubcarrierIndex),1,'y');
            default_color(sims.dfe1_axes{iaxes+2}); 
            default_color(sims.dfe1_axes1(iaxes+2)); 
        end
    
end


function  SubEVMAnalysis( dfe_axes, DataSubcarrierIndex, EVM,  params)       
    sft = length(params.SubcarrierIndex1);
    Sc =[  -(  params.NFFT-params.SubcarrierIndex2+1) (params.SubcarrierIndex1-1 )];
     bar(dfe_axes, circshift(-EVM(1, DataSubcarrierIndex), [sft, 0]) ,1,'y')
    xlim(dfe_axes, [1 length(DataSubcarrierIndex)]); 
    default_color(dfe_axes); 
end

function  SubEVMAnalysis1( dfe_axes, DataSubcarrierIndex, EVM,  params)       
    sft = params.NFFT/2;
%     sft = 0;
     Sc = [-params.NFFT/2: params.NFFT/2-1]; 
     bar(dfe_axes,  [-params.NFFT/2: params.NFFT/2-1],  circshift(-EVM, [ 0 params.NFFT/2]), 1, 'y');
    xlim(dfe_axes, [Sc(1) Sc(end)]); 
    default_color(dfe_axes); 
end

function str = get_string( iaxes, NStream ) 
   str{1} = 'X pol';str{2} = 'Y pol';
    str =  str{iaxes};
end 

