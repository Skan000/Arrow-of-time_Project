clear all

load Data/Concat_Emotion_100.mat

nPatients = 100; %Number of patients(and trials)
window = 8;
space=1;
runLength=166;
results = zeros(nPatients-1,runLength-window);

fw_data = concatPatientsEmotion(:,:,1:33);
fw_data = fw_data(:,:);
bw_data = fliplr(fw_data);

[~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
[~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);
res_bw=fliplr(res_bw);

%Compute kurtosis delta on concatNbr concatenated patients WM tasks.
for i = 1:nPatients-1
    %Task
    if i==34
        fw_data = concatPatientsEmotion(:,:,34:66);
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);
        res_bw=fliplr(res_bw);
    elseif i==67
        fw_data = concatPatientsEmotion(:,:,67:nPatients);
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);
        res_bw=fliplr(res_bw);
    end
    
    for j = 1:(runLength-1-window)/space
        start = ((j-1)*space+1)+runLength*mod(i-1,33);
        stop = ((j-1)*space+window)+runLength*mod(i-1,33);
        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw(:,start:stop));
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw(:,start:stop));

        delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;

        results(i,j*space) = delta_bwfw_T;      
    end
end
plot(mean(results))
title('Emotion Task targeting using sliding window with width = 8 frames using 166*33 time points')
ylabel('Average bw - fw delta kurtosis')
xlabel('Start frame of the window')
%xticklabels({'10','60','110','160','210','260','310','360','410'})
xlim([0 runLength-1-window])
%vline([72-window/2 143-window/2],'b')
%vline([47-window/2 118-window/2 190-window/2],'b')