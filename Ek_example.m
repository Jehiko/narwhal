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

load 'LEE.mat' 
load 'Dimen_30min.mat'

%%
figure
set(gcf, 'Position', [27        1086         991         259])

ax1=subplot(2,1,1);
plot(t, dp,'k','LineWidth',1)
    hold on
    xlim([be fi])
    ylim([-50 800])
    
    set(gca, 'Ydir','reverse')
    set(gca, 'FontSize', F);

ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

yyaxis right
    plot(Tstamp, Ene,'r-')
    ylim([0 10])
    ylabel(['E$_k, (m/s)^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    
    ax = gca; 
    ax.YAxis(2).Color = 'r';
    xlim([datenum('2013-09-24 18:00:00') datenum('2013-09-25 06:00:00')])
    datetick('x','keeplimits')


ax2=subplot(2,1,2);
plot(t, dp,'k','LineWidth',1)
    hold on
    xlim([be fi])
    ylim([-50 800])
    
    set(gca, 'Ydir','reverse')
    set(gca, 'FontSize', F);

ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

yyaxis right
    plot(Tstamp, Ene,'r-')
    ylim([0 10])
    ylabel(['E$_k, (m/s)^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    
    ax = gca; 
    ax.YAxis(2).Color = 'r';
    xlim([datenum('2013-08-31 00:00:00') datenum('2013-09-15 00:00:00')])
    datetick('x','keeplimits')

    %
be_l = datenum('2013-08-31 00:00:00');
fi_l = datenum('2013-09-15 00:00:00');
ind_cwt = (Tstamp >= be_l & Tstamp < fi_l);

ax3=subplot(3,1,3);

cwt(Ene(ind_cwt),minutes(10));
set(gca, 'FontSize', F);
%set(gca,'Position',[0.1300    0.5838    0.7750    0.3069])


ylabel(['Period, mins'],'FontSize',F+2,'FontWeight','bold','Interpreter','latex');

% title([])
% set(gca,'XTickLabel',[])
% xlabel([])
% set(gca,'YTick',[0.1 1 10 100 1000 10000])

colormap hot

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/em_cwt_short'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/Emb_energy_med_timeseries'];
saveas(gcf, [saveas_f, '.png'], 'png')