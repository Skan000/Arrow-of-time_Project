clear all

load Data/electricity.mat

lag=200;
p1 = electricity(:,:);
p1=p1(:,:);
perm = p1(:,randperm(size(p1,2)));
%Compute unshuffled and shuffled auto-corr function
autoChrono = acf(p1',lag);
autoShufl = acf(perm',lag);

xlimit = (size(autoChrono)/2);
xlimit = xlimit(1);
N=max(size(p1));
ax1 = subplot(1,2,1); % top subplot
stem(ax1,linspace(0,xlimit*2,xlimit*2),autoChrono)
%line([0 lag+.5], (1.96)*(1/sqrt(N))*ones(1,2))
%line([0 lag+.5], (-1.96)*(1/sqrt(N))*ones(1,2))
% Some figure properties
%line_hi = (1.96)*(1/sqrt(N))+.05;
%line_lo = -(1.96)*(1/sqrt(N))-.05;
%bar_hi = max(autoChrono)+.05 ;
%bar_lo = -max(autoChrono)-.05 ;
%if (abs(line_hi) > abs(bar_hi)) % if rejection lines might not appear on graph
%    axis([0 lag+.60 line_lo line_hi])
%else
%    axis([0 lag+.60 bar_lo bar_hi])
%end
title(ax1,'Chronological order auto-correlation')
ylabel(ax1,'Auto-correlation')
xlabel(ax1,'Lag order')


ax2 = subplot(1,2,2); % bottom subplot
stem(ax2, linspace(0,xlimit*2,xlimit*2), autoShufl)
%line([0 lag+.5], (1.96)*(1/sqrt(N))*ones(1,2))
%line([0 lag+.5], (-1.96)*(1/sqrt(N))*ones(1,2))
% Some figure properties
%line_hi = (1.96)*(1/sqrt(N))+.05;
%line_lo = -(1.96)*(1/sqrt(N))-.05;
%bar_hi = max(autoShufl)+.05 ;
%bar_lo = -max(autoShufl)-.05 ;
%if (abs(line_hi) > abs(bar_hi)) % if rejection lines might not appear on graph
%    axis([0 lag+.60 line_lo line_hi])
%else
%    axis([0 lag+.60 bar_lo bar_hi])
%end
title(ax2,'Shuffled order auto-correlation')
ylabel(ax2,'Auto-correlation')
xlabel(ax2,'Lag order')
