clear all

load Data/Concat_Motor_100.mat

nPatients = 100; %Number of patients(and trials)
window = 8;
space=1;
runLength=274;
results = zeros(nPatients,runLength-window);

fw_data = concatPatientsMotor(:,:,1:33);
fw_data = fw_data(:,:);
bw_data = fliplr(fw_data);

[~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
[~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);
res_bw=fliplr(res_bw);

%Compute kurtosis delta on concatNbr concatenated patients WM tasks.
for i = 1:nPatients-1
    disp(i);
    %Task
    if i==34
        fw_data = concatPatientsMotor(:,:,34:66);
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);
        res_bw=fliplr(res_bw);
    elseif i==67
        fw_data = concatPatientsMotor(:,:,67:nPatients);
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
average=mean(results);
plot(average)
title('Motor Task targeting using sliding window with width = 8 frames using 274*33 time points')
ylabel('Average bw - fw delta kurtosis')
xlabel('Start frame of the window')
%xticklabels({'10','60','110','160','210','260','310','360','410'})
xlim([0 runLength-1-window])
vline([123-window/2 204-window/2],'b')
vline([102-window/2 184-window/2 245-window/2],'b')
set(gca,'FontSize',13)

%Average per zone rest/task
restLength=length(102-window/2:123-window/2);
restWindowsAvg=[mean(average(102-window/2:123-window/2)) mean(average(184-window/2:204-window/2)) mean(average(245-window/2:length(average)))];
restMean=mean(average([102-window/2:123-window/2 184-window/2:204-window/2 245-window/2:length(average)]));
taskMean=mean(average([1:102-window/2 123-window/2:184-window/2 204-window/2:min(245-window/2,length(average))]));
taskWindows=[1:102-window/2-restLength 123-window/2:184-window/2-restLength 204-window/2:min(245-window/2,length(average))-restLength];

taskWindowsAvg=[];
for i=taskWindows
    taskWindowsAvg = [taskWindowsAvg mean(average(i:i+restLength))];
end

%plot(taskWindowsAvg)
%title('Motor Task averages for a window of size 8')
% ylabel('Average bw - fw delta kurtosis')
% xlabel('Window position in the task blocks')
% set(gca,'FontSize',13)

hold on
for i=restWindowsAvg
    hline(i,'g')
end
hline(taskMean,'r')

hold off