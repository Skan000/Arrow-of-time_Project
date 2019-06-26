clear all;

%% Include
addpath(genpath('./'));
settings1;

%% Simulated AR(p) process
rep = 100;  % repetitions for accuracy measurement
T = 9800;   % time series length
p = 1;      % lag order
n = 360;     % dimensionality

%% Settings
rVals = 0.1 : 0.1 : 2.0; % noise type
batch_size=n;

NOISE_TYPE = NOISE_SWING;
F_TASK = F_RECOMPUTE;
%F_TASK = F_RELOAD;

filename = 'mvar_noiseType_gauss_regionsKurt';


%% preallocate
results = zeros(length(rVals), 2);

%% MAIN
if(F_TASK == F_RECOMPUTE)
   for rr = 1 : length(rVals)
      r = rVals(rr);

      deltaKurt_fw = zeros(1,rep);
      deltaKurt_bw = zeros(1,rep);

      for a = 1 : rep 
         disp(['doing r = ', num2str(r), ' : rep ', num2str(a), '/', num2str(rep)]);

         % generate noise vector
         eps_t = genNoise(T, n, NOISE_TYPE, r);
         % generate AR coefficients
         phi = genCoeff(n,p);
         % generate time series
         [fw_data, bw_data] = genVAR(phi, zeros(n,1), eps_t, p, T, n);
         delta_fw_sum=0;
         delta_bw_sum=0;
         for i=1:n/batch_size
            % fit AR process 
             [~,~,~,res_fw] = CBIG_RL2017_ar_mls(fw_data(:,1+(i-1)*batch_size:batch_size+(i-1)*batch_size), p);
             [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data(:,1+(i-1)*batch_size:batch_size+(i-1)*batch_size), p);
             % gaussianity measure
             [~, ~, ~, delta_fw] = mardiaKurtosis(res_fw');
             [~, ~, ~, delta_bw] = mardiaKurtosis(res_bw');
             delta_fw_sum=delta_fw_sum+delta_fw;
             delta_bw_sum=delta_bw_sum+delta_bw;
         end
         deltaKurt_fw(a)=delta_fw_sum/(n/batch_size);
         deltaKurt_bw(a)=delta_bw_sum/(n/batch_size);
      end

      LI = deltaKurt_fw > deltaKurt_bw;
      
      results(rr, 1) = sum(LI);
      results(rr, 2) = rep - sum(LI);
   end
   
   save(['Results/', filename, '.mat'], 'results');
else
   % load last results 
   load(['Results/', filename, '.mat'])
end

%% Plot
set(0,'defaultAxesFontSize',14)

fig = figure;
bar(rVals, results,'stacked', 'FaceColor','flat'); axis tight;
xticks([0.1,0.5,1.0,1.5,2.0] )
xticklabels({'0.1','0.5','1.0', '1.5', '2.0'})
xlabel('r'); ylabel('accuracy');
legend('forward', 'backward', 'Location', 'SouthEast');
title(['Effect of noise type on data of size 9000 x 360',num2str(batch_size)])

