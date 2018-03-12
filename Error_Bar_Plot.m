%% Plotting the Average Sensitivity and Specificity

Avg_Sensitivity = [];
Std_Sensitivity = [];
Avg_Specificity = [];
Std_Specificity = [];
PCA_Num = 5;
for i = 2:PCA_Num
Results_Folder = 'Results\';
Data = xlsread(fullfile(Results_Folder,strcat('PCA',num2str(i),'.xls')));
Sensitivity_Data = Data(:,2); 
Specificity_Data = Data(:,3); 
Avg_Sensitivity(i-1) = mean(Sensitivity_Data);
Std_Sensitivity(i-1) = std(Sensitivity_Data);
Avg_Specificity(i-1) = mean(Specificity_Data); 
Std_Specificity(i-1) = std(Specificity_Data); 
end

model_series = [Avg_Sensitivity', Avg_Specificity'];
model_error = [Std_Sensitivity', Std_Specificity'];

[bar_xtick,hb,he]=errorbar_groups(model_series,model_error);

figure(2); 
h = bar([2 3 4 5], model_series);
%errorbar([2 3 4 5],model_series,model_error,'.')
xlabel('Number of Principal Components','fontsize',13)
ylabel('Performance','fontsize',13)
set(gca,'FontSize',13);
h_legend = legend('Average Sensitivity','Average Specificity','Location','northoutside')
axis([1 6 0 1])
set(h(1), 'FaceColor','r')
set(h(2), 'FaceColor','b')
set(h_legend,'FontSize',13);
print -dpng Components_Plot
