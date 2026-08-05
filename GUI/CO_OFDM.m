function varargout = CO_OFDM(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CO_OFDM_OpeningFcn, ...
                   'gui_OutputFcn',  @CO_OFDM_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function CO_OFDM_OpeningFcn(hObject, eventdata, handles, varargin)
set(handles.figure1, 'Name', 'CO-OFDM');
handles.tgroup = uitabgroup('Parent', handles.figure1,'TabLocation', 'top');
handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'Main');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'Analysis'); 
handles.tab3 = uitab('Parent', handles.tgroup, 'Title', 'Parameter'); 
set(handles.uipanel1,'Parent',handles.tab1)
set(handles.uipanel2,'Parent',handles.tab2) 
set(handles.uipanel3,'Parent',handles.tab3) 
set(handles.uipanel2,'position',get(handles.uipanel1,'position'));
set(handles.uipanel3,'position',get(handles.uipanel1,'position'));

handles.output = hObject;
[sims, params]=  Default();
handles.sims =sims;
handles.params =params;

handles.sims.const_axes{1} = handles.const_axes1;
handles.sims.const_slider(1) = handles.const_slider1;
handles.sims.const_axes{2} = handles.const_axes2;
handles.sims.const_slider(2)= handles.const_slider2;
handles.sims.psd_axes = handles.axes3;
handles.sims.psd_text = handles.text20;
handles.sims.ber_axes = handles.axes4;
handles.sims.tau_axes = handles.axes5;
handles.sims.cpr_axes = handles.axes6;
handles.sims.sync_axes = handles.axes7;
handles.sims.sync_axes1 = handles.axes8;
handles.sims.figure_handle = handles;
handles.sims.psdhandle.figure1 = handles;
handles.sims.evm_text          = handles.edit5_1;
handles.sims.cpr_text          = handles.cpr_text;
handles.sims.const_text(1)     = handles.text17;
handles.sims.const_text(2)     = handles.text19;
handles.sims.consthandle(1).figure1= handles;
handles.sims.consthandle(2).figure1= handles;
handles.sims.consthandle(1).popupmenu1= handles.popupmenu1;
handles.sims.consthandle(2).popupmenu1= handles.popupmenu2;
handles.sims.dfe_axes{1} = handles.axes2_1;
handles.sims.dfe_axes1(1) = handles.axes2_2;
handles.sims.dfe_axes{2} = handles.axes2_3;
handles.sims.dfe_axes1(2) = handles.axes2_4;
handles.sims.dfe_axes{3} = handles.axes2_5;
handles.sims.dfe_axes1(3) = handles.axes2_6;
handles.sims.dfe_axes{4} = handles.axes2_7;
handles.sims.dfe_axes1(4) = handles.axes2_8;
handles.sims.dfe1_axes{1} = handles.axes3_1;
handles.sims.dfe1_axes1(1) = handles.axes3_2;
handles.sims.dfe1_axes{2} = handles.axes3_3;
handles.sims.dfe1_axes1(2) = handles.axes3_4;
handles.sims.dfe1_axes{3} = handles.axes3_5;
handles.sims.dfe1_axes1(3) = handles.axes3_6;
handles.sims.dfe1_axes{4} = handles.axes3_7;
handles.sims.dfe1_axes1(4) = handles.axes3_8; 

handles.sims.dfe_text(1) = handles.text139;
handles.sims.dfe_text(2) = handles.text140;
handles.sims.dfe_text(3) = handles.text141;
handles.sims.dfe_text(4) = handles.text142;
handles.sims.dfe1_text(1) = handles.text143;
handles.sims.dfe1_text(2) = handles.text144;
handles.sims.dfe1_text(3) = handles.text145;
handles.sims.dfe1_text(4) = handles.text146;
         
handles.sims.psdhandle.popupmenu1= handles.popupmenu3;
handles.paramhandle ='';
run_10 = ['Run-' num2str(handles.sims.max_num_sim)];
%set( handles.RunSbutton, 'String', {'Run' 'Stop' 'Run-10' 'Reset' 'Rerun' 'Stop on error' }); 
set( handles.popupmenu1, 'String', {'Equalized' 'Received' 'After TPR' 'After Eq1' 'After CFE' 'After CPR' 'After CPR Sync'  'EyeDiagram' 'Level Analysis'  'All' '2D' });
set( handles.popupmenu2, 'String', {'Equalized' 'Received' 'After TPR' 'After Eq1' 'After CFE' 'After CPR' 'After CPR Sync'  'EyeDiagram' 'Level Analysis'  'All' '2D' });
set( handles.RunSbutton, 'String', {'Run' 'Stop' run_10 'Reset' 'Rerun' 'Stop on error' }); 
set( handles.RunSbutton, 'String', {'Run' 'Stop' run_10 'Reset' 'Rerun' 'Stop on error' 'Run-1' }); 
set( handles.pushbutton1, 'String', {'Reserved'});

%%
set( handles.text0_3,  'String', 'FFT size');
set( handles.edit0_3,  'Style', 'edit'); 
set( handles.edit0_3,  'String', '0'); 
set( handles.text0_4,  'String', 'CP ratio');
set( handles.edit0_4,  'Style', 'edit'); 
set( handles.edit0_4,  'String', '0'); 
set( handles.text0_5,  'String', '# TX stream');
set( handles.edit0_5,  'Style', 'edit'); 
set( handles.text0_6,  'String', '# data subcarrier');
set( handles.edit0_6,  'Style', 'edit'); 
set( handles.edit0_6,  'String', '0'); 
set( handles.text0_7,  'String', 'min subcarrier');
set( handles.edit0_7,  'Style', 'edit'); 
set( handles.edit0_7,  'String', '0'); 
set( handles.text0_8,  'String', '# data symbol');
set( handles.edit0_8,  'Style', 'edit'); 
set( handles.edit0_8,  'String', '1');
set( handles.text0_9,  'String', 'LTF repetition'); 
set( handles.edit0_9,  'Style', 'edit'); 
set( handles.edit0_9,  'String', '1');
set( handles.text0_10, 'String', 'CRT rep.');
set( handles.edit0_10, 'String', '1');
set( handles.text0_11, 'String', 'Preamble Type');
set( handles.edit0_11, 'String', {'No preamble' 'Reserved' 'Reserved' 'Reserved' 'CRT' });
set( handles.edit0_11, 'Value', 5);
set( handles.edit0_11, 'Style', 'popupmenu');
set( handles.text0_12, 'String', 'Bit allocation');
set( handles.edit0_12, 'Style', 'popupmenu');
set( handles.edit0_12, 'String', {'Disable' 'Enable' });
set( handles.edit0_12, 'Value',  1);
set( handles.text0_13, 'String', 'Power loading');
set( handles.edit0_13, 'Style', 'popupmenu');
set( handles.edit0_13, 'String', {'Disable' 'Enable' });
set( handles.edit0_13, 'Value',  1);
set( handles.text0_14, 'String', 'Reserved');
set( handles.edit0_14, 'String', '0');
set( handles.text0_15, 'String', 'Reserved');
set( handles.edit0_15, 'String', '0');


%%
set( handles.text1_1, 'String', 'Resampling');
set( handles.edit1_1, 'String', {'PPG' 'Resample(I)'  'resample' 'interpolate' 'fft' 'linear'  'arbitrary' });
set( handles.edit1_1, 'Style', 'popupmenu');
set( handles.text1_3, 'String', 'Filter ');
set( handles.edit1_3, 'String', {'Disable' 'SRRC' 'RC' 'Hanning windowed sinc' });
set( handles.edit1_3, 'Style', 'popupmenu');
set( handles.edit1_3, 'Value', 1);
set( handles.text1_5, 'String', 'TX IF band');
set( handles.edit1_5, 'Style', 'popupmenu');
set( handles.edit1_5, 'String', {'Disable' 'Enable' });
set( handles.text1_6, 'String', 'TX IF Freq(GHz)');
set( handles.edit1_6, 'Style', 'edit');
set( handles.text1_7, 'String', 'Gen Filename'); 
set( handles.edit1_7, 'Style', 'pushbutton');
set( handles.text1_8, 'String', 'CP shift');

%%
set( handles.text2_1, 'String', 'Sweep') 
set( handles.edit2_1, 'String', {'Disable'});
set( handles.edit2_1, 'Value', 1);
set( handles.edit2_1, 'Style', 'popupmenu');
set( handles.text2_2, 'String', 'Range') 
set( handles.edit2_2, 'String', '0');
set( handles.text2_3, 'String', 'Store OSC') 
set( handles.text2_4, 'String', 'OSC Freq. GSaps');
set( handles.edit2_4, 'Style', 'edit');
set( handles.edit2_4, 'String', '0');
set( handles.text2_5, 'String', 'RX IF band');
set( handles.edit2_5, 'Style', 'popupmenu');
set( handles.edit2_5, 'String', {'Disable' 'Enable' });
set( handles.text2_6, 'String', 'RX IF Freq(GHz)');
set( handles.edit2_6, 'String', '0');
set( handles.edit2_6, 'Style', 'edit');
set( handles.text2_7, 'String', 'LPF bandwidth');
set( handles.edit2_7, 'String', '0');
set( handles.edit2_7, 'Style', 'edit');
set( handles.text2_8, 'String', 'Reserved');
set( handles.edit2_8, 'String', '0');
set( handles.edit2_8, 'Style', 'edit');

set( handles.text2_9, 'String', 'Skew compensation');
set( handles.edit2_9, 'String', {'Disable' 'Enable' });
set( handles.edit2_9, 'Style', 'popupmenu');
set( handles.text2_10, 'String', 'Matched filter');
set( handles.edit2_10, 'Value', 1);
set( handles.edit2_10, 'String', {'Disable' 'SRRC' });
set( handles.edit2_10, 'Style', 'popupmenu');
set( handles.text2_11, 'String', 'Roll-off factor');
set( handles.edit2_11, 'String', '0');
set( handles.edit2_11, 'Style', 'edit');
set( handles.text2_12, 'String', 'AGC');
set( handles.edit2_12, 'Style', 'popupmenu');
set( handles.edit2_12, 'Value', 1);
set( handles.edit2_12, 'String', {'Disable' 'Enable' });
set( handles.text2_13, 'String', 'DC Cancel');
set( handles.edit2_13, 'Style', 'popupmenu');
set( handles.edit2_13, 'Value', 1);
set( handles.edit2_13, 'String', {'Disable' 'Enable' });
set( handles.text2_14, 'String', 'Reserved')  ;
set( handles.edit2_14, 'String', '0')  ;
set( handles.edit2_14, 'Style', 'edit')  ;
set( handles.text2_15, 'String', 'Reserved')  ;
set( handles.edit2_15, 'String', '0')  ;
set( handles.edit2_15, 'Style', 'edit')  ;
%
set( handles.text3_1, 'String', 'Sync point') 
set( handles.edit3_1, 'String', '0') 
set( handles.edit3_1, 'Style', 'edit') 
set( handles.text3_2, 'String', 'ISFA ') 
set( handles.edit3_2, 'Style', 'popupmenu');
set( handles.edit3_2, 'Value', 1);
set( handles.edit3_2, 'String', {'Disable' 'Enable' });
set( handles.text3_3, 'String', 'ISFA size')  
set( handles.edit3_3, 'String', '0') 
set( handles.edit3_3, 'Style', 'edit') 
set( handles.text3_4, 'String', 'CPE') 
set( handles.edit3_4, 'Style', 'popupmenu');
set( handles.edit3_4, 'Value', 1);
set( handles.edit3_4, 'String', {'Disable' 'Enable' });
set( handles.text3_5, 'String', 'Blind CPE') ;
set( handles.edit3_5, 'Value', 1);
set( handles.edit3_5, 'Style', 'popupmenu');
set( handles.edit3_5, 'String', {'Disable' 'Enable' });
set( handles.text3_6, 'String', 'CFO recovery ') ; 
set( handles.edit3_6, 'Style', 'popupmenu');
set( handles.edit3_6, 'Value', 2);
set( handles.edit3_6, 'String', {'Disable' 'Enable' });
set( handles.text3_7, 'String', 'Fine CFO recovery ') ; 
set( handles.edit3_7, 'Style', 'popupmenu');
set( handles.edit3_7, 'Value', 2);
set( handles.edit3_7, 'String', {'Disable' 'Enable' }); 
set( handles.text3_8, 'String', 'Reserved')  ;
set( handles.edit3_8, 'String', '0')  ;
set( handles.edit3_8, 'Style', 'edit')  ;
set( handles.text3_9, 'String', 'Time recovery') 
set( handles.edit3_9, 'Value', 1);
set( handles.edit3_9, 'String', {'Disable' 'Enable' });
set( handles.edit3_9, 'Style', 'popupmenu');
set( handles.text3_10, 'String', 'K1')  ;
set( handles.edit3_10, 'String', '0')  ;
set( handles.edit3_10, 'Style', 'edit')  ;
set( handles.text3_11, 'String', 'K2')  ;
set( handles.edit3_11, 'String', '0')  ;
set( handles.edit3_11, 'Style', 'edit')  ; 
set( handles.text3_12, 'String', 'Reserved')  ;
set( handles.edit3_12, 'String', '0')  ;
set( handles.edit3_12, 'Style', 'edit')  ;
set( handles.text3_13, 'String', 'Reserved')  ;
set( handles.edit3_13, 'String', '0')  ;
set( handles.edit3_13, 'Style', 'edit')  ;
set( handles.text3_14, 'String', 'Reserved')  ;
set( handles.edit3_14, 'String', '0')  ;
set( handles.edit3_14, 'Style', 'edit')  ;
set( handles.text3_15, 'String', 'Reserved')  ;
set( handles.edit3_15, 'String', '0')  ;
set( handles.edit3_15, 'Style', 'edit')  ;




%%
UpdateDisplay(hObject, eventdata, handles);
guidata(hObject, handles);

 


function varargout = CO_OFDM_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.const_axes1;
varargout{2} = handles.const_slider1;
varargout{3} = handles.const_axes2;
varargout{4} = handles.const_slider2;
varargout{5} = handles.axes3;
varargout{6} = handles.axes4;
varargout{7} = handles.axes5;
varargout{8} = handles.axes6;
varargout{9} = handles.axes7;
varargout{10} = handles.axes8;
varargout{11} = handles;
%varargout{1} = handles.output;


function const_slider1_Callback(hObject, eventdata, handles)
frame = get(handles.figure1,  'UserData');

mapper_list =  QAMMapperList (  frame) ;
signal_str = get( handles.popupmenu1,  'String' );
signal_type = get( handles.popupmenu1,  'Value' ) ;      
frame.upper_right_idx = find(frame.mapper_tx2(1,:) ==frame.upper_right_data);
const_axes = handles.const_axes1;

iInv = get( hObject,  'Value' ) ;
subShowConst(const_axes, frame, signal_str,signal_type,1, mapper_list, iInv );
 
 

function const_slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function popupmenu1_Callback(hObject, eventdata, handles)
frame = get(handles.figure1,  'UserData'); 
signal_str = get( hObject,  'String' );
signal_type = get( hObject,  'Value' ) ;   

if ( strcmp(signal_str{signal_type} ,  'Level Analysis') ) 
    frame = get(handles.figure1,  'UserData');
    GuiLevelAnalysis( 'Genbutton_Callback',  'Level analysis', handles.sims, handles.params, frame);
end
if ( strcmp(signal_str{signal_type} ,  'All') )     
    equalized = frame.recovered2(1,:); 
    mapper_list =  QAMMapperList (  frame, '' ) ;
    frame.upper_right_idx = find(frame.mapper_tx2(1,:) ==frame.upper_right_data);
    SubShowConstellationA( equalized,  handles.const_axes1,  frame, 1, mapper_list  );
end
if ( strcmp(signal_str{signal_type} ,  '2D') )     
    equalized = frame.recovered2(1,:); 
    figure;
    count=hist2d(real(equalized(1,:)),imag(equalized(1,:)), 100);
    imagesc( count);
end
if ( strcmp(signal_str{signal_type} ,  'Eyediagram') )
    %frame = get(handles.figure1,  'UserData');
    params = frame.params;
    equalized = frame.recovered2(1,:);
    subShowEyediagram(equalized, params.RXSampleFreq, params.RXoversample);
end

function subShowEyediagram(equalized, RXSampleFreq,RXoversample)

    resample_rate = 10;
    equalized_resample = resample(equalized, resample_rate, 1);
    max_abs = ceil(max(abs(equalized_resample)) * 10 ) * 0.1;
    equalized_resample1 =  equalized_resample/max(abs(equalized_resample));
    eyeObj = commscope.eyediagram('SamplingFrequency', ...
                    RXSampleFreq * resample_rate,  ...
                    'AmplitudeResolution', 0.00500, ...
                    'PlotType', '2D Color', ...
                    'MinimumAmplitude', -max_abs, ...
                    'MaximumAmplitude', max_abs, ...
                    'OperationMode', 'Complex', ...
                    'SamplesPerSymbol', RXoversample * resample_rate );
    eyeObj.update(  equalized_resample);
    eyescope(eyeObj); 
    


function SubShowConstellationA( equalized, const_axes,  frame, synchronized, mapper_list  )
MaxStep = 1; 
d = floor(1.0/MaxStep*size(equalized,2));
x = ( 1:d );
plot  (const_axes, equalized(:, x), 'y*');
hold(const_axes, 'on');
ylim  (const_axes, [-1.7 1.7]);
xlim  (const_axes, [-1.7 1.7]);
if ( synchronized == 1 )
    upper_right_idx = frame.upper_right_idx ;
    %plot  (const_axes, equalized(:, intersect(x,upper_right_idx)), 'go' );
    if ( frame.BER < 0.1 )
        plot  (const_axes, equalized(:, intersect(x, frame.error_const_idx)), 'm*' );
    end
end
plot  (const_axes, mapper_list, 'ro' );
hold(const_axes, 'off');
default_color(const_axes);



function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function const_slider2_Callback(hObject, eventdata, handles)
frame = get(handles.figure1,  'UserData');

mapper_list =  QAMMapperList (  frame, '' ) ;
signal_str = get( handles.popupmenu2,  'String' );
signal_type = get( handles.popupmenu2,  'Value' ) ;      
if ( size( frame.mapper_tx2,1) == 1)
    frame.upper_right_idx = find(frame.mapper_tx2(1,:) ==frame.upper_right_data);
else
    frame.upper_right_idx = find(frame.mapper_tx2(2,:) ==frame.upper_right_data);
end
const_axes = handles.const_axes2;

iInv = get( hObject,  'Value' ) ;
subShowConst(const_axes, frame, signal_str,signal_type,2, mapper_list, iInv );
 

function subShowConst(const_axes, frame, signal_str,signal_type,iaxes, mapper_list, iInv)
synchronized = 0 ;

upper_right_idx = frame.upper_right_idx ; 
if ( strcmp(signal_str{signal_type} ,  'Equalized') )
    equalized = frame.recovered2(iaxes,:);
    synchronized = 1 ;
    upper_right_idx = frame.upper_right_idx ;
    
end
if ( strcmp(signal_str{signal_type} ,  'Received') )
    equalized = frame.received(iaxes,:);
end
if ( strcmp(signal_str{signal_type} ,  'After TPR') )
    equalized = frame.resampledout(iaxes, 1:2:end);
end
if ( strcmp(signal_str{signal_type} ,  'After CFE') )
    equalized = frame.cfo_recovered(iaxes, 1:2:end);
end
if ( strcmp(signal_str{signal_type} ,  'After CPR') )
    equalized = frame.phase_error_recovered(iaxes, 1:2:end);
    synchronized = 1 ;
    upper_right_idx = frame.upper_right_idx ;
end
if ( strcmp(signal_str{signal_type} ,  'After CPR Sync') )
    equalized = frame.phase_error_recovered_sync(iaxes, 1:2:end);
    synchronized = 1 ;
    upper_right_idx = frame.upper_right_idx ;
end
if ( strcmp(signal_str{signal_type} ,  'After CPR0') )
    equalized = frame.phase_error_recovered(iaxes, 1:2:end);
    synchronized = 1 ;
    idx_offset = frame.fsfs.start_of_frame;
    
    upper_right_idx = frame.upper_right_idx ;%+ idx_offset -1 ;
end
if ( strcmp(signal_str{signal_type} ,  'After Eq1') )
    synchronized = 1 ;
    equalized = frame.cfo_recovered_eq(iaxes, 1:2:end);
end
if ( strcmp(signal_str{signal_type} ,  'After FrameStart') )
    equalized = frame.cfo_recovered_sync(iaxes, 1:2:end);
end
Step = 0.05;
MaxStep = 1/Step +1;
% MaxStep = 1;
% iInv = get( hObject,  'Value' ) ;
slider_inv =  floor ( iInv * 1/Step + 0.5 ) +1 ;
d = floor(1.0/MaxStep*size(equalized,2));
x = ( 1:d )+ d*(slider_inv-1);
plot  (const_axes, equalized(:, x), 'y*');
hold(const_axes, 'on');
ylim  (const_axes, [-1.7 1.7]); 
xlim  (const_axes, [-1.7 1.7]); 
if ( synchronized == 1 &&  frame.params.searchfineframe.en ==  1)    
    %plot  (const_axes, equalized(:, intersect(x,upper_right_idx)), 'go' );
    if ( frame.BER < 0.1 )
        plot  (const_axes, equalized(:, intersect(x, frame.error_const_idx)), 'm*' );
    end
end
plot  (const_axes, mapper_list, 'ro' );
hold(const_axes, 'off');
default_color(const_axes);


function const_slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function popupmenu2_Callback(hObject, eventdata, handles)
frame = get(handles.figure1,  'UserData'); 
signal_str = get( hObject,  'String' );
signal_type = get( hObject,  'Value' ) ;   

if ( strcmp(signal_str{signal_type} ,  'Level Analysis') ) 
    frame = get(handles.figure1,  'UserData');
    GuiLevelAnalysis( 'Genbutton_Callback',  'Level analysis', handles.sims, handles.params, frame);
end
if ( strcmp(signal_str{signal_type} ,  'All') )     
    equalized = frame.recovered2(2,:); 
    mapper_list =  QAMMapperList (  frame, '' ) ;
    frame.upper_right_idx = find(frame.mapper_tx2(2,:) ==frame.upper_right_data);
    SubShowConstellationA( equalized,  handles.const_axes2,  frame, 1, mapper_list  );
end
if ( strcmp(signal_str{signal_type} ,  '2D') )     
    equalized = frame.recovered2(2,:); 
    figure;
    count=hist2d(real(equalized(1,:)),imag(equalized(1,:)), 100);
    imagesc( count);
end
if ( strcmp(signal_str{signal_type} ,  'Eyediagram') )
    %frame = get(handles.figure1,  'UserData');
    params = frame.params;
    equalized = frame.recovered2(2,:);
    subShowEyediagram(equalized, params.RXSampleFreq, params.RXoversample);
end

function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu3_Callback(hObject, eventdata, handles)
signals = get(handles.figure1,  'UserData');

signal_str = get( hObject,  'String' );
signal_type = get( hObject,  'Value' ) ;  
psd_axes = handles.axes3;
Welch =1;
if ( strcmp(signal_str{signal_type} ,  'Received(X)') )
    in = signals.received(1,:);
    Rs = signals.receivedclk;
end
if ( strcmp(signal_str{signal_type} ,  'Received(Y)') )
    in = signals.received(2,:);
    Rs = signals.receivedclk; 
end
if ( strcmp(signal_str{signal_type} ,  'Transmitted(X)') )
    in = signals.txsignal.txout(1,:);
    Rs = signals.params.TXSampleFreq; 
end
if ( strcmp(signal_str{signal_type} ,  'Transmitted(Y)') )
    in = signals.txsignal.txout(2,:);
    Rs = signals.params.TXSampleFreq; 
end
if ( strcmp(signal_str{signal_type} ,  'PostEmphasis') )
    in = signals.postemphasis(1,:); Rs = signals.receivedclk; 
end
if ( strcmp(signal_str{signal_type} ,  'Matched Filter out') )
    in = signals.in_filter(1,:); Rs = signals.receivedclk; 
end

draw_psd ( psd_axes, in, Rs, Welch);
    
% signals.postemphasis  = frame.postemphasis;
% GHz =1e9;
%ylim  (psd_axes, [-150 15]); 
%xlabel(psd_axes,'Freq. (GHz)', 'Color','white');
%grid(psd_axes, 'on');
%return
% if ( strcmp(signal_str{signal_type} ,  'X real') )
%     in = real(signals.equalized(1,:));
%      SubShowEyediagram( in, psd_axes, signals.params  )
% end
% if ( strcmp(signal_str{signal_type} ,  'X imag') )
%     in = imag(signals.equalized(1,:));
%      SubShowEyediagram( in, psd_axes, signals.params  )
% end
% if ( strcmp(signal_str{signal_type} ,  'Y real') )
%     in = real(signals.equalized(2,:));
%      SubShowEyediagram( in, psd_axes, signals.params  )
% end
% if ( strcmp(signal_str{signal_type} ,  'Y imag') )
%     in = imag(signals.equalized(2,:));
%      SubShowEyediagram( in, psd_axes, signals.params  )
% end
default_color(psd_axes);

function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function draw_psd (axes, in, Rs, Welch)
% if ( version('-release') == '2019a' )
if ( Welch == 0 )
        [pxx,w] = periodogram(in);
    freq = fftshift(fft(in));
    pxx = abs(freq);
    w=[-Rs/2:Rs/length(in): Rs/2-Rs/length(in)];
    plot  ( axes, w,mag2db(pxx/max(pxx)), 'y');
else
%     Hs=spectrum.periodogram;
    Hs=spectrum.welch;
%     psd(Hs,in(1,:), 'Fs',Rs, 'CenterDC', 1)
    Hpsd = psd(Hs, in(1,:), 'Fs', Rs, 'CenterDC', 1);
    Pw=Hpsd.Data;
    Fw=Hpsd.Frequencies;
    plot(axes, Fw,mag2db(Pw), 'y', 'LineWidth', 2);
%     global SW_PATH;
%     save( [SW_PATH '/Results/Spectrum/Pw.mat'], 'Pw');
end




% --- Executes on button press in RunSbutton.
function RunSbutton_Callback(hObject, eventdata, handles)
global SW_DEBUG_ONLY
if ( SW_DEBUG_ONLY == 1 )
    testvector = 2;
else    
    testvector = 0;
end

if ( get( hObject, 'Value') == 2 || get( hObject, 'Value') == 4 )
    pause(0.1);
    return
end


[handles.sims, handles.params] = update_ParameterSet(hObject, eventdata, handles);
disp2(handles.sims.logfile, 'Parameter updated');
 
sims = handles.sims ;
params = handles.params ; 
sims.testvector = testvector;

params.NRXStream = params.NTXStream;
[sims, params]=  ReInit ( sims, params  ); 
guidata(hObject, handles);
pause(0.5);
for simseq=1:length(sims.X_coor)
    [sims, params]=  SweepSim ( sims, params, simseq  );
    UpdateDisplay(hObject, eventdata, handles);
    handles.sims = sims;
    handles.params = params;
    guidata(hObject, handles);
    pause(0.5);

    %-------------------- Generate TX or read tx pattern  --------------------------
    if ( params.AWGResampleMethod == 0 )
         [txsignal, params] = SelPtnFile ( sims.testvector, sims, params );
    else
        if ( sims.gen_tx == 1 && testvector == 0 )
            [txout,  txsignal]= TxTop( sims, params) ;
            txsignal = GenAWG( txsignal, handles.sims.txdata_file , sims, params);
            frameout.txsignal = txsignal;
            set( handles.figure1, 'UserData', frameout);
            guidata(hObject, handles);
            pause(5);
        else
            if ( simseq == 1 )
                [txsignal, params] = SelPtnFile ( sims.testvector, sims, params );
            end
        end
    end
                 
    %-------------------- RX Top                          --------------------------
    idx=1; EVM_best = 0;
    simout.out = zeros(1,2);
    while( get( hObject, 'Value') ~= 2  && ( get( hObject, 'Value') ~= 5 ||  idx ==1 ))
        pause(0.5);
        if ( get( hObject, 'Value') == 5  )
            [channelout]       = handles.channelout;
        else
            [channelout]       = SelTestVector( testvector, idx, sims, params ) ;
            handles.channelout = channelout;        
            guidata(hObject, handles);
        end
        [frameout, sims] =  RxTop( channelout, txsignal, sims, params) ; 
        simout             = SimAnalysis( sims, simout, frameout, idx );   
        simout.out(idx, 1) = mean(simout.BER);
        simout.out(idx, 2) = mean(simout.EVM);
        disp_result(simout, frameout, sims, params);
        if ( mean(frameout.EVM) < EVM_best )
%             params.dfe.filtertap =frameout.dfeout.filtercoef;   
            EVM_best = mean(frameout.EVM);
        end
        if ( get( hObject, 'Value') == 3 && idx >=  sims.max_num_sim  )
            break;
        end
        if ( get( hObject, 'Value') == 6 && idx >=  2  )
            if (  frameout.BER > 0.001)
                break;
            end
        end
        if ( get( hObject, 'Value') == 7  )
            break;
        end
        idx = idx + 1;
        if ( get( hObject, 'Value') == 4  )
            idx = 1;
            set( hObject, 'Value', 1) ;
        end
    end % while( get( hObject, 'Value') ~= 2  
end % for simseq=1:length(sims.X_coor)

handles.sims = sims;
handles.params = params;
guidata(hObject, handles);
set( hObject, 'Value', 1);


function pushbutton1_Callback(hObject, eventdata, handles)


function val = get_value(handles1)
val = get(handles1, 'Value');

function val = get_string(handles1)
val = str2num(get(handles1, 'String'));

function val_list = get_regexp(handles1)
str = get(handles1, 'String');
if ( size( regexp( str, ':'),1) ~= 0 )
   index  =regexp( str, ':', 'split');
   val_list = str2num(index{1}):str2num(index{2}):str2num(index{3});
else
   val_list = str2num(str);
end 


function sims = get_simmode(sims,mode)
sims.mode  = mode;
if ( sims.mode == 0 )
    sims.X_coor            = 0;
end



function [sims, params] = update_ParameterSet(hObject, eventdata, handles)
GHz=1e9;MHz=1e6;km=1e3;
handles.params.Nbpsc           = get_value (handles.edit0_1);
handles.params.BaudFreq        = get_string(handles.edit0_2) * GHz;
handles.params.NFFT            = get_string(handles.edit0_3);
handles.params.CP_ratio        = get_string(handles.edit0_4);
handles.params.NTXStream       = get_string(handles.edit0_5);
handles.params.Nsd             = get_string(handles.edit0_6);
handles.params.sc1             = get_string(handles.edit0_7);
handles.params.NDataSymbol     = get_string(handles.edit0_8);
handles.params.NLTF            = get_string(handles.edit0_9);
handles.params.cfr.CRTrep      = get_string(handles.edit0_10);
handles.params.cfr.CFEtype     = get_value(handles.edit0_11)  ;
handles.params.en_bit_alloc    = get_value(handles.edit0_12)-1  ;
handles.params.en_power_loading   = get_value(handles.edit0_13)-1  ;
handles.params.NRXStream       = handles.params.NTXStream;
handles.params.TXSampleFreq = handles.params.BaudFreq   ;
handles.params.RXSampleFreq = handles.params.BaudFreq   ;

handles.params.AWGResampleMethod =get_value(handles.edit1_1) -1 ;
handles.params.AWGSampleFreq = get_string(handles.edit1_2) *GHz;
handles.params.TXMatchedfilter.en           = get_value(handles.edit1_3) -1 ;
handles.params.TXMatchedfilter.alpha = get_string(handles.edit1_4) ; 
handles.params.TX_IF_band = get_value(handles.edit1_5)-1 ; 
handles.params.TX_IF_Freq = get_string(handles.edit1_6) * GHz ; 
handles.sims.txdata_file = get(handles.edit1_7, 'UserData');

handles.sims.mode              = get_value(handles.edit2_1)-1 ;
handles.sims.X_coor            = get_regexp(handles.edit2_2) ;
handles.sims                   = get_simmode( handles.sims,get_value(handles.edit2_1)-1);
handles.sims.store_data        = get_value(handles.edit2_3) -1; 
handles.params.OSCFreq         = get_string(handles.edit2_4) * GHz ; 
handles.params.RX_IF_band = get_value(handles.edit2_5)-1 ; 
handles.params.RX_IF_Freq = get_string(handles.edit2_6) * GHz ; 
handles.params.LPF.NBandwidth    = get_string( handles.edit2_7)/(handles.params.RX_IFSampleFreq/GHz);
 

handles.params.skew.en            = get_value( handles.edit2_9) -1;
handles.params.RXMatchedfilter.en    = get_value( handles.edit2_10) -1 ;
handles.params.RXMatchedfilter.alpha = get_string( handles.edit2_11);
handles.params.AGC.en            = get_value( handles.edit2_12) -1;
handles.params.DCCancel.en       = get_value( handles.edit2_13) -1;

handles.params.ce.en_ISFA        = get_value( handles.edit3_2) -1;
handles.params.ce.ISFASize       = get_string( handles.edit3_3);
handles.params.cpr.en      = get_value( handles.edit3_4) -1;
handles.params.cpr.bcpr_en      = get_value( handles.edit3_5) -1;

handles.params.cfr.en      = get_value( handles.edit3_6) -1;
handles.params.fcfr.en      = get_value( handles.edit3_7) -1;

handles.params.tpr.en            = get_value( handles.edit3_9) -1;
handles.params.tpr.K1            = get_string( handles.edit3_10);
handles.params.tpr.K2            = get_string( handles.edit3_11);



handles.sims.dataf.data_file = handles.sims.dataf.data_file ;
sims=handles.sims;
params=handles.params;
guidata(hObject, handles);


 

 
function UpdateDisplay(hObject, eventdata, handles)
params = handles.params;
sims = handles.sims;
GHz=1e9;MHz=1e6;km=1e3;
set( handles.edit0_1, 'Value', params.Nbpsc);
set( handles.edit0_2, 'String', num2str(params.BaudFreq/GHz)); 
set( handles.edit0_3, 'String', num2str(params.NFFT));
set( handles.edit0_4, 'String', num2str(params.CP_ratio));
set( handles.edit0_5, 'String', num2str(params.NTXStream));
set( handles.edit0_6, 'String', num2str(params.Nsd));
set( handles.edit0_7, 'String', num2str(params.sc1));
set( handles.edit0_8, 'String', num2str(params.NDataSymbol));
set( handles.edit0_9, 'String', num2str(params.NLTF));
set( handles.edit0_10, 'String', num2str(params.cfr.CRTrep));
set( handles.edit0_11, 'Value', (params.cfr.CFEtype ));
set( handles.edit0_12, 'Value', (params.en_bit_alloc +1) );
set( handles.edit0_13, 'Value', (params.en_power_loading +1) );


set( handles.edit1_1, 'Value', ( params.AWGResampleMethod)+1);
set( handles.edit1_2, 'String', num2str( params.AWGSampleFreq/GHz));
set( handles.edit1_3, 'Value', ( params.TXMatchedfilter.en + 1));
set( handles.edit1_4, 'String', num2str( params.TXMatchedfilter.alpha)); 
set( handles.edit1_5, 'Value', ( params.TX_IF_band + 1));
set( handles.edit1_6, 'String', num2str( params.TX_IF_Freq /GHz));
set( handles.edit1_7, 'String', sims.txdata_filename); 
set( handles.edit1_7, 'UserData',  sims.txdata_file); 


set( handles.edit2_3, 'Value', ( sims.store_data + 1));
set( handles.edit2_4, 'String', num2str( params.OSCFreq/GHz));
set( handles.edit2_5, 'Value', ( params.RX_IF_band + 1));
set( handles.edit2_6, 'String', num2str( params.RX_IF_Freq /GHz));
set( handles.edit2_7, 'String', num2str( params.LPF.NBandwidth * params.RX_IFSampleFreq/GHz ));

% set( handles.edit2_9, 'Value', ( params.skew.en) +1);
set( handles.edit2_10, 'Value', ( params.RXMatchedfilter.en + 1));
set( handles.edit2_11, 'String', num2str( params.RXMatchedfilter.alpha)); 
set( handles.edit2_12, 'Value', ( params.AGC.en+1)); 
set( handles.edit2_13, 'Value', ( params.DCCancel.en+1)); 

set( handles.edit3_2, 'Value', ( params.ce.en_ISFA+1)); 
set( handles.edit3_3, 'String', num2str( params.ce.ISFASize)); 
set( handles.edit3_4, 'Value', ( params.cpr.en +1)); 
set( handles.edit3_5, 'Value', ( params.cpr.bcpr_en +1)); 
set( handles.edit3_6, 'Value', ( params.cfr.en + 1));  
set( handles.edit3_7, 'Value', ( params.fcfr.en + 1));  

set( handles.edit3_9, 'Value', ( params.tpr.en+1)); 
set( handles.edit3_10, 'String', num2str( params.tpr.K1)); 
set( handles.edit3_11, 'String', num2str( params.tpr.K2)); 
% 


handles.sims = sims;
handles.params = params;
guidata(hObject, handles);




 
function Genbutton_Callback(hObject, eventdata, handles) 
[handles.sims, handles.params] = update_ParameterSet(hObject, eventdata, handles);
disp2(handles.sims.logfile, 'Parameter updated');
sims = handles.sims ;
params = handles.params ; 
[sims, params]=  ReInit ( sims, params  );  
handles.sims = sims;
handles.params = params;
guidata(hObject, handles);
[txout,  txsignal]= TxTop( sims, params) ;   
GenAWG( txsignal, handles.sims.txdata_file , sims, params);

function uipushtool1_ClickedCallback(hObject, eventdata, handles)
 global SW_PATH
[FileName, PathName] = uiputfile([ SW_PATH './Results/Figures/SingleCarrier']);
if ( PathName ~= 0 )
    saveas(gcf,  [PathName FileName '.fig' ], 'fig');
    pause(1);
    img =getframe(gcf);
    imwrite(img.cdata, [PathName FileName '.png' ]);
end


function RunSbutton_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_13_Callback(hObject, eventdata, handles)


function edit3_13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% function edit3_16_Callback(hObject, eventdata, handles)
% 
% 
% function edit3_16_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end



function edit3_15_Callback(hObject, eventdata, handles)


function edit3_15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_14_Callback(hObject, eventdata, handles)


function edit3_14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_11_Callback(hObject, eventdata, handles)

function edit3_11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_12_Callback(hObject, eventdata, handles)


function edit3_12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_7_Callback(hObject, eventdata, handles)


function edit3_7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_10_Callback(hObject, eventdata, handles)


function edit3_10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_9_Callback(hObject, eventdata, handles)


function edit3_9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_8_Callback(hObject, eventdata, handles)


function edit3_8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_3_Callback(hObject, eventdata, handles)


function edit3_3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_6_Callback(hObject, eventdata, handles)

function edit3_6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_5_Callback(hObject, eventdata, handles)


function edit3_5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_4_Callback(hObject, eventdata, handles)


function edit3_4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_1_Callback(hObject, eventdata, handles)

function edit3_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_2_Callback(hObject, eventdata, handles)


function edit3_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_10_Callback(hObject, eventdata, handles)


function edit2_10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_15_Callback(hObject, eventdata, handles)

function edit2_15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_16_Callback(hObject, eventdata, handles)


function edit2_16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_14_Callback(hObject, eventdata, handles)


function edit2_14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_13_Callback(hObject, eventdata, handles)


function edit2_13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_12_Callback(hObject, eventdata, handles)


function edit2_12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_9_Callback(hObject, eventdata, handles)


function edit2_9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_11_Callback(hObject, eventdata, handles)


function edit2_11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_3_Callback(hObject, eventdata, handles)


function edit2_3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_8_Callback(hObject, eventdata, handles)


function edit2_8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_1_Callback(hObject, eventdata, handles)


function edit2_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_7_Callback(hObject, eventdata, handles)


function edit2_7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_6_Callback(hObject, eventdata, handles)
if ( get( hObject, 'Value') == 3) 
[FileName,PathName]  = uigetfile([ '*.*']);
if isequal(FileName,0) || isequal(PathName,0)
    disp2(handles.sims.logfile, 'User clicked Cancel.')
else
    disp2(handles.sims.logfile, ['Setting TX File ', FileName,' in Path', PathName]);
    handles.sims.postemphasis_file = [PathName,FileName];
%     handles.sims.txdata_filename = [FileName];
%     set( hObject, 'String',  handles.sims.txdata_filename);
%     set( hObject, 'UserData',  handles.sims.txdata_file);
    guidata(hObject, handles);
end
end


function edit2_6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_5_Callback(hObject, eventdata, handles)


function edit2_5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_2_Callback(hObject, eventdata, handles)


function edit2_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_4_Callback(hObject, eventdata, handles)


function edit2_4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit0_9_Callback(hObject, eventdata, handles)


function edit0_9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit0_8_Callback(hObject, eventdata, handles)


function edit0_8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit0_7_Callback(hObject, eventdata, handles)

function edit0_7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit0_6_Callback(hObject, eventdata, handles)


function edit0_6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit0_5_Callback(hObject, eventdata, handles)

function edit0_4_Callback(hObject, eventdata, handles)

function edit0_4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit0_3_Callback(hObject, eventdata, handles)


function edit0_3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit0_2_Callback(hObject, eventdata, handles)

function edit0_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit0_1_Callback(hObject, eventdata, handles)


function edit0_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_1_Callback(hObject, eventdata, handles)


function edit1_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_7_Callback(hObject, eventdata, handles)
[FileName,PathName]  = uiputfile([ '*.*']);
if isequal(FileName,0) || isequal(PathName,0)
    disp2(handles.sims.logfile, 'User clicked Cancel.')
else
    disp2(handles.sims.logfile, ['Setting TX File ', FileName,' in Path', PathName]);
    handles.sims.txdata_file = [PathName,FileName];
    handles.sims.txdata_filename = [FileName];
    set( hObject, 'String',  handles.sims.txdata_filename);
    set( hObject, 'UserData',  handles.sims.txdata_file);
    guidata(hObject, handles);
end


function edit1_7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1_6_Callback(hObject, eventdata, handles)


function edit1_4_Callback(hObject, eventdata, handles)


function edit1_4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_2_Callback(hObject, eventdata, handles)


function edit1_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1_5_Callback(hObject, eventdata, handles)


function edit1_5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1_3_Callback(hObject, eventdata, handles)


function edit1_3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function CO_OFDM_Callback(hObject, eventdata, handles)



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit0_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit0_9 as text
%        str2double(get(hObject,'String')) returns contents of edit0_9 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit0_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit0_10_Callback(hObject, eventdata, handles)
% hObject    handle to edit0_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit0_10 as text
%        str2double(get(hObject,'String')) returns contents of edit0_10 as a double


% --- Executes during object creation, after setting all properties.
function edit0_10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit0_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit0_11_Callback(hObject, eventdata, handles)
% hObject    handle to edit0_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit0_11 as text
%        str2double(get(hObject,'String')) returns contents of edit0_11 as a double


% --- Executes during object creation, after setting all properties.
function edit0_11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit0_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit0_12_Callback(hObject, eventdata, handles)
% hObject    handle to edit0_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit0_12 as text
%        str2double(get(hObject,'String')) returns contents of edit0_12 as a double


% --- Executes during object creation, after setting all properties.
function edit0_12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit0_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit0_13_Callback(hObject, eventdata, handles)
% hObject    handle to edit0_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit0_13 as text
%        str2double(get(hObject,'String')) returns contents of edit0_13 as a double


% --- Executes during object creation, after setting all properties.
function edit0_13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit0_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit0_14_Callback(hObject, eventdata, handles)
% hObject    handle to edit0_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit0_14 as text
%        str2double(get(hObject,'String')) returns contents of edit0_14 as a double


% --- Executes during object creation, after setting all properties.
function edit0_14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit0_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit0_15_Callback(hObject, eventdata, handles)
% hObject    handle to edit0_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit0_15 as text
%        str2double(get(hObject,'String')) returns contents of edit0_15 as a double


% --- Executes during object creation, after setting all properties.
function edit0_15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit0_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_8_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_8 as text
%        str2double(get(hObject,'String')) returns contents of edit1_8 as a double


% --- Executes during object creation, after setting all properties.
function edit1_8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit51_Callback(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit51 as text
%        str2double(get(hObject,'String')) returns contents of edit51 as a double


% --- Executes during object creation, after setting all properties.
function edit51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_9_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_9 as text
%        str2double(get(hObject,'String')) returns contents of edit1_9 as a double


% --- Executes during object creation, after setting all properties.
function edit1_9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_10_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_10 as text
%        str2double(get(hObject,'String')) returns contents of edit1_10 as a double


% --- Executes during object creation, after setting all properties.
function edit1_10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_11_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_11 as text
%        str2double(get(hObject,'String')) returns contents of edit1_11 as a double


% --- Executes during object creation, after setting all properties.
function edit1_11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_12_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_12 as text
%        str2double(get(hObject,'String')) returns contents of edit1_12 as a double


% --- Executes during object creation, after setting all properties.
function edit1_12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_13_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_13 as text
%        str2double(get(hObject,'String')) returns contents of edit1_13 as a double


% --- Executes during object creation, after setting all properties.
function edit1_13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_14_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_14 as text
%        str2double(get(hObject,'String')) returns contents of edit1_14 as a double


% --- Executes during object creation, after setting all properties.
function edit1_14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_15_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_15 as text
%        str2double(get(hObject,'String')) returns contents of edit1_15 as a double


% --- Executes during object creation, after setting all properties.
function edit1_15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
