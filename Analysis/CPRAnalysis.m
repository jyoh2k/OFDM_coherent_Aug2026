function  [sims, frameout] = CPRAnalysis( sims, params, frameout)

%  Usage      : [sfo]= CPRAnalysis( sims, params, tpr)
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


    frameout.cfrout.cfe = frameout.cfrout.cfe + frameout.fsfs.phaseoffset;
    frameout.fee = [ frameout.cfrout.cfo_est* params.RXSampleFreq - sims.channel.CarrierFreqOff , 0] ;
    frameout.cfrout.rcfo_est =0;

    cpr   = frameout.cprout;
    PRL = params.cpr.BLK ;
    phase = cpr.phase(1,1:PRL:end) ;
    phase_cfe = frameout.cfrout.cfe ;
%     phase_cfe = frameout.cfrout.cfe(1,1: params.cfr.PRL:end) ;
    cpe_blk = cpr.cpe_blk(1,1:PRL:end) ;
    acc = cpr.acc_error(1,:) ;
     
    %% Estimated accumulated timing error 
    est = mod(phase,1);
%     if ( sims.run_mode == 1 )
%         pn = sims.channel.PhaseOffset;
%         pn = pn + RateConversion((sims.txpn + sims.rxpn), sims.channel.SampleFreq,  params.RXSampleFreq); 
%         stidx =  length(params.sync_pattern ) * params.RXoversample * 2+ 1 ;
% %         stidx = stidx + PRL /2;
% %         exp1 = pn(stidx:PRL:end)  ;
%         stidx = stidx ;
%         exp1 = pn(stidx:1:end)  ;
%         frameout.cfrout.rcfo_est =sims.channel.CarrierFreqOff /params.RXSampleFreq  -frameout.cfrout.cfo_est ;  
%         exp1  = exp1 + frameout.cfrout.rcfo_est *2*pi * [1:length(exp1)];
% %         exp_diff  = [exp1]-[zeros(size(exp1(:,1))) exp1(:,1:end-1)]; 
%         exp2 =  exp1;
% %         exp2 =  exp2 - exp2(1);
%         diff_phase1 = (ones(size(cpr.phase,1),1) *exp2- (cpr.phase+cpr.cpe_blk));
%         diff_phase = mod( diff_phase1 +pi/4, pi/2)-pi/4;  
%         diff_phase = diff_phase(1,:);
%         diff_phase1 = diff_phase1(1,:);
%         frameout.pee = mean(diff_phase  .^2); 
%         frameout.mse_pe = mean(diff_phase  .^2); 
%         frameout.mean_pe = mean(diff_phase ); 
%         frameout.var_pe  = var(diff_phase);          
%         frameout.pee1 = mean(diff_phase1  .^2); 
%         frameout.mse_pe1 = mean(diff_phase1  .^2); 
%         frameout.mean_pe1 = mean(diff_phase1 ); 
%         frameout.var_pe1 = var(diff_phase1); 
%         diff_phase1_mod  = round(diff_phase1/(pi/2));
%         cyclic_slip =  diff_phase1_mod(2:end) - diff_phase1_mod(1:end-1) ;
%         cyclic_slip_cnt = length( find(abs(cyclic_slip) > 0.9));
%         frameout.cyclic_slip_rate = cyclic_slip_cnt/length(cyclic_slip);
%          frameout.totphase = length(cyclic_slip);
% %         cyclic_slip =  diff_phase1_mod(2:end) - diff_phase1_mod(1:end-1) ;
% %         cyclic_slip_cnt = length( find(cyclic_slip > ( pi/2-0.3)));
% %         diff_phase = mod( diff_phase1 +pi , pi*2)-pi;  
% %         figure;hist(diff_phase,20);
%     else
        exp1 = 0 ;
        idx=1:size(phase(1,1:PRL:end),2);
        P = polyfit(idx,phase(1,1:PRL:end)+cpe_blk(1,1:PRL:end),1); 
        exp2 = P(1) * idx + P(2);       
        frameout.cfrout.rcfo_est = P(1) / ( PRL)/pi /2;
        frameout.pee = 0;
%     end
    
    if (sims.show_cpr == 0 )    
        return;
    end
    
    %         exp1 = exp1 + sims.channel.CarrierFreqOff / params.RXSampleFreq* params.cpr.PRL*( 0:length(exp1)-1) * 2 *pi ; 
    if (  isempty(sims.cpr_axes)   || ~ ishandle(sims.cpr_axes) )
        [sims.cpr_axes, sims.cpr_text, sims.cpr_axes1]=TPRFigure();
        set(sims.cpr_text, 'String', 'Phase error recovery');
    end

    xidx = 1:PRL:length(phase)*PRL;
    xidx1= 1:PRL:length(phase_cfe)*PRL;
    xidx2= 1:PRL:length(exp2)*PRL;
    xidx3= 1:PRL:length(est)*PRL;
    p = plot  (sims.cpr_axes, ...
        xidx,  unwrap(phase+cpe_blk), 'r',...  % phase noise 
        xidx1, (phase_cfe )*0,  'y',... % CFO  
        xidx2, exp2, 'b--');
    if ( version('-release') == '2014a')
        set(p,{'LineWidth'},{2;2;2})
    else 
        p(1).LineWidth =2;p(2).LineWidth =2;p(3).LineWidth =2;
    end
    title (sims.cpr_axes,'Phase');  
    xlim  (sims.cpr_axes, [1 xidx3(end)]); 
    default_color(sims.cpr_axes);

    %% Estimated timing error 
    r1   = phase * 1;
    r2   = params.cpr.K1*cpe_blk;
    r2   = r2 - [r2(2:end) r2(end)];
    r3   = params.cpr.K2*acc;
    ll3  = length(r3);
    xidx = 1:PRL:ll3*PRL;

    if ( ~isempty(sims.cpr_axes1)   &&  ishandle(sims.cpr_axes1) )
        p =   plot  (  sims.cpr_axes1, ...
             xidx, unwrap(r2(1:ll3)), 'g' ,  ...
             xidx, r3(1:ll3), 'y');
        if ( version('-release') == '2014a')
            set(p,{'LineWidth'},{2;2})
        else 
            p(1).LineWidth =2;p(2).LineWidth =2;
        end
        title(sims.cpr_axes1,'Estimated timing error');
    
        xlim(sims.cpr_axes1, [1 xidx(end)]);
        default_color(sims.cpr_axes1);
    end
    %%
    if ( sims.run_mode == 1 )
    set(sims.cpr_text, 'String', ...
        [ 'Exp ' num2str(sims.channel.CarrierFreqOff/1e9, '%1.3E GHz')    ...
          ' Est ' num2str(  frameout.cfrout.cfo_est * params.RXSampleFreq /1e9, '%1.3E GHz') ]);
    else
    set(sims.cpr_text, 'String', ...
        [ 'Exp ' num2str(frameout.cfrout.rcfo_est * params.RXSampleFreq /1e9, '%1.3E GHz')    ...
          ' Est ' num2str(  frameout.cfrout.cfo_est * params.RXSampleFreq /1e9, '%1.3E GHz') ]);
    end  
end
