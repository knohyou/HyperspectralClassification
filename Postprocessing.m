function [Tumor_Superpixel_Predicted, Sensitivity,Specificity, Classified_NonTumors, Truth_NonTumors, Classified_Tumors, Truth_Tumors, Total_Pixels_Classification, Total_Pixels_Truth] = Postprocessing(Name, Predicted, Expected, Results_Folder, Results_Individual_Directory, Superpixel_Index, Figures)

x_size = size(Superpixel_Index,1);
y_size = size(Superpixel_Index,2);
Tumor_Superpixel_Predicted = zeros(x_size,y_size);
Tumor_Superpixel_Expected = zeros(x_size,y_size);

for i = 0:max(max(Superpixel_Index))
    indx = find(Superpixel_Index == i);
    Tumor_Superpixel_Predicted(indx) = Predicted(i+1);
    Tumor_Superpixel_Expected(indx) = Expected(i+1);
end
if Figures == 1;
figure; imagesc(Superpixel_Index)
figure; imagesc(Tumor_Superpixel_Predicted)
figure; imagesc(Tumor_Superpixel_Expected)
end
%% Improve Classification Identify Connected Tumor Regon
BW = Tumor_Superpixel_Predicted;
if Figures == 1;
    figure; imagesc(BW)
end
CC = bwconncomp(BW);
stat=regionprops(CC,'Centroid','Area','PixelIdxList');
[maxValue,index] = max([stat.Area]);
[rw col]=size(stat);
for j=1:rw
    if (j~=index)
       BW(stat(j).PixelIdxList)=0; % Remove all small regions except large area index
    end
end

if Figures == 1;
figure,imagesc(BW);
end


Tumor_Superpixel_Predicted = imfill(BW,'holes'); 
if Figures == 1;
figure; imagesc(Tumor_Superpixel_Predicted)
end

Truth_Name = strcat('tumor_mask_',Name,'.tif');
Truth = double(imread(Truth_Name));
if Figures == 1;
figure; imagesc(Truth)
set(gcf,'position',[0 0 1 1],'units','normalized')
print(gcf, fullfile(Results_Folder,strcat('Truth_', Name, datestr(now, 'mmm-dd-yyyy'))), '-djpeg') 
end

if Figures == 1;
figure; imagesc(Tumor_Superpixel_Predicted)
print(gcf, fullfile(Results_Folder,strcat('Tumor_Superpixel_Predicted_', Name,'_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg') 
end

if Figures == 1;
figure; imagesc(Tumor_Superpixel_Expected)
print(gcf, fullfile(Results_Folder,strcat('Tumor_Superpixel_Expected_', Name,'_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg') 
end

%% Evaluation of Sensitivity and Specificity
[c,cm,ind,per]  = confusion(Truth(:)', Tumor_Superpixel_Predicted(:)');
if Figures == 1;
figure; plotconfusion(Truth(:)', Tumor_Superpixel_Predicted(:)')
print(gcf, fullfile(Results_Folder,strcat('Confusion_', Name,'_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg') 
end

Classified_NonTumors = cm(1,1)+cm(2,1);
Truth_NonTumors = cm(1,1)+cm(1,2);
Classified_Tumors = cm(2,2)+ cm(1,2);
Truth_Tumors = cm(2,2)+cm(2,1);
Total_Pixels_Classification = length(Tumor_Superpixel_Predicted(:));
Total_Pixels_Truth = length(Truth(:));

[c,cm,ind,per]  = confusion(Tumor_Superpixel_Predicted(:)', Truth(:)');
Sensitivity = per(1,4);
Specificity = per(1,3);

end

