TestPercent = 0.3;
% Number of rows in AllData, replace with all_contraction_data from
% contraction data
num_rows = size(AllData, 1);
% Number of rows to extract for TestData
num_rows_test = round(TestPercent * num_rows);

% Randomly select rows for TestData
index_test = datasample(1:num_rows, num_rows_test, 'Replace', false);
TestData30 = AllData(index_test, :);

% Select the remaining rows for TrainingData
TrainingData30 = AllData;
TrainingData30(index_test, :) = [];