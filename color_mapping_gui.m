
function varargout = color_mapping_gui(varargin)
%COLOR_MAPPING_GUI View color mappings for orientation preference maps.
%   A GUI for viewing example orientation preference maps with
%   different color mappings.

% Code written by Nicholas J. Hughes, 2014, released under the following
% licence.
%
% The MIT License (MIT)
%
% Copyright (c) 2014 Nicholas J. Hughes
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @color_mapping_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @color_mapping_gui_OutputFcn, ...
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


function color_mapping_gui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Map file locations
handles.overrep_map = 'overrep_map.mat';
handles.normal_map = 'normal_map.mat';

% Defaults
handles.n = 180;                % Number of colors
handles.chroma = 45;            % Chroma (HCL, mHCL) or saturation (HSV)
handles.luminance = 60;         % Luminance (HCL, mHCL) or value (HSV)
handles.mod = 7;                % Luminance moduation variance (mHCL)
handles.colormap = 'mhcl';      % Selected color mapping
handles.luminance_only = false; % Selected luminance display option
handles.overrep = false;        % Selected overrepresentaiton display option
handles.cycle_map = 0;          % Hue degree corresponding to zero degrees
handles.map = load_map(handles);
guidata(hObject, handles);
plot_lum(handles);
display_map(handles);


function varargout = color_mapping_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function slider_chroma_Callback(hObject, eventdata, handles)

% Update chroma/saturation value
handles.chroma = get(hObject, 'Value');
set(handles.edit_chroma, 'String', num2str(round(handles.chroma)));
handles.map = load_map(handles);
guidata(hObject, handles);
display_map(handles);
plot_lum(handles);


function slider_chroma_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider_luminance_Callback(hObject, eventdata, handles)

% Update luminance/value value
handles.luminance = get(hObject, 'Value');
set(handles.edit_luminance, 'String', num2str(round(handles.luminance)));
handles.map = load_map(handles);
guidata(hObject, handles);
display_map(handles);
plot_lum(handles);


function slider_luminance_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edit_chroma_Callback(hObject, eventdata, handles)

% Update chroma/saturation value
handles.chroma = round(str2double(get(hObject, 'String')));
if handles.chroma > 100
    handles.chroma = 100;
elseif handles.chroma < 0
    handles.chroma = 0;
end
set(hObject, 'String', num2str(handles.chroma));
set(handles.slider_chroma, 'Value', handles.chroma);
handles.map = load_map(handles);
guidata(hObject, handles);
display_map(handles);
plot_lum(handles);


function edit_chroma_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_luminance_Callback(hObject, eventdata, handles)

% Update luminance/value value
handles.luminance = round(str2double(get(hObject, 'String')));
if handles.luminance > 100
    handles.luminance = 100;
elseif handles.luminance < 0
    handles.luminance = 0;
end
set(hObject, 'String', num2str(handles.luminance));
set(handles.slider_luminance, 'Value', handles.luminance);
handles.map = load_map(handles);
guidata(hObject, handles);
display_map(handles);
plot_lum(handles);


function edit_luminance_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function display_map(handles)

% Display chosen map with chosen color mapping
axes(handles.axes_map);
imagesc(angle(handles.map)*180/pi/2);
axis equal;
axis tight;
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(handles.text_invalid, 'Visible', 'off');
if strcmp(handles.colormap, 'hsv')
    cm = hsv2rgb([linspace(0,1,handles.n)', ...
                  handles.chroma/100*ones(handles.n,1), ...
                  handles.luminance/100*ones(handles.n,1)]);
elseif strcmp(handles.colormap, 'hcl')
    cm = hcl_colormap(handles.n, handles.chroma, handles.luminance);
else
    cm = mhcl_colormap(handles.n, handles.chroma, handles.luminance, handles.mod);
    if handles.luminance + handles.mod > 100 || handles.luminance - handles.mod < 0
        set(handles.text_invalid, 'Visible', 'on');
    end
end
cm = circshift(cm, [handles.cycle_map 0]);
if handles.luminance_only
    y = rgb2lum(cm);
    colormap([y y y]);
else
    colormap(cm);
end
ch = colorbar;
set(ch, 'YTick', []);

% Update zero-orientation color bar
set(handles.uipanel_zero_color, 'BackgroundColor', cm(90,:));


function plot_lum(handles)

% Calculate luminance vs. functions for each color mapping
n = 360;
cm_hsv = hsv2rgb([linspace(0,1,n)', ...
                  handles.chroma/100*ones(n,1), ...
                  handles.luminance/100*ones(n,1)]);
cm_hcl = hcl_colormap(n, handles.chroma, handles.luminance);
cm_mhcl = mhcl_colormap(n, handles.chroma, handles.luminance, handles.mod);

% Plot
cols = hcl_colormap(12, 55, 65);
cols = cols([2,5,8],:);
axes(handles.axes_lum);
cla;
hold on;
plot(0:n-1, rgb2lum(cm_hsv)*100, 'Color', cols(1,:), 'LineWidth', 5);
plot(0:n-1, rgb2lum(cm_hcl)*100, 'Color', cols(2,:), 'LineWidth', 5);
plot(0:n-1, rgb2lum(cm_mhcl)*100, 'Color', cols(3,:), 'LineWidth', 5);
hold off;
xlim([0 360]);
ylim([0 100]);
set(gca, 'FontSize', 20);
set(gca, 'LineWidth', 2);
xlabel('Hue (degrees)');
ylabel('Luminance');
set(gca, 'XTick', 0:90:360);
lh = legend('HSV', 'HCL', 'mHCL');
box(lh, 'off');


function map = load_map(handles)

% Load the chosen map from file
if handles.overrep
    load(handles.overrep_map);
else
    load(handles.normal_map);
end
map = maps(:,:,1) + 1i*maps(:,:,2);


function uipanel_colormap_SelectionChangeFcn(hObject, eventdata, handles)

% Update color mapping choice
cm_choice = get(eventdata.NewValue, 'Tag');
if strcmp(cm_choice, 'radiobutton_hsv')
    handles.colormap = 'hsv';
    set(handles.text_chroma, 'String', 'Saturation (S):');
    set(handles.text_luminance, 'String', 'Value (V):');
    set(handles.text_mod, 'Enable', 'off');
elseif strcmp(cm_choice, 'radiobutton_hcl')
    handles.colormap = 'hcl';
    set(handles.text_chroma, 'String', 'Chroma (C):');
    set(handles.text_luminance, 'String', 'Lightness (L):');
    set(handles.text_mod, 'Enable', 'off');
else
    handles.colormap = 'mhcl';
    set(handles.text_chroma, 'String', 'Chroma (C):');
    set(handles.text_luminance, 'String', 'Base Lightness (L0):');
    set(handles.text_mod, 'Enable', 'on');
end
handles.map = load_map(handles);
guidata(hObject, handles);
display_map(handles);


function uipanel_overrep_SelectionChangeFcn(hObject, eventdata, handles)

% Update overrepresentation choice
overrep_choice = get(eventdata.NewValue, 'Tag');
if strcmp(overrep_choice, 'radiobutton_yes')
    handles.overrep = true;
else
    handles.overrep = false;
end
handles.map = load_map(handles);
guidata(hObject, handles);
display_map(handles);


function checkbox_luminance_Callback(hObject, eventdata, handles)

% Update luminance display choice
handles.luminance_only = get(hObject, 'Value');
handles.map = load_map(handles);
guidata(hObject, handles);
display_map(handles);


function slider_cycle_map_Callback(hObject, eventdata, handles)

% Update 0 degree hue choice
handles.cycle_map = round(get(hObject, 'Value'));
set(handles.edit_cycle_map, 'String', num2str(handles.cycle_map));
handles.map = load_map(handles);
guidata(hObject, handles);
display_map(handles);


function slider_cycle_map_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edit_cycle_map_Callback(hObject, eventdata, handles)

% Update 0 degree hue choice
handles.cycle_map = round(str2double(get(hObject, 'String')));
if ~any(handles.cycle_map == 0:(handles.n-1));
    handles.cycle_map = 0;
end
set(hObject, 'String', num2str(handles.cycle_map));
set(handles.slider_cycle_map, 'Value', handles.cycle_map);
handles.map = load_map(handles);
guidata(hObject, handles);
display_map(handles);


function edit_cycle_map_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function slider_mod_Callback(hObject, eventdata, handles)

% Update luminance variance modulation value
handles.mod = round(get(hObject, 'Value'));
set(handles.edit_mod, 'String', num2str(handles.mod));
handles.map = load_map(handles);
guidata(hObject, handles);
display_map(handles);
plot_lum(handles);


function slider_mod_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edit_mod_Callback(hObject, eventdata, handles)

% Update luminance variance modulation value
handles.mod = round(str2double(get(hObject, 'String')));
if ~any(handles.mod == 0:50);
    handles.mod = 0;
end
set(hObject, 'String', num2str(handles.mod));
set(handles.slider_mod, 'Value', handles.mod);
handles.map = load_map(handles);
guidata(hObject, handles);
display_map(handles);
plot_lum(handles);


function edit_mod_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
