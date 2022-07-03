close all
clear all

F = 18;

load '/Volumes/Extreme SSD/NARWHAL/dive.mat'

T = Date + datenum('1900-01-01 00:00:00');

% EMBED all
y = phasespace(Depth,3,375);

%% plot

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

set(gca, 'FontSize', F);

% %% SAVE PLOT
% saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/3D_states_all'];
% saveas(gcf, [saveas_f, '.png'], 'png')

%% EPOCHS

%STEREOTYPE 1: rest
start = datenum('2013-08-23 02:15:00');
finish = datenum('2013-08-23 04:15:00');

    index= (T >= start & T < finish); t = T(index); dp = Depth(index);
    y_s = phasespace(dp,3,375);

    hold on
    plot3(y_s(:,1), y_s(:,2), y_s(:,3), 'g-', 'LineWidth',5)

% %STEREOTYPE 1to2: rest-to-bout
start = datenum('2013-08-22 22:53:00');
finish = datenum('2013-08-22 23:18:00');

    index= (T >= start & T < finish); t = T(index); dp = Depth(index);
    y_s = phasespace(dp,3,375);

    hold on
    plot3(y_s(:,1), y_s(:,2), y_s(:,3), 'y-', 'LineWidth',5)

%STEREOTYPE 2: dive bout
start = datenum('2013-08-23 00:00:00');
finish = datenum('2013-08-23 02:00:00');

    index= (T >= start & T < finish); t = T(index); dp = Depth(index);
    y_s = phasespace(dp,3,375);

    hold on
    plot3(y_s(:,1), y_s(:,2), y_s(:,3), 'r-', 'LineWidth',2)

%STEREOTYPE 2to1: bout-to-rest
start = datenum('2013-08-23 02:04:00');
finish = datenum('2013-08-23 03:00:00');

    index= (T >= start & T < finish); t = T(index); dp = Depth(index);
    y_s = phasespace(dp,3,375);

    hold on
    plot3(y_s(:,1), y_s(:,2), y_s(:,3), 'b-', 'LineWidth',5)


%STEREOTYPE 3: shallow bout
start = datenum('2013-08-22 00:30:00');
finish = datenum('2013-08-22 01:30:00');

    index= (T >= start & T < finish); t = T(index); dp = Depth(index);
    y_s = phasespace(dp,3,375);

    hold on
    plot3(y_s(:,1), y_s(:,2), y_s(:,3), 'w-', 'LineWidth',5)

% start = datenum('2013-08-24 11:00:00');
% finish = datenum('2013-08-24 12:00:00');

% spiral
% start = datenum('2013-08-24 20:30:00');
% finish = datenum('2013-08-24 22:30:00');

%hexagon
% start = datenum('2013-08-26 01:00:00');
% finish = datenum('2013-08-26 06:00:00');

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

% start = datenum('2013-08-15 00:00:00');
% finish = datenum('2013-11-05 00:00:00');

%
% index= (T >= start & T < finish); t = T(index); dp = Depth(index);
% y_s = phasespace(dp,3,375);
% 
% hold on
% plot3(y_s(:,1), y_s(:,2), y_s(:,3), 'r-', 'LineWidth',5)

xlim([0 800])
ylim([0 800])
zlim([0 800])


% legend('Trajectory','Start','Location','northwest','FontSize',F-2)

% %% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/3D_states_main_zoom'];
% saveas(gcf, [saveas_f, '.png'], 'png')

return

%%

% checks

%Euclid distance



figure

plot(t, dp,'k','LineWidth',2) 
hold on

ls = y_s(:,1).^2+y_s(:,2).^2+y_s(:,3).^2; l = ls.^0.5;

plot(t(1:end-375*2), l,'r','LineWidth',1)

set(gca,'Ydir','reverse')

figure
plot(t(1:end-375*2), detrend(cumsum(l)),'r','LineWidth',1)


yyaxis right
plot(t(1:end-375*2-1), diff(l),'b','LineWidth',1)
