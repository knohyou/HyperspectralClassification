function varargout = gui_interface(varargin)
% GUI_INTERFACE MATLAB code for gui_interface.fig
%      GUI_INTERFACE, by itself, creates a new GUI_INTERFACE or raises the existing
%      singleton*.
%
%      H = GUI_INTERFACE returns the handle to a new GUI_INTERFACE or the handle to
%      the existing singleton*.
%
%      GUI_INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_INTERFACE.M with the given input arguments.
%
%      GUI_INTERFACE('Property','Value',...) creates a new GUI_INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_interface

% Last Modified by GUIDE v2.5 08-Dec-2015 13:38:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_interface_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_interface_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before gui_interface is made visible.
function gui_interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_interface (see VARARGIN)

% Choose default command line output for gui_interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_interface wait for user response (see UIRESUME)
% uiwait(handles.tag);


% --- Outputs from this function are returned to the command line.
function varargout = gui_interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function Superpixel_Num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Superpixel_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%input = str2num(get(hObject,'String'));
%if (isempty(input))
%     set(hObject,'String','0')
%end




% --- Executes on button press in Create_Folders.
function Create_Folders_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Folders (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pre_directory num

pre_directory = 'F:\Toshiba_Red\08282015_TransferOtherExternal\';
cd(pre_directory)
addpath(genpath('SPIE_Conference_Paper'))
EntireTime = tic;
cd(strcat(pre_directory,'SPIE_Conference_Paper\Codes\libsvm-3.20\matlab\'))
make
cd(strcat(pre_directory,'SPIE_Conference_Paper\Codes'))
addpath(genpath('libsvm-3.20'))
addpath(genpath('TurboPixels'))
addpath(genpath('SLIC_mex'))
opengl('save','hardware')
cd(strcat(pre_directory,'SPIE_Conference_Paper\'))
addpath(genpath(strcat(pre_directory,'OriginalData')))
addpath(genpath('Codes'))
cd(strcat(pre_directory,'SPIE_Conference_Paper\Codes\SLIC_mex'))
%mex -setup  
%mex -O slicmex.c
cd(pre_directory)

prompt = {'Enter Mice Num: ','Enter Superpixel Num:','Enter Superpixel Constraint:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1','1000','100'};
Superpixel_Parameter = inputdlg(prompt,dlg_title,num_lines,defaultans);
%Superpixel_Parameter_Num = str2num(Superpixel_Parameter);

project_label = '_SLIC_Superpixel_Trial1';
%Num_Superpixel = Superpixel_Parameter{1};
Mice_Selection = str2num(Superpixel_Parameter{1});
Num_Superpixel = str2num(Superpixel_Parameter{2});
Superpixel_Constraint = str2num(Superpixel_Parameter{3});
Project = 'Results_Distance_SVM_All_2Class';
Results_Dir = strcat(pre_directory,'\SPIE_Conference_Paper\Results');
Downsample_Num = 2; % For pixelwise method
superpixel = 1; %1 = yes or 0 = no

%% Choose Results Folder
Results_Folder = strcat(Results_Dir,'\',datestr(now, 'mmm-dd-yyyy'),project_label);
Check = exist(Results_Folder);
if Check == 0
    mkdir(Results_Folder)
end


%% Feature Extraction
Name_All = {'885', '888', '889', '890', '891', '892', '893', '894', '895', '896', '897', '898'};
w = 450:2:900;
Feature1_All = {};
Feature2_All = {};
Group_All = {};
Image_xsize = {};
Image_ysize = {};
Superpixel_size_All = {};
Pause = 0;
Superpixel_sd = {};
%Mice_Selection = 1;
for i = Mice_Selection
    Image_Name = strcat('im_',Name_All{i},'.mat');
    White_Name = strcat('white_',Name_All{i},'.mat');
    Dark_Name = strcat('dark_',Name_All{i},'.mat');
    Truth_Name = strcat('tumor_mask_',Name_All{i},'.tif');
    
    
    % Individual Results Folder
    Results_Individual_Folder = strcat(pre_directory,'\SPIE_Conference_Paper\ProcessedData\',Name_All{i},'\',Project,'\',datestr(now, 'mmm-dd-yyyy'),project_label);
    Check = exist(Results_Individual_Folder);
    if Check == 0
        mkdir(Results_Individual_Folder)
    end
    
    %% Showing Spectra Tumor vs Normal
load(Image_Name)
load(Dark_Name)
load(White_Name)

%load(Truth_Name)
Mice_Num = str2num(Image_Name(4:6));
Image = double(hsi_roi(:,:,1:length(w)));
Dark = double(dark_roi(:,:,1:length(w)));
White = double(white_roi(:,:,1:length(w)));

Name = num2str(Mice_Num); 
A = zeros(size(White,1),size(White,2),size(White,3));
A(A==0) = eps;
Reflectance = (Image - Dark)./((White+A) - Dark);
w_interest = find(w == 812);

Truth = double(imread(Truth_Name));
axes(handles.axes7);
imagesc(Truth)
impixelinfo()

figure; imagesc(Reflectance(:,:,w == 812));
Tumor_ROI = double(roipoly); 
size(Tumor_ROI)
figure; imagesc(Reflectance(:,:,w == 812));
Normal_ROI = double(roipoly);
Tumor_Plot = [];
Normal_Plot = [];
for i = 1:size(Reflectance,3)
    Mask_Reflectance = Reflectance(:,:,i).*Tumor_ROI;
    Mask_Reflectance_Normal = Reflectance(:,:,i).*Normal_ROI;
    Tumor_Plot(i) = sum(Mask_Reflectance(:))./sum(Tumor_ROI(:));
    Normal_Plot(i) = sum(Mask_Reflectance_Normal(:))./sum(Normal_ROI(:));
end

Wavelengths = linspace(400, 900, length(Tumor_Plot));
axes(handles.axes6);
plot(Wavelengths, Tumor_Plot,'b-', Wavelengths, Normal_Plot, 'r-')
legend('Tumor Spectra', 'Normal Spectra','Location','Southwest')

%% Select Wavelength Regions
prompt = {'Higher Wavelengths LowerBound:','Higher Wavelengths UpperBound:', 'Lower Wavelengths LowerBound:', 'Lower Wavelengths UpperBound:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'780','820','480','500'};
Wavelength_Difference = inputdlg(prompt,dlg_title,num_lines,defaultans);
%Superpixel_Parameter_Num = str2num(Superpixel_Parameter);
High_LB = str2num(Wavelength_Difference{1});
High_UB = str2num(Wavelength_Difference{2});
Low_LB = str2num(Wavelength_Difference{3});
Low_UB = str2num(Wavelength_Difference{4});

High_Wavelength = [High_LB, High_UB];
Low_Wavelength = [Low_LB, Low_UB];

    %%
    if superpixel == 1
        [Feature1, Feature2, Group, Feature1_Matrix, Feature2_Matrix, Superpixel_size, Feature1_Image, Feature2_Image,Reflectance_Image_Interest]= function_HSI_Distance_Superpixel_SVM_All_2Class_Concise_New(Num_Superpixel, Truth_Name,Image_Name,White_Name,Dark_Name, ...
            Results_Individual_Folder,  w, Pause, Superpixel_Constraint, High_Wavelength, Low_Wavelength);
        
        Superpixel_size_All{i} = mean(Superpixel_size);
        Superpixel_sd{i} = std(Superpixel_size);
        
    elseif superpixel == 0
        [Feature1, Feature2, Group, Feature1_Matrix, Feature2_Matrix, x_sie, y_size]= function_HSI_Distance_NoSuperpixel_SVM_All_2Class_Concise(Truth_Name,Image_Name,White_Name,Dark_Name, Downsample_Num,...
            Results_Individual_Folder,  w, Pause);
        Image_xsize{i} = x_size;
        Image_ysize{i} = y_size;
    end
    
    Feature1_All{i} = Feature_Stand(Feature1);
    Feature2_All{i} = Feature_Stand(Feature2);
    Group_All{i} = Group';
    
    %save(fullfile(Results_Folder,strcat('Results_', datestr(now, 'mmm-dd-yyyy'))))
    
end


axes(handles.axes2);
imagesc(Feature1_Image)
impixelinfo()
axes(handles.axes3);
imagesc(Feature2_Image)
impixelinfo()
axes(handles.axes4);
imagesc(Reflectance_Image_Interest)
impixelinfo()
axes(handles.axes5);
gscatter(Feature1,Feature2,Group)

% --- Executes on button press in Load_Feature1.
function Load_Feature1_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Feature1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Mice_Selection  = 1;
global pre_directory
run_GUI_FeatureExtraction



function Superpixel_Num_Callback(hObject, eventdata, handles)
% hObject    handle to Superpixel_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Superpixel_Num as text
%        str2double(get(hObject,'String')) returns contents of Superpixel_Num as a double
