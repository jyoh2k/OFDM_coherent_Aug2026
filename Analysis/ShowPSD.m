function  [sims] = ShowPSD( sims, params, frame)

%  Usage      : [sims]= ShowPSD( sims, params, frame)
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

     if (sims.show_psd ==0 )
         return;
     end

    if (  isempty(sims.psd_axes)   || ~ ishandle(sims.psd_axes) )
        [sims.psd_axes, sims.psd_text, sims.psdhandle] = PSD();
    end

    received = frame.received ;
    GHz      = 1e9;
    Rs       = params.RXSampleFreq/GHz;
    if ( sims.run_mode == 1 )
    end        
    signals  = frame;
    signals.txsignal =  frame.txsignal; 
    signals.received   = frame.received ; 

    % PSD() 함수에서 반환되는 handles 구조체 사용
    % handles 구조체에서 figure handle 찾기
    if isstruct(sims.psdhandle)
        % figure handle 찾기 (보통 'output' 필드에 있음)
        if isfield(sims.psdhandle, 'output') && ishandle(sims.psdhandle.output)
            set( sims.psdhandle.output, 'UserData', signals);
        end
        
        % psdpopupmenu handle 찾기
        if isfield(sims.psdhandle, 'psdpopupmenu') && ishandle(sims.psdhandle.psdpopupmenu)
            set( sims.psdhandle.psdpopupmenu, 'Value', 1);
        end
    end    
    Welch =1;
    draw_psd (sims.psd_axes, received(1,:), Rs, Welch);
    grid(sims.psd_axes,'on');
    %ylim  (sims.psd_axes, [-90 10]); 
    default_color(sims.psd_axes);
 
end

function draw_psd (axes, in, Rs, Welch) 
    if ( Welch == 0 )
            [pxx,w] = periodogram(in);
        freq = fftshift(fft(in));
        pxx = abs(freq);
        w=[-Rs/2:Rs/length(in): Rs/2-Rs/length(in)];
        plot  ( axes, w,mag2db(pxx/max(pxx)), 'y');
    else
    %     Hs=spectrum.periodogram;
        Hs=spectrum.welch; 
        Hpsd = psd(Hs, in(1,:), 'Fs', Rs, 'CenterDC', true);
        Pw=Hpsd.Data;
        Fw=Hpsd.Frequencies;
        plot(axes, Fw,mag2db(Pw), 'y', 'LineWidth', 2); 
    end
end


