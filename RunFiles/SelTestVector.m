function [channelout] = SelTestVector( testvector, simnum, sims, params )  

%  Usage      : [channelout] = SelTestVector( setnumber, simnum, sims, params )  
%
%  Function   :
%     Carrier frequency offset compensation  and phase recovery
%
%  Port  :
%     1. AIN        : Original signal
%     2. params     : CPR parameter
%     3. T          : Reserved for fixed sim.
%     4. AOUT       : Recovered signal
%     5. cprout     : Recovered phase error (For debugging use)
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :
global DATA_PATH

if ( testvector == 0 )
    sims.simnum =  simnum;
    %[channelout] = LeCroy_Scope_Read( sims, params );
    [channelout] = DSO_Read( sims, params );
    disp(['Data loaded from oscilloscope']);
    return;
end 

switch (testvector) 
        
    case 1
        global SW_PATH
        file_name           = [SW_PATH 'FixedData1.mat'];
    case 2
         file_name           = [ '/mnt/5_ExpData/Tbps_coherent/2022/elecB2B/XIXQ_1.mat'];
    case 3
         file_name           = [ '/mnt/5_ExpData/Tbps_coherent/2022/elecB2B_2/0225_1.mat'];
    case 4
        file_name           = [  '/home/miroandi/Service/2021/Tbps_coherent_21/Tbps_coherent/2_Matlab/Results/Test3.mat'];
    case 5
        file_name           = [DATA_PATH '2022/20220303/OptB2B_fiber0_1m/Tbps_03-Mar-2022_PPG_0km' num2str(simnum) '_30.mat'];
    case 6
        file_name           = [DATA_PATH '2022//20220303/OptB2B_Fiber3m/Tbps_03-Mar-2022_PPG_0km' num2str(simnum) '_30.mat'];
    case 7
        file_name           = [ DATA_PATH '2022/May19/Tbps_19-May-2022_STBC_AWG_0km' num2str(simnum)  '_15.mat'];
    case 8
        file_name           = [ DATA_PATH '2022/May19/Tbps_19-May-2022_AWG_0km' num2str(simnum)  '_15.mat'];
    case 9
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_0km/STBC_PPG_4QAM_50GS_30GBaud_0km_0ps_-36dBm_' num2str(simnum)  '.mat'];
    case 10
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_0km/STBC_PPG_4QAM_50GS_30GBaud_0km_0ps_-35dBm_' num2str(simnum)  '.mat'];
    case 11
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_0km/STBC_PPG_4QAM_50GS_30GBaud_0km_0ps_-34dBm_' num2str(simnum)  '.mat'];
    case 12
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_0km/STBC_PPG_4QAM_50GS_30GBaud_0km_0ps_-33dBm_' num2str(simnum)  '.mat'];
    case 13
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_0km/STBC_PPG_4QAM_50GS_30GBaud_0km_0ps_-32dBm_' num2str(simnum)  '.mat'];
    case 14
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_0km/STBC_PPG_4QAM_50GS_30GBaud_0km_0ps_-31dBm_' num2str(simnum)  '.mat'];
    case 15
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_0km/STBC_PPG_4QAM_50GS_30GBaud_0km_0ps_-30dBm_' num2str(simnum)  '.mat'];
    case 16
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_0km/STBC_PPG_4QAM_50GS_30GBaud_0km_0ps_-29dBm_' num2str(simnum)  '.mat'];
    case 17
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_0km/STBC_PPG_4QAM_50GS_30GBaud_0km_0ps_-28dBm_' num2str(simnum)  '.mat'];
    case 18
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km_2/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-35dBm_' num2str(simnum)  '.mat'];
    case 19
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km_2/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-34dBm_' num2str(simnum)  '.mat'];
    case 20
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km_2/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-33dBm_' num2str(simnum)  '.mat'];
    case 21
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km_2/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-32dBm_' num2str(simnum)  '.mat'];
    case 22
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km_2/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-31dBm_' num2str(simnum)  '.mat'];
    case 23
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-30dBm_' num2str(simnum)  '.mat'];
    case 24
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-29dBm_' num2str(simnum)  '.mat'];
    case 25
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-28dBm_' num2str(simnum)  '.mat'];
    case 26
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-27dBm_' num2str(simnum)  '.mat'];
    case 27
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-26dBm_' num2str(simnum)  '.mat'];
    case 28
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-25dBm_' num2str(simnum)  '.mat'];
    case 29
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-24dBm_' num2str(simnum)  '.mat'];
    case 30
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-23dBm_' num2str(simnum)  '.mat'];
    case 31
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-22dBm_' num2str(simnum)  '.mat'];
    case 119
        file_name           = [ DATA_PATH '2022/2022_June02/PPG_20km_2/STBC_PPG_4QAM_50GS_30GBaud_20km_0ps_-31dBm_' num2str(simnum)  '.mat'];
    case 120
        file_name           = [ DATA_PATH '2022/2022_June02/AWG_20km/DP_AWG_4QAM_50GS_30GBaud_20km_0ps_-22dBm_' num2str(simnum)  '.mat'];
    case 121
        file_name           = [ DATA_PATH '2022/2022_June02/AWG_20km/DP_AWG_4QAM_50GS_30GBaud_20km_0ps_-31dBm_' num2str(simnum)  '.mat'];
    case 122
        file_name           = [ DATA_PATH '2022/2022_June02/AWG_20km/DP_AWG_4QAM_50GS_30GBaud_20km_0ps_-31dBm_' num2str(simnum)  '.mat'];
    case 123
        file_name           = [ DATA_PATH '2022/2022_June02/AWG_20km/DP_AWG_4QAM_50GS_30GBaud_20km_0ps_-31dBm_' num2str(simnum)  '.mat'];
    case 124 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-10dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 125 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-11dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 126 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-12dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 127 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-13dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 128 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-14dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 129 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-15dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 130 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-16dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 131 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-17dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 132 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-18dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 133 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-19dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 134 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-20dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 135 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-21dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 136 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-22dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 137 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-23dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 138 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-24dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 139 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-25dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 140 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-26dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 141 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-27dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 142 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-28dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 143 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-29dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 144 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_0km_0ps_-30dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 145 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-13dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 146 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-14dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 147 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-15dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 148 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-16dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 149 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-17dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 150 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-18dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 151 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-19dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 152 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-20dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 153 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-21dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 154 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-22dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 155 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-23dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 156 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-24dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 157 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-25dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 158 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-26dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 159 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-27dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 160 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-28dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 161 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-29dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 162 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_30GBaud_20km_0ps_-30dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 163 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-7dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 164 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-8dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 165 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-9dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 166 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-10dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 167 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-11dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 168 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-12dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 169 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-13dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 170 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-14dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 171 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-15dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 172 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-16dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 173 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-17dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 174 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-18dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 175 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-19dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 176 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-20dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 177 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-21dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 178 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-22dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 179 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-23dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 180 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-24dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 181 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-25dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 182 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-26dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 183 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-27dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 184 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_0km_0ps_-28dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 185 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-11dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 186 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-12dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 187 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-13dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 188 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-14dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 189 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-15dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 190 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-16dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 191 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-17dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 192 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-18dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 193 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-19dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 194 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-20dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 195 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-21dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 196 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-22dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 197 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-23dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 198 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-24dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 199 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-25dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 200 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-26dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 201 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-27dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 202 
        file_name           = [DATA_PATH '2022/29-Nov-2022/PTBC_AWG_16QAM_160GS_60GBaud_20km_0ps_-28dBm_' num2str(simnum) '_cal_SRRC0.1.mat' ];
    case 205 
        file_name           = [DATA_PATH '2022/20-Dec-2022_2/Opticore(ITLA)_AWG_16QAM_80GS_30GBaud_0km_0ps_-' num2str(simnum * 2 +8) 'dBm_1.mat' ];
    case 206 
        file_name           = [DATA_PATH '2022/20-Dec-2022/Opticore(ITLA)_AWG_4QAM_80GS_30GBaud_0km_0ps_-' num2str(simnum * 2 +14) 'dBm_1.mat' ];
    case 207 
        file_name           = [DATA_PATH '2022/15-Feb-2023/16QAM_20Gbaud_skew_160GS.mat'];
    case 208 
        file_name           = [DATA_PATH '2022/15-Feb-2023/16QAM_7Gbaud_skew_160GS.mat'];
    case 209 
        file_name           = [DATA_PATH '2022/15-Feb-2023/16QAM_30Gbaud_skew_160GS.mat'];
    case 210 
        file_name           = [DATA_PATH '2022/15-Feb-2023/16QAM_60Gbaud_skew_160GS.mat'];
    case 211 
        file_name           = [DATA_PATH '2023/20230411_set1/save1/TeraHertz11-Apr-2023_OFDM_AWG_0km' num2str(simnum) '_30.mat'];
    case 212 
        file_name           = [DATA_PATH '2023/20230411_set1/save2/TeraHertz11-Apr-2023_OFDM_AWG_0km' num2str(simnum) '_40.mat'];
    case 213 
        file_name           = [DATA_PATH '2023/20230411_set1/save3/TeraHertz11-Apr-2023_OFDM_AWG_0km' num2str(simnum) '_50.mat'];
    case 214 
%         simnum =4;
        file_name           = [DATA_PATH '2023/20230411_set1/save4/TeraHertz11-Apr-2023_OFDM_AWG_0km' num2str(simnum) '_60.mat'];
    case 215 
        file_name           = [DATA_PATH '2023/20230411_set4_20km/TeraHertz11-Apr-2023_OFDM_AWG_0km' num2str(simnum) '_30.mat'];
    case 216 
        file_name           = [DATA_PATH '2023/20-Jun-2023/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 217 
        file_name           = [DATA_PATH '2023/20-Jun-2023/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 218 
        file_name           = [DATA_PATH '2023/20-Jun-2023/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 219 
        file_name           = [DATA_PATH '2023/20-Jun-2023/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 220 
        file_name           = [DATA_PATH '2023/20-Jun-2023/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 221 
        file_name           = [DATA_PATH '2023/20-Jun-2023/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 222 
        file_name           = [DATA_PATH '2023/20-Jun-2023/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 223 
        file_name           = [DATA_PATH '2023/20-Jun-2023/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-15dBm_' num2str(simnum) '.mat'];

    case 224 
        file_name           = [DATA_PATH '2023/20-Jun-2023/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-25dBm_err_' num2str(simnum) '.mat'];

    case 225
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 226
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-29dBm_' num2str(simnum) '.mat'];
    case 227
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-28dBm_' num2str(simnum) '.mat'];
    case 228
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-27dBm_' num2str(simnum) '.mat'];
    case 229
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-26dBm_' num2str(simnum) '.mat'];
    case 230
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 231
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-24dBm_' num2str(simnum) '.mat'];
    case 232
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-23dBm_' num2str(simnum) '.mat'];
    case 233
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-22dBm_' num2str(simnum) '.mat'];
    case 234
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-21dBm_' num2str(simnum) '.mat'];
    case 235
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 236
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-19dBm_' num2str(simnum) '.mat'];
    case 237
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-18dBm_' num2str(simnum) '.mat'];
    case 238
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-17dBm_' num2str(simnum) '.mat'];
    case 239
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-16dBm_' num2str(simnum) '.mat'];
    case 240
        file_name = [DATA_PATH 'Jul17_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 241
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 242
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-29dBm_' num2str(simnum) '.mat'];
    case 243
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-28dBm_' num2str(simnum) '.mat'];
    case 244
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-27dBm_' num2str(simnum) '.mat'];
    case 245
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-26dBm_' num2str(simnum) '.mat'];
    case 246
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 247
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-24dBm_' num2str(simnum) '.mat'];
    case 248
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-23dBm_' num2str(simnum) '.mat'];
    case 249
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-22dBm_' num2str(simnum) '.mat'];
    case 250
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-21dBm_' num2str(simnum) '.mat'];
    case 251
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 252
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-19dBm_' num2str(simnum) '.mat'];
    case 253
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-18dBm_' num2str(simnum) '.mat'];
    case 254
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-17dBm_' num2str(simnum) '.mat'];
    case 255
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-16dBm_' num2str(simnum) '.mat'];
    case 256
        file_name = [DATA_PATH 'Jul17_45GBaud_0km/PTBC_AWG_16QAM_256GS_45GBaud_0km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 257
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 258
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-29dBm_' num2str(simnum) '.mat'];
    case 259
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-28dBm_' num2str(simnum) '.mat'];
    case 260
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-27dBm_' num2str(simnum) '.mat'];
    case 261
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-26dBm_' num2str(simnum) '.mat'];
    case 262
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 263
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-24dBm_' num2str(simnum) '.mat'];
    case 264
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-23dBm_' num2str(simnum) '.mat'];
    case 265
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-22dBm_' num2str(simnum) '.mat'];
    case 266
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-21dBm_' num2str(simnum) '.mat'];
    case 267
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 268
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-19dBm_' num2str(simnum) '.mat'];
    case 269
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-18dBm_' num2str(simnum) '.mat'];
    case 270
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-17dBm_' num2str(simnum) '.mat'];
    case 271
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-16dBm_' num2str(simnum) '.mat'];
    case 272
        file_name = [DATA_PATH 'Jul17_60GBaud_0km/PTBC_AWG_16QAM_256GS_60GBaud_0km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 273
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 274
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-29dBm_' num2str(simnum) '.mat'];
    case 275
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-28dBm_' num2str(simnum) '.mat'];
    case 276
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-27dBm_' num2str(simnum) '.mat'];
    case 277
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-26dBm_' num2str(simnum) '.mat'];
    case 278
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 279
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-24dBm_' num2str(simnum) '.mat'];
    case 280
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-23dBm_' num2str(simnum) '.mat'];
    case 281
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-22dBm_' num2str(simnum) '.mat'];
    case 282
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-21dBm_' num2str(simnum) '.mat'];
    case 283
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 284
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-19dBm_' num2str(simnum) '.mat'];
    case 285
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-18dBm_' num2str(simnum) '.mat'];
    case 286
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-17dBm_' num2str(simnum) '.mat'];
    case 287
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-16dBm_' num2str(simnum) '.mat'];
    case 288
        file_name = [DATA_PATH 'Jul17_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 289
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 290
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-29dBm_' num2str(simnum) '.mat'];
    case 291
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-28dBm_' num2str(simnum) '.mat'];
    case 292
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-27dBm_' num2str(simnum) '.mat'];
    case 293
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-26dBm_' num2str(simnum) '.mat'];
    case 294
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 295
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-24dBm_' num2str(simnum) '.mat'];
    case 296
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-23dBm_' num2str(simnum) '.mat'];
    case 297
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-22dBm_' num2str(simnum) '.mat'];
    case 298
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-21dBm_' num2str(simnum) '.mat'];
    case 299
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 300
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-19dBm_' num2str(simnum) '.mat'];
    case 301
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-18dBm_' num2str(simnum) '.mat'];
    case 302
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-17dBm_' num2str(simnum) '.mat'];
    case 303
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-16dBm_' num2str(simnum) '.mat'];
    case 304
        file_name = [DATA_PATH 'Jul17_45GBaud_20km/PTBC_AWG_16QAM_256GS_45GBaud_20km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 305
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 306
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-29dBm_' num2str(simnum) '.mat'];
    case 307
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-28dBm_' num2str(simnum) '.mat'];
    case 308
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-27dBm_' num2str(simnum) '.mat'];
    case 309
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-26dBm_' num2str(simnum) '.mat'];
    case 310
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 311
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-24dBm_' num2str(simnum) '.mat'];
    case 312
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-23dBm_' num2str(simnum) '.mat'];
    case 313
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-22dBm_' num2str(simnum) '.mat'];
    case 314
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-21dBm_' num2str(simnum) '.mat'];
    case 315
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 316
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-19dBm_' num2str(simnum) '.mat'];
    case 317
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-18dBm_' num2str(simnum) '.mat'];
    case 318
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-17dBm_' num2str(simnum) '.mat'];
    case 319
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-16dBm_' num2str(simnum) '.mat'];
    case 320
        file_name = [DATA_PATH 'Jul17_60GBaud_20km/PTBC_AWG_16QAM_256GS_60GBaud_20km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 321
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 322
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-29dBm_' num2str(simnum) '.mat'];
    case 323
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-28dBm_' num2str(simnum) '.mat'];
    case 324
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-27dBm_' num2str(simnum) '.mat'];
    case 325
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-26dBm_' num2str(simnum) '.mat'];
    case 326
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 327
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-24dBm_' num2str(simnum) '.mat'];
    case 328
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-23dBm_' num2str(simnum) '.mat'];
    case 329
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-22dBm_' num2str(simnum) '.mat'];
    case 330
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-21dBm_' num2str(simnum) '.mat'];
    case 331
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 332
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-19dBm_' num2str(simnum) '.mat'];
    case 333
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-18dBm_' num2str(simnum) '.mat'];
    case 334
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-17dBm_' num2str(simnum) '.mat'];
    case 335
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-16dBm_' num2str(simnum) '.mat'];
    case 336
        file_name = [DATA_PATH 'Jul18_30GBaud_0km/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 337
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 338
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-29dBm_' num2str(simnum) '.mat'];
    case 339
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-28dBm_' num2str(simnum) '.mat'];
    case 340
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-27dBm_' num2str(simnum) '.mat'];
    case 341
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-26dBm_' num2str(simnum) '.mat'];
    case 342
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 343
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-24dBm_' num2str(simnum) '.mat'];
    case 344
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-23dBm_' num2str(simnum) '.mat'];
    case 345
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-22dBm_' num2str(simnum) '.mat'];
    case 346
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-21dBm_' num2str(simnum) '.mat'];
    case 347
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-20dBm_' num2str(simnum+8) '.mat'];
    case 348
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-19dBm_' num2str(simnum) '.mat'];
    case 349
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-18dBm_' num2str(simnum) '.mat'];
    case 350
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-17dBm_' num2str(simnum) '.mat'];
    case 351
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-16dBm_' num2str(simnum) '.mat'];
    case 352
        file_name = [DATA_PATH 'Jul18_30GBaud_20km/PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 353
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 354
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-29dBm_' num2str(simnum) '.mat'];
    case 355
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-28dBm_' num2str(simnum) '.mat'];
    case 356
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-27dBm_' num2str(simnum) '.mat'];
    case 357
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-26dBm_' num2str(simnum) '.mat'];
    case 358
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 359
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-24dBm_' num2str(simnum) '.mat'];
    case 360
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-23dBm_' num2str(simnum) '.mat'];
    case 361
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-22dBm_' num2str(simnum) '.mat'];
    case 362
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-21dBm_' num2str(simnum) '.mat'];
    case 363
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 364
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-19dBm_' num2str(simnum) '.mat'];
    case 365
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-18dBm_' num2str(simnum) '.mat'];
    case 366
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-17dBm_' num2str(simnum) '.mat'];
    case 367
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-16dBm_' num2str(simnum) '.mat'];
    case 368
        file_name = [DATA_PATH 'Jul18_30GBaud_0km_fixed/_fixed_PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 369
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 370
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-29dBm_' num2str(simnum) '.mat'];
    case 371
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-28dBm_' num2str(simnum) '.mat'];
    case 372
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-27dBm_' num2str(simnum) '.mat'];
    case 373
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-26dBm_' num2str(simnum) '.mat'];
    case 374
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 375
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-24dBm_' num2str(simnum) '.mat'];
    case 376
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-23dBm_' num2str(simnum) '.mat'];
    case 377
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-22dBm_' num2str(simnum) '.mat'];
    case 378
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-21dBm_' num2str(simnum) '.mat'];
    case 379
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 380
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-19dBm_' num2str(simnum) '.mat'];
    case 381
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-18dBm_' num2str(simnum) '.mat'];
    case 382
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-17dBm_' num2str(simnum) '.mat'];
    case 383
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-16dBm_' num2str(simnum) '.mat'];
    case 384
        file_name = [DATA_PATH 'Jul18_30GBaud_20km_fixed/(fixed)PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 385
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-30dBm_' num2str(simnum) '.mat'];
    case 386
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-29dBm_' num2str(simnum) '.mat'];
    case 387
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-28dBm_' num2str(simnum) '.mat'];
    case 388
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-27dBm_' num2str(simnum) '.mat'];
    case 389
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-26dBm_' num2str(simnum) '.mat'];
    case 390
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-25dBm_' num2str(simnum) '.mat'];
    case 391
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-24dBm_' num2str(simnum) '.mat'];
    case 392
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-23dBm_' num2str(simnum) '.mat'];
    case 393
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-22dBm_' num2str(simnum) '.mat'];
    case 394
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-21dBm_' num2str(simnum) '.mat'];
    case 395
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-20dBm_' num2str(simnum) '.mat'];
    case 396
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-19dBm_' num2str(simnum) '.mat'];
    case 397
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-18dBm_' num2str(simnum) '.mat'];
    case 398
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-17dBm_' num2str(simnum) '.mat'];
    case 399
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-16dBm_' num2str(simnum) '.mat'];
    case 400
        file_name = [DATA_PATH 'Jul18_30GBaud_MatchedOff/PTBC_AWG_16QAM_256GS_30GBaud_0km_0ps_-15dBm_' num2str(simnum) '.mat'];
    case 500
        file_name = ['/home/miroandi/Service/2024/Tbps_24/Release/20240314_Report/DP_30Gbaud_16QAM_256GSample_2023_Dec_ver/DP_AWG_16QAM_256GS_30GBaud.mat'];
    case 501
        file_name = ['/home/miroandi/Service/2024/Tbps_24/Release/20240314_Report/DP_30Gbaud_16QAM_256GSample_2023_Jun_ver/DP_AWG_16QAM_256GS_30GBaud.mat'];
    case 502
        file_name = ['/home/miroandi/Service/2024/Tbps_24/Release/20240314_Report/PTBC_30Gbaud_16QAM_256GSample_2023_Dec_ver/PTBC_AWG_16QAM_256GS_30GBaud.mat'];
    case 503
        file_name = ['/home/miroandi/Service/2024/Tbps_24/Release/20240314_Report/PTBC_30Gbaud_16QAM_256GSample_2023_Jun_ver/PTBC_AWG_16QAM_256GS_30GBaud.mat'];
    case 504
        file_name = ['/home/miroandi/Service/2024/Tbps_24/Release/FPGA_PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps.mat'];
    case 505
        file_name = ['/home/miroandi/Service/2024/Tbps_24/Release/FPGA_PTBC_AWG_16QAM_256GS_30GBaud_20km_0ps_Aug06.mat'];
    case 506
        file_name = ['/home/miroandi/Service/2024/Tbps_24/Release/EB2B_error.mat'];

    otherwise
        file_name           = [DATA_PATH '../../Results/sim/2020/OSNR8_PN1MHz.mat'];
end

if ( exist(file_name)~= 0 )
    load ( file_name ); 
%     channelout = conj( channelout); 
    if ( testvector > 8  & testvector < 207) 

            if ( params.PTBC == 0)
                channelout =[transpose(mode1_X);transpose(mode1_Y);];
            else
                channelout =  transpose(mode1_X);
            end
 
    end 
    if ( testvector > 216  & testvector < 225) 
        channelout =transpose(channelout(1,:)');
    end 
    disp2(sims.logfile,  file_name );
else
    error(['Failed to find ' file_name]);
end
    
 
