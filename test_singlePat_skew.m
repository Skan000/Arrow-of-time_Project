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
    fw_data = fw_data(:,:);
    bw_data = fliplr(fw_data);

    [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
    [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

    [~, ~, deltaSkew_fw(i), aa(i)] = mardiaKurtosis(res_fw');
    [~, ~, deltaSkew_bw(i), bb(i)] = mardiaKurtosis(res_bw');

    delta_bwfw_R = deltaSkew_bw(i) - deltaSkew_fw(i);
    
    results1RL(i) = delta_bwfw_R;
end

%Compute kurtosis delta on one single patient at a time for the 4 Rest runs concatenated.
for i = 1:nPatients
    %Rest
    fw_data = concatPatientsAllRest(:,:,i);
    fw_data = fw_data(:,:);
    bw_data = fliplr(fw_data);

    [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
    [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

    [~, ~, deltaSkew_fw(i), aa(i)] = mardiaKurtosis(res_fw');
    [~, ~, deltaSkew_bw(i), bb(i)] = mardiaKurtosis(res_bw');

    delta_bwfw_R = deltaSkew_bw(i) - deltaSkew_fw(i);
    
    resultsAll(i) = delta_bwfw_R;
end