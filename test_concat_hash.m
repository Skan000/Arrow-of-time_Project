%Computes delta kurtosis on WM tasks concatenated for each patients

clear all

load Data/Concat_TaskWM_100.mat

nPatients = 100;
results = zeros(nPatients,1);

concatNbr = 22; %0 for no concatenation

%Compute kurtosis delta on concatNbr concatenated patients WM tasks.
for i = 1:nPatients
    %Task
    fw_data = concatPatientsWMem(:,:,randperm(100,concatNbr));
    fw_data = fw_data(:,:);
    bw_data = fliplr(fw_data);

    [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
    [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

    res_fw = WMBlockExtraction(res_fw,concatNbr);
    res_bw = WMBlockExtraction(res_bw,concatNbr);
        
    [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
    [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

    delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;
    
    results(i) = delta_bwfw_T;
end
stem(results)
title('Results on 22 randomly concatenated patients for the WM task with block selection')
ylabel('bw - fw delta kurtosis')
xlabel('Group ID')
ylim([-200 200])