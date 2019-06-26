clear all

load Data/Concat_Rest1LR_100.mat
load Data/Concat_AllRest_100.mat

nPatients = 100;
results1RL = zeros(1,nPatients);
resultsAll = zeros(1,nPatients);

%Compute kurtosis delta on one single patient at a time for Rest1RL.
for i = 1:nPatients
    
    %Rest
    fw_data = concatPatients(:,:,i);
    fw_data = [fw_data(:,:) fw_data(:,:) fw_data(:,:)];
    bw_data = fliplr(fw_data);

    [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
    [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

    [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
    [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

    delta_bwfw_R = deltaKurt_bw - deltaKurt_fw;
    
    results1RL(i) = delta_bwfw_R;
end

%Compute kurtosis delta on one single patient at a time for the 4 Rest runs concatenated.
for i = 1:nPatients
    
    %Rest
    fw_data = concatPatientsAllRest(:,:,i);
    fw_data = [fw_data(:,:) fw_data(:,:) fw_data(:,:)];
    bw_data = fliplr(fw_data);

    [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
    [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

    [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
    [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

    delta_bwfw_R = deltaKurt_bw - deltaKurt_fw;
    
    resultsAll(i) = delta_bwfw_R;
end