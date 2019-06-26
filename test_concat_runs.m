%Computes delta kurtosis on WM tasks concatenated in order for each patients

clear all

load Data/Concat_TaskWM_100.mat

nPatients = 100;
results = zeros(nPatients,1);

concatNbr = 23; %0 for no concatenation

%Compute kurtosis delta on concatNbr concatenated patients WM tasks.
for i = 1:nPatients
    %Task
    if i+concatNbr<100
        fw_data = concatPatientsWMem(:,:,i:i+concatNbr);
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

        delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;
        
    else
        fw_data1 = concatPatientsWMem(:,:,i:nPatients);
        fw_data1 = fw_data1(:,:);
        fw_data2 = concatPatientsWMem(:,:,1:i+concatNbr-nPatients);
        fw_data2 = fw_data2(:,:);
        fw_data = [fw_data1 fw_data2];
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

        delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;
    end
    
    results(i) = delta_bwfw_T;
end
stem(results)
title('Results on 24 concatenated patients for the Rest1LR run')
ylabel('bw - fw delta kurtosis')
xlabel('Group ID')
ylim([-400 200])