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
window=8;%window<n gives mostly null delta kurtosis if not non-translated

NOISE_TYPE = NOISE_SWING;
F_TASK = F_RECOMPUTE;
%F_TASK = F_RELOAD;

filename = 'mvar_noiseType_Window_normal';


%% preallocate
results = zeros(length(rVals), 3);

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
         % fit AR process 
         [~,~,~,res_fw] = CBIG_RL2017_ar_mls(fw_data, p);
         [~,~,~,res_bw] = CBIG_RL2017_ar_mls(bw_data, p);
         % gaussianity measure
         rand = randi([1 T-window-1]);
         [~, ~, ~, deltaKurt_fw(a)] = mardiaKurtosis(res_fw(:,rand:rand+window-1)');
         [~, ~, ~, deltaKurt_bw(a)] = mardiaKurtosis(res_bw(:,rand:rand+window-1)');
      end

      LI = deltaKurt_fw > deltaKurt_bw;
      Nul = deltaKurt_fw == deltaKurt_bw;
      
      results(rr, 1) = sum(LI);
      results(rr, 2) = rep - sum(LI)- sum(Nul);
      results(rr, 3) = sum(Nul);
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
legend('forward', 'backward','undecided', 'Location', 'NorthEast');
title(['Effect of noise type on non translated data (10 x 360)'])
