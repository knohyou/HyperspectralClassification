function [Reflectance_Cal, Mice_Num, Truth] = function_PCA(Truth_Name,Image_Name,White_Name,Dark_Name, Results_Folder, w, Figures);

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


end
