function   [sims, params]=  Default()
    
    global SW_PATH
    global  DSP_PATH 
    run( ['Units.m']);
    
    if ( exist('sims') == 0) 
        [sims, params]=  Init(    );        
        load ([SW_PATH 'RunDir/savedState.mat']);
    else
        [sims, params]=  Init ( sims, params  );
    end
    
    defaultStream = RandStream.getGlobalStream;
    defaultStream.State = savedState;
    %%
    sims.show_constellation = 1;
    sims.show_ber  = 1;
    sims.show_cpr  = 1;
    sims.show_sync = 1;
    sims.show_psd  = 0;
    sims.show_ce = 1;
    sims.mode      = 0;  
    sims.X_coor    = [0];
    sims.Ylabel    = 'EVM '; 
    sims.max_num_sim              = 10;
    sims.en_disp_result            = 1; 
    sims.dataf.data_file            = [DSP_PATH 'Ptn/prbs31.txt'];
    %%
    params.BaudFreq = 30*GHz;
    params.RX = 30*GHz;
    params.Nbpsc = 2 ;
    params.TXSampleFreq = params.BaudFreq;
    params.RXSampleFreq = params.BaudFreq;
    params.AWGSampleFreq = params.TXSampleFreq;
    params.OSCFreq  = params.RXSampleFreq;
    params.AWGSampleFreq = 90*GHz; 
    params.OSCFreq  = 80*GHz;
    params.AWGResampleMethod = 1;
    %% RX DSP
    params.searchframe.en = 1;
    params.searchfineframe.en = 1;
    params.searchfineframe.type = 1;
    params.cfr.en = 0;
    %% Channel
    %%
    sims.mode      = 0;
    sims.X_coor    = 0;
    %%
    [sims, params]=  ReInit ( sims, params  );  

end
