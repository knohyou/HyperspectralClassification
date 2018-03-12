function [Predicted, Sensitivity,Specificity] = Postprocessing_wo_superpixel(Name, predict_label_L, Group_Test, x_size_DS, y_size_DS, Results_Folder, Results_Individual_Directory, Figures);


Truth = reshape(Group_Test, [x_size_DS, y_size_DS]);
Predicted = reshape(predict_label_L, [x_size_DS, y_size_DS]);

if Figures == 1
figure; imagesc(Truth)
print(gcf, fullfile(Results_Folder,strcat('DS_Truth', Name,'_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg') 
figure; imagesc(Predicted)
print(gcf, fullfile(Results_Folder,strcat('DS_Predicted', Name,'_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg') 
end


[c,cm,ind,per]  = confusion(Truth(:)', Predicted(:)');
if Figures == 1;
figure; plotconfusion(Truth(:)', Predicted(:)')
print(gcf, fullfile(Results_Folder,strcat('Confusion_', Name,'_', datestr(now, 'mmm-dd-yyyy'))), '-djpeg') 
end

Classified_NonTumors = cm(1,1)+cm(2,1);
Truth_NonTumors = cm(1,1)+cm(1,2);
Classified_Tumors = cm(2,2)+ cm(1,2);
Truth_Tumors = cm(2,2)+cm(2,1);
Total_Pixels_Classification = length(Predicted(:));
Total_Pixels_Truth = length(Truth(:));

[c,cm,ind,per]  = confusion(Predicted(:)', Truth(:)');
Sensitivity = per(1,4);
Specificity = per(1,3);


end

