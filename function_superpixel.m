function [Feature, group, Superpixel_Cal_Vector, Superpixel_Cal_Matrix, Superpixel_Truth_Vector, Superpixel_Truth_Matrix, sup_cal_image_matrix] = function_superpixel(Mice_Num, Num_Superpixel, Reflectance_Cal_PCA_Image, Truth, Results_Folder, w, Pause, Superpixel_Constraint, Figures, Num_PCA);


x_size = size(Reflectance_Cal_PCA_Image,1);
y_size = size(Reflectance_Cal_PCA_Image,2);

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
print(gcf, fullfile(Results_Folder, strcat(Mice_Num, '_Superpixel_Reflectance_Cal_PC_',num2str(PC),'_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg')
end
end

for PC = 1:Num_PCA 
if Figures == 1;
figure; imagesc(Superpixel_Truth_Matrix(:,:,PC))
print(gcf, fullfile(Results_Folder, strcat(Mice_Num, '_Superpixel_Truth_PC_',num2str(PC),'_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg')
end
end

%% Rename Variables
Feature = Superpixel_Cal_Vector;
sup_cal_image_matrix = sup_cal_image{1};
group = Superpixel_Truth_Vector(:,1);
