% % Notes
% This is just a script with the basic template of how the app works
% Code for the app itself is written in the AppDesigner in Code view

%% SECTION 1
load("BaggedTrees_Model.mat")
load('WideNeuralNet_Model.mat')
load("FineTree_Model.mat")
% 
% T = readtable("ThinSheetDataToPredict.xlsx");
% yfit = trainedModel_NeuralNetwork.predictFcn(T);
% writematrix(yfit, 'PredictedData.xlsx');
% 
% pressure = table2array(T(:,1));
% predicted_forces = yfit;

% prompt input
% prompt_f = "Input desired force: ";
% force_input = input(prompt_f);
% prompt_pmin = "Input desired minimum pressure: ";
% prompt_pmax = "Input desired maximum pressure: ";
% min_pressure = input(prompt_pmin);
% max_pressure = input(prompt_pmax);

lengths = [12];
diameters = [0.25];
man_methods = {'Latex Sheet'};
thickness = [0.006];
% pressures = zeros(min_pressure, max_pressure);
pressures = 1:2000;

% write if statements to take this stuff out - CONSTRAINTS


% make data to predict
test_data = combinations(pressures, lengths, diameters, thickness, man_methods);
test_data = renamevars(test_data,["pressures","lengths","diameters","thickness","man_methods"],["Pressure","Length","Diameter","Thickness","FabricationMethod"]);

% predict using the data
yfit = BaggedTrees_Model.predictFcn(test_data);
predicted_forces = array2table(yfit);

final_data = [test_data, predicted_forces];
final_data.Properties.VariableNames{6} = 'Force';

yfit_nn = WideNeuralNet_Model.predictFcn(test_data);
pf_nn = array2table(yfit_nn);
fd_nn = [test_data, pf_nn];
fd_nn.Properties.VariableNames{6} = 'Force';

yfit_f = FineTree_Model.predictFcn(test_data);
pf_f = array2table(yfit_f);
fd_f = [test_data, pf_f];
fd_f.Properties.VariableNames{6} = 'Force';

figure()
hold on
scatter(final_data.Pressure, final_data.Force);
scatter(fd_nn.Pressure, fd_nn.Force);
scatter(fd_f.Pressure, fd_f.Force);
xlabel('Pressure (mBar)'), ylabel('Force (N)')
title('Predicted Force Profile for GPR Squared Exponential');

%% SECTION 2
% filter out the data based on desired force - get data as close to 45 as
% possible - top 5 suggestions

final_data.Mins = abs(final_data.Force - 45);



% for i = 1:height(predicted_forces)
%     force = double(final_data(i,6));
%     if force == force_input
%         suggestions = [suggestions; final_data(i)];
%     end
% end
% suggestions

%% SECTION 3
% split into matrices for each manufacturing type
latex_sheet = final_data(contains(final_data.FabricationMethod, 'Latex Sheet'), :);
[mins, sheet_index] = mink(latex_sheet.Mins, 5);
latex_tube = final_data(contains(final_data.FabricationMethod, 'Latex Tube'), :);
[mins, tube_index] = mink(latex_tube.Mins, 5);
bmis = final_data(contains(final_data.FabricationMethod, 'BMIS Rolled'), :);
[mins, bmis_index] = mink(bmis.Mins, 5);
ripstop = final_data(contains(final_data.FabricationMethod, 'Rolled Ripstop'), :);
[mins, ripstop_index] = mink(ripstop.Mins, 5);
latex_dip = final_data(contains(final_data.FabricationMethod, 'Latex Dip'), :);
[mins, dip_index] = mink(latex_dip.Mins, 5);

suggestions = [latex_sheet(sheet_index,:); latex_tube(tube_index, :); bmis(bmis_index, :); ripstop(ripstop_index, :); latex_dip(dip_index, :)];
