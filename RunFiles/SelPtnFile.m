function [ txsignal, params] = SelPtnFile ( testvector, sims, params )  

%  Usage      : [ txsignal, params] = SelPtnFile ( testvector, sims, params )  
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

global DATA_PATH
global SW_PATH

file_name = sims.txdata_filename;

switch (testvector)
    case 1
        %file_name = sims.txdata_file;
        file_name           = [DATA_PATH 'Jul18_30GBaud_0km_fixed/TxPtn_30GBaud_fixed.mat'];
        %file_name =  ([ DATA_PATH1 '2021/20210309_rolo-off sweep/TxPtn.mat']);
    case 2
        file_name           = [  '/mnt/5_ExpData/Tbps_coherent/2022/elecB2B/TxPtn.mat'];
%          file_name           = [ '/home/miroandi/Service/2021/Tbps_coherent_21/Tbps_coherent/2_Matlab/Results/TxPtn.mat'];
    case 3
        file_name           = [  '/mnt/5_ExpData/Tbps_coherent/2022/elecB2B_2/TxPtn.mat'];
    case 4
        file_name           = [  '/mnt/5_ExpData/Tbps_coherent/2022/elecB2B_2/TxPtn.mat'];
    case 5
        file_name           = [ DATA_PATH '2022/20220303/TxPtn.mat'];
    case 6
        file_name           = [ DATA_PATH '2022/20220303/TxPtn.mat'];
    case 7
        file_name           = [ DATA_PATH '2022/May19/TxPtn_STBC_15G.mat'];
    case 8
        file_name           = [ DATA_PATH '2022/May19/TxPtn_dualpol_15G.mat'];
    case {9, 10, 11, 12, 13, 14, 15, 16, 17}
        file_name           = [ DATA_PATH '2022/2022_June02/TxPtn_STBCQPSK30Gb.mat']; 
    case {18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31}
        file_name           = [ DATA_PATH '2022/2022_June02/TxPtn_STBCQPSK30Gb.mat']; 
    case 100
        file_name           = [ DATA_PATH '2022/2022_June02/TxPtn_DPQPSK30Gb.mat']; 
    case { 124,125,126,127,128,129,130,131,132,133,134,135,136,137,138 }
        file_name           = [DATA_PATH '2022/29-Nov-2022/TxPtn.mat'];        
    case { 139,140,141,142,143,144,145,146,147,148,149,150,151,152,153 }
        file_name           = [DATA_PATH '2022/29-Nov-2022/TxPtn.mat'];        
    case { 154,155,156,157,158,159,160,161,162,163,164,165,166,167,168 }
        file_name           = [DATA_PATH '2022/29-Nov-2022/TxPtn.mat'];        
    case { 169,170,171,172,173,174,175,176,177,178,179,180,181,182,183 }
        file_name           = [DATA_PATH '2022/29-Nov-2022/TxPtn.mat'];        
    case { 184,185,186,187,188,189,190,191,192,193,194,195,196,197,198 }
        file_name           = [DATA_PATH '2022/29-Nov-2022/TxPtn.mat'];        
    case { 199,200,201,202,203,204}
        file_name           = [DATA_PATH '2022/29-Nov-2022/TxPtn.mat'];        
    case { 205}
        file_name           = [DATA_PATH '2022/20-Dec-2022_2/TxPtn_DP_16QAM.mat'];   
    case { 206}
        file_name           = [DATA_PATH '2022/20-Dec-2022/TxPtn_DP_QPSK.mat'];       
    case { 207}
        file_name           = [DATA_PATH '2022/15-Feb-2023/TxPtn_20Gbaud.mat'];
    case { 208}
        file_name           = [DATA_PATH '2022/15-Feb-2023/TxPtn_7G.mat'];
    case { 209}
        file_name           = [DATA_PATH '2022/15-Feb-2023/TxPtn_30Gbaud.mat'];
    case { 210}
        file_name           = [DATA_PATH '2022/15-Feb-2023/TxPtn_60Gbad.mat'];
    case { 211}
        file_name           = [DATA_PATH '2023/20230411_set1/TxPtn_30GBaud.mat'];
    case { 212}
        file_name           = [DATA_PATH '2023/20230411_set1/TxPtn_40GBaud.mat'];
    case { 213}
        file_name           = [DATA_PATH '2023/20230411_set1/TxPtn_50GBaud.mat'];
    case { 214}
        file_name           = [DATA_PATH '2023/20230411_set1/TxPtn_60GBaud.mat'];
    case { 215}
        file_name           = [DATA_PATH '2023/20230411_set4_20km/TxPtn.mat'];
    case { 216, 217, 218, 219, 220, 221, 222, 223, 224}
        file_name           = [DATA_PATH '2023/20-Jun-2023/TxPtn.mat'];
    case { 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, ...
           235, 236, 237, 238, 239, 240}
        file_name           = [DATA_PATH 'Jul17_30GBaud_0km/TxPtn_Matched_30GBaud.mat'];
    case { 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, ...
           251, 252, 253, 254, 255, 256}
        file_name           = [DATA_PATH 'Jul17_45GBaud_0km/TxPtn_Matched_45GBaud.mat'];
    case { 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, ...
           267, 268, 269, 270, 271, 272}
        file_name           = [DATA_PATH 'Jul17_60GBaud_0km/TxPtn_Matched_60GBaud.mat'];
    case { 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, ...
           283, 284, 285, 286, 287, 288}
        file_name           = [DATA_PATH 'Jul17_30GBaud_20km/TxPtn_Matched_30GBaud.mat'];
    case { 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, ...
           299, 300, 301, 302, 303, 304}
        file_name           = [DATA_PATH 'Jul17_45GBaud_20km/TxPtn_Matched_45GBaud.mat'];
    case { 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, ...
           315, 316, 317, 318, 319, 320}
        file_name           = [DATA_PATH 'Jul17_60GBaud_20km/TxPtn_Matched_60GBaud.mat'];
    case { 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, ...
           331, 332, 333, 334, 335, 336}
        file_name           = [DATA_PATH 'Jul18_30GBaud_0km/TxPtn_30GBaud.mat'];
    case { 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, ...
           347, 348, 349, 350, 351, 352}
        file_name           = [DATA_PATH 'Jul18_30GBaud_20km/TxPtn_30GBaud.mat'];
    case { 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, ...
           363, 364, 365, 366, 367, 368}
        file_name           = [DATA_PATH 'Jul18_30GBaud_0km_fixed/TxPtn_30GBaud_fixed.mat'];
    case { 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, ...
           379, 380, 381, 382, 383, 384}
        file_name           = [DATA_PATH 'Jul18_30GBaud_20km_fixed/TxPtn_30GBaud_fixed.mat'];
    case { 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, ...
           395, 396, 397, 398, 399, 400}
        file_name           = [DATA_PATH 'Jul18_30GBaud_MatchedOff/TxPtn_30GBaud_MatchedOff.mat'];

    case 500
        file_name = ['/home/miroandi/Service/2024/Tbps_24/Release/20240314_Report/DP_30Gbaud_16QAM_256GSample_2023_Dec_ver/TxPtn.mat'];
    case 501
        file_name = ['/home/miroandi/Service/2024/Tbps_24/Release/20240314_Report/DP_30Gbaud_16QAM_256GSample_2023_Jun_ver/TxPtn.mat'];
    case 502
        file_name = ['/home/miroandi/Service/2024/Tbps_24/Release/20240314_Report/PTBC_30Gbaud_16QAM_256GSample_2023_Dec_ver/TxPtn.mat'];
    case 503
        file_name = ['/home/miroandi/Service/2024/Tbps_24/Release/20240314_Report/PTBC_30Gbaud_16QAM_256GSample_2023_Jun_ver/TxPtn.mat'];

    case 504
        file_name           = [DATA_PATH 'Jul18_30GBaud_0km_fixed/TxPtn_30GBaud_fixed.mat'];
    case 505
        file_name           = [DATA_PATH 'Jul18_30GBaud_0km_fixed/TxPtn_30GBaud_fixed.mat'];
    case 506
        file_name           = [DATA_PATH 'Jul18_30GBaud_0km_fixed/TxPtn_30GBaud_fixed.mat'];


    otherwise
         file_name = sims.txdata_file;
end


if ( exist(file_name)~= 0 )
    load ( file_name );     
    disp2(sims.logfile,  file_name );
else
    error(['Failed to find ' file_name]);
end
        
        
end 
