function [sims] = DrawSimout( simout, sims, params, new)  

    if ( size(simout.out,1) == 1 )
        return;
    end
    
    if (  isempty(sims.plot_axes{sims.plot_mode})   || ~ ishandle(sims.plot_axes{sims.plot_mode}) ) 
            [sims.plot_axes{sims.plot_mode}, sims.plothandle{sims.plot_mode} ]=GuiPlot();
            hold(sims.plothandle{sims.plot_mode}.axes1, 'off'); 
    end

    if ( new == 1 )
        hold(sims.plothandle{sims.plot_mode}.axes1, 'off');
    end
     
    if ( sims.plot_mode == 1 )
      semilogy  (sims.plothandle{sims.plot_mode}.axes1, sims.X_coor(1:size(simout.out,1)), simout.out(:,1), simout.color, 'LineWidth', 2, 'Display' , simout.legend);
    end
    if ( sims.plot_mode == 2 )
      plot  (sims.plothandle{sims.plot_mode}.axes1, sims.X_coor(1:size(simout.out,1)), simout.out(:,2), simout.color, 'LineWidth', 2, 'Display' , simout.legend);
    end
    if ( sims.plot_mode == 3 )
      semilogy  (sims.plothandle{sims.plot_mode}.axes1, sims.X_coor(1:size(simout.out,1)), simout.out(:,3), simout.color, 'LineWidth', 2, 'Display' , simout.legend);
    end
    if ( sims.plot_mode == 4 )
      plot  (sims.plothandle{sims.plot_mode}.axes1, sims.X_coor(1:size(simout.out,1)), simout.out(:,4), simout.color, 'LineWidth', 1.5, 'Display' , simout.legend);
    end
    if ( sims.plot_mode == 5 )
      plot  (sims.plothandle{sims.plot_mode}.axes1, sims.X_coor(1:size(simout.out,1)), simout.out(:,5), simout.color, 'LineWidth', 1.5, 'Display' , simout.legend);
    end
    
%    legend  ( sims.plothandle{sims.plot_mode}.axes1, ['\color{white} ' simout.legend]);
    if ( sims.plot_mode == 3 )        
        set(sims.plothandle{sims.plot_mode}.text1, 'String', simout.title);
        xlabel(sims.plothandle{sims.plot_mode}.axes1, sims.Xlabel, 'Color',[0 0 0], 'FontSize',14, 'FontWeight','bold');
        ylabel(sims.plothandle{sims.plot_mode}.axes1, sims.Ylabel, 'Color',[0 0 0],'FontSize',14, 'FontWeight','bold');
        set(sims.plothandle{sims.plot_mode}.axes1, 'Color', [ 1 1 1 ]);
        set(sims.plothandle{sims.plot_mode}.figure1, 'Color' ,[1 1 1]); 
        default_colorw(sims.plothandle{sims.plot_mode}.axes1);
        hold(sims.plothandle{sims.plot_mode}.axes1, 'on');
        grid(sims.plothandle{sims.plot_mode}.axes1, 'on');
        set(sims.plothandle{sims.plot_mode}.text1, 'BackgroundColor' ,[1 1 1]); 
        set(sims.plothandle{sims.plot_mode}.text1, 'ForegroundColor' ,[0 0 0]); 
    else
        set(sims.plothandle{sims.plot_mode}.text1, 'String', simout.title);
        xlabel(sims.plothandle{sims.plot_mode}.axes1, sims.Xlabel, 'Color',[1 1 1], 'FontSize',14, 'FontWeight','bold');
        ylabel(sims.plothandle{sims.plot_mode}.axes1, sims.Ylabel, 'Color',[1 1 1],'FontSize',14, 'FontWeight','bold');
        default_color(sims.plothandle{sims.plot_mode}.axes1);
        hold(sims.plothandle{sims.plot_mode}.axes1, 'on');
        set(sims.plothandle{sims.plot_mode}.axes1, 'Color', [0.3 0.3 0.3 ]);
        grid(sims.plothandle{sims.plot_mode}.axes1, 'on');
    end
%     xlim(sims.plothandle{sims.plot_mode}.axes1, [1e-5 1e-3])
end
