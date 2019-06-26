load('randPerms_AllRestSep.mat')
load('randPerms_Gamble.mat')
load('randPerms_Motor.mat')
load('randPerms_Relational.mat')
load('randPerms_Social.mat')
load('randPerms_WM.mat')
load('randPerms_Emotion.mat')

hold on
plot(mean(randPerms_AllRestSep),'DisplayName','All Rest Runs','LineWidth',2)
plot(mean(randPerms_WM),'DisplayName','Working Memory','LineWidth',2)
plot(mean(randPerms_Gamble),'DisplayName','Gamble','LineWidth',2)
plot(mean(randPerms_Relational),'DisplayName','Relational','LineWidth',2)
plot(mean(randPerms_Motor),'DisplayName','Motor','LineWidth',2) %highest
plot(mean(randPerms_Social),'DisplayName','Social','LineWidth',2)
plot(mean(randPerms_Emotion),'DisplayName','Emotion','LineWidth',2)
hold off
title('Trend of the delta kurtosis in function of the amount of data')
ylabel('Average bw - fw delta kurtosis')
xlabel('Number of data points, x1190')
ylim([-650 100])
%xticklabels({'10','60','110','160','210','260','310','360','410'})
xlim([2 14])
legend('Location', 'SouthWest');
set(gca,'FontSize',16)