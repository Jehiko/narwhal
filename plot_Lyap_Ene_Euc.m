close all
clear all

F = 18;

start = datenum('2013-08-16 00:00:00');
finish = datenum('2013-11-06 00:00:00');

%% empty bins
% close all

% WindowLength = 60*30; % = 1 h

% empty bins for results
% Lya=[];
% Tstamp =[];
% Euc=[];
% Ene=[];
% Ent=[];

% for idx = [1:60*10:length(dp)-WindowLength-1];
% 
%     Block = dp(idx:idx+WindowLength+1); % add 1 sec for E_k
%     Tstamp = [Tstamp; mean(t(idx:idx+WindowLength))];
% 
% % %Lyapunov 
% %     lyapExp = lyapunovExponent(Block(1:end-1),1,375,3);
% %     Lya=[Lya; lyapExp];
% % 
% % %Euclid
% %     y = phasespace(Block(1:end-1),3,375);
% %     L=(y(:,1).^2+y(:,2).^2+y(:,3).^2).^0.5;
% %     Euc=[Euc; median(L)];
% % 
% % %Energy_k
% %     yv = phasespace(Block,3,375);
% %     dy = (diff(yv(:,1)).^2+diff(yv(:,2)).^2+diff(yv(:,3)).^2).^0.5;
% %     e=0.5*dy.^2;
% % 
% %     Ene=[Ene; median(e)];
% 
% %Entropy    
%     approxEnt = approximateEntropy(Block(1:end-1),375,3);
%     
%     Ene=[Ent; median(approxEnt)];
% 
% end
% 
% return

% see Lyapunov_narwhal.m
load 'LEE.mat' 
load 'Entropy.mat'

figure
hold on

yyaxis right
% centr_line(1:length(Lya),1) = 0;
% patch([Tstamp' fliplr(Tstamp')], [centr_line' fliplr(Lya')], 'k','FaceAlpha',.5)

above = Lya .* (Lya > 0);
below = Lya .* (Lya <= 0);
area(Tstamp, below, 'FaceColor', 'b', 'EdgeColor','b');
area(Tstamp, above, 'FaceColor', 'r', 'EdgeColor','None');


plot(Tstamp, Ene/25,'k-')

ylabel(['$\Lambda_m$, s$^{-1}$ / E$_k, (m/s)^2$ '],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylim([-0.02 0.3])
datetick('x','keeplimits')

ax = gca; 
ax.YAxis(2).Color = 'r';

yyaxis left
plot(t, dp,'-','Color',[0.5 0.5 0.5])
hold on
plot(Tstamp, Euc,'b-')

ax = gca;
ax.YAxis(1).Color = 'k';

set(gca, 'Ydir','reverse')
ylim([0 1000])
ylabel(['Depth/Length, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

grid on

set(gca, 'FontSize', F);
set(gcf, 'Position',[824   982   997   243])

legend({'D','L','$\Lambda_m\leq$0','$\Lambda_m>$0','0.04E$_k$'},...
    'Location', 'southwest','Interpreter','latex',...
    'FontSize',F,'AutoUpdate','off')

xlim([datenum('2013-09-02 12:00:00') datenum('2013-09-05 00:00:00')])

datetick('x','dd/mm','keeplimits')

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Full_LyaEneEuc_depth'];
saveas(gcf, [saveas_f, '.png'], 'png')

return

inn = (Lya < 0);

figure 
plot3(Euc, Lya, Ene,'.')
axis('square')
box on
set(gca, 'FontSize', F);
grid on

ylabel(['$\Lambda_m$, s$^{-1}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
xlabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
zlabel(['$E_k, (m/s)^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

xlim([0 800])
ylim([-0.02 0.2])
zlim([0 5])

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/lambda_test_30min_hiatus'];
% saveas(gcf, [saveas_f, '.png'], 'png')



%% Lyapunov
xb = [0:10:800];
yb = [-0.02:0.01:0.20];

[xx,yy]=meshgrid(xb,yb);
[n,c]=hist3([Euc, Lya], 'Edges', {xb yb});

% PLOT
figure
set(gcf, 'Position', [1707        1001         591         344])

s = surf(xx, yy, n'/sum(n,'All')*100,'EdgeColor','None')
% s = surf(xx, yy, log10(n.'+1),'EdgeColor','None')

view(0,90)
zlim([0 5])

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
   
 caxis([0 2]), set(c,'Limits', [0 2])
 set(c,'Ticks', [0 2])

set(gca, 'FontSize', F);

xlabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylabel(['$\Lambda_m$, s$^{-1}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

xlim([0 800])
ylim([-0.02 0.2])

%visible grid
line([200 200],[0 5],[4 4],'Color','w','LineStyle',':','LineWidth',0.5) %
line([400 400],[0 5],[4 4],'Color','w','LineStyle',':','LineWidth',0.5) %
line([600 600],[0 5],[4 4],'Color','w','LineStyle',':','LineWidth',0.5) %
line([0 800],[0 0],[4 4],'Color','w','LineStyle',':','LineWidth',0.5) %
line([0 800],[0.1 0.1],[4 4],'Color','w','LineStyle',':','LineWidth',0.5) %


saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/heatmap_L_vs_Lambda'];
saveas(gcf, [saveas_f, '.png'], 'png')

return

% Energy_k

xb = [0:10:800];
yb = [0:0.5:5];

[xx,yy]=meshgrid(xb,yb);
[n,c]=hist3([Euc, Ene], 'Edges', {xb yb});

% PLOT
figure
set(gcf, 'Position', [1707        1001         591         344])

s = surf(xx, yy, n'/sum(n,'All')*100,'EdgeColor','None')
% s = surf(xx, yy, log10(n.'+1),'EdgeColor','None')

view(0,90)
zlim([0 5])

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
   
 caxis([0 2]), set(c,'Limits', [0 2])
 set(c,'Ticks', [0 2])

set(gca, 'FontSize', F);

xlabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylabel(['$E_k$, (m/s)$^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

xlim([0 800])
ylim([0 5])

line([200 200],[0 5],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %
line([400 400],[0 5],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %
line([600 600],[0 5],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %
line([0 800],[2 2],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %
line([0 800],[4 4],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %


saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/heatmap_L_vs_Ek'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% Histograms

%% histogram for r

figure
set(gcf, 'Position', [1707        1185         591         160])

histogram(Euc,'Normalization','probability','FaceColor','k','EdgeColor','k',...
    'Orientation','vertical','BinWidth',10,'BinLimits',[0,800])

xlim([0 800])
ylim([0 0.15])

xlabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylabel(['Probability, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

set(gca, 'FontSize', F);
grid on
% set(gca, 'Ydir','reverse')
set(gca,'xaxisLocation','top')

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_L_hist'];
saveas(gcf, [saveas_f, '.png'], 'png')


%%

figure
set(gcf, 'Position', [1564        1001         142         344])

histogram(Lya,'Normalization','probability','FaceColor','k','EdgeColor','k',...
    'Orientation','horizontal', 'BinWidth',0.01,'BinLimits',[-0.02,0.2])

xlim([0 1])
ylim([-0.02 0.2])

% ylabel(['Energy, $(m/s)^{0.5}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
xlabel(['Probability, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

set(gca, 'FontSize', F);
grid on

set(gca, 'Position', [0.2446    0.1517    0.6604    0.7733])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_Lya_hist'];
saveas(gcf, [saveas_f, '.png'], 'png')


%% E_k

figure
set(gcf, 'Position', [1564        1001         142         344])

histogram(Ene,'Normalization','probability','FaceColor','k','EdgeColor','k',...
    'Orientation','horizontal', 'BinWidth',0.5,'BinLimits',[0,5])

xlim([0 1])
ylim([0 5])

% ylabel(['Energy, $(m/s)^{2}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
xlabel(['Probability, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

set(gca, 'FontSize', F);
grid on

set(gca, 'Position', [0.1300    0.1517    0.7750    0.7733])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_Ek_hist'];
saveas(gcf, [saveas_f, '.png'], 'png')


%%
% %% Lyapunov vs E_k
% xb = [0:0.5:5];
% yb = [-0.02:0.01:0.20];
% 
% [xx,yy]=meshgrid(xb,yb);
% [n,c]=hist3([Ene, Lya], 'Edges', {xb yb});
% 
% % PLOT
% figure
% set(gcf, 'Position', [1707        1001         591         344])
% 
% s = surf(xx, yy, n'/sum(n,'All')*100,'EdgeColor','None')
% % s = surf(xx, yy, log10(n.'+1),'EdgeColor','None')
% 
% view(0,90)
% zlim([0 15])
% 
% % colormap(1-gray)
% colormap hot
% 
% grid on
% ax = gca;
% ax.GridColor = 'w'
% 
% c=colorbar('Location','east');
%     
% c.Color='w'
% set(c,'Position',[0.8268    0.7059    0.0250    0.1381])
% 
% hold on
% c.Label.String = '%';
% % c.Label.Interpreter = 'latex';
% c.Label.FontSize = F;
%    
%  caxis([0 15]), set(c,'Limits', [0 15])
%  set(c,'Ticks', [0 15])
% 
% set(gca, 'FontSize', F);
% 
% xlabel(['$E_k$, (m/s)$^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
% ylabel(['$\Lambda_m$, s$^{-1}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
% 
% xlim([0 5])
% ylim([-0.02 0.2])
% 
% %visible grid
% line([200 200],[0 5],[4 4],'Color','w','LineStyle',':','LineWidth',0.5) %
% line([400 400],[0 5],[4 4],'Color','w','LineStyle',':','LineWidth',0.5) %
% line([600 600],[0 5],[4 4],'Color','w','LineStyle',':','LineWidth',0.5) %
% line([0 800],[0 0],[4 4],'Color','w','LineStyle',':','LineWidth',0.5) %
% line([0 800],[0.1 0.1],[4 4],'Color','w','LineStyle',':','LineWidth',0.5) %
% 
% 
% saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/heatmap_Ek_vs_Lambda'];
% saveas(gcf, [saveas_f, '.png'], 'png')


%% HOURLY stats

index= (Tstamp >= start & Tstamp < finish);

t = datetime(Tstamp(index),'ConvertFrom','datenum');

D = timetable(t,Lya(index), Ene(index), Euc(index), Ent(index));
%D = timetable(t,time2num(Period(index)));

ind1 = (hour(t)>=0 & hour(t)<3);
ind2 = (hour(t)>=3 & hour(t)<6);
ind3 = (hour(t)>=6 & hour(t)<9);
ind4 = (hour(t)>=9 & hour(t)<12);
ind5 = (hour(t)>=12 & hour(t)<15);
ind6 = (hour(t)>=15 & hour(t)<18);
ind7 = (hour(t)>=18 & hour(t)<21);
ind8 = (hour(t)>=21 & hour(t)<24);

%Lyapunov
em_i1 = D.Var1(ind1);
em_i2 =D.Var1(ind2);
em_i3 =D.Var1(ind3);
em_i4 =D.Var1(ind4);
em_i5 =D.Var1(ind5);
em_i6 =D.Var1(ind6);
em_i7 =D.Var1(ind7);
em_i8 =D.Var1(ind8);

%Energy_k
em_i1 = D.Var2(ind1);
em_i2 =D.Var2(ind2);
em_i3 =D.Var2(ind3);
em_i4 =D.Var2(ind4);
em_i5 =D.Var2(ind5);
em_i6 =D.Var2(ind6);
em_i7 =D.Var2(ind7);
em_i8 =D.Var2(ind8);

%Euclid
em_i1 = D.Var3(ind1);
em_i2 =D.Var3(ind2);
em_i3 =D.Var3(ind3);
em_i4 =D.Var3(ind4);
em_i5 =D.Var3(ind5);
em_i6 =D.Var3(ind6);
em_i7 =D.Var3(ind7);
em_i8 =D.Var3(ind8);

%Entropy
em_i1 = D.Var4(ind1);
em_i2 =D.Var4(ind2);
em_i3 =D.Var4(ind3);
em_i4 =D.Var4(ind4);
em_i5 =D.Var4(ind5);
em_i6 =D.Var4(ind6);
em_i7 =D.Var4(ind7);
em_i8 =D.Var4(ind8);

%% Lyapunov

Y = [em_i1, em_i2, em_i3, em_i4, em_i5, em_i6, em_i7, em_i8];

MED = median(Y);
dive=prctile(Y,75);

figure
distributionPlot(Y,'globalNorm',2,'histOpt',0,...
    'divFactor',[-0.015:0.01:0.2],'variableWidth',true,...
    'showMM',6)

set(gca, 'xticklabel',{'0-3 h','3-6 h','6-9 h', '9-12 h', '12-15 h','15-18 h','18-21 h','21-24 h'})
ylabel(['$\Lambda_m$, s$^{-1}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
ylim([-0.02 0.2])
grid on

hold on
plot(MED,'r')
plot(dive,'b--')

legend off
xtickangle(45)
box on

set(gcf, 'Position', [991        1000         545         345])

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_violin_Lya'];
saveas(gcf, [saveas_f, '.png'], 'png')

%%
figure
hold on
[f,x] = ecdf([em_i1; em_i2]);
plot(x, f, 'k-','LineWidth',3)
[f,x] = ecdf([em_i3; em_i4]);
plot(x, f, 'r-','LineWidth',3)
[f,x] = ecdf([em_i5; em_i6]);
plot(x, f, 'r:','LineWidth',3)
[f,x] = ecdf([em_i7; em_i8]);
plot(x, f, 'k:','LineWidth',3)

legend({'0-6 h','6-12 h','12-18 h', '18-24 h'},...
'Location', 'southeast','Interpreter','latex','FontSize',F)

xlabel(['$\Lambda_m$, s$^{-1}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

ylabel(['eCDF, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
box on

set(gcf, 'Position', [1587         934         283         212])

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_eCDF_Lya'];
saveas(gcf, [saveas_f, '.png'], 'png')

%%
%% POLAR
%close loop by adding an extra point at 22.5 degress

angs = [22.5:45:350 22.5];

dive = [dive dive(1)];

figure 
h=mmpolar(deg2rad(angs), dive, 'bo:', ...
    'TDirection', 'cw', 'TZeroDirection', 'North', ...
    'RGridVisible','on', 'TGridVisible','on', 'RLimit',[0 0.04],...
    'TTickDelta',45,'TTickLabel',{'0','3','6','9','12','15','18','21'},...
    'FontSize', F, 'RGridColor',[0.5 0.5 0.5],'TGridColor',[0.5 0.5 0.5],...
    'TTickOffset',0.2);

set(h,'LineWidth',2)
set(h,'MarkerFaceColor','b')

set(gcf, 'Position', [1259  1024  225  211])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_polar_Lya'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% Energy_k
Y = [em_i1, em_i2, em_i3, em_i4, em_i5, em_i6, em_i7, em_i8];

MED = median(Y);

figure
distributionPlot_OnlyPositive(Y,'globalNorm',2,'histOpt',0,...
    'divFactor',[0:0.4:6],'variableWidth',true,...
    'showMM',0)

set(gca, 'xticklabel',{'0-3 h','3-6 h','6-9 h', '9-12 h', '12-15 h','15-18 h','18-21 h','21-24 h'})
ylabel(['$E_k$, $(m/s)^{2}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
ylim([0 6])
grid on

hold on
plot(MED,'r')
legend off
xtickangle(45)
box on

set(gcf, 'Position', [991        1000         545         345])

set(gca,'xaxisLocation','top')

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_violin_energy'];
saveas(gcf, [saveas_f, '.png'], 'png')


%% POLAR
%close loop by adding an extra point at 22.5 degress

angs = [22.5:45:350 22.5];
medians= [MED MED(1)];

figure 
h=mmpolar(deg2rad(angs), medians, 'ro-', ...
    'TDirection', 'cw', 'TZeroDirection', 'North', ...
    'RGridVisible','on', 'TGridVisible','on', 'RLimit',[0 3],...
    'TTickDelta',45,'TTickLabel',{'0','3','6','9','12','15','18','21'},...
    'FontSize', F, 'RGridColor',[0.5 0.5 0.5],'TGridColor',[0.5 0.5 0.5],...
    'TTickOffset',0.2);

set(h,'LineWidth',2)
set(h,'MarkerFaceColor','r')

set(gcf, 'Position', [1259  1024  225  211])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_polar_energy'];
saveas(gcf, [saveas_f, '.png'], 'png')

%%

figure
hold on
[f,x] = ecdf([em_i1; em_i2]);
plot(x, f, 'k-','LineWidth',3)
[f,x] = ecdf([em_i3; em_i4]);
plot(x, f, 'r-','LineWidth',3)
[f,x] = ecdf([em_i5; em_i6]);
plot(x, f, 'r:','LineWidth',3)
[f,x] = ecdf([em_i7; em_i8]);
plot(x, f, 'k:','LineWidth',3)

legend({'0-6 h','6-12 h','12-18 h', '18-24 h'},...
'Location', 'southeast','Interpreter','latex','FontSize',F)

xlabel(['$E_k$, $(m/s)^{2}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

ylabel(['eCDF, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
xlim([0 6])

box on

set(gcf, 'Position', [1587         934         283         212])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_eCDF_energy'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% Euclid
Y = [em_i1, em_i2, em_i3, em_i4, em_i5, em_i6, em_i7, em_i8];

MED = median(Y);
dive=prctile(Y,75);

figure
distributionPlot_OnlyPositive(Y,'globalNorm',2,'histOpt',0,...
    'divFactor',[0:20:800],'variableWidth',true,...
   'showMM',0)%,'addBoxes',1)

set(gca, 'xticklabel',{'0-3 h','3-6 h','6-9 h', '9-12 h', '12-15 h','15-18 h','18-21 h','21-24 h'})
ylabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
ylim([0 800])
grid on

hold on
plot(MED,'r')
plot(dive,'b--')
legend off
xtickangle(45)
box on

set(gcf, 'Position', [991        1000         545         345])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_violin_L'];
saveas(gcf, [saveas_f, '.png'], 'png')


%% POLAR
%close loop by adding an extra point at 22.5 degress

angs = [22.5:45:350 22.5];
medians= [MED MED(1)];

dive = [dive dive(1)]

figure 
h=mmpolar(deg2rad(angs), medians, 'ro-', ...
    deg2rad(angs), dive, 'bo:', ...
    'TDirection', 'cw', 'TZeroDirection', 'North', ...
    'RGridVisible','on', 'TGridVisible','on', 'RLimit',[0 500],...
    'TTickDelta',45,'TTickLabel',{'0','3','6','9','12','15','18','21'},...
    'FontSize', F, 'RGridColor',[0.5 0.5 0.5],'TGridColor',[0.5 0.5 0.5],...
    'TTickOffset',0.2);

set(h,'LineWidth',2)
set(h(1),'MarkerFaceColor','r')
set(h(2),'MarkerFaceColor','b')

set(gcf, 'Position', [1259  1024  225  211])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_polar_L'];
saveas(gcf, [saveas_f, '.png'], 'png')

%%

figure
hold on
[f,x] = ecdf([em_i1; em_i2]);
plot(x, f, 'k-','LineWidth',3)
[f,x] = ecdf([em_i3; em_i4]);
plot(x, f, 'r-','LineWidth',3)
[f,x] = ecdf([em_i5; em_i6]);
plot(x, f, 'r:','LineWidth',3)
[f,x] = ecdf([em_i7; em_i8]);
plot(x, f, 'k:','LineWidth',3)

legend({'0-6 h','6-12 h','12-18 h', '18-24 h'},...
'Location', 'southeast','Interpreter','latex','FontSize',F)

xlabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

ylabel(['eCDF, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
xlim([0 800])

box on

set(gcf, 'Position', [1587         934         283         212])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_eCDF_L'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% Entropy
Y = [em_i1, em_i2, em_i3, em_i4, em_i5, em_i6, em_i7, em_i8];

MED = median(Y);
dive=prctile(Y,75);

figure
distributionPlot_OnlyPositive(Y,'globalNorm',2,'histOpt',0,...
    'divFactor',[-0.5:0.1:1],'variableWidth',true,...
   'showMM',0)%,'addBoxes',1)

set(gca, 'xticklabel',{'0-3 h','3-6 h','6-9 h', '9-12 h', '12-15 h','15-18 h','18-21 h','21-24 h'})
ylabel(['ApEn, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
ylim([-0.5 1])
grid on

hold on
plot(MED,'r')
plot(dive,'b--')
legend off
xtickangle(45)
box on

set(gcf, 'Position', [991        1000         545         345])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_violin_ApEn'];
saveas(gcf, [saveas_f, '.png'], 'png')


%% POLAR
%close loop by adding an extra point at 22.5 degress

angs = [22.5:45:350 22.5];
medians= [MED MED(1)];

dive = [dive dive(1)]

figure 
h=mmpolar(deg2rad(angs), medians, 'ro-', ...
    deg2rad(angs), dive, 'bo:', ...
    'TDirection', 'cw', 'TZeroDirection', 'North', ...
    'RGridVisible','on', 'TGridVisible','on', 'RLimit',[-0.25 0.25],...
    'TTickDelta',45,'TTickLabel',{'0','3','6','9','12','15','18','21'},...
    'FontSize', F, 'RGridColor',[0.5 0.5 0.5],'TGridColor',[0.5 0.5 0.5],...
    'TTickOffset',0.2);

set(h,'LineWidth',2)
set(h(1),'MarkerFaceColor','r')
set(h(2),'MarkerFaceColor','b')

set(gcf, 'Position', [1259  1024  225  211])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_polar_ApEn'];
saveas(gcf, [saveas_f, '.png'], 'png')

%%

figure
hold on
[f,x] = ecdf([em_i1; em_i2]);
plot(x, f, 'k-','LineWidth',3)
[f,x] = ecdf([em_i3; em_i4]);
plot(x, f, 'r-','LineWidth',3)
[f,x] = ecdf([em_i5; em_i6]);
plot(x, f, 'r:','LineWidth',3)
[f,x] = ecdf([em_i7; em_i8]);
plot(x, f, 'k:','LineWidth',3)

legend({'0-6 h','6-12 h','12-18 h', '18-24 h'},...
'Location', 'southeast','Interpreter','latex','FontSize',F)

xlabel(['ApEn, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

ylabel(['eCDF, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
xlim([-0.5 1])

box on

set(gcf, 'Position', [1587         934         283         212])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_eCDF_ApEn'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% Period
load 'Period_120min.mat'

start = datenum('2013-08-16 00:00:00');
finish = datenum('2013-11-06 00:00:00');

index= (Tstamp >= start & Tstamp < finish);

t = datetime(Tstamp(index),'ConvertFrom','datenum');
D = timetable(t,time2num(Period(index)));

ind1 = (hour(t)>=0 & hour(t)<3);
ind2 = (hour(t)>=3 & hour(t)<6);
ind3 = (hour(t)>=6 & hour(t)<9);
ind4 = (hour(t)>=9 & hour(t)<12);
ind5 = (hour(t)>=12 & hour(t)<15);
ind6 = (hour(t)>=15 & hour(t)<18);
ind7 = (hour(t)>=18 & hour(t)<21);
ind8 = (hour(t)>=21 & hour(t)<24);

%Period
em_i1 = D.Var1(ind1);
em_i2 =D.Var1(ind2);
em_i3 =D.Var1(ind3);
em_i4 =D.Var1(ind4);
em_i5 =D.Var1(ind5);
em_i6 =D.Var1(ind6);
em_i7 =D.Var1(ind7);
em_i8 =D.Var1(ind8);

Y = [em_i1, em_i2, em_i3, em_i4, em_i5, em_i6, em_i7, em_i8];

MED = median(Y);
dive=prctile(Y,5);

figure
distributionPlot_OnlyPositive(Y,'globalNorm',2,'histOpt',0,...
    'divFactor',[0:2:35],'variableWidth',true,...
    'showMM',0)

set(gca, 'xticklabel',{'0-3 h','3-6 h','6-9 h', '9-12 h', '12-15 h','15-18 h','18-21 h','21-24 h'})
ylabel(['Period, min'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
ylim([0 30])
grid on

hold on
plot(MED,'r')
plot(dive,'b--')
legend off
xtickangle(45)
box on

set(gcf, 'Position', [991        1000         545         345])

set(gca,'xaxisLocation','top')

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_violin_period'];
saveas(gcf, [saveas_f, '.png'], 'png')

figure
hold on
[f,x] = ecdf([em_i1; em_i2]);
plot(x, f, 'k-','LineWidth',3)
[f,x] = ecdf([em_i3; em_i4]);
plot(x, f, 'r-','LineWidth',3)
[f,x] = ecdf([em_i5; em_i6]);
plot(x, f, 'r:','LineWidth',3)
[f,x] = ecdf([em_i7; em_i8]);
plot(x, f, 'k:','LineWidth',3)

l=legend({'0-6 h','6-12 h','12-18 h', '18-24 h'},...
'Location', 'southeast','Interpreter','latex','FontSize',F)



xlabel(['Period, min'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

ylabel(['eCDF, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
xlim([0 35])

box on

set(gcf, 'Position', [1587         934         283         212])
set(l, 'Position',[0.6349    0.2624    0.3498    0.4335])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_eCDF_period'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% PERIOD polar
angs = [22.5:45:350 22.5];
medians= [MED MED(1)];

dive = [dive dive(1)]

figure 
h=mmpolar(deg2rad(angs), medians, 'ro-', ...
    deg2rad(angs), dive, 'bo:', ...
    'TDirection', 'cw', 'TZeroDirection', 'North', ...
    'RGridVisible','on', 'TGridVisible','on', 'RLimit',[5 20],...
    'TTickDelta',45,'TTickLabel',{'0','3','6','9','12','15','18','21'},...
    'FontSize', F, 'RGridColor',[0.5 0.5 0.5],'TGridColor',[0.5 0.5 0.5],...
    'TTickOffset',0.2);

set(h,'LineWidth',2)
set(h(1),'MarkerFaceColor','r')
set(h(2),'MarkerFaceColor','b')

set(gcf, 'Position', [1259  1024  225  211])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_polar_period'];
saveas(gcf, [saveas_f, '.png'], 'png')