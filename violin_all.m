close all
clear all

F = 18;

start = datenum('2013-08-16 00:00:00');
finish = datenum('2013-11-06 00:00:00');

%%
load 'LEE.mat' 
% load 'Entropy.mat'
load 'Dimen_30min.mat'

index= (Tstamp >= start & Tstamp < finish);
t = datetime(Tstamp(index),'ConvertFrom','datenum');

%% HOURLY stats

index= (Tstamp >= start & Tstamp < finish);
t = datetime(Tstamp(index),'ConvertFrom','datenum');
% 
% X = [Euc, Lya, Ene, Dimen];
% 
% for i = 1:1:length(X)

D = timetable(t,Dimen(index));
%D = timetable(t,time2num(Period(index)));

ind1 = (hour(t)>=0 & hour(t)<3);
ind2 = (hour(t)>=3 & hour(t)<6);
ind3 = (hour(t)>=6 & hour(t)<9);
ind4 = (hour(t)>=9 & hour(t)<12);
ind5 = (hour(t)>=12 & hour(t)<15);
ind6 = (hour(t)>=15 & hour(t)<18);
ind7 = (hour(t)>=18 & hour(t)<21);
ind8 = (hour(t)>=21 & hour(t)<24);

%Dimention
em_i1 = D.Var1(ind1);
em_i2 =D.Var1(ind2);
em_i3 =D.Var1(ind3);
em_i4 =D.Var1(ind4);
em_i5 =D.Var1(ind5);
em_i6 =D.Var1(ind6);
em_i7 =D.Var1(ind7);
em_i8 =D.Var1(ind8);

%% Dimention
Y = [em_i1, em_i2, em_i3, em_i4, em_i5, em_i6, em_i7, em_i8];

MED = median(Y);
dive=prctile(Y,75);

figure
distributionPlot_OnlyPositive(Y,'globalNorm',2,'histOpt',0,...
    'divFactor',[1:0.1:3],'variableWidth',true,...
    'showMM',0)

set(gca, 'xticklabel',{'0-3 h','3-6 h','6-9 h', '9-12 h', '12-15 h','15-18 h','18-21 h','21-24 h'})
ylabel(['d, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
ylim([1 3])
grid on

hold on
plot(MED,'r')
plot(dive,'b--')
legend off
xtickangle(45)
box on

set(gcf, 'Position', [991        1000         545         345])

set(gca,'xaxisLocation','top')

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_violin_d'];
saveas(gcf, [saveas_f, '.png'], 'png')


%% POLAR
%close loop by adding an extra point at 22.5 degress

angs = [22.5:45:350 22.5];
medians= [MED MED(1)];

dive = [dive dive(1)]

figure 
h=mmpolar(deg2rad(angs), dive, 'bo:', ...
    'TDirection', 'cw', 'TZeroDirection', 'North', ...
    'RGridVisible','on', 'TGridVisible','on', 'RLimit',[1 3],...
    'TTickDelta',45,'TTickLabel',{'0','3','6','9','12','15','18','21'},...
    'FontSize', F, 'RGridColor',[0.5 0.5 0.5],'TGridColor',[0.5 0.5 0.5],...
    'TTickOffset',0.2);

set(h,'LineWidth',2)
set(h(1),'MarkerFaceColor','b')
%set(h(2),'MarkerFaceColor','b')

set(gcf, 'Position', [1259  1024  225  211])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_polar_d'];
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

xlabel(['d, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

ylabel(['eCDF, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
xlim([1 3])

box on

set(gcf, 'Position', [1587         934         283         212])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_eCDF_d'];
saveas(gcf, [saveas_f, '.png'], 'png')