clear all

load Data/Concat_TaskWM_100.mat
load Data/Concat_Rest1LR_100.mat

nPatients = 25;
results = zeros(2,nPatients);

%Compute kurtosis delta on concatenated patients(starting from 1 to nPatients combined patients) for Rest1RL and Language task.
for i = 1:nPatients
    %Task
    if i>0
        fw_data = concatPatients(:,:,1:i);
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

        delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;
    end
    %Rest
    %fw_data = concatPatientsAllRest(:,:,1:i);
    %fw_data = fw_data(:,:);
    %bw_data = fliplr(fw_data);

    %[~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
    %[~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

    %[~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
    %[~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

    delta_bwfw_R = 0;%deltaKurt_bw - deltaKurt_fw;
    if i>0
        results(:,i) = [delta_bwfw_T, delta_bwfw_R];
    else
        results(:,i) = [0.0, delta_bwfw_R];
    end
end

stem(results(1,:))
title('Results on concatenated Rest1LR tasks')
ylabel('bw - fw delta kurtosis')
xlabel('Number of patients')
ylim([-600 200])