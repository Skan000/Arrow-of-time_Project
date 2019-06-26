clear all

load Data/Concat_TaskWM_100.mat

nPatients = 100; %Number of patients(and trials)
window = 10;
results = zeros(nPatients,394-window);

%Compute kurtosis delta on concatNbr concatenated patients WM tasks.
for i = 1:nPatients
    %Task
    fw_data = concatPatientsWMem(:,:,i);
    fw_data = fw_data(:,:);
    bw_data = fliplr(fw_data);

    [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
    [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);
    res_bw=fliplr(res_bw);
    
    for j = 1:394-window

        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw(:,((j-1)*1+1):((j-1)*1+window)));
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw(:,((j-1)*1+1):((j-1)*1+window)));

        delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;

        results(i,j) = delta_bwfw_T;      
    end
end
plot(mean(results))
title('Task targeting using sliding window with width = 10 frames')
ylabel('Average bw - fw delta kurtosis')
xlabel('Starting frame of the window')
%xticklabels({'10','60','110','160','210','260','310','360','410'})
xlim([0 394-window])
vline([100-window/2 196-window/2 292-window/2],'b')
vline([76-window/2 172-window/2 268-window/2 364-window/2],'b')