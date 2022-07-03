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

be = datenum('2013-09-24 14:18:39');
fi = datenum('2013-09-25 02:18:39');

TiV=t(1:end-375*2-1);

%% Ngo et al., 2019, Fig.8 48-h time-stamp mistake?

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

%% LOAD CHAOS

load 'LEE.mat' 
load 'Dimen_30min.mat'
X = [Euc, Lya, Ene, Dimen];

% CLUSTERING - GMM

k=4;
rng(3);
options = statset('MaxIter',10000);
initialCond2 = randsample(1:k,length(X),true);

gm = fitgmdist(X,k,'CovarianceType','diagonal',...
    'SharedCovariance',true,...
    'Options',options,...
    'Start',initialCond2);

P = posterior(gm,X);

% n = size(X,1);
% [~,order] = sort(P(:,1));

idx = cluster(gm,X);

%% align time vectors
td = datetime(t,'ConvertFrom','datenum');
ti = datetime(Tstamp,'ConvertFrom','datenum');
D = timetable(td,dp,'VariableNames',{'Depth'});
% Di = timetable(ti,Lya, Euc, Ene,'VariableNames',{'Lyapunov','Euclid','Energy'});
Di = timetable(ti,idx, P,'VariableNames',{'Cluster','Member'});
TT = synchronize(D,Di);

Ft = fillmissing(TT.td,'linear');
Fd = fillmissing(TT.Depth,'linear');
Fc = fillmissing(TT.Cluster,'nearest');
Fm = fillmissing(TT.Member,'nearest');

FULLfill= timetable(Ft, Fd, Fc, Fm, 'VariableNames',{'Depth','Cluster','Member'});



%%
close all

figure
set(gcf, 'Position', [27        1086         991         259])

ax1=subplot(3,1,1);
plot(t, dp,'k','LineWidth',1)
    hold on
    xlim([be fi])
    ylim([-50 800])
    datetick('x','keeplimits')
    set(gca, 'Ydir','reverse')
    set(gca, 'FontSize', F);

plot(Tstamp,Euc,'b-')

ylabel(['Depth/Length, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');


    yyaxis right
    above = Lya .* (Lya > 0);
    below = Lya .* (Lya <= 0);
area(Tstamp, below, 'FaceColor', 'b', 'EdgeColor','b');
area(Tstamp, above, 'FaceColor', 'r', 'EdgeColor','None');

plot(Tstamp, Ene/25,'m-')
plot(Tstamp, Dimen/15,'g-')

    ylabel(['$\Lambda_m$, s$^{-1}$ / E$_k, (m/s)^2$ / d, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    ylim([-0.02 0.3])
    datetick('x','keeplimits')
    title('Attractor properties','FontSize',F,'FontWeight','bold','Interpreter','latex')


ax = gca; 
ax.YAxis(2).Color = 'r';

legend({'Depth','L','$\Lambda_m\leq$0','$\Lambda_m>$0','E$_k/25$','d/15'},...
    'Location', 'southwest','Interpreter','latex',...
    'FontSize',F,'AutoUpdate','off')

ax2=subplot(3,1,2);
    plot(t, dp,'k','LineWidth',1)
    hold on

    ylim([-50 800])
    title('Chaos-based classification','FontSize',F,'FontWeight','bold','Interpreter','latex')
    ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    set(gca, 'Ydir','reverse')
    set(gca, 'FontSize', F);
    xlim([be fi])
    datetick('x','keeplimits')

plot(datenum(FULLfill.Ft(FULLfill.Cluster==1)), FULLfill.Depth(FULLfill.Cluster==1),'g.')
plot(datenum(FULLfill.Ft(FULLfill.Cluster==2)), FULLfill.Depth(FULLfill.Cluster==2),'b.')
plot(datenum(FULLfill.Ft(FULLfill.Cluster==3)), FULLfill.Depth(FULLfill.Cluster==3),'k.')
plot(datenum(FULLfill.Ft(FULLfill.Cluster==4)), FULLfill.Depth(FULLfill.Cluster==4),'r.')

%plot GOOD cluster results
% idxC1 = find(FULLfill.Member(:,1)>= 0.5);
% idxC2 = find(FULLfill.Member(:,2)>= 0.5);
% idxC3 = find(FULLfill.Member(:,3)>= 0.5);
% idxC4 = find(FULLfill.Member(:,4)>= 0.5);
% 
% plot(datenum(FULLfill.Ft(idxC1)), FULLfill.Depth(idxC1),'g.')
% plot(datenum(FULLfill.Ft(idxC2)), FULLfill.Depth(idxC2),'b.')
% plot(datenum(FULLfill.Ft(idxC3)), FULLfill.Depth(idxC3),'k.')
% plot(datenum(FULLfill.Ft(idxC4)), FULLfill.Depth(idxC4),'r.')


l=legend({'Depth','1','2','3','4'},...
'Location', 'southwest','Interpreter','latex','FontSize',F,'AutoUpdate','off')

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
linkaxes([ax1 ax2 ax3],'x')

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/classifier_Sep24'];
% saveas(gcf, [saveas_f, '.png'], 'png')




%% sea ice SUMMER (N70.5 W-24.5)
load '/Volumes/Extreme SSD/NARWHAL/RecurrencePlot_ToolBox/seaice/seaice.mat'
SeaT = seaice.time/24/60^2 + datenum('1970-01-01 00:00:00');

%% sea ice WINTER (N69.4 W-22.4)
% load '/Volumes/Extreme SSD/NARWHAL/RecurrencePlot_ToolBox/seaice/seaice_w.mat'
% SeaTw = seaice_winter.time/24/60^2 + datenum('1970-01-01 00:00:00');

%% sea ice WINTER (N69.0 W-23.0)
load '/Volumes/Extreme SSD/NARWHAL/RecurrencePlot_ToolBox/seaice/seaice_wHJ.mat'
SeaTw = seaice_winter.time/24/60^2 + datenum('1970-01-01 00:00:00');

close all
figure
subplot(2,1,1)
hold on
plot(Tstamp(idx==3),X(idx==3,1),'b.')
plot(Tstamp(idx==4),X(idx==4,1),'.','Color',[0.5 0.5 0.5])
ylabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylim([0 200])

yyaxis right
plot(SeaT, seaice.sea_ice_fraction*100,'r-', 'LineWidth',2)
plot(SeaTw, seaice_winterHJ.sea_ice_fraction*100,'g-', 'LineWidth',2)
ylabel(['Sea-ice concentration, $\%$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylim([0 100])
xlim([start finish])

datetick('x','keeplimits')

set(gca, 'FontSize', F);

ax = gca; 
ax.YAxis(2).Color = 'r';

l=legend({'Cluster 3','Cluster 4','Sea-ice (N70.5 W24.5)','Sea-ice (N69.0 W23.0)'},...
'Location', 'northwest','Interpreter','latex','FontSize',F-2,'AutoUpdate','off')

%
subplot(2,1,2)

%binary1 = X(idx==1,1)./X(idx==1,1);
%binary2 = X(idx==2,1)./X(idx==2,1);
binary3 = X(idx==3,1)./X(idx==3,1);
binary4 = X(idx==4,1)./X(idx==4,1);

hold on

%plot(Tstamp(idx==1),cumsum(binary1)/sum(binary1)*100,'.','Color',[0.5 0.5 0.5])
%plot(Tstamp(idx==2),cumsum(binary2)/sum(binary2)*100,'k.')

plot(Tstamp(idx==3),cumsum(binary3)/sum(binary3)*100,'b.')
% plot(Tstamp(idx==4),cumsum(binary4)/sum(binary4)*100,'m.')
ylabel({'Cumulative number'; 'of state instants, $\%$'},'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylim([0 100])

yyaxis right
plot(SeaT, seaice.sea_ice_fraction*100,'r-', 'LineWidth',2)
plot(SeaTw, seaice_winterHJ.sea_ice_fraction*100,'g-', 'LineWidth',2)
ylabel(['Sea-ice concentration, $\%$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylim([0 100])
xlim([start finish])

datetick('x','keeplimits')

set(gca, 'FontSize', F);

ax = gca; 
ax.YAxis(2).Color = 'r';

l=legend({'Cluster 3','Sea-ice (N70.5 W24.5)','Sea-ice (N69.0 W23.0)'},...
'Location', 'northwest','Interpreter','latex','FontSize',F-2,'AutoUpdate','off')

set(gcf, 'Position', [16   745   699   550])

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/seaice'];
saveas(gcf, [saveas_f, '.png'], 'png')


%% sea-ice and Deepening
close all
figure

start = datenum('2013-08-23 00:00:00');
finish = datenum('2013-09-22 00:00:00');

index_nsi= (Tstamp >= start & Tstamp < finish);
IDXnsi = idx(index_nsi);
Xnsi = X(index_nsi,:);
Tstamp_nsi = Tstamp(index_nsi);

plot(Tstamp_nsi(IDXnsi==3),Xnsi(IDXnsi==3,1),'b.')

median(Xnsi(IDXnsi==3,1))

hold on
% sea-ice and Deepening
start = datenum('2013-09-22 00:00:00');
finish = datenum('2013-10-21 00:00:00');

index_nsi= (Tstamp >= start & Tstamp < finish);
IDXnsi = idx(index_nsi);
Xnsi = X(index_nsi,:);
Tstamp_nsi = Tstamp(index_nsi);

plot(Tstamp_nsi(IDXnsi==3),Xnsi(IDXnsi==3,1),'r.')

datetick('x','keeplimits')

median(Xnsi(IDXnsi==3,1))
mean(Xnsi(IDXnsi==3,1))
std(Xnsi(IDXnsi==3,1))