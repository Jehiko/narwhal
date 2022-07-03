close all
clear all

F = 18;

load '/Volumes/Extreme SSD/NARWHAL/dive.mat'

T = Date + datenum('1900-01-01 00:00:00');

start = datenum('2013-08-15 00:00:00');
% finish = datenum('2013-08-25 18:00:00');
finish = datenum('2013-11-07 00:00:00');

index= (T >= start & T < finish); 
t = T(index); 
dp = Depth(index);

figure
set(gcf, 'Position', [27        1086         991         259])

plot(t, dp,'k','LineWidth',1)
hold on

ylim([0 1000])
ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'Ydir','reverse')
xlim([start finish])
          
datetick('x','keeplimits')
set(gca, 'FontSize', F);

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/data'];
saveas(gcf, [saveas_f, '.png'], 'png')

%%
figure

set(gcf, 'Position', [27        1086         991         259])

cwt(dp,minutes(1/60))%,'PeriodLimits',[minutes(1) minutes(120)]);
set(gca, 'FontSize', F);
set(gca,'Position',[0.1300    0.1100    0.7750    0.8150])

ylabel(['Period, mins'],'FontSize',F+2,'FontWeight','bold','Interpreter','latex');

title([])
set(gca,'XTickLabel',[])
xlabel([])
set(gca,'YTick',[0.1 1 10 100 1000 10000])

% line([0 120000],[60 60]*24,'Color','w','LineStyle','-.','LineWidth',0.5)
% 
colormap hot
% c=colorbar('Location','east');
%     
% c.Color='w'
% set(c,'Position',[0.8591    0.2832    0.0095    0.1415])
% c.Label.String = 'Magnitude';
% 
% set(gcf, 'Position', [801        1066        1363         279])

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/data_cwt'];
saveas(gcf, [saveas_f, '.png'], 'png')