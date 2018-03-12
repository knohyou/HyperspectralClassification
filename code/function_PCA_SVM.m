function [Feature, group, Superpixel_Cal_Vector, Superpixel_Cal_Matrix, Superpixel_Truth_Vector, Superpixel_Truth_Matrix, sup_cal_image_matrix, latent] = function_PCA_SVM(Num_Superpixel, Truth_Name,Image_Name,White_Name,Dark_Name, Results_Folder, w, Pause, Superpixel_Constraint, Figures, Num_PCA);

%% Load Images
% Load Raw Image, Dark Image, and White Image and Ground Truth Dataset
load(Image_Name)
load(Dark_Name)
load(White_Name)

Mice_Num = str2num(Image_Name(4:6));
Image = double(hsi_roi(:,:,1:length(w)));
Dark = double(dark_roi(:,:,1:length(w)));
White = double(white_roi(:,:,1:length(w)));
Name = num2str(Mice_Num);
Truth = double(imread(Truth_Name));

x_size = size(Image,1);
y_size = size(Image,2);
z_size = size(Image,3);

% Figures of Ground Truth, Dark and White Images
if Figures == 1
figure;  imagesc(Truth);
print(gcf, fullfile(Results_Folder, strcat(Name, '_Truth_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg')
figure; imagesc(Dark(:,:,1));
print(gcf, fullfile(Results_Folder, strcat(Name, '_Dark_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg')
figure;  imagesc(White(:,:,1));
print(gcf, fullfile(Results_Folder, strcat(Name, '_White_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg')
end

%% Reflectance Hypercube
% Calculates the Reflectance Dataset based on the (Raw -Dark)/(White -
% Dark). The A value is there to prevent division by zero
A = zeros(size(White,1),size(White,2),size(White,3)); A(A==0) = eps; 
Reflectance = (Image - Dark)./((White+A) - Dark);
w_interest = find(w == 812);
if Figures == 1
figure; imagesc(Reflectance(:,:,w_interest));
print(gcf, fullfile(Results_Folder, strcat(Name, '_Reflectance_NotCal_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg')
end

%% Normaliziation - Reflectance Calibration
% The total reflectance is the sum of all reflectance intensity values for
% each pixels. Reflectance hypercube is normalized by the total
% reflectance. 
Total_Reflectance = sum(Reflectance,3);
Total_Reflectance_Filt = medfilt2(Total_Reflectance,[3,3], 'symmetric');
if Figures ==1 
figure; imagesc(Total_Reflectance)
figure; imagesc(Total_Reflectance_Filt)
end

Difference_Reflectance_Cal = [];
Difference_Reflectance = [];
Reflectance_Cal = zeros(x_size,y_size,z_size);
for i = 1:x_size
    for j = 1:y_size
        Reflectance_Cal(i,j,:) = Reflectance(i,j,:)./Total_Reflectance_Filt(i,j);
    end
end

if Figures == 1;
figure; imagesc(Reflectance_Cal(:,:,w_interest));
print(gcf, fullfile(Results_Folder, strcat(Name, '_Reflectance_Cal_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg')
end

%% Apply PCA
% PCA is applied to the Reflectance Normalized Dataset
Reflectance_Cal_Vector = reshape(Reflectance_Cal,[x_size*y_size, length(w)]);
[coeff,score, latent] = pca(Reflectance_Cal_Vector);
Reflectance_Cal_PCA = Reflectance_Cal_Vector*coeff;
Reflectance_Cal_PCA_Image = reshape(Reflectance_Cal_PCA,[x_size,y_size,length(w)]);

%% Apply Superpixel
sup_cal_image = {};
Superpixel_Truth_Vector = [];
Superpixel_Truth = zeros(x_size,y_size);
Superpixel_Truth_Matrix = zeros(x_size,y_size,Num_PCA);
Superpixel_Cal_Vector = [];
Superpixel_Cal_Image = zeros(x_size,y_size);
Superpixel_Cal_Matrix = zeros(x_size,y_size,Num_PCA);
for pca_indx = 1:Num_PCA %Input variable Num_PCA determines the number of principal components used 
    %% Create Superpixels
    First_PC_Image = Reflectance_Cal_PCA_Image(:,:,1);
    sup_cal_image{pca_indx} = Superpixel_SLIC(Mice_Num, First_PC_Image,Num_Superpixel,Superpixel_Constraint, Results_Folder);
    
    %% Using the superpixel defined regions, reconstruct the superpixel PCA images
    for i = 0:max(max( sup_cal_image{pca_indx}))
        [indx] = find( sup_cal_image{pca_indx} == i);
        Reflectance_Cal_Image = Reflectance_Cal_PCA_Image(:,:,pca_indx);
        Superpixel_Cal_Vector(i+1, pca_indx) = mean(mean(Reflectance_Cal_Image(indx),1),2);
        Superpixel_Cal_Image(indx) = mean(mean(Reflectance_Cal_Image(indx),1),2);
        temp = mean(mean(Truth(indx),1),2);
       
        %% Create Superpixel Ground Truth Image 
        % If more than half of a superpixel region is tumor, set  the superpixel ground truth region = 1, 
        % If more than half of a superpixel region is normal, set  the superpixel ground truth region = 0, 
        if temp >= 0.5
             Superpixel_Truth_Vector(i+1, pca_indx) = 1; 
            Superpixel_Truth(indx) = 1;
        elseif temp < 0.5
            Superpixel_Truth(indx) = 0;
             Superpixel_Truth_Vector(i+1, pca_indx) = 0; 
        end
    end
    Superpixel_Cal_Matrix(:,:,pca_indx) = Superpixel_Cal_Image;
    Superpixel_Truth_Matrix(:,:,pca_indx) = Superpixel_Truth;
end

%% Save Different PC Images
for PC = 1:Num_PCA 
if Figures == 1;
figure; imagesc(Superpixel_Cal_Matrix(:,:,PC))
print(gcf, fullfile(Results_Folder, strcat(Name, '_Superpixel_Reflectance_Cal_PC_',num2str(PC),'_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg')
end
end

for PC = 1:Num_PCA 
if Figures == 1;
figure; imagesc(Superpixel_Truth_Matrix(:,:,PC))
print(gcf, fullfile(Results_Folder, strcat(Name, '_Superpixel_Truth_PC_',num2str(PC),'_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg')
end
end

%% Rename Variables
Feature = Superpixel_Cal_Vector;
sup_cal_image_matrix = sup_cal_image{1};
group = Superpixel_Truth_Vector(:,1);
end
