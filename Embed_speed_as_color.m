close all
clear all

F = 18;

load '/Volumes/Extreme SSD/NARWHAL/dive.mat'

T = Date + datenum('1900-01-01 00:00:00');

start = datenum('2013-08-15 14:00:00');
finish = datenum('2013-11-06 18:00:00');

index= (T >= start & T < finish); 
t = T(index); 
dp = Depth(index);

% EMBED all
y = phasespace(dp(1:end-1),3,375);

% Energy
yv = phasespace(dp(1:end),3,375);
dy = (diff(yv(:,1)).^2+diff(yv(:,2)).^2+diff(yv(:,3)).^2).^0.5;

% e=0.5*dy.^2;

sp= diff(dp);
spm=medfilt1(sp, 375*1);
%% plot

close all
figure
set(gcf, 'Position', [1437         525         787         820])

% s=scatter3(y(:,1), y(:,2), y(:,3), 5, sp(1:end-375*2),'.')

%Kinetic energy
s=scatter3(y(:,1), y(:,2), y(:,3), 5, spm(1:end-375*2),'.')

% s.MarkerEdgeAlpha = 0.01;

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

%% colorbar
c=colorbar('Location','east');
c.Color='k'
hold on
c.Label.String = 'Speed (m/s)';
% c.Label.Interpreter = 'latex';
c.Label.FontSize = F;
c.FontSize = F;
colormap(redblue)
colormap jet
caxis([-1 1]*4), set(c,'Limits', [-1 1]*4)
set(c,'Ticks', [-1 0 1]*4)
set(c,'Position',[0.1525    0.6610    0.0203    0.0647])

%background to black
% set(gca,'Color','k')

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_speed_b'];
% saveas(gcf, [saveas_f, '.png'], 'png')