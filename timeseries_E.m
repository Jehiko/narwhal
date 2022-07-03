close all
clear all

F = 18;

load '/Volumes/Extreme SSD/NARWHAL/dive.mat'

T = Date + datenum('1900-01-01 00:00:00');

start = datenum('2013-08-16 00:00:00');
% finish = datenum('2013-08-25 18:00:00');
finish = datenum('2013-11-06 00:12:31');

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

TiV=t(1:end-375*2-1);

% equivalent of Mahalanobis distance
mah1 = mean(y(:,1))-y(:,1);
mah2 = mean(y(:,2))-y(:,2);
mah3 = mean(y(:,3))-y(:,3);

mahd = (mah1.^2 + mah2.^2 + mah3.^2).^0.5;
%(mean(y(:,1))^2+mean(y(:,2))^2+mean(y(:,3))^2)^0.5

mahdm=medfilt1(mahd, windf);
mahdmO=mahdm-mode(mahdm);


%% CONDITIONAL selections

% ind_R = (mahdmO >= -5 & mahdmO < 0 & em <= 0.26);
% ind_Bs = (mahdmO < 5 & em >= 0.26);

ind_R = (mahdm >= 150 & mahdm < 180 & em < 0.5);
ind_Bs = (mahdm >= 100 & mahdm < 150 & em >= 1 & em < 2.5);

% ind_R = (Lm <= 100 & em < 0.5);
ind_Ro = (Lm <= 100 & em >= 0.26 & em < 1);

ind_Bd = (mahdmO >= 0 & em >= 1);


ind_ex = (Lm >= 600 & em >= 3);

%% 
% close all

%interval
be = datenum('2013-09-24 18:00:00');
fi = datenum('2013-09-25 06:00:00');

be_l = datenum('2013-08-31 00:00:00');
fi_l = datenum('2013-09-15 00:00:00');

ind_cwt = (TiV >= be_l & TiV < fi_l);

figure
set(gcf, 'Position', [27        1086         991         259])

ax1=subplot(2,1,1);
plot(t, dp,'k','LineWidth',1)
hold on

   ylim([0 900])
   ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
   set(gca, 'Ydir','reverse')
   
    yyaxis right
    plot(TiV, em,'r','LineWidth',1)
        ylim([0 10])
        yticks([1:4:5])
        ylabel(['Energy, $(m/s)^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
        xlim([be fi])
       
        datetick('x','keeplimits')
    set(gca, 'FontSize', F);
     
%     legend({'Depth','L','M','E$_k$'},...
%     'Location', 'southeast','Interpreter','latex','FontSize',F)

ax = gca;
ax.YAxis(2).Color = 'r';

ax1=subplot(2,1,2);
plot(t, dp,'k','LineWidth',1)
hold on

   ylim([0 900])
   ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
   set(gca, 'Ydir','reverse')
   
    yyaxis right
    plot(TiV, em,'r','LineWidth',1)
        ylim([0 10])
        yticks([1:4:5])
        ylabel(['Energy, $(m/s)^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
        xlim([be_l fi_l])
         xticks([be_l:2:fi_l])
        yticks([1:4:5])
        datetick('x','keeplimits','keepticks')
    set(gca, 'FontSize', F);
     
%     legend({'Depth','L','M','E$_k$'},...
%     'Location', 'southeast','Interpreter','latex','FontSize',F)

ax = gca;
ax.YAxis(2).Color = 'r';

set(gcf, 'Position', [1508        1004         991         338])

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_energy_med_timeseries'];
% saveas(gcf, [saveas_f, '.png'], 'png')

%% CWT of E_k (median)
% mi=mutual(em, 386, 60^2*12);

%%
% figure
% 
% set(gcf, 'Position', [1505         190         991         338])
% 
% cwt(em(ind_cwt),minutes(1/60));
% set(gca, 'FontSize', F);
% set(gca,'Position',[0.1300    0.5838    0.7750    0.3069])
% 
% 
% ylabel(['Period, mins'],'FontSize',F+2,'FontWeight','bold','Interpreter','latex');
% 
% title([])
% set(gca,'XTickLabel',[])
% xlabel([])
% set(gca,'YTick',[0.1 1 10 100 1000 10000])
% 
% colormap hot
% 
% %% SAVE PLOT
% saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/em_cwt_short'];
% saveas(gcf, [saveas_f, '.png'], 'png')

% line([0 120000],[60 60]*24,'Color','w','LineStyle','-.','LineWidth',0.5)
%%%
%%% Distribution by day hours

t = datetime(TiV,'ConvertFrom','datenum');
D = timetable(t,em);

% DEEP=medfilt1(dp(1:end-751),windf);
% D = timetable(t,DEEP);

ind1 = (hour(t)>=0 & hour(t)<3);
ind2 = (hour(t)>=3 & hour(t)<6);
ind3 = (hour(t)>=6 & hour(t)<9);
ind4 = (hour(t)>=9 & hour(t)<12);
ind5 = (hour(t)>=12 & hour(t)<15);
ind6 = (hour(t)>=15 & hour(t)<18);
ind7 = (hour(t)>=18 & hour(t)<21);
ind8 = (hour(t)>=21 & hour(t)<24);

%energy
em_i1 = em(ind1); em_i1=em_i1(1:end-1); %due to innacurate stamp, extra sample
em_i2 =em(ind2);
em_i3 =em(ind3);
em_i4 =em(ind4);
em_i5 =em(ind5);
em_i6 =em(ind6);
em_i7 =em(ind7);
em_i8 =em(ind8);

%depth
% em_i1 = DEEP(ind1); em_i1=em_i1(1:end-1); %due to innacurate stamp, extra sample
% em_i2 =DEEP(ind2);
% em_i3 =DEEP(ind3);
% em_i4 =DEEP(ind4);
% em_i5 =DEEP(ind5);
% em_i6 =DEEP(ind6);
% em_i7 =DEEP(ind7);
% em_i8 =DEEP(ind8);

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

xlabel(['E$_k$, $(m/s)^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

ylabel(['eCDF, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
box on

set(gcf, 'Position', [1587         934         283         212])

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_eCDF'];
% saveas(gcf, [saveas_f, '.png'], 'png')

%% Violin plots

Y = [em_i1, em_i2, em_i3, em_i4, em_i5, em_i6, em_i7, em_i8];

MED = median(abs(Y));

figure
[h,L,MX,MED]=violin(Y,'facecolor','k','edgecolor','k','mc',[]);

% distributionPlot_OnlyPositive(Y,'showMM',false, 'globalNorm',2)

set(gca, 'xticklabel',{'0-3 h','3-6 h','6-9 h', '9-12 h', '12-15 h','15-18 h','18-21 h','21-24 h'})
ylabel(['E$_k$, $(m/s)^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
ylim([0 6])

hold on
plot(MED,'r')
legend off
xtickangle(45)

set(gcf, 'Position', [991        1000         545         345])

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_violin'];
% saveas(gcf, [saveas_f, '.png'], 'png')

%% POLAR
%close loop by adding an extra point at 22.5 degress

angs = [22.5:45:350 22.5];
% means = [MX MX(1)];
medians= [MED MED(1)];

% medians = [sum(Y) sum(Y(:,1))];



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

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_polar'];
% saveas(gcf, [saveas_f, '.png'], 'png')


return

ax2=subplot(3,1,2);
    plot(t, dp,'k','LineWidth',1)
    hold on
    plot(TiV(ind_R), dp(ind_R),'r.','MarkerSize',10)

    ylim([0 800])
    ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    set(gca, 'Ydir','reverse')
    set(gca, 'FontSize', F);
    xlim([be fi])
    datetick('x','keeplimits')
    
legend({'Depth','R'},...
'Location', 'southeast','Interpreter','latex','FontSize',F)

%%%

ax3=subplot(3,1,3);
    plot(t, dp,'k','LineWidth',1)
    hold on
    plot(TiV(ind_Bd), dp(ind_Bd),'b.','MarkerSize',10)
    plot(TiV(ind_Bs), dp(ind_Bs),'g.','MarkerSize',10)

    ylim([0 800])
    ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    set(gca, 'Ydir','reverse')
    set(gca, 'FontSize', F);
    xlim([be fi])
    datetick('x','keeplimits')
    
legend({'Depth','B$_d$','B$_s$'},...
'Location', 'southeast','Interpreter','latex','FontSize',F)

set(gcf, 'Position', [27         806        1017         539])

linkaxes([ax1 ax2 ax3],'xy')


histogram(em_i1,50,'Normalization','pdf','FaceColor','k','EdgeColor','k',...
    'Orientation','horizontal', 'BinWidth',0.5, 'DisplayStyle','stairs')


histogram(em_i8,50,'Normalization','pdf','FaceColor','None','EdgeColor','g',...
    'Orientation','horizontal', 'BinWidth',0.5, 'DisplayStyle','stairs')
