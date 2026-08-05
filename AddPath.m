
global SW_DEBUG_ONLY
SW_DEBUG_ONLY = 0;
global FIXED_ARCHITECTURE
FIXED_ARCHITECTURE = 0;
global SC
SC = 0;  %1;

global  DSP_PATH
if ( SW_DEBUG_ONLY == 1 )
    currentFolder = [ pwd, filesep ] ;
    DSP_PATH=[ currentFolder '..' filesep  '..' filesep 'DSP_Platform' filesep ];
%     DSP_PATH=currentFolder;    
else
    currentFolder = [ pwd, filesep ] ;
    DSP_PATH=currentFolder;
end


addpath( [ DSP_PATH 'Analysis']  );
addpath( [ DSP_PATH 'Common' ] );
addpath( [ DSP_PATH 'Filters' ] );
addpath( [ DSP_PATH 'Receiver'] );
addpath( [ DSP_PATH 'Transmitter'] );
addpath( [ DSP_PATH 'Components'] );
% addpath( [ DSP_PATH 'ProbabilityShaping'] );
% addpath( [ DSP_PATH 'FEC']);
addpath( [ DSP_PATH 'GUI'] );
addpath( [ DSP_PATH 'PtnGen'] );
addpath( [ DSP_PATH 'Measurement'] )
% if ( FIXED_ARCHITECTURE == 1 )
%     addpath( [ DSP_PATH 'Fixed'] );
% end


global  SW_PATH 
currentFolder = [ pwd, filesep ] ;
SW_PATH=currentFolder ;
addpath( [ SW_PATH 'Channel' ] ); 
addpath( [ SW_PATH 'GUI'] );
addpath( [ SW_PATH 'InitFiles'] );
addpath( [ SW_PATH 'RunFiles' ] );
addpath( [ SW_PATH 'Instrument'] );
% addpath( [ SW_PATH 'Instrument' filesep 'iqtools'] );
% addpath( [ SW_PATH 'Instrument' filesep 'KeySight_AWG'] );
% addpath( [ SW_PATH 'Instrument' filesep 'Tektronix_DSO'] );
%addpath( [ SW_PATH 'Instrument' filesep 'Lecroy_DSO'] );
% addpath( [ SW_PATH 'Instrument' filesep 'Keysight_DSO'] );
addpath( [ SW_PATH 'TOI_DSP'] );
% if ( FIXED_ARCHITECTURE == 1 )
%     addpath( [ SW_PATH 'Fixed'] );
% end

% global ampCorrFilename;
% global arbConfigFilename
% global DATA_PATH;
% 
% arbConfigFilename=[currentFolder 'Instrument' filesep 'ConfigFile' filesep 'arbConfig_M8194.mat'];
% ampCorrFilename=[currentFolder 'Instrument' filesep 'ConfigFile' filesep 'ampCorr.mat'];
% 
% if ( SW_DEBUG_ONLY == 1 )
%     DATA_PATH=[ '/mnt/5_ExpData/Tbps_coherent/Release/'];
% else
%     DATA_PATH=[ SW_PATH 'Results\TxPtn\'];
% end
% 
% 
% if ( MatLic )
%     addpath( [ DSP_PATH 'Tool'] );
% end
% 
% 
% global SKIP_SETTLE_TIME
% SKIP_SETTLE_TIME = 1;
% if ( SW_DEBUG_ONLY == 1 )
%    SKIP_SETTLE_TIME = 1;
% end
% 
