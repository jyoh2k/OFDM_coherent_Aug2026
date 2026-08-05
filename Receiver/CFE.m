function [cfeout] = CFE( AIN, params)
%  Usage      :  [AOUT, cfrout] = CFE( AIN, params)
%
%  Function   :
%     Carrier frequency offset estimation algorithm
%
%  Port
%     1. AIN        : Original signal
%     2. params     : CFE (carrier frquency offset estimation)
%     3. cfoout     : Estimated phase 
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   

    type = params.CFEtype;
    OV   = params.OV;
    PRL  = (floor(size(AIN,2)/OV)-1)*OV;
        
    iPRL =1:OV:PRL;
    phasediff_int1 =0 ;  
    phasediff_int2 =0 ;
    phasediff_f      =0 ;
    phase_offset    = 0;
    if ( type == 1 ) 
        %  1/(2.75/50)/2 = 9 samples 
        max_len = min( params.PRL * 10, size(AIN,2));
        cpe_blk = CPE( AIN(1,1:params.OV:max_len), params);        
        [cpe_blk1] = PhaseCorrection( cpe_blk, params);
        cpe_unwrap = unwrap( cpe_blk1) ;
        phasediff_sample = (cpe_unwrap(params.PRL- params.BLK*2 +1) - (cpe_unwrap(1)))/(params.PRL- params.BLK*2);
    end 
    if ( type == 2 )  %%  
        index1 =  length(params.sync_pattern) * params.OV; 
        second_tr = AIN(1,index1+(1:params.OV:index1));
        cfo_blk = conj(AIN(1,1:params.OV:index1))  .*    second_tr; 
        phasediff = mean(angle(cfo_blk));%angle(sum( cfo_blk ));
        phasediff_sample = phasediff/index1;   
    end
    
    if ( type == 5 )  %% CRT
        crtrep = params.CRTrep;
        % Freq-OS STF is zero-inserted by Lbb; CRT geometry is on native (Lbb=1) grid.
        % Decimate OS samples first, then reuse 144/288 CRT indexing.
        Lbb = 1;
        if isfield(params, 'Lbb') && ~isempty(params.Lbb)
            Lbb = params.Lbb;
        end
        Nstf = 288 * Lbb;                 % [sync sync] length on OS grid
        stf_os = AIN(1, 1:params.OV*crtrep:Nstf*params.OV*crtrep);
        AIN_symbol = stf_os(1:Lbb:end);   % back to native 288-sample STF
        OV_n = 1;                         % native grid
        rep3 =  144 * OV_n;
        idx1_9 = [3:72-9]; idx2_9 = [3+9:72]; interval_9 = 9 * OV_n;
        idx1_16 = 72+[3:72-16]; idx2_16 = 72+[3+16:72]; interval_16 = 16 * OV_n;
        idx1_144 = [3:144]; idx2_144 = 144+[3:144]; interval_144 = 144 * OV_n;
        phasediff_int1    = CPE_diff( AIN_symbol, idx1_9, idx2_9, interval_9);
        phasediff_int2    = CPE_diff( AIN_symbol, idx1_16, idx2_16, interval_16);
        phasediff_f       = CPE_diff( AIN_symbol, idx1_144, idx2_144, interval_144);

        
        cfo_phase_1    = phase2crt( phasediff_int1, rep3   ) ;
        cfo_phase_2    = phase2crt( phasediff_int2, rep3   ) ;
        f_FFO          = phase2crt( phasediff_f, rep3   ); 

        [cfo_phase_9 , out_int1, out_frac1 ] = Get_int( cfo_phase_1, f_FFO,  1 ) ;
        [cfo_phase_16, out_int2, out_frac2 ] = Get_int( cfo_phase_2, f_FFO,  1 ) ;
        [cfo_phase , int1, int2]             = get_crt_9_16( out_int1, out_int2);

        phasediff_sample = crt2phase(cfo_phase + f_FFO, rep3  );
        % Phase per OS sample: native step was 1 sample; OS grid has Lbb samples
        phasediff_sample = phasediff_sample / crtrep / Lbb;
    end
    
    cfeout.phasediff = phasediff_sample;    
    cfeout.phase_offset = phase_offset;
    cfeout.phasediff_int1 = phasediff_int1;
    cfeout.phasediff_int2 = phasediff_int2;
    cfeout.phasediff_f = phasediff_f;
end


function phasediff_sample = CPE_diff( AIN, idx1, idx2, interval)
        first_tr =  AIN(:,idx1); 
        second_tr = AIN(:,idx2);
        cfo_blk = conj(first_tr)  .*    second_tr; 
        phasediff = angle(sum(sum( cfo_blk )));
        phasediff_sample = phasediff/interval;
end


function [ out, out_int, out_frac ] = Get_int( in_coarse, in_fine, unit)
         f_est1 = round( in_coarse*(unit))/(unit)  +  in_fine    ;
         out = round ( (in_coarse-f_est1)*unit)/(unit)  + f_est1    ;
         out_int = round ( (in_coarse-f_est1)*unit) + round( in_coarse*(unit))   ;
         out_frac = f_est1- round( in_coarse*(unit))/(unit)   ;
end



function [out, int_16, int_9] = get_crt_9_16( int_16, int_9 )

    mx1 = 9 ;  mx2 = 16;
    a1  = 64;  a2  =-63;
    M   = mx1 * mx2;
    int_16 = double(int_16);
    int_9  = double(int_9);
    if ( int_16 == 8 ) int_16 = -8 ;end

    out =mod((a1 * mod ( real(int_9) , mx1) + a2 * mod ( real(int_16), mx2)) ,M);
    out = mod((out + M/2 ), M)-M/2;

end

function crt    = phase2crt( phase, rep_frac   ) 
     % phase : crt =  2*pi/rep_frac :  1
      crt = phase /( 2*pi/rep_frac );
end

function phase  = crt2phase( crt, rep_frac ) 
       phase  = crt *( 2*pi/rep_frac );
end
