function  disp_result( simout, frameout, sim, params )  
    if nargin < 4
        if nargin < 1
            disp([' || OSNR ||  BER  || EVM  ||']);
        else
            disp2(sim.logfile, [' || OSNR || BER  || EVM  ||']);
        end
        return; 
    end 
    
        if ( sim.en_disp_result == 1 )
            str = '';
            str = [str  ' || ', num2str( sim.X_val ), '  ' ];
            str = [str  ' || ', num2str(mean(simout.BER(1:simout.Totframe))) ];
            str = [str  ' || ', num2str(mean(simout.EVM(1:simout.Totframe))) ];
            str = [str  ' || ', num2str(frameout.cfrout.cfo_est * params.RXSampleFreq /1e6, '%1.2E '), ' MHz' ];
            str = [str  ' || ', num2str(simout.Totframe ), ' Fr.' ];
            disp2(sim.logfile, [ str,    '  || '])
        end
        
        if ( sim.en_disp_result == 2 )
            str = '';
            str = [str  ' || ', num2str( sim.X_val ), '  ' ];
            str = [str  ' || ', num2str(frameout.codedBER) ];
            str = [str  ' || ', num2str(frameout.BER) ];
            str = [str  ' || ', num2str(frameout.EVM) ];
            if ( params.ps.en == 1)
                str = [str  ' || ', num2str(frameout.NGMI) ];
            end
            str = [str  ' || ', num2str(frameout.cfrout.cfo_est * params.RXSampleFreq /1e6, '%1.2E '), ' MHz' ];
            str = [str  ' || ', num2str(frameout.pee , '%1.2E '  ), '  ' ];
            str = [str  ' || ', num2str( mean(  simout.MSTE (1:simout.Totframe)))  ];
            global FIXED_ARCHITECTURE
            if ( FIXED_ARCHITECTURE == 1 )
            str = [str  ' || ', num2str( frameout.agcgain * 2^params.AGC.T.Gain.fracl)  ];
            end
            str = [str  ' || ', num2str(simout.Totframe ), ' Fr. ' ];
            disp2(sim.logfile, [ str,    '  || '])
        end
        if (  ~isempty(sim.evm_text) &&  ishandle(sim.evm_text) )
            mean_EVM = mean(simout.EVM(1:simout.Totframe));
            mean_EVM_Str = num2str(mean_EVM) ;
            set(sim.evm_text, 'String', [ mean_EVM_Str  ' dB'] );
            set(sim.figure_handle.edit5_2, 'String', [ num2str(params.databits) ''] );
            set(sim.figure_handle.edit5_3, 'String', [ num2str(frameout.Nbiterr) ''] );
            mean_BER = num2str(mean(simout.BER(1:simout.Totframe)), '%1.1E ') ;
            set(sim.figure_handle.edit5_4, 'String', [  mean_BER  ] );
            set(sim.figure_handle.text5_4, 'String', [ 'BER(Mea.)' ] );
%             set(sim.figure_handle.edit5_5, 'String', [ num2str(frameout.sfo_ppm) ' ppm'] );
            set(sim.figure_handle.edit5_6, 'String', [ num2str(frameout.cfrout.cfo_est*params.RXSampleFreq/1e6) ' MHz'] );
  
            global SC
            if ( SC == 1 )
                set(sim.figure_handle.text5_7, 'String',  'Pol' );
                [pol_est,pol_est0] =  est_pol( simout, frameout, sim, params )  ;
                set(sim.figure_handle.edit5_7, 'String', [ num2str( floor(pol_est(1) * 180/pi)) ' °'] );
                set(sim.figure_handle.text5_8, 'String',  'Data Rate' );
                data_rate =  params.BaudFreq * params.Nbitspersymbol * params.NTXStream;
                set(sim.figure_handle.edit5_8, 'String', [ num2str( data_rate /1e9) ' Gbps'] );
            else
                set(sim.figure_handle.text5_7, 'String',  'Data Rate' );
                %data_rate =  params.BaudFreq /params.NFFT * 1/(1+params.CP_ratio)* params.Nbpsym;
                data_rate =  params.BaudFreq /params.NSamplepersymbol * params.Nbpsym;
                set(sim.figure_handle.edit5_7, 'String', [ num2str( data_rate /1e9) ' Gbps'] );
            end 

        end
end
 
function [pol_est,pol_est0]  =  est_pol( simout, frameout, sim, params )
     if ( params.PTBC == 1 )
         h = frameout.stbcout.h(:,params.stbc.Npostcursor+1, end);
         pol_est = atan2( abs(h(2)), abs(h(1)))  ;
         pol_est0 = pol_est ;
         return;
     end
     if ( params.NTXStream == 1 )
         pol_est = 0;pol_est0=0;
         return;
     end
      coef0 = (frameout.dfeout.filtercoef( :, params.dfe.Npostcursor+1));
      pol0_1 = atan2(real(coef0(3)),real(coef0(1))) ;
      pol0_2 = atan2(-real(coef0(2)),real(coef0(4)));
      pol_est0 = mean([pol0_1 pol0_2]) ;
      pol_est1= angle(frameout.dfe1out.filtercoef( :, params.dfe1.Npostcursor+1)) ;
      frameout.fsfs.pol_est;
      pol_est = - pol_est0 +   frameout.fsfs.pol_est;
      if ( pol_est > 1 )
          pol_est = pol_est - 2;
      end
      pol_est = pol_est * pi/2 ;
end

