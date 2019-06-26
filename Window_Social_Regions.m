clear all

load Data/Concat_Social_100.mat

nPatients = 100; %Number of patients(and trials)
window = 60;%60,6
space=1;
runLength=264;
results = zeros(nPatients,runLength-window-1);

fw_data = concatPatientsSocial(:,:,1:33);
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
        fw_data = concatPatientsSocial(:,:,34:66);
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);
        res_bw=fliplr(res_bw);
    elseif i==67
        fw_data = concatPatientsSocial(:,:,67:nPatients);
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);
        res_bw=fliplr(res_bw);
    end
    
    for j = 1:(runLength-1-window)/space
        start = ((j-1)*space+1)+runLength*mod(i-1,33);
        stop = ((j-1)*space+window)+runLength*mod(i-1,33);
        delta_bwfw_T=0;
        regions=floor(360/(window/6));
        for row=1:regions
            [ deltaKurt_fw] = Mskekur(res_fw(1+floor(window/6)*(row-1):floor(window/6)+floor(window/6)*(row-1),start:stop)',1);
            [ deltaKurt_bw] = Mskekur(res_bw(1+floor(window/6)*(row-1):floor(window/6)+floor(window/6)*(row-1),start:stop)',1);
            %[ deltaKurt_fw] = Mskekur(res_fw(row,start:stop)',1);
            %[ deltaKurt_bw] = Mskekur(res_bw(row,start:stop)',1);

             delta_bwfw_T = delta_bwfw_T + deltaKurt_bw - deltaKurt_fw;
        end

        results(i,j*space) = delta_bwfw_T/regions; 
    end
end
average=mean(results);
plot(average)
title('Social Task targeting using sliding window with width = 60 frames using 264*33 time points')
ylabel('Average bw - fw delta kurtosis')
xlabel('Start frame of the window')
xlim([0 runLength-1-window])
vline([52-window/2 103-window/2 154-window/2 205-window/2],'b')
vline([32-window/2 83-window/2 134-window/2 185-window/2 236-window/2],'b')
set(gca,'FontSize',12)

%Average per zone rest/task
restLength=length(32-window/2:52-window/2);
restWindowsAvg=[mean(average(32-window/2:52-window/2)) mean(average(83-window/2:103-window/2)) mean(average(134-window/2:154-window/2)) mean(average(185-window/2:205-window/2)) mean(average(236-window/2:length(average)))];
restMean=mean(average([32-window/2:52-window/2 83-window/2:103-window/2 134-window/2:154-window/2 185-window/2:205-window/2 236-window/2:length(average)]));
taskMean=mean(average([1:32-window/2 52-window/2:83-window/2 103-window/2:134-window/2 154-window/2:185-window/2 205-window/2:min(236-window/2,length(average))]));
taskWindows=[1:32-window/2-restLength 52-window/2:83-window/2-restLength 103-window/2:134-window/2-restLength 154-window/2:185-window/2-restLength  205-window/2:min(236-window/2,length(average))-restLength];

taskWindowsAvg=[];
for i=taskWindows
    taskWindowsAvg = [taskWindowsAvg mean(average(i:i+restLength))];
end
%plot(taskWindowsAvg)
%title('Social Task averages for a window of size 40')
% ylabel('Average bw - fw delta kurtosis')
% xlabel('Window position in the task blocks')
% set(gca,'FontSize',12)

hold on
for i=restWindowsAvg
    hline(i,'g')
end
hline(taskMean,'r')

hold off