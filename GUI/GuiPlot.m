function varargout = GuiPlot(varargin)

gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuiPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @GuiPlot_OutputFcn, ...
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
 


function GuiPlot_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


 
function varargout = GuiPlot_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.axes1;
varargout{2} = handles;
 
 
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function Plot_Callback(hObject, eventdata, handles)
 


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
 

% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
global SW_PATH
[FileName, PathName] = uiputfile([ SW_PATH './Results/Figures/*']);
if ( PathName ~= 0 )
    saveas(hObject,  [PathName FileName '.fig' ], 'fig');
%     saveas(handles.figure1,  [PathName FileName '.fig' ], 'fig');
    img =getframe(gcf);
%      img =getframe(handles.axes1);
    imwrite(img.cdata, [PathName FileName '.png' ]);
end
 
 


% 
% % function uitoggletool4_ClickedCallback(hObject, eventdata, handles)
% % value = get(hObject, 'Visible');
% insertmenufcn(gcbf,'Legend')


% --------------------------------------------------------------------
function uitoggletool4_ClickedCallback(hObject, eventdata, handles)
% insertmenufcn(gcbf,'Legend');
        hfig=gcbf;
        lmenu = findall(gcbf,'Tag','figMenuInsertLegend');
        ltogg = uigettool(hfig,'Annotation.InsertLegend');
        cax = get(hfig,'CurrentAxes');
        if ~isempty(cax)
            % Check to see if the plot is empty:
            children = graph2dhelper ('get_legendable_children', cax);
            if ~isempty(children)
                if (~isempty(lmenu) && isequal(lmenu,gcbo) && strcmpi(get(lmenu,'Checked'),'off')) ||...
                        (~isempty(ltogg) && isequal(ltogg,gcbo) && strcmpi(get(ltogg,'State'),'on'))
                    hleg =  legend(cax,'show'); 
                    if (get(handles.figure1, 'Color') == [1 1 1])
                        set(hleg,'Color','w','TextColor','black', 'FontSize', 11);
                    else
                        set(hleg,'Color','k','TextColor','yellow', 'FontSize', 11);
                    end
                     
                else
                    legend(cax,'off');
                end
            else
                if ~isempty(ltogg)
                    set(ltogg,'State','off');
                    hL = legend(cax);
                    if ~isempty(hL)
                        legend(cax,'off');
                    end
                end
            end
        else
            if ~isempty(ltogg)
                set(ltogg,'State','off');
            end
        end


% --------------------------------------------------------------------
function uitoggletool6_ClickedCallback(hObject, eventdata, handles)
if (get(handles.figure1, 'Color') == [1 1 1])
    default_color1(handles);
else
    default_color2(handles);
end 
 


function default_color1(handles)
set(handles.figure1, 'Color' , [ 0  0 0]);
set(handles.text1, 'BackgroundColor' , [ 0  0 0]);
set(handles.text1, 'ForegroundColor' , [  1 1 1]);
  if ( ~isempty(handles.axes1)   && ishandle(handles.axes1) )
      handlesf = handles.axes1;
    set(handlesf, 'Color', [0.3  0.3 0.3]);
    set(handlesf, 'AmbientLightColor', [ 1 1 1]);
%     set(handlesf, 'Color', [ 1 1 1]);
%     set(handlesf, 'GridColor', [ 1 1 1  ]);  
    set(handlesf, 'XColor', [ 1 1 1]);
    set(handlesf, 'YColor', [ 1 1 1]);
%     xlabel(sims.plothandle{sims.plot_mode}.axes1, sims.Xlabel, 'Color','white');
%     ylabel(sims.plothandle{sims.plot_mode}.axes1, sims.Ylabel, 'Color','white');
   % set(handlesf, 'XTick', [ ]);
   % set(handlesf, 'YTick', [ ]);
end


function default_color2(handles)
set(handles.figure1, 'Color' , [  1  1 1]);
set(handles.text1, 'BackgroundColor' , [  1  1 1]);
set(handles.text1, 'ForegroundColor' , [  0 0 0]);
  if ( ~isempty(handles.axes1)   && ishandle(handles.axes1) )
      handlesf = handles.axes1;
    set(handlesf, 'Color', [ 1 1 1]);
    set(handlesf, 'AmbientLightColor', [ 0 0 0]);
%     set(handlesf, 'Color', [ 1 1 1]);
%     set(handlesf, 'GridColor', [ 1 1 1  ]);  
    set(handlesf, 'XColor', [ 0 0 0]);
    set(handlesf, 'YColor', [ 0 0 0]);
%     xlabel(sims.plothandle{sims.plot_mode}.axes1, sims.Xlabel, 'Color','white');
%     ylabel(sims.plothandle{sims.plot_mode}.axes1, sims.Ylabel, 'Color','white');
   % set(handlesf, 'XTick', [ ]);
   % set(handlesf, 'YTick', [ ]);
end
