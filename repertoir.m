close all
clear all

F = 18;

load '/Volumes/Extreme SSD/NARWHAL/dive.mat'

T = Date + datenum('1900-01-01 00:00:00');

% EMBED all
y = phasespace(Depth,3,375);

%% plot

close all
figure
set(gcf, 'Position', [1437         525         787         820])

s=scatter3(y(:,1), y(:,2), y(:,3), 'k.');
s.MarkerEdgeAlpha = 0.01;

axis('square')
view(135,30)

xlabel(['x(t), m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylabel(['x(t+$\tau$), m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
zlabel(['x(t+2$\tau$), m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

xticks([0:200:800])
yticks([0:200:800])
zticks([0:200:800])

xlim([0 800])
ylim([0 800])
zlim([0 800])

set(gca, 'FontSize', F*2);

% %% SAVE PLOT
% saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/3D_states_all'];
% saveas(gcf, [saveas_f, '.png'], 'png')

% INTERESTING EPOCHS

% touch outer attractor
% start = datenum('2013-08-24 10:30:00');
% finish = datenum('2013-08-24 12:30:00');

% spiral
% start = datenum('2013-08-24 20:00:00');
% finish = datenum('2013-08-24 21:30:00');

%Inner attractor to outer orbits and back
% start = datenum('2013-08-26 03:30:00');
% finish = datenum('2013-08-26 07:30:00');

%?
% start = datenum('2013-09-06 04:00:00');
% finish = datenum('2013-09-06 04:50:00');

%limited by depth????
% start = datenum('2013-08-26 10:30:00');
% finish = datenum('2013-08-26 12:30:00');

%extra-deep
% start = datenum('2013-08-27 13:00:00');
% finish = datenum('2013-08-27 14:00:00');
  
%sharp peak session
% start = datenum('2013-09-25 22:00:00');
% finish = datenum('2013-09-25 23:30:00');

start = datenum('2013-10-01 05:00:00');
finish = datenum('2013-10-01 06:30:00');

index= (T >= start & T < finish); t = T(index); dp = Depth(index);
    y_s = phasespace(dp,3,375);

    hold on
    plot3(y_s(:,1), y_s(:,2), y_s(:,3), 'r-', 'LineWidth',5)

xlim([0 800])
ylim([0 800])
zlim([0 800])

% legend('Trajectory','Start','Location','northwest','FontSize',F-2)

% show time series

ax1 = axes('Position',[0.1321    0.8280    0.3088    0.1557]) 

plot(t, dp,'k','LineWidth',2) 
hold on

set(gca,'Ydir','reverse')

xlim([start finish])
xticks([start finish])
ylim([0 800])
yticks([0 600])
ylabel('Depth (m)','FontSize',F,'FontWeight','bold','Interpreter','latex');

dateFormat = 'ddm HH:MM';

datetick('x',dateFormat,'keeplimits','keepticks')
set(ax1, 'FontSize', F*1.5);

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/3D_states_bout_rubin'];
% saveas(gcf, [saveas_f, '.png'], 'png')








%%


ls = y_s(:,1).^2+y_s(:,2).^2+y_s(:,3).^2; l = ls.^0.5;

plot(t(1:end-375*2), l,'r','LineWidth',1)


% figure
% plot(t(1:end-375*2), detrend(cumsum(l)),'r','LineWidth',1)
% 
% 
% yyaxis right
% plot(t(1:end-375*2-1), diff(l),'b','LineWidth',1)
