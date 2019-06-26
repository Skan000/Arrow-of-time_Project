%Computes delta kurtosis on WM tasks randomly concatenated for each patients

clear all

load Data/Concat_AllRestSep_100.mat

nPatients = 100;
results = zeros(nPatients,1);

concatNbr = 18; %Number of concatenated runs

%Compute kurtosis delta on concatNbr concatenated patients WM tasks.
for i = 1:nPatients
    %Task
    fw_data = concatPatientsAllRestSep(:,:,randperm(400,concatNbr));
    fw_data = fw_data(:,:);
    bw_data = fliplr(fw_data);

    [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
    [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

    [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
    [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

    delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;
    
    results(i) = delta_bwfw_T;
end
stem(results)
title('Results on 18 randomly concatenated patients for the Rest tasks')
ylabel('bw - fw delta kurtosis')
xlabel('Group ID')
ylim([-600 200])