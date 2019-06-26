%Computes delta kurtosis on WM tasks randomly concatenated for each patients

%clear all

load Data/Concat_Relational_100.mat

nPatients = 100; %Number of patients(and trials)
maxCat = 5*17; %Number of concatenated runs
space = 5;
steps=round(maxCat/space);
%results = zeros(nPatients,steps+1,360);

for concatNbr = 15:steps
    disp('CONCAT NBR : ');
    disp(concatNbr);
    %Compute kurtosis delta on concatNbr concatenated patients WM tasks.
    for i = 1:nPatients
        disp('PATIENT NBR : ');
        disp(i);
        if concatNbr*space==1
            fw_data = concatPatientsRelational(:,:,i);
        else
            fw_data = concatPatientsRelational(:,:,randperm(100,concatNbr*space));
        end
        fw_data = fw_data(:,:);
        bw_data = fliplr(fw_data);

        [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
        [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);
        
        for j = 1:360
            
            [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw(j,:)');
            [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw(j,:)');

            delta_bwfw_T = deltaKurt_bw - deltaKurt_fw;
            
            results(i,concatNbr,j) = delta_bwfw_T; % column = nbrOfRuns, line = random grp
        end
    end
end
%results(:,steps+1,:)=space;%last columns = number of spaces between each step
randPerms_Relational_Regions=results;
save('Results/randPerms_Relational_Regions.mat','randPerms_Relational_Regions');