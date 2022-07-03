close all
clear all

F = 18;

load '/Volumes/Extreme SSD/NARWHAL/dive.mat'

T = Date + datenum('1900-01-01 00:00:00');

start = datenum('2013-08-15 14:00:00');
% finish = datenum('2013-08-25 18:00:00');
finish = datenum('2013-11-06 18:00:00');

% 
% start = datenum('2013-09-22 14:18:39');
% finish = datenum('2013-09-24 02:18:39');

index= (T >= start & T < finish); 
t = T(index); 
dp = Depth(index);

%% empty bins
close all

WindowLength = 60*30; % = 1 h

% empty bins for results
Lya=[];
Tstamp =[];
Euc=[];
Ene=[];
Ent=[];
Period=[];
Dimen=[];

for idx = [1:60*10:length(dp)-WindowLength-1];

    Block = dp(idx:idx+WindowLength+1); % add 1 sec for E_k
    Tstamp = [Tstamp; mean(t(idx:idx+WindowLength))];

%Lyapunov 
%     lyapExp = lyapunovExponent(Block(1:end-1),1,375,3,'MinSeparation',1020);
%     Lya=[Lya; lyapExp];
% 
% %Euclid
%     y = phasespace(Block(1:end-1),3,375);
%     L=(y(:,1).^2+y(:,2).^2+y(:,3).^2).^0.5;
%     Euc=[Euc; median(L)];
% 
% %Energy_k
%     yv = phasespace(Block,3,375);
%     dy = (diff(yv(:,1)).^2+diff(yv(:,2)).^2+diff(yv(:,3)).^2).^0.5;
%     e=0.5*dy.^2;
% 
%     Ene=[Ene; median(e)];

%Entropy    
%     approxEnt = approximateEntropy(Block(1:end-1),375,3);
% 
%     Ent=[Ent; approxEnt];

%Period    
%     per = ceil(1/max(meanfreq(Block(1:end-1),1)));
%     Period=[Period; per];

%CWT-derived dominant timescale
%     [wt,period] =cwt(Block(1:end-1), minutes(1/60));
%     in = find(median(abs(wt(:,:)),2) == max(median(abs(wt(:,:)),2)));
%     Period=[Period; period(in)];

%Dimentions
Y = phasespace(Block(1:end-1),3,375);

for j=1:size(Y,1)
distance=pdist2(Y(j,:),Y);
logdista =-log(distance);
thresh=quantile(logdista, 0.98);
logdista=sort(logdista);
findidx=find(logdista>thresh,1);
logextr=logdista(findidx:end-1);
lambda=mean(logextr-thresh);
d1(j) = 1./lambda;
end

Dimen=[Dimen; median(d1(d1>0))];

end

% save('Period_120min.mat','Period', 'Tstamp')
% save('Lyap_minsep17min_w30min.mat','Lya', 'Tstamp')
save('Dimen_30min.mat','Dimen', 'Tstamp')

plot(Tstamp, Dimen,'k.-')


return
%

figure

% plot(Tstamp, E,'k.-')
hold on

centr_line(1:length(Lya),1) = 0;
patch([Tstamp' fliplr(Tstamp')], [centr_line' fliplr(Lya')], 'k','FaceAlpha',.5)

plot(Tstamp, Ene/25,'g.-')

ylabel(['$\Lambda_m$, s$^{-1}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylim([-0.02 0.2])
datetick('x','keeplimits')

yyaxis right
plot(t, dp,'r')
hold on
plot(Tstamp, Euc,'b.-')

set(gca, 'Ydir','reverse')
ylim([0 800])
ylabel(['Depth, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

grid on

set(gca, 'FontSize', F);

set(gcf, 'Position',[824   982   997   243])

legend({'$\Lambda_m$','0.04E$_k$','D','L'},...
    'Location', 'southwest','Interpreter','latex','FontSize',F,'AutoUpdate','off')

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



%%
xb = [0:10:800];
yb = [-0.02:0.01:0.20];

[xx,yy]=meshgrid(xb,yb);
[n,c]=hist3([Euc, Lya], 'Edges', {xb yb});

% PLOT
figure
set(gcf, 'Position', [1707        1001         591         344])

% s = surf(xx, yy, n'/sum(n,'All')*100,'EdgeColor','None')
s = surf(xx, yy, log10(n.'+1),'EdgeColor','None')

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
c.Label.String = 'log10(n+1)';
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
line([200 200],[0 5],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %
line([400 400],[0 5],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %
line([600 600],[0 5],[2 2],'Color','w','LineStyle',':','LineWidth',0.5) %
line([0 800],[0 0],[2 2],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5) %
line([0 800],[0.1 0.1],[2 2],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5) %


saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/heatmap_L_vs_Lambda'];
saveas(gcf, [saveas_f, '.png'], 'png')

return



%% HOURLY stats

t = datetime(Tstamp,'ConvertFrom','datenum');
D = timetable(t,Lya);

ind1 = (hour(t)>=0 & hour(t)<3);
ind2 = (hour(t)>=3 & hour(t)<6);
ind3 = (hour(t)>=6 & hour(t)<9);
ind4 = (hour(t)>=9 & hour(t)<12);
ind5 = (hour(t)>=12 & hour(t)<15);
ind6 = (hour(t)>=15 & hour(t)<18);
ind7 = (hour(t)>=18 & hour(t)<21);
ind8 = (hour(t)>=21 & hour(t)<24);

%Entropy
em_i1 = Lya(ind1);
em_i2 =Lya(ind2);
em_i3 =Lya(ind3);
em_i4 =Lya(ind4);
em_i5 =Lya(ind5);
em_i6 =Lya(ind6);
em_i7 =Lya(ind7);
em_i8 =Lya(ind8);

%% Violin plots - ONLY POSITIVE

Y = [em_i1, em_i2, em_i3, em_i4, em_i5, em_i6, em_i7, em_i8];

MED = median(Y);

figure
distributionPlot(Y,'showMM',false, 'globalNorm',2)

set(gca, 'xticklabel',{'0-3 h','3-6 h','6-9 h', '9-12 h', '12-15 h','15-18 h','18-21 h','21-24 h'})
ylabel(['$\Lambda_m$, s$^{-1}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
ylim([-0.02 0.2])

hold on
plot(MED,'r')
legend off
xtickangle(45)
box on

set(gcf, 'Position', [991        1000         545         345])

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_violin_entropy'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% POLAR
%close loop by adding an extra point at 22.5 degress

angs = [22.5:45:350 22.5];
medians= [MED MED(1)];

figure 
h=mmpolar(deg2rad(angs), medians, 'ro-', ...
    'TDirection', 'cw', 'TZeroDirection', 'North', ...
    'RGridVisible','on', 'TGridVisible','on', 'RLimit',[-0.01 0.2],...
    'TTickDelta',45,'TTickLabel',{'0','3','6','9','12','15','18','21'},...
    'FontSize', F, 'RGridColor',[0.5 0.5 0.5],'TGridColor',[0.5 0.5 0.5],...
    'TTickOffset',0.2);

set(h,'LineWidth',2)
set(h,'MarkerFaceColor','r')

set(gcf, 'Position', [1259  1024  225  211])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_polar_entropy'];
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

xlabel(['Entropy,-'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

ylabel(['eCDF, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
xlim([0 1])

box on

set(gcf, 'Position', [1587         934         283         212])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/diurnal_eCDF_entropy'];
saveas(gcf, [saveas_f, '.png'], 'png')