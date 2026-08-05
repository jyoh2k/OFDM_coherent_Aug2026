function  [sims, frame] = TPRAnalysis( sims, params, frame)

%  Usage      : [sims, frame]= TPRAnalysis( sims, params, tpr)
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :
if (sims.show_tpr == 0 )
    frame.tee = [ 0, 0] ;
    return;
end
    tpr   = frame.tprout;
    tau   = tpr.tau ;
    acc   = tpr.acc ;
    phase = tpr.phase ;

    idx=130:length(tau);
    P = polyfit(idx,tau(idx),1);
    % sfo = - P(1)/1e-6;
    % sfo_init =  P(2) ;
    sfo = P ;
    frame.sfo = sfo;
    frame.sfo_ppm = P(1)/params.tpr.PRL/1e-6;

    
    if (  isempty(sims.tau_axes)   || ~ ishandle(sims.tau_axes) )
            [sims.tau_axes, sims.tau_text, sims.ter_axes]=TPRFigure();
        end

        %% Estimated accumulated timing error 
        est = mod(tau,1);
        if ( sims.run_mode == 1 )
            exp1 = sims.channel.TimePhaseOff +sims.channel.TimeFreqOff*params.tpr.PRL*( 0:length(tau)-1) +0.5;
            exp = mod( -exp1,1);
        else 
            exp1 =- sfo(2)  - sfo(1) *( 0:length(tau)-1) +0.5;
            exp = mod( -exp1,1);
	end
        PRL = params.tpr.PRL;
        xidx = 1:PRL:length(tau)*PRL ;
        p = plot  (sims.tau_axes,xidx, est, 'r', xidx, exp, 'b-');
        p = plot  (sims.tau_axes,xidx, tau, 'r', xidx, -exp1, 'b-');
        if ( version('-release') == '2014a')
            set(p,{'LineWidth'},{2;2})
        else 
            p(1).LineWidth =2;p(2).LineWidth =2;
        end
        title (sims.tau_axes,'Tau');  
%         ylim  (sims.tau_axes, [-0.5 1.5]); 
        xlim  (sims.tau_axes, [1 xidx(end)]); 
        default_color(sims.tau_axes);
        %% Estimated timing error 
        r1   = tau * 1;
        r2   = params.tpr.K1*phase;
%         r2   = phase ;
        r3   = params.tpr.K2*acc;
        ll3  = length(r3);
        xidx = 1:PRL:ll3*PRL ;

    if (  ~isempty(sims.ter_axes)   &&  ishandle(sims.ter_axes) )
        p =   plot  (  sims.ter_axes, ...
                 xidx, r2(1:ll3), 'g' ,  ...
                 xidx, r3(1:ll3), 'y');
        if ( version('-release') == '2014a')
            set(p,{'LineWidth'},{2;2})
        else 
            p(1).LineWidth =2;p(2).LineWidth =2;
        end
        title(sims.ter_axes,'Estimated timing error');
         
        xlim(sims.ter_axes, [1 xidx(end)]);
        default_color(sims.ter_axes);
    end 

%     frame.tee = [ mean(tpr.phase),var(tpr.phase)] ;
    tee = tau + exp1 - 0.5;
    tee = tee(200:end);
    frame.tee = [ sqrt(mean(tee.^2)),var(tee)] ;
 
end
