clear all

load Data/Concat_Gamble_100.mat

nPatients = 100; %Number of patients(and trials)
window = 40;
space=1;
runLength=243;
results = zeros(nPatients,runLength-window-1);

fw_data = concatPatientsGamble(:,:,1:33);
fw_data = fw_data(:,:);
bw_data = fliplr(fw_data);

[~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
[~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);
res_bw=fliplr(res_bw);

%Compute kurtosis delta on concatNbr concatenated patients WM tasks.
for i = 1:nPatients-1
    %Task
    disp(i);
    if i==34
        fw_data = concatPatientsGamble(:,:,34:66);
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);
        res_bw=fliplr(res_bw);
    elseif i==67
        fw_data = concatPatientsGamble(:,:,67:nPatients);
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
        regions=floor(360/(window/5));
        for row=1:regions
            [ deltaKurt_fw] = Mskekur(res_fw(1+floor(window/5)*(row-1):floor(window/5)+floor(window/5)*(row-1),start:stop)',1);
            [ deltaKurt_bw] = Mskekur(res_bw(1+floor(window/5)*(row-1):floor(window/5)+floor(window/5)*(row-1),start:stop)',1);
            %[ deltaKurt_fw] = Mskekur(res_fw(row,start:stop)',1);
            %[ deltaKurt_bw] = Mskekur(res_bw(row,start:stop)',1);

             delta_bwfw_T = delta_bwfw_T + deltaKurt_bw - deltaKurt_fw;
        end

        results(i,j*space) = delta_bwfw_T/regions;      
    end
end

average=mean(results);
plot(average)
title('Gamble Task targeting using sliding window with width = 40 frames using 243*33 time points')
ylabel('Average bw - fw delta kurtosis')
xlabel('Start frame of the window')
%xticklabels({'10','60','110','160','210','260','310','360','410'})
xlim([0 runLength-1-window])
vline([60-window/2 119-window/2 178-window/2],'b')
vline([40-window/2 97-window/2 158-window/2 217-window/2],'b')
set(gca,'FontSize',12)

%Average per zone rest/task
restLength=length(40-window/2:60-window/2);
restWindowsAvg=[mean(average(40-window/2:60-window/2)) mean(average(97-window/2:119-window/2)) mean(average(158-window/2:178-window/2)) mean(average(217-window/2:length(average)))];
restMean=mean(average([40-window/2:60-window/2 97-window/2:119-window/2 158-window/2:178-window/2 217-window/2:length(average)]));
taskMean=mean(average([1:40-window/2 60-window/2:97-window/2 119-window/2:158-window/2 178-window/2:min(217-window/2,length(average))]));
taskWindows=[1:40-window/2-restLength 60-window/2:97-window/2-restLength 119-window/2:158-window/2-restLength 178-window/2:min(217-window/2,length(average))-restLength];

taskWindowsAvg=[];
for i=taskWindows
    taskWindowsAvg = [taskWindowsAvg mean(average(i:i+restLength))];
end
%plot(taskWindowsAvg)
%title('Gamble Task averages for a window of size 40')
% ylabel('Average bw - fw delta kurtosis')
% xlabel('Window position in the task blocks')
% set(gca,'FontSize',12)

hold on
for i=restWindowsAvg
    hline(i,'g')
end
hline(taskMean,'r')

hold off