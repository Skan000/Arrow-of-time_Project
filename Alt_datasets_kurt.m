clear all

load Data/exchange_rate.mat
load Data/solar_AL.mat
load Data/traffic.mat
load Data/electricity.mat

%Alt datasets tests on lag order using mardia kurtosis

maxLag=10;
results = zeros(maxLag,4);

for i=1:maxLag
    %exchange_rate fit and kurtosis
    fw_data = exchange_rate(:,:);
    bw_data = fliplr(fw_data);

    [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', 1);
    [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', 1);

    [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
    [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

    delta_bwfw = deltaKurt_bw - deltaKurt_fw;

    results(i,1) = delta_bwfw;

    %solar_AL fit and kurtosis
    fw_data = solar_AL(:,:);
    bw_data = fliplr(fw_data);

    [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', i);
    [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', i);

    [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
    [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

    delta_bwfw = deltaKurt_bw - deltaKurt_fw;

    results(i,2) = delta_bwfw;

    %traffic fit and kurtosis
    fw_data = traffic(:,:);
    bw_data = fliplr(fw_data);

    [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', i);
    [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', i);

    [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
    [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

    delta_bwfw = deltaKurt_bw - deltaKurt_fw;

    results(i,3) = delta_bwfw;%*1000/abs(delta_bwfw);

    %electricity fit and kurtosis
    fw_data = electricity(:,:);
    bw_data = fliplr(fw_data);

    [~,B,~,res_fw] = CBIG_RL2017_ar_mls(fw_data', i);
    [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data', i);

    [~, ~, ~, deltaKurt_fw] = mardiaKurtosis(res_fw');
    [~, ~, ~, deltaKurt_bw] = mardiaKurtosis(res_bw');

    delta_bwfw = deltaKurt_bw - deltaKurt_fw;

    results(i,4) = delta_bwfw;
end

stem(results(:,1))
hold on
stem(results(:,2))
stem(results(:,3))
stem(results(:,4))
xlim([0 11])
title('Test on 4 alternative multivariate datasets')
legend('exchange\_rate','solar\_AL','traffic','electricity')
ylabel('bw - fw delta kurtosis')
xlabel('lag order')
hold off
