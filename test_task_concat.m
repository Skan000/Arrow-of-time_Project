%Concat 16 language tasks runs 306*16 to get roughly as much datapoints as
%in rest runs 1190*4

clear all

load Data/Concat_TaskLang_100.mat
load Data/Concat_AllRest_100.mat

nPatients = 100;
results = zeros(nPatients);

%Compute kurtosis delta on 16 concatenated patients Language task.
for i = 1:nPatients
    %Task
    if i+16<100
        fw_data = concatPatientsTask(:,:,i:i+16);
        fw_data = fw_data(:,:);
        %fw_data = fw_data - mean(fw_data);
        %fw_data = normr(fw_data);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

        delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;
        
    else
        fw_data1 = concatPatientsTask(:,:,i:nPatients);
        fw_data1 = fw_data1(:,:);
        fw_data2 = concatPatientsTask(:,:,1:i+16-nPatients);
        fw_data2 = fw_data2(:,:);
        fw_data = [fw_data1 fw_data2];
        %fw_data = fw_data - mean(fw_data);
        %fw_data = normr(fw_data);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

        delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;
    end
    
    results(i) = delta_bwfw_T;
end