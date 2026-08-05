run( ['Units.m']);
[sims, params]=  Init (    );
dir0 = [   SW_PATH './Results/Figures/260803_ofdm/' ];
[s,messy] =mkdir([    dir0 ]); 

global SC
SC = 0;

IQGain =0; IQPhase=0;IQSkew=0;PhaseNoise=0;PMD=0;CFO=0; 
FiberLen = 0.1;
% idx =0;
% skewcomp_en =0;

color_list = {'bo-' 'm<-' 'g+-' 'cs-' 'rd-' 'k>-' 'bo:' 'm<:' 'g+:' 'cs:' 'rd:' 'k>:'...
    'mo--' 'g<--' 'c+--' 'rs--' 'kd--' 'b>--' 'mo-.' 'g<-.' 'c+-.' 'rs-.' 'kd-.' 'b>-.'};
%cidx=0;

sims.plot_axes{3}='';

mode = 87; %86;
num_sim = 1;

X_coor = [9:2:20];

simcases = 22; %[1 22];

% PNval = [0 0.5];
% FLval = [0.1 20];
% PMDval = [0 5];
% CFOval = [ 0 1.5];

%for PhaseNoise = [0:0.1:1]
%for FiberLen = 20; %[1:3:30]
%for PMD = [0:1:10]
for k = 1:length(simcases),
    % PhaseNoise = PNval(k);
    % FiberLen = FLval(k);
    % PMD = PMDval(k);
    % CFO = CFOval(k);
    sim_case = simcases(k);

    color = color_list{k};
%{cidx+1}];
    run([SW_PATH './RunDir/run_simple_ofdm_sim.m']);
    %cidx=cidx+1;
end

ylim( sims.plothandle{3}.axes1, [1e-5 0.5e-1]) ;
xlim( sims.plothandle{3}.axes1,[ROP_dBm(1) ROP_dBm(length(X_coor))+1]);

%
dir1 = [   dir0 str  'w/'  ];
dir2= [  dir0 str  '/'];

[s,messy] =mkdir([    dir1 ]);
[s,messy] =mkdir([    dir2 ]); 

disp_ber( 1.0e-2, dir1, dir2, sims, simout, [   'OFDM ' str '-260803' ] , params, X_coor, draw_new_plot, 2, 1);
