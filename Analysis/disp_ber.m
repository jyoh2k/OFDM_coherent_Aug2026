function  disp_ber( BER, dir1, dir2, sims, simout, filename , params, X_coor, draw_new_plot, en_ber, save_file)

if ( en_ber == 1)
    simout.out(:,1)=BER ;
    simout.out(:,3)=BER ;
    simout.legend =[ 'FEC: ' num2str(BER)];
    simout.color = 'g-';
    sims.plot_mode = 1 ;
    sims = DrawSimout( simout, sims, params, draw_new_plot);
    sims.plot_mode = 3 ;
    sims = DrawSimout( simout, sims, params, draw_new_plot);

    [X_coor1, Pb] = Theoretical_BER( X_coor,params);
    simout.legend = 'Ideal';
    simout.out(:, 1) =Pb;
    simout.out(:, 3) =Pb;
    sims.plot_mode = 1 ;
    simout.color = 'yo--';
    sims = DrawSimout( simout, sims, params, draw_new_plot);  
    sims.plot_mode = 3 ;
    simout.color = 'ko--';
    sims = DrawSimout( simout, sims, params, draw_new_plot);  
end

if ( en_ber == 2)
    % simout.out(:,1)=BER ;
    simout.out(:,3)=BER ;
    simout.legend =[ 'FEC: ' num2str(BER)];
    simout.color = 'g-';
    % sims.plot_mode = 1 ;
    % sims = DrawSimout( simout, sims, params, draw_new_plot);
    sims.plot_mode = 3 ;
    sims = DrawSimout( simout, sims, params, draw_new_plot);
end
%     hleg =  legend(get(  sims.plothandle{1}.axes1,'CurrentAxes'),'show');
    % hleg =  legend(  sims.plothandle{1}.axes1,'show');
    % set(hleg,'Color','k','TextColor','yello');
%     hleg =  legend(get(  sims.plothandle{3}.axes1,'CurrentAxes'),'show');
    hleg =  legend(  sims.plothandle{3}.axes1,'show');
    set(hleg,'Color','w','TextColor','black'); 
    file1 ='simcase';
    file1 ='';
    if ( save_file == 1)
            % saveas(sims.plothandle{1}.figure1, [dir1 file1 filename '.fig' ], 'fig');  
            saveas(sims.plothandle{3}.figure1, [dir2 file1  filename '.fig' ], 'fig');  
    end 
    
    if ( save_file == 2) 
            % saveas(sims.plothandle{1}.figure1, [dir1 file1  filename '.fig' ], 'fig');   
%             saveas(gca, [dir1 filename '.png'], 'png');
%             img =getframe(sims.plothandle{1}.figure1);imwrite(img.cdata,  [dir1 file1  filename '.png' ], 'png'); 
%             pause(1);
            saveas(sims.plothandle{3}.figure1, [dir2 file1  filename '.fig' ], 'fig');             
%             img =getframe(sims.plothandle{3}.figure1);imwrite(img.cdata,  [dir2 file1  filename '.png' ], 'png');              
%             saveas(gca, [dir2 filename '.png'], 'png');
    end 
end
