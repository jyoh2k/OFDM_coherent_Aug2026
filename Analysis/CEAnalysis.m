function  [sims, frame] = CEAnalysis( sims, params, frame)

%  Usage      : [sims, frame] = CEAnalysis( sims, params, frame)
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

     
    if (sims.show_ce )
        
        idx_axes = [1:params.NTXStream*params.NRXStream]; 
        
        for iaxes=idx_axes
            if (  isempty(sims.dfe_axes{iaxes})   || ~ ishandle(sims.dfe_axes{iaxes}))
                [sims.dfe_axes{iaxes}, sims.dfe_text(iaxes), sims.dfe_axes1(iaxes)]=TPRFigure();
                str = get_string( iaxes, params.NTXStream );
                set(sims.dfe_text(iaxes), 'String', ['Channel matrix ', str] );
            end

            %% Estimated channel
            H =  squeeze( frame.ce.H_mean( mod(iaxes-1,2)+1, floor((iaxes-1)/2)+1 , :)); 
            H_ISFA =   squeeze( frame.ce.H_ISFA( mod(iaxes-1,2)+1, floor((iaxes-1)/2)+1 , :)); 
            sft = length(params.SubcarrierIndex1);
            SubCEAnalysis1(  sims.dfe_axes{iaxes}, sims.dfe_axes1(iaxes),   circshift(H, [ sft 0]), circshift(H_ISFA,  [ sft 0]), params );
        end
    end
end

function str = get_string( iaxes, NStream )
%  sidx = (is - 1 )* NStream + os ; % equation index 
%  For example, input stream : 3 , output stream:2  
%  sidx = 3: is = 2, os = 1 
    i_num = floor( (iaxes-1) /NStream )+1;
    o_num = mod( iaxes-1, NStream)+1;
    str = [num2str(i_num) , '->', num2str(o_num)];
end 

function  SubCEAnalysis( dfe_axes, dfe_axes1, H ,H_ISFA, params)
    hold(dfe_axes, 'off');
    hold(dfe_axes1, 'off');
    Sc =[  -(  params.NFFT-params.SubcarrierIndex2+1) (params.SubcarrierIndex1-1 )];
    
    p =   plot  (  dfe_axes, Sc, real(H_ISFA), 'y-');
    hold(dfe_axes, 'on');
    p =   plot  (  dfe_axes, Sc, real(H), 'c-');
    title (dfe_axes,'Real channel');  
    default_color(dfe_axes);
    p =   plot  (  dfe_axes1, Sc, imag(H_ISFA), 'y-');
    hold(dfe_axes1, 'on');
    p =   plot  (  dfe_axes1, Sc, imag(H), 'c-');
    title (dfe_axes1,'Real channel');  
    default_color(dfe_axes1);
    ylim(dfe_axes, [-0.1 0.1]); 
    ylim(dfe_axes1, [-0.1 0.1]); 
end



function  SubCEAnalysis1( dfe_axes, dfe_axes1, H ,H_ISFA, params)
    hold(dfe_axes, 'off');
    hold(dfe_axes1, 'off');
    Sc =[  -(  params.NFFT-params.SubcarrierIndex2+1) (params.SubcarrierIndex1-1 )];
    
    p =   plot  (  dfe_axes, Sc, abs(H_ISFA), 'y-');
    hold(dfe_axes, 'on');
    p =   plot  (  dfe_axes, Sc, abs(H), 'c-');
    title (dfe_axes,'amplitude');  
    default_color(dfe_axes);
    p =   plot  (  dfe_axes1, Sc, angle(H_ISFA), 'y-');
    hold(dfe_axes1, 'on');
    p =   plot  (  dfe_axes1, Sc, angle(H), 'c-');
    title (dfe_axes1,'phase');  
    default_color(dfe_axes1);
    ylim(dfe_axes, [-0.1 0.1]); 
    ylim(dfe_axes1, [-2*pi 2*pi]); 
end