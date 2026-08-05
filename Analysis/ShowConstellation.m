function  [sim] = ShowConstellation( sim, params, frame)

%  Usage      : [sim]= ShowConstellation( sim, params, frame)
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

 if (sim.show_constellation ==0 )
     return;
 end


 
for iaxes=1:size(frame.recovered2,1) %%min(size(frame.recovered2,1),2)
    if (  isempty(sim.const_axes{iaxes})   || ~ ishandle(sim.const_axes{iaxes}) )
        [sim.const_axes{iaxes}, sim.const_text(iaxes), sim.const_slider(iaxes), sim.consthandle(iaxes)] = Constellations();
        set(sim.const_text(iaxes), 'String', ['Constellation stream', num2str(iaxes)] );
    end

    frame.iaxes = iaxes;
    frame.Nbitspersymbol = params.Nbitspersymbol ;     

  if (sim.show_constellation ==1 )
    SubShowConstellation( sim.const_axes{iaxes}, sim.const_text(iaxes), sim.const_slider(iaxes), sim.consthandle(iaxes), params, frame );
  else % if (sim.show_constellation ==2 )
    SubShowConstellation1( sim.const_axes{iaxes}, sim.const_text(iaxes), sim.const_slider(iaxes), sim.consthandle(iaxes), params, frame );
  end 
end
end

function   SubShowConstellation( const_axes, const_text, const_slider, consthandle, params, frame )
    %if (  isempty(consthandle.figure1) || ~ ishandle(consthandle.figure1) )
        %set( consthandle.figure1, 'UserData', frame);
    %end 
    set( consthandle.popupmenu1, 'Value', 1);
    Step = 0.05;
    MaxStep = 1/Step +1;
    tail = params.Nbitspersymbol * 125;
    equalized = frame.recovered2(frame.iaxes, 1:end-tail) ; 
%     equalized = frame.cfo_recovered_eq(frame.iaxes, 1:2:end-tail) ; 
    
    frame.upper_right_idx = find(frame.mapper_tx2(frame.iaxes,:) ==frame.upper_right_data);
    upper_right_idx = frame.upper_right_idx ; 
    for iInv =1:MaxStep
        slider_inv = (iInv-1)*1.0* Step;

        set( const_slider, 'String',  num2str(iInv));
        set( const_slider,  'Value', slider_inv );

        d = floor(1.0/MaxStep*size(equalized,2));
        x = ( 1:d )+ d*(iInv-1); 
        mapper_list =  TxMapperList (  params) ;
        plot  (const_axes, equalized(:, x), 'y*' );
        hold(const_axes, 'on');
%         plot  (const_axes, equalized(:, intersect(x,upper_right_idx)), 'go' );
        plot  (const_axes, mapper_list, 'ro' ); 
%     histogram2(const_axes, real(equalized(:, x)), imag(equalized(:, x)));%            
        %count=hist2d(real(equalized(1,x)),imag(equalized(1,x)), 100);
        %imagesc( count);
        hold(const_axes, 'off');
        ylim  (const_axes, [-1.7 1.7]); 
        xlim  (const_axes, [-1.7 1.7]); 
        default_color(const_axes);
        pause(0.05);
    end
end


function   SubShowConstellation1( const_axes, const_text, const_slider, consthandle, params, frame )
    set( consthandle.popupmenu1, 'Value', 1);
    tail = params.Nbitspersymbol * 125;
    equalized = frame.recovered2(frame.iaxes, 1:end-tail) ;  
    plot  (const_axes, equalized(:, params.NTrainingSymbol+1:end), 'y*' );
    hold(const_axes, 'off');
    ylim  (const_axes, [-1.7 1.7]); 
    xlim  (const_axes, [-1.7 1.7]); 
    default_color(const_axes); 
end
