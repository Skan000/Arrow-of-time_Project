%Computes delta kurtosis on WM tasks randomly concatenated for each patients

clear all

load Data/Concat_TaskWM_100.mat

nPatients = 100; %Number of patients(and trials)
maxCat = 50; %Number of concatenated runs
space = 3;
steps=round(maxCat/space);
results = zeros(nPatients,steps+1);
fw_data = concatPatientsWMem(:,:,1:100);
fw_data = fw_data(:,:);
bw_data = fliplr(fw_data);
[~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
[~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

for concatNbr = 1:steps
    %Compute kurtosis delta on concatNbr concatenated patients WM tasks.
    for i = 1:nPatients
        if concatNbr==1
            start = (i-1)*length(concatPatientsWMem)+1;
            stop = i*length(concatPatientsWMem)-1;
            res_fw_shrink = res_fw(:,start:stop);
            res_bw_shrink = res_bw(:,(length(res_bw)-stop+1):(length(res_bw)-start+1));
        else
            group=randperm(100,concatNbr*space);
            indices_fw=[];
            indices_bw=[];
            for e=1:length(group)
                start = (group(e)-1)*length(concatPatientsWMem)+1;
                stop = group(e)*length(concatPatientsWMem)-1;
                indices_fw = [indices_fw start:stop];
                indices_bw = [indices_bw (length(res_bw)-stop+1):(length(res_bw)-start+1)];
            end
            res_fw_shrink = res_fw(:,indices_fw);
            res_bw_shrink = res_fw(:,indices_bw);
        end

        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw_shrink');
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw_shrink');

        delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;

        results(i,concatNbr) = delta_bwfw_T; % column = nbrOfRuns, line = random grp
    end
end
results(:,steps+1)=space;%last columns = number of spaces between each step
randPerms_TaskWM_1Fit=results;
save('Results/randPerms_TaskWM_1Fit.mat','randPerms_TaskWM_1Fit');