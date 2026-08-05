function  [sim, frame] = SyncAnalysis( sim, params, frame)

%  Usage      : [sfo]= SyncAnalysis( sim, params, tpr)
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :
if (sim.show_sync == 0 ) 
    return;
end



if (  isempty(sim.sync_axes)   || ~ ishandle(sim.sync_axes) )
    [sim.sync_axes, sim.sync_text, sim.sync_axes1]=TPRFigure();
    set(sim.sync_text, 'String', 'Frame search');
end

%% Autocorrelation 
%if (  params.cfr.CFEtype  ~= 1 )
    metric   = frame.fscs.metric ;
    start_of_frame   = frame.fscs.MaxPos ;
    p = plot  (sim.sync_axes,1:length(metric), metric, 'b',...
                      start_of_frame(1), metric(1,start_of_frame), 'rs');
 
    if ( version('-release') == '2014a')
        set(p,{'LineWidth'},{2;2})
    else 
        p(1).LineWidth =2;p(2).LineWidth =2;
    end
    title (sim.sync_axes,'Autocorrelation');  
    xlim  (sim.sync_axes, [1 length(metric)]); 
    default_color(sim.sync_axes);
%end
%% Cross correlation 
if (  params.searchfineframe.en == 0 )
    return;
end
metric   = frame.fsfs.metric ;
start_of_frame   = frame.fsfs.MaxPos ;

if ( length(start_of_frame) ~= 1 )
    p = plot  (sim.sync_axes1,1:length(metric), metric, 'b',...
                      start_of_frame(1), metric(1,start_of_frame(1)), 'rs', ...
                      start_of_frame(2), metric(1,start_of_frame(2)), 'ys');
    if ( version('-release') == '2014a')
        set(p,{'LineWidth'},{2;2;2})
    else 
        p(1).LineWidth =2;p(2).LineWidth =2;p(3).LineWidth =2;
    end
else
    p = plot  (sim.sync_axes1,1:length(metric), metric, 'b',...
                      start_of_frame(1), metric(1,start_of_frame(1)), 'rs');
    if ( version('-release') == '2014a')
        set(p,{'LineWidth'},{2;2})
    else 
        p(1).LineWidth =2;p(2).LineWidth =2;
    end
end
title (sim.sync_axes1,'Cross correlation');  
xlim  (sim.sync_axes1, [1 length(metric)]); 
 
default_color(sim.sync_axes1);
 
end
