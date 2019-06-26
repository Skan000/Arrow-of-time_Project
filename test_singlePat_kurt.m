clear all

nPatients = 100;
results1RL = zeros(1,nPatients);
resultsAll = zeros(1,nPatients);
run=3;

%Compute kurtosis delta on one single patient at a time for Rest1RL.
if run ==1
    load Data/Concat_Rest1LR_100.mat
    for i = 1:nPatients

        %Rest
        fw_data = concatPatients(:,:,i);
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

        delta_bwfw_R = deltaKurt_bw - deltaKurt_fw;

        results1RL(i) = delta_bwfw_R;
    end

%Compute kurtosis delta on one single patient at a time for the 4 Rest runs concatenated.
elseif run==2
    load Data/Concat_AllRest_100.mat
    for i = 1:nPatients

        %Rest
        fw_data = concatPatientsAllRest(:,:,i);
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

        delta_bwfw_R = deltaKurt_bw - deltaKurt_fw;

        resultsAll(i) = delta_bwfw_R;
    end
    
elseif run ==3
%Compute kurtosis delta on one single patient at a time for TaskWM.
load Data/Concat_TaskWM_100.mat
    for i = 1:nPatients
        
        %TaskMW
        fw_data = concatPatientsWMem(:,:,i);
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 7);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 7);

        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

        delta_bwfw_R = deltaKurt_bw - deltaKurt_fw;

        resultsTask(i) = delta_bwfw_R;
    end
end