close all, clear all
F = 18;
%%

load 'LEE.mat'
load 'Dimen_30min.mat'

% X = [Euc, Lya, Ene];
X = [Euc, Lya, Ene, Dimen];

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



set(gca, 'FontSize', F);

%% CLUSTERING
%% GMM

k=4;
rng(3);
options = statset('MaxIter',10000);
initialCond2 = randsample(1:k,length(X),true);

gm = fitgmdist(X,k,'CovarianceType','diagonal',...
    'SharedCovariance',true,...
    'Options',options,...
    'Start',initialCond2);

threshold = [0.4 0.6];
P = posterior(gm,X);

n = size(X,1);
[~,order] = sort(P(:,1));

% figure
% plot(1:n,P(order,1),'r-',1:n,P(order,2),'b-',1:n,P(order,3),'g-')
% legend({'Cluster 1', 'Cluster 2','Cluster 3'})
% ylabel('Cluster Membership Score')
% xlabel('Point Ranking')
% title('GMM with Full Unshared Covariances')

idx = cluster(gm,X);

idxC1 = find(P(:,1)>= 0.9);
idxC2 = find(P(:,2)>= 0.9);
idxC3 = find(P(:,3)>= 0.9);
idxC4 = find(P(:,4)>= 0.9);

idxBoth = find(P(:,1)>=threshold(1) & P(:,1)<=threshold(2)); 
numInBoth = numel(idxBoth)

% scatter3(X(:,1),X(:,2),X(:,3),10, idx, 'filled')
%%

figure
hold on
plot3(X(idx==1,1),X(idx==1,2),X(idx==1,4),'r.','MarkerSize',8)
plot3(X(idx==2,1),X(idx==2,2),X(idx==2,4),'k.','MarkerSize',8)
plot3(X(idx==3,1),X(idx==3,2),X(idx==3,4),'b.','MarkerSize',8)
plot3(X(idx==4,1),X(idx==4,2),X(idx==4,4),'m.','MarkerSize',8)

% colormap("parula")

l=legend({'Cluster 1', 'Cluster 2','Cluster 3'},...
    'FontSize',F,'FontWeight','bold','Interpreter','latex');

set(l,'Position',[0.6325    0.4687    0.3224    0.2792])

% axis('square')
box on
set(gca, 'FontSize', F);
grid on

ylabel(['$\Lambda_m$, s$^{-1}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
xlabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
zlabel(['$E_k, (m/s)^2$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

xlim([0 800])
ylim([-0.02 0.2])
zlim([0 5])

view(-45,35)
axis('square')

set(gca, 'FontSize', F);

set(gca, 'Position',[-0.1480    0.2482    1.0530    0.6768])
set(gcf, 'Position',[636   586   359   267])

% hold on
% plot3(X(idxBoth,1),X(idxBoth,2),X(idxBoth,3),'ko','MarkerSize',30)

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/clustering_LyaEucEne'];
% saveas(gcf, [saveas_f, '.png'], 'png')


NORmul = 'countdensity'; %'probability'

ha = tight_subplot(3,1,[.01 .03],[.15 .01],[.01 .01])

axes(ha(1))
histogram(X(idxC2,1),'Normalization',NORmul,'FaceColor','b','EdgeColor','b',...
    'Orientation','vertical', 'BinWidth',10,'BinLimits',[0,800])

% l=legend({'Cluster 2'},...
%     'FontSize',F,'FontWeight','bold','Interpreter','latex');


axes(ha(2))
histogram(X(idxC1,1),'Normalization',NORmul,'FaceColor','r','EdgeColor','r',...
    'Orientation','vertical', 'BinWidth',10,'BinLimits',[0,800])

% l=legend({'Cluster 1'},...
%     'FontSize',F,'FontWeight','bold','Interpreter','latex');


axes(ha(3))
histogram(X(idxC3,1),'Normalization',NORmul,'FaceColor','k','EdgeColor','k',...
    'Orientation','vertical', 'BinWidth',10,'BinLimits',[0,800])

% l=legend({'Cluster 3'},...
%     'FontSize',F,'FontWeight','bold','Interpreter','latex');


xlabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylabel(['Probability, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

set(ha(1:3), 'FontSize', F);

ha(1).XGrid = 'on'
ha(2).XGrid = 'on'
ha(3).XGrid = 'on'

set(ha(1:2),'XTickLabel',''); set(ha,'YTickLabel','')

set(gcf, 'Position',[1914         542         264         319])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/clusters_hist'];
% saveas(gcf, [saveas_f, '.png'], 'png')

%% Time budgets

% full
clus1f = length(X(idx==1,1));
clus2f = length(X(idx==2,1));
clus3f = length(X(idx==3,1));
clus4f = length(X(idx==4,1));

totalf = sum([clus1f, clus2f, clus3f, clus4f]);

%>0.9 ranking
clus1 = length(X(idxC1,1));
clus2 = length(X(idxC2,1));
clus3 = length(X(idxC3,1));
clus4 = length(X(idxC4,1));

total = sum([clus1, clus2, clus3, clus4]);

figure
hold on
b=bar(1, [clus1/total; clus1f/totalf], 'k')
b(1).FaceColor = [0.6 0.6 0.6]
b(2).FaceColor = [0.6 0.6 0.6]
b(2).FaceAlpha = .3;
b=bar(2, [clus2/total; clus2f/totalf],'k') 
b(2).FaceAlpha = .3;
b=bar(3, [clus3/total; clus3f/totalf],'b')
b(2).FaceAlpha = .3;
b=bar(4, [clus4/total; clus4f/totalf],'m')
b(2).FaceAlpha = .3;
ylabel(['Probability, -'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

xticks([1,2,3,4])
% set(gca, 'xticklabel',{'Cluster 2','3-6 h','6-9 h', '9-12 h'})

set(gca, 'FontSize', F);
ylim([0 1])
grid on

set(gcf, 'Position',[1000         827         200         136])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/time_budget'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% plot clustering results

figure
hold on
plot(Tstamp(idxC1),X(idxC1,1),'.','Color',[.5 .5 .5])
plot(Tstamp(idxC2),X(idxC2,1),'k.')
plot(Tstamp(idxC3),X(idxC3,1),'b.')
plot(Tstamp(idxC4),X(idxC4,1),'m.')

xlim([datenum('2013-10-12 00:00:00') datenum('2013-10-20 00:00:00')])
datetick('x','keeplimits')

ylabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
grid on

l=legend({'Cluster 1', 'Cluster 2','Cluster 3','Cluster 4'},...
    'FontSize',F,'FontWeight','bold','Interpreter','latex','Location','bestoutside');

set(gcf, 'Position',[511   630   738   190])

saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/decluster_example'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% cluster by hour of a day
close all
ha = tight_subplot(1,5,[.01 .03],[.25 .01],[.1 .01])

S = {datenum('2013-08-16 00:00:00'), ...
    datenum('2013-08-30 00:00:00'), ...
    datenum('2013-09-13 00:00:00'),...
    datenum('2013-09-27 00:00:00'),...
    datenum('2013-10-13 00:00:00')};

for i = [1:1:5]

start = S{i}
finish = start+14;

% start = datenum('2013-10-01 00:00:00');
% finish = datenum('2013-10-30 00:00:00');

index= (Tstamp >= start & Tstamp < finish);

t = datetime(Tstamp(index),'ConvertFrom','datenum');
D = timetable(t,idx(index));

ind1 = (hour(t)>=0 & hour(t)<3);
ind2 = (hour(t)>=3 & hour(t)<6);
ind3 = (hour(t)>=6 & hour(t)<9);
ind4 = (hour(t)>=9 & hour(t)<12);
ind5 = (hour(t)>=12 & hour(t)<15);
ind6 = (hour(t)>=15 & hour(t)<18);
ind7 = (hour(t)>=18 & hour(t)<21);
ind8 = (hour(t)>=21 & hour(t)<24);

%cluster
em_i1 = D.Var1(ind1);
em_i2 =D.Var1(ind2);
em_i3 =D.Var1(ind3);
em_i4 =D.Var1(ind4);
em_i5 =D.Var1(ind5);
em_i6 =D.Var1(ind6);
em_i7 =D.Var1(ind7);
em_i8 =D.Var1(ind8);

% Y = [em_i1, em_i2, em_i3, em_i4, em_i5, em_i6, em_i7, em_i8];
Y = [[em_i1; em_i2], [em_i3; em_i4], [em_i5; em_i6], [em_i7;em_i8]];

ups = hist(Y,4);

axes(ha(i))
% b=bar(ups'/length(em_i1),'stacked')
b=bar(ups'/length([em_i1; em_i2]),'stacked')


b(1).FaceColor = 'k'; b(1).FaceAlpha = 0.5;
b(2).FaceColor = 'k'; b(2).FaceAlpha = 1;
b(3).FaceColor = 'b'; b(3).FaceAlpha = 0.5;
b(4).FaceColor = 'm'; b(4).FaceAlpha = 0.5;

% set(gca, 'xticklabel',{'0-3 h','3-6 h','6-9 h', '9-12 h', '12-15 h','15-18 h','18-21 h','21-24 h'})

set(gca, 'xticklabel',{'0-6 h','6-12 h', '12-18 h','18-24 h'})

ylabel([{'Time ratio' ; '(per 6h bin)'}],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
% grid on
title([datestr(start,'dd mmm') '-' datestr(finish,'dd mmm')],'FontSize',F,'FontWeight','bold','Interpreter','latex')

xtickangle(45)
box on
axis('square')

end

set(ha(2:5),'YLabel',[])
set(ha(2:5),'YTickLabel',[])

l=legend({'1', '2','3','4'},...
    'FontSize',F,'FontWeight','bold','Interpreter','latex')%,'Location','bestoutside');

set(l,'Position',[0.0019    0.0118    0.0757    0.3861])

set(gcf, 'Position', [1715         982         832         238])


%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/cluster_hourly_season'];
saveas(gcf, [saveas_f, '.png'], 'png')

%% FULL

start = datenum('2013-08-16 00:00:00');
finish = datenum('2013-10-27 00:00:00');

index= (Tstamp >= start & Tstamp < finish);

t = datetime(Tstamp(index),'ConvertFrom','datenum');
D = timetable(t,idx(index));

ind1 = (hour(t)>=0 & hour(t)<3);
ind2 = (hour(t)>=3 & hour(t)<6);
ind3 = (hour(t)>=6 & hour(t)<9);
ind4 = (hour(t)>=9 & hour(t)<12);
ind5 = (hour(t)>=12 & hour(t)<15);
ind6 = (hour(t)>=15 & hour(t)<18);
ind7 = (hour(t)>=18 & hour(t)<21);
ind8 = (hour(t)>=21 & hour(t)<24);

%cluster
em_i1 = D.Var1(ind1);
em_i2 =D.Var1(ind2);
em_i3 =D.Var1(ind3);
em_i4 =D.Var1(ind4);
em_i5 =D.Var1(ind5);
em_i6 =D.Var1(ind6);
em_i7 =D.Var1(ind7);
em_i8 =D.Var1(ind8);

Y = [em_i1, em_i2, em_i3, em_i4, em_i5, em_i6, em_i7, em_i8];

ups = hist(Y,4);

b=bar(ups'/length(em_i1),'stacked')

b(1).FaceColor = 'k'; b(1).FaceAlpha = 0.5;
b(2).FaceColor = 'k'; b(2).FaceAlpha = 1;
b(3).FaceColor = 'b'; b(3).FaceAlpha = 0.5;
b(4).FaceColor = 'm'; b(4).FaceAlpha = 0.5;

set(gca, 'xticklabel',{'0-3 h','3-6 h','6-9 h', '9-12 h', '12-15 h','15-18 h','18-21 h','21-24 h'})

%set(gca, 'xticklabel',{'0-6 h','6-12 h', '12-18 h','18-24 h'})

ylabel([{'Time ratio' ; '(per 3h bin)'}],'FontSize',F,'FontWeight','bold','Interpreter','latex');
set(gca, 'FontSize', F);
% grid on
% title([datestr(start,'dd mmm') '-' datestr(finish,'dd mmm')],'FontSize',F,'FontWeight','bold','Interpreter','latex')

xtickangle(45)
box on
% axis('square')

l=legend({'1', '2','3','4'},...
    'FontSize',F,'FontWeight','bold','Interpreter','latex','Location','bestoutside');

% set(l,'Position',[0.0019    0.0118    0.0757    0.3861])

set(gcf, 'Position', [1640        1018         536         278])


%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/cluster_hourly'];
saveas(gcf, [saveas_f, '.png'], 'png')