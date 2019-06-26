%Computes delta kurtosis on WM tasks randomly concatenated for each patients

clear all

load Data/Concat_Language_100.mat

nPatients = 100; %Number of patients(and trials)
maxCat = 4*17; %Number of concatenated runs
space = 4;
steps=round(maxCat/space);
results = zeros(nPatients,steps+1);

for concatNbr = 1:steps
    %Compute kurtosis delta on concatNbr concatenated patients WM tasks.
    for i = 1:nPatients
        if concatNbr*space==1
            fw_data = concatPatientsLanguage(:,:,i);
        else
            fw_data = concatPatientsLanguage(:,:,randperm(100,concatNbr*space));
        end
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

        [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
        [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

        delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;

        results(i,concatNbr) = delta_bwfw_T; % column = nbrOfRuns, line = random grp
    end
end
results(:,steps+1)=space;%last columns = number of spaces between each step
randPerms_Language=results;
save('Results/randPerms_Language.mat','randPerms_Language');