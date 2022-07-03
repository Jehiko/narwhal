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

% ind_R = (mahdmO >= -5 & mahdm0 < 5 & em < 0.5);
% ind_Bs = (mahdmO <= -5 & em < 0.75);

ind_R = (Lm <= 15 & em < 0.5);
% ind_Ro = (Lm <= 100 & em >= 0.26 & em < 1);

ind_Bd = (Lm >= 300 & em >= 2);
ind_Bs = (Lm <= 300 & em >= 1);

% ind_ex = (Lm >= 600 & em >= 3);

%% 
% close all

%interval
be = datenum('2013-09-24 14:18:39');
fi = datenum('2013-09-25 02:18:39');

% Ngo et al., 2019, Fig.8 48-h time-stamp mistake?

ngo1 = (TiV >= datenum('2013-09-24 15:50:00') & TiV <= datenum('2013-09-24 16:00:00') ...
    | TiV >= datenum('2013-09-24 17:10:00') & TiV <= datenum('2013-09-24 17:15:00') ...
    | TiV >= datenum('2013-09-24 17:22:00') & TiV <= datenum('2013-09-24 17:58:00')...
    | TiV >= datenum('2013-09-24 18:27:00') & TiV <= datenum('2013-09-24 18:31:00'));

ngo2 = (TiV >= datenum('2013-09-24 16:52:00') & TiV <= datenum('2013-09-24 17:08:00') ...
    | TiV >= datenum('2013-09-24 19:32:00') & TiV <= datenum('2013-09-24 19:35:00') ...
    | TiV >= datenum('2013-09-24 21:02:00') & TiV <= datenum('2013-09-24 22:27:00') ...
    | TiV >= datenum('2013-09-24 22:29:00') & TiV <= datenum('2013-09-24 23:15:00') ... 
    | TiV >= datenum('2013-09-24 23:25:00') & TiV <= datenum('2013-09-24 23:42:00')...
    | TiV >= datenum('2013-09-24 23:53:00') & TiV <= datenum('2013-09-25 01:20:00'));

ngo3 = (TiV >= datenum('2013-09-24 14:18:39') & TiV <= datenum('2013-09-24 15:47:00') ...
    | TiV >= datenum('2013-09-24 16:04:00') & TiV <= datenum('2013-09-24 16:44:00') ...
    | TiV >= datenum('2013-09-24 19:05:00') & TiV <= datenum('2013-09-24 20:58:00') ...
    | TiV >= datenum('2013-09-25 01:21:00') & TiV <= datenum('2013-09-25 02:18:38'));

%%
close all

figure
set(gcf, 'Position', [27        1086         991         259])

ax1=subplot(3,1,1);
plot(t, dp,'k','LineWidth',1)
hold on

    yyaxis left
    plot(TiV, Lm,'b-','LineWidth',1)
%     plot(TiV, mahdmO,'b-','LineWidth',2)
        ylim([-50 800])
        ylabel(['Length, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
        set(gca, 'Ydir','reverse')
   
    yyaxis right
    plot(TiV, em,'r','LineWidth',1)
        ylim([0 5])
        yticks([0:2:4])
        ylabel(['Energy, $(m/s)^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
        xlim([be fi])
        datetick('x','keeplimits')

%     set(gca, 'Ydir','reverse')
    set(gca, 'FontSize', F);
     
    legend({'Depth','L','M','E$_k$'},...
    'Location', 'southeast','Interpreter','latex','FontSize',F)

ax = gca;
ax.YAxis(2).Color = 'r';
yyaxis left

%%%

ax2=subplot(3,1,2);
    plot(t, dp,'k','LineWidth',1)
    hold on
    plot(TiV(ind_R), dp(ind_R),'r.','MarkerSize',5)
    plot(TiV(ind_Bd), dp(ind_Bd),'b.','MarkerSize',5)
    plot(TiV(ind_Bs), dp(ind_Bs),'g.','MarkerSize',5)

    ylim([-50 800])
    title('Chaos-based classification','FontSize',F,'FontWeight','bold','Interpreter','latex')
    ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    set(gca, 'Ydir','reverse')
    set(gca, 'FontSize', F);
    xlim([be fi])
    datetick('x','keeplimits')
    
legend({'Depth','R', 'B$_d$','B$_s$'},...
'Location', 'southwest','Interpreter','latex','FontSize',F)

%%%

ax3=subplot(3,1,3);
    
    plot(t, dp,'k','LineWidth',2)
    hold on
    plot(TiV(ngo1), dp(ngo1),'.','MarkerEdgeColor','r','MarkerSize',5)% [0.9290 0.6940 0.1250]
    plot(TiV(ngo2), dp(ngo2),'.','MarkerEdgeColor', 'g', 'MarkerSize',5)% [0.4660 0.6740 0.4880]
    plot(TiV(ngo3), dp(ngo3),'.','MarkerEdgeColor','b', 'MarkerSize',5)% [0 0.4470 0.7410]
    
    plot(t(dp<4), dp(dp<4),'k.','MarkerSize',5)
% 
    ylim([-50 800])
    title('HMM classification (Ng{\^o} et al., 2019)','FontSize',F,'FontWeight','bold','Interpreter','latex')
    ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    set(gca, 'Ydir','reverse')
    set(gca, 'FontSize', F);
    xlim([be fi])
    datetick('x','keeplimits')
      
l=legend({'No label','1','2','3'},...
'Location', 'southwest','Interpreter','latex','FontSize',F,'AutoUpdate','off')

%%%

set(gcf, 'Position', [72          86        1228        1259])
linkaxes([ax1 ax2 ax3],'xy')

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/classifier_Sep24'];
% saveas(gcf, [saveas_f, '.png'], 'png')