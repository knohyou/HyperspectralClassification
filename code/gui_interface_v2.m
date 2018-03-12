function varargout = gui_interface_v2(varargin)
% GUI_INTERFACE_V2 MATLAB code for gui_interface_v2.fig
%      GUI_INTERFACE_V2, by itself, creates a new GUI_INTERFACE_V2 or raises the existing
%      singleton*.
%
%      H = GUI_INTERFACE_V2 returns the handle to a new GUI_INTERFACE_V2 or the handle to
%      the existing singleton*.
%
%      GUI_INTERFACE_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_INTERFACE_V2.M with the given input arguments.
%
%      GUI_INTERFACE_V2('Property','Value',...) creates a new GUI_INTERFACE_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_interface_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_interface_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_interface_v2

% Last Modified by GUIDE v2.5 08-Dec-2015 14:59:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_interface_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_interface_v2_OutputFcn, ...
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


% --- Executes just before gui_interface_v2 is made visible.
function gui_interface_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_interface_v2 (see VARARGIN)

% Choose default command line output for gui_interface_v2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_interface_v2 wait for user response (see UIRESUME)
% uiwait(handles.tag);


% --- Outputs from this function are returned to the command line.
function varargout = gui_interface_v2_OutputFcn(hObject, eventdata, handles) 
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

%% Add Directories and Folders and Subfolders
pre_directory = 'F:\ImageProcessingProject\';
cd(pre_directory)
addpath(genpath('libsvm-3.20'))
cd(strcat(pre_directory,'libsvm-3.20\matlab\'))
make %make allows matlab to run Mex files (c code)
cd(pre_directory)
addpath(genpath('SLIC_mex')) 
opengl('save','hardware')
addpath(genpath(strcat(pre_directory,'OriginalData')))
cd(pre_directory)

prompt = {'Enter Mice Num: ','Enter Superpixel Num:','Enter Superpixel Constraint:','Number of PCA:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1','1000','100','2'};
Superpixel_Parameter = inputdlg(prompt,dlg_title,num_lines,defaultans);

project_label = '_PC2'; %Project Trials
Mice_Number = str2num(Superpixel_Parameter{1});
Num_Superpixel = str2num(Superpixel_Parameter{2});
Superpixel_Constraint = str2num(Superpixel_Parameter{3});
Num_PCA = str2num(Superpixel_Parameter{4});
Project = 'Results_PCA_SLIC_SVM'; %Project Folder Name
Results_Dir = strcat(pre_directory,'Results'); %Name Results folders for all resultsDownsample_Num = 2; % For pixelwise method
Name_All = {'888', '889', '890', '891', '892', '893', '894', '895', '896', '897', '898'}; %Mice Numbers
w = 450:2:880; %Wavelength Region of Analysis
Figures = 0; 

%% Choose Results Folder
Results_Folder = strcat(Results_Dir,'\',datestr(now, 'mmm-dd-yyyy'),project_label);
Check = exist(Results_Folder);
if Check == 0
    mkdir(Results_Folder)
end
addpath(genpath(strcat(pre_directory,'Results')))


%% Feature ExtractionFeature1_All = {};
Feature2_All = {};
Group_All = {};
Image_xsize = {};
Image_ysize = {};
Superpixel_size_All = {};
Pause = 0;
Superpixel_sd = {};
Superpixel_Indx = {};
PCA_latent = {};
i = Mice_Number
    %% Raw data, White, Dark, and Ground Truth data names
    Image_Name = strcat('im_',Name_All{i},'.mat');
    White_Name = strcat('white_',Name_All{i},'.mat');
    Dark_Name = strcat('dark_',Name_All{i},'.mat');
    Truth_Name = strcat('tumor_mask_',Name_All{i},'.tif');
    
    
    %% Create Processed Images Folder to store images
    Results_Individual_Folder = strcat(pre_directory,'ProcessedData\',Name_All{i},'\',Project,'\',datestr(now, 'mmm-dd-yyyy'),project_label);
    Check = exist(Results_Individual_Folder);
    if Check == 0
        mkdir(Results_Individual_Folder)
    end
    
    
    %% Showing Spectra Tumor vs Normal
load(Image_Name)
load(Dark_Name)
load(White_Name)

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
title('Select Tumor Region (Refer Ground Truth Image)')
Tumor_ROI = double(roipoly); 
size(Tumor_ROI)
figure; imagesc(Reflectance(:,:,w == 812));
title('Select NonTumor Region (Refer Ground Truth Image)')
Normal_ROI = double(roipoly);

disp('Processing')
Tumor_Plot = [];
Normal_Plot = [];
for k = 1:size(Reflectance,3)
    Mask_Reflectance = Reflectance(:,:,k).*Tumor_ROI;
    Mask_Reflectance_Normal = Reflectance(:,:,k).*Normal_ROI;
    Tumor_Plot(k) = sum(Mask_Reflectance(:))./sum(Tumor_ROI(:));
    Normal_Plot(k) = sum(Mask_Reflectance_Normal(:))./sum(Normal_ROI(:));
end

Wavelengths = linspace(w(1), w(end), length(Tumor_Plot));
axes(handles.axes6);
plot(Wavelengths, Tumor_Plot,'b-', Wavelengths, Normal_Plot, 'r-')
legend('Tumor Spectra', 'Normal Spectra','Location','northoutside')

 %% Apply PCA and Superpixel Segmentation
    [Feature, Group, Superpixel_Cal_Vector, Superpixel_Cal_Matrix, Superpixel_Truth_Vector, Superpixel_Truth_Matrix, sup_cal_image, latent]= function_PCA_SVM(Num_Superpixel, Truth_Name,Image_Name,White_Name,Dark_Name, Results_Individual_Folder, w, Pause, Superpixel_Constraint, Figures, Num_PCA);
    Superpixel_Indx{i} = sup_cal_image;
    Superpixel_Cal_Matrix_All{i} = Superpixel_Cal_Matrix;
    Superpixel_Truth_Matrix_All{i} = Superpixel_Truth_Matrix;
    PCA_latent{i} = latent;
    
      %% Standardize the Features
    Feature_Standardize = zeros(size(Feature,1),size(Feature,2));
    for j = 1:size(Feature,2)
        Feature_Standardize(:,j) = Feature_Stand(Feature(:,j));
    end
    
    %% Store Features and Ground Truths in Cells
    Feature_All{i} = Feature_Standardize;
    Group_All{i} = Group;  


axes(handles.axes2);
imagesc(Superpixel_Cal_Matrix_All{Mice_Number}(:,:,2))
impixelinfo()
axes(handles.axes3);
imagesc(Superpixel_Cal_Matrix_All{Mice_Number}(:,:,1))
impixelinfo()
axes(handles.axes4);
imagesc(Reflectance(:,:,w == 812))
impixelinfo()
axes(handles.axes5);
gscatter(Feature_All{1}(:,1),Feature_All{1}(:,2),Group_All)
legend('Tumor', 'Normal','Location','northoutside')
xlabel('Feature 1')
ylabel('Feature 2')


Mice_Number = i; 
 for PC = 1:Num_PCA
  figure(10); subplot(1,Num_PCA,PC); imagesc(Superpixel_Cal_Matrix_All{Mice_Number}(:,:,PC))
 title(strcat('PC',num2str(PC)))   
 axis square
 end
 
 disp('Completed Feature Extraction of One Mice')
 disp('Click All Mice Feature Extraction & Classification to Run Process')
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pre_directory num

%% Add Directories and Folders and Subfolders
pre_directory = 'F:\ImageProcessingProject\';
cd(pre_directory)
addpath(genpath('libsvm-3.20'))
cd(strcat(pre_directory,'libsvm-3.20\matlab\'))
make %make allows matlab to run Mex files (c code)
cd(pre_directory)
addpath(genpath('SLIC_mex')) 
opengl('save','hardware')
addpath(genpath(strcat(pre_directory,'OriginalData')))
cd(pre_directory)

prompt = {'Enter Superpixel Num:','Enter Superpixel Constraint:','Number of PCA:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1000','100','2'};
Superpixel_Parameter = inputdlg(prompt,dlg_title,num_lines,defaultans);

%Mice_Number = str2num(Superpixel_Parameter{1});
Num_Superpixel = str2num(Superpixel_Parameter{1});
Superpixel_Constraint = str2num(Superpixel_Parameter{2});
Num_PCA = str2num(Superpixel_Parameter{3});
project_label = strcat('_PC',num2str(Num_PCA)); %Project Trials
Project = 'Results_PCA_SLIC_SVM'; %Project Folder Name
Results_Dir = strcat(pre_directory,'Results'); %Name Results folders for all resultsDownsample_Num = 2; % For pixelwise method
Name_All = {'888', '889', '890', '891', '892', '893', '894', '895', '896', '897', '898'}; %Mice Numbers
w = 450:2:880; %Wavelength Region of Analysis
Figures = 0; 

%% Choose Results Folder
Results_Folder = strcat(Results_Dir,'\',datestr(now, 'mmm-dd-yyyy'),project_label);
Check = exist(Results_Folder);
if Check == 0
    mkdir(Results_Folder)
end
addpath(genpath(strcat(pre_directory,'Results')))


%% Feature ExtractionFeature1_All = {};
Feature2_All = {};
Group_All = {};
Image_xsize = {};
Image_ysize = {};
Superpixel_size_All = {};
Pause = 0;
Superpixel_sd = {};
Superpixel_Indx = {};
PCA_latent = {};
for i = 1:length(Name_All)
    disp(strcat('Mice',num2str(i)))
    %% Raw data, White, Dark, and Ground Truth data names
    Image_Name = strcat('im_',Name_All{i},'.mat');
    White_Name = strcat('white_',Name_All{i},'.mat');
    Dark_Name = strcat('dark_',Name_All{i},'.mat');
    Truth_Name = strcat('tumor_mask_',Name_All{i},'.tif');
    
    
    %% Create Processed Images Folder to store images
    Results_Individual_Folder = strcat(pre_directory,'ProcessedData\',Name_All{i},'\',Project,'\',datestr(now, 'mmm-dd-yyyy'),project_label);
    Check = exist(Results_Individual_Folder);
    if Check == 0
        mkdir(Results_Individual_Folder)
    end
    
    
    %% Apply PCA and Superpixel Segmentation
    disp('Apply PCA and Superpixels')
    [Feature, Group, Superpixel_Cal_Vector, Superpixel_Cal_Matrix, Superpixel_Truth_Vector, Superpixel_Truth_Matrix, sup_cal_image, latent]= function_PCA_SVM(Num_Superpixel, Truth_Name,Image_Name,White_Name,Dark_Name, Results_Individual_Folder, w, Pause, Superpixel_Constraint, Figures, Num_PCA);
    Superpixel_Indx{i} = sup_cal_image;
    Superpixel_Cal_Matrix_All{i} = Superpixel_Cal_Matrix;
    Superpixel_Truth_Matrix_All{i} = Superpixel_Truth_Matrix;
    PCA_latent{i} = latent;
    
      %% Standardize the Features
    Feature_Standardize = zeros(size(Feature,1),size(Feature,2));
    for j = 1:size(Feature,2)
        Feature_Standardize(:,j) = Feature_Stand(Feature(:,j));
    end
    
    %% Store Features and Ground Truths in Cells
    Feature_All{i} = Feature_Standardize;
    Group_All{i} = Group;  

 Mice_Number = i;
axes(handles.axes2);
imagesc(Superpixel_Cal_Matrix_All{Mice_Number}(:,:,2))
impixelinfo()
axes(handles.axes3);
imagesc(Superpixel_Cal_Matrix_All{Mice_Number}(:,:,1))
impixelinfo()
axes(handles.axes5);
gscatter(Feature_All{i}(:,1),Feature_All{i}(:,2),Group_All{i})
legend('Tumor', 'Normal','Location','northoutside')
xlabel('Feature 1')
ylabel('Feature 2')


Mice_Number = i; 
 for PC = 1:Num_PCA
  figure(10); subplot(1,Num_PCA,PC); imagesc(Superpixel_Cal_Matrix_All{Mice_Number}(:,:,PC))
 title(strcat('PC',num2str(PC)))   
 axis square
 end
end

disp('Apply SVM')
%% Run Support Vector Machine
Sensitivity = {};
Specificity = {};
Classified_NonTumors = {};
Truth_NonTumors = {};
Classified_Tumors = {};
Truth_Tumors = {};
Total_Pixels_Classification = {};
Total_Pixels_Truth = {};
predict_label = {};
accuracy = {};
dec_values = {};
CrossVal_Matrix = [];
Tumor_Predicted = {};
for i = 1:length(Name_All)
    disp(strcat('SVM for Mice',num2str(i)))
    
    
    %% Feature Testing Data
    Feature_Test = Feature_All{i};
        
    %% Feature Training Dataset
    Feature_temp = Feature_All;
    Feature_temp{i} = [];
    Feature_temp(~cellfun('isempty',Feature_temp)); %leave-one-out method 
    Feature_Train = Feature_temp;
    Feature = Combine_Cell_Vector(Feature_Train);

    %% Superpixel Ground Truth Testing Data
    Group_Test = Group_All{i};
    
    %% Group Training Dataset
    Group_temp = Group_All;
    Group_temp{i} = [];
    Group_temp(~cellfun('isempty',Group_temp)); %leave-one-out method 
    Group_Train = Group_temp;
    Group = Combine_Cell_Vector(Group_Train); 
    
    
    Name = Name_All{i}; %Mice of Interest for Testing Data  
    training_label = Group; 
    training_data = Feature;
    test_label = Group_Test;
    test_data = Feature_Test;
    
    %% Train SVM Model
    C = sum(find(Group == 1)); %Set C Parameter for 
    C_Tumor = C/sum(find(Group == 1)); %C Parameter for Tumor Class
    C_Normal = C/sum(find(Group == 0)); %C Parameter for Normal Tissue Class
    model_rbf = svmtrain(training_label,training_data, sprintf('-t 2 -c 1 -w1 %g -w0 %g', C_Tumor, C_Normal'))
    
    %% Test SVM Classifier 
    [predict_label_L, accuracy_L, dec_values_L] = svmpredict(test_label, test_data, model_rbf);
    predict_label{i} = predict_label_L;
    accuracy{i} = accuracy_L;
    dec_values{i} = dec_values_L;
    
    %% Post Processing and Performance Evaluation
    Results_Individual_Directory  = strcat(pre_directory,'Results\',datestr(now, 'mmm-dd-yyyy'),project_label);
    [Tumor_Superpixel_Predicted, Sensitivity_Ind,Specificity_Ind, Classified_NonTumors, Truth_NonTumors, Classified_Tumors, Truth_Tumors, Total_Pixels_Classification, Total_Pixels_Truth] = Postprocessing(Name, predict_label_L, Group_Test, Results_Folder, Results_Individual_Directory, Superpixel_Indx{i}, Figures);
    
    Tumor_Predicted{i} = Tumor_Superpixel_Predicted;
    Sensitivity{i} = Sensitivity_Ind;
    Specificity{i} = Specificity_Ind;
end

%% Compile Results in Excel Table
Mice = Name_All;
T = table(Mice', Sensitivity', Specificity', 'VariableNames', {'Mice','Sensitivity', 'Specificity'});

mean(cell2mat(Specificity))
writetable(T, fullfile(Results_Folder,strcat('Mice12_LeaveOneOut', datestr(now, 'mmm-dd-yyyy'),'.xls')));


%% Plotting the Average Sensitivity and Specificity
Avg_Specificity =[];
Avg_Sensitivity= [];
for i = 2:Num_PCA
Avg_Sensitivity(i-1) = mean(cell2mat(Sensitivity));
Avg_Specificity(i-1) = mean(cell2mat(Specificity));
end

model_series = [Avg_Sensitivity', Avg_Specificity'];


if Num_PCA == 2;
    axes(handles.axes8);
    h = bar([1 2], [NaN NaN; model_series]);    
    xlabel('Number of Principal Components','fontsize',13)
ylabel('Performance','fontsize',13)
set(gca,'FontSize',13);
h_legend = legend('Average Sensitivity','Average Specificity','Location','northoutside');
axis([1.5 2.5 0 1])
set(h(1), 'FaceColor','r')
set(h(2), 'FaceColor','b')
set(h_legend,'FontSize',13);
print -dpng Components_Plot
disp('Completed Project')
elseif Num_PCA > 2
    axes(handles.axes8);
    h = bar([2:Num_PCA], model_series);
%errorbar([2 3 4 5],model_series,model_error,'.')
xlabel('Number of Principal Components','fontsize',13)
ylabel('Performance','fontsize',13)
set(gca,'FontSize',13);
h_legend = legend('Average Sensitivity','Average Specificity','Location','northoutside');
axis([1 Num_PCA+1 0 1])
set(h(1), 'FaceColor','r')
set(h(2), 'FaceColor','b')
set(h_legend,'FontSize',13);
print -dpng Components_Plot
disp('Completed Project')
end
