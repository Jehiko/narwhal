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
L=(y(:,1).^2+y(:,2).^2+y(:,3).^2).^0.5;


% Energy
yv = phasespace(dp(1:end),3,375);
dy = (diff(yv(:,1)).^2+diff(yv(:,2)).^2+diff(yv(:,3)).^2).^0.5;

% Lv=(y(:,1).^2+y(:,2).^2+y(:,3).^2).^0.5;

e=0.5*dy.^2;

%median filter
em=medfilt1(e, 375*2);
% em=dy;

sp= diff(dp);
%% plot embedding and energy

close all
figure
set(gcf, 'Position', [1437         525         787         820])

% s=scatter3(y(:,1), y(:,2), y(:,3), 5, sp(1:end-375*2),'.')

% CONDITIONAL selections
ind = (em >= 0);
s=scatter3(y(ind,1), y(ind,2), y(ind,3), 5, em(ind),'.')

%Kinetic energy
% s=scatter3(y(:,1), y(:,2), y(:,3), 5, em,'.')

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
c.Label.String = 'Energy ((m/s)^2)';
% c.Label.Interpreter = 'latex';
c.Label.FontSize = F;
c.FontSize = F;
colormap(1-hot)
caxis([0 5]), set(c,'Limits', [0 5])
set(c,'Ticks', [0 5])
set(c,'Position',[0.1525    0.6610    0.0203    0.0647])

%background to black
% set(gca,'Color','k')

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_energy_med_sm4'];
% saveas(gcf, [saveas_f, '.png'], 'png')

return

%% plot energy and euclidian distance

% PLANE EQUATION
% x + y + z = D;
D = y(:,1)+y(:,2)+y(:,3);

% shortest distance to the plane
r = D*cosd(90-atand(2^0.5))/(2^0.5);

%bins
xb = [0:10:800];
yb = [0:1:20];
[xx,yy]=meshgrid(xb,yb);

% HIST
[n,c]=hist3([r, e], 'Edges', {xb yb});

% PLOT
figure
set(gcf, 'Position', [1707        1001         591         344])

s = surf(xx, yy, n','EdgeColor','None')
% s = surf(xx, yy, log10(n.'+1),'EdgeColor','None')

view(0,90)
zlim([0 40000])

% colormap(1-gray)
colormap hot

grid on
ax = gca;
ax.GridColor = 'w'

c=colorbar('Location','east');
    
c.Color='w'
set(c,'Position',[0.8268    0.7059    0.0250    0.1381])

hold on
c.Label.String = 'n';
% c.Label.Interpreter = 'latex';
c.Label.FontSize = F;
   
caxis([0 40000]), set(c,'Limits', [0 40000])

set(gca, 'FontSize', F);
% axis('square')

% xticks([0:200:800])
% yticks([0:1:6])

xlabel(['r, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylabel(['Energy, $(m/s)^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

xlim([0 800])
ylim([0 10])

%visible grid
line([200 200],[0 20],[40000 40000],'Color','w','LineStyle','--','LineWidth',0.5) %
line([400 400],[0 20],[40000 40000],'Color','w','LineStyle','--','LineWidth',0.5) %
line([600 600],[0 20],[40000 40000],'Color','w','LineStyle','--','LineWidth',0.5) %
line([0 800],[5 5],[40000 40000],'Color','w','LineStyle','--','LineWidth',0.5) %

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_L_energy'];
% saveas(gcf, [saveas_f, '.png'], 'png')


return
%% histogram for r

figure
set(gcf, 'Position', [1349         912         591         209])

histogram(r,100,'Normalization','pdf','FaceColor','k','EdgeColor','k',...
    'Orientation','horizontal')

xlim([0 800])

xlabel(['r, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylabel(['Probability, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

set(gca, 'FontSize', F);
grid on

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_r_hist'];
saveas(gcf, [saveas_f, '.png'], 'png')


%%
histogram(e,50,'Normalization','pdf','FaceColor','k','EdgeColor','k',...
    'Orientation','horizontal')

set(gcf, 'Position',[1357         915         174         344])

xlim([0 1])
ylim([0 10])

% ylabel(['Energy, $(m/s)^{0.5}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
xlabel(['Probability, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

set(gca, 'FontSize', F);
grid on

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_e_hist'];
saveas(gcf, [saveas_f, '.png'], 'png')

