close all
clear all

F = 18;

load '/Volumes/Extreme SSD/NARWHAL/dive.mat'

T = Date + datenum('1900-01-01 00:00:00');

start = datenum('2013-08-15 14:00:00');
% finish = datenum('2013-08-25 18:00:00');
finish = datenum('2013-11-06 18:00:00');

index= (T >= start & T < finish); 
t = T(index); 
dp = Depth(index);

%MEDIAN FILTER WINDOW
windf = 375*2;

% EMBED all
y = phasespace(dp(1:end-1),3,375);
L=(y(:,1).^2+y(:,2).^2+y(:,3).^2).^0.5;
    Lm = medfilt1(L, windf);

% Energy
yv = phasespace(dp(1:end),3,375);
dy = (diff(yv(:,1)).^2+diff(yv(:,2)).^2+diff(yv(:,3)).^2).^0.5;

e=0.5*dy.^2;
    em=medfilt1(e, windf);

% PLANE EQUATION
% x + y + z = D;
D = y(:,1)+y(:,2)+y(:,3);
    Dm = medfilt1(D, windf);

% shortest distance to the plane
r = D*cosd(90-atand(2^0.5))/(2^0.5);
    rm=medfilt1(r, windf);

sp= diff(dp);

mah1 = mean(y(:,1))-y(:,1);
mah2 = mean(y(:,2))-y(:,2);
mah3 = mean(y(:,3))-y(:,3);

mahd = (mah1.^2 + mah2.^2 + mah3.^2).^0.5;

mahdm=medfilt1(mahd, windf);

%% plot embedding and energy

close all

figure
set(gcf, 'Position', [1437         525         787         820])

TiV=t(1:end-375*2-1);

hold on
plot(TiV, r, 'm','LineWidth',1)
plot(TiV, rm,'m','LineWidth',2)

plot(TiV, L,'k','LineWidth',1)
plot(TiV, Lm,'k','LineWidth',2)

plot(t, dp,'b','LineWidth',3)

yyaxis right
% plot(t(1:end-375*2-1), e, 'r','LineWidth',1)
plot(TiV, em, 'r','LineWidth',2)

legend({'r','r$_m$','L','L$_m$','Depth','E$_k$'},...
    'Location', 'northwest','Interpreter','latex','FontSize',F)

yyaxis left
ylim([0 800])
ylabel(['Distances, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

yyaxis right
ylim([0 6])
ylabel(['E$_k$ (m/s)$^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

datetick('x','keeplimits','keepticks')

set(gca, 'FontSize', F);

% return

% CONDITIONAL selections
% ind = (Lm >= 100 & em > 1);
% ind = (Lm <= 100 & em < 0.3);
ind = (Lm <= 40 & em >= 0.26 & em < 0.7);


figure
set(gcf, 'Position', [1437         525         787         820])

plot(TiV(ind), dp(ind),'r.','MarkerSize',10)
hold on
plot(t, dp,'k','LineWidth',1)

    yyaxis left
    plot(TiV, Lm,'b','LineWidth',1)
    ylim([0 800])

    yyaxis right
    plot(TiV, em,'m','LineWidth',1)
    ylim([0 5])

    xlim([datenum('2013-08-28 14:00:00') datenum('2013-08-29 14:00:00')])
    datetick('x','keeplimits','keepticks')

    set(gca, 'Ydir','reverse')
    
return

%%%%%%%%%%%%%
%%%%%%%%%%%%%

figure
set(gcf, 'Position', [1437         525         787         820])

% CONDITIONAL selections
% ind = (Lm <= 100 & em < 0.7 & em < 1);
% ind = (Lm <= 100 & em > 0.5 & em < 1);
% ind = (Lm >= 50 & Lm <= 400 & em > 1 & em < 1.75);
% ind = (Lm >= 350 & Lm <= 500 & em > 2 & em < 2.5);
% ind = (Lm >= 380 & Lm <= 440 & em >= 2 & em < 2.5);
% ind = (Lm <= 50 & em <= 0.26);

ind = (Lm >= 300);

% s=scatter3(y(ind,1), y(ind,2), y(ind,3), 5, em(ind),'.')

%Kinetic energy
s=scatter3(y(:,1), y(:,2), y(:,3), 5, rm,'.')

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
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_energy_alpha'];
% saveas(gcf, [saveas_f, '.png'], 'png')


%% plot energy and euclidian distance


%bins
xb = [0:10:800];
yb = [0:0.5:5];
[xx,yy]=meshgrid(xb,yb);

% HIST
[n,c]=hist3([Lm, em], 'Edges', {xb yb});
% [n,c]=hist3([mahdm, em], 'Edges', {xb yb});

% PLOT
figure
set(gcf, 'Position', [1707        1001         591         344])

s = surf(xx, yy, n'/sum(n,'All')*100,'EdgeColor','None')
% s = surf(xx, yy, log10(n.'+1),'EdgeColor','None')

view(0,90)
zlim([0 2])

% colormap(1-gray)
colormap hot

grid on
ax = gca;
ax.GridColor = 'w'

c=colorbar('Location','east');
    
c.Color='w'
set(c,'Position',[0.8268    0.7059    0.0250    0.1381])

hold on
c.Label.String = '%';
% c.Label.Interpreter = 'latex';
c.Label.FontSize = F;
   
 caxis([0 1.25]), set(c,'Limits', [0 1.25])
 set(c,'Ticks', [0 1])

set(gca, 'FontSize', F);
% axis('square')

% xticks([0:200:800])
% yticks([0:1:6])

xlabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylabel(['Energy, $(m/s)^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

xlim([0 800])
ylim([0 5])

%visible grid
line([200 200],[0 5],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %
line([400 400],[0 5],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %
line([600 600],[0 5],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %
line([0 800],[2 2],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %
line([0 800],[4 4],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %


saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_L_vs_mah_median'];
% saveas(gcf, [saveas_f, '.png'], 'png')


return
%% histogram for r

figure
set(gcf, 'Position', [1707        1185         591         160])

histogram(Lm,'Normalization','pdf','FaceColor','k','EdgeColor','k',...
    'Orientation','vertical','BinWidth',20)

xlim([0 800])

xlabel(['M, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylabel(['Probability, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

set(gca, 'FontSize', F);
grid on
set(gca, 'Ydir','reverse')

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_L_hist'];
saveas(gcf, [saveas_f, '.png'], 'png')


%%

figure
set(gcf, 'Position', [1564        1001         142         344])

histogram(em,50,'Normalization','pdf','FaceColor','k','EdgeColor','k',...
    'Orientation','horizontal', 'BinWidth',0.5)

xlim([0 1])
ylim([0 5])

% ylabel(['Energy, $(m/s)^{0.5}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
xlabel(['Probability, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

set(gca, 'FontSize', F);
grid on

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_e_hist'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% Depth vs Speed

%bins
xb = [0:20:900];
yb = [-5.75:0.5:5.75];
[xx,yy]=meshgrid(xb,yb);

% HIST
[n,c]=hist3([dp(1:end-1), sp], 'Edges', {xb yb});

% PLOT
figure
set(gcf, 'Position', [1852         786         399         393])

% s = surf(xx, yy, n'/sum(n,'All')*100,'EdgeColor','None')
s = surf(yy, xx, log10(n.'+1),'EdgeColor','None')

view(0,90)
% zlim([0 2])

set(gca, 'Ydir','reverse')
axis('square')

colormap hot

grid on
ax = gca;
ax.GridColor = 'w'

c=colorbar('Location','east');
    
c.Color='w'


hold on
c.Label.String = 'log(n+1)';
% c.Label.Interpreter = 'latex';
c.Label.FontSize = F;
   
%  caxis([0 1.25]), set(c,'Limits', [0 1.25])
%  set(c,'Ticks', [0 1])

set(gca, 'FontSize', F);

ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
xlabel(['Speed, m/s'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

ylim([0 900])
xlim([-6 6])

set(c,'Position',[0.1902    0.1970    0.0253    0.0880])

%visible grid
line([-6 6],[200 200],[7 7],'Color','w','LineStyle',':','LineWidth',0.5) %
line([-6 6],[200 200]*2,[7 7],'Color','w','LineStyle',':','LineWidth',0.5) %
line([-6 6],[200 200]*3,[7 7],'Color','w','LineStyle',':','LineWidth',0.5) %
line([-6 6],[200 200]*4,[7 7],'Color','w','LineStyle',':','LineWidth',0.5) %

line([0 0],[0 900],[7 7],'Color','w','LineStyle',':','LineWidth',0.5) %
line([-2 -2],[0 900],[7 7],'Color','w','LineStyle',':','LineWidth',0.5) %
line([2 2],[0 900],[7 7],'Color','w','LineStyle',':','LineWidth',0.5) %
line([-2 -2]*2,[0 900],[7 7],'Color','w','LineStyle',':','LineWidth',0.5) %
line([2 2]*2,[0 900],[7 7],'Color','w','LineStyle',':','LineWidth',0.5) %

d = [0:10:1400];
v = 1.92-exp(-0.081*d+0.64);
plot3(v,d,(6+v*0),'b','LineWidth',2)
plot3(-v,d,(6+v*0),'b','LineWidth',2)

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/speed_heatmap_L2003'];
saveas(gcf, [saveas_f, '.png'], 'png')