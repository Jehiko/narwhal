load 'LEE.mat' 
load 'Dimen_30min.mat'
X = [Euc, Lya, Ene, Dimen];
F = 18;

%%
close all
figure

set(gcf, 'Position',[1112         628        1445         487])

subplot(1,3,1)
scatter3(X(:,1),X(:,2),X(:,4),10, X(:,3), 'filled')
colormap hot
xlim([0 800])
ylim([-0.02 0.2])
zlim([1 3])

view(34,34)

xlabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylabel(['$\Lambda_m$, s$^{-1}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
zlabel(['$d, -$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

c=colorbar('Location','east');
c.Color='k'
set(c,'Position',[0.317130841856234,0.741273100616019,0.010896839804664,0.099537987679675])

hold on
c.Label.String = '$E_k, (m/s)^2$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = F;
   
caxis([0 6]), set(c,'Limits', [0 6])
set(c,'Ticks', [0 6])
view(45,45)

set(gca, 'FontSize', F);
axis('square')

%% xy plane density
subplot(1,3,2)
hold on

xb = [0:10:800];
yb = [-0.02:0.01:0.20];
zb = [1:0.1:3];

[xx,yy]=meshgrid(xb,yb);
[n,c]=hist3([Euc, Lya], 'Edges', {xb yb});
s = surf(xx, yy, 1*ones(size(xx)), n'/sum(n,'All')*100,'EdgeColor','None','FaceAlpha',1)

[yy,zz]=meshgrid(yb,zb);
[n,c]=hist3([Lya, Dimen], 'Edges', {yb zb});
s = surf(0*ones(size(yy)), yy, zz, n'/sum(n,'All')*100,'EdgeColor','None','FaceAlpha',1)

[xx,zz]=meshgrid(xb,zb);
[n,c]=hist3([Euc, Dimen], 'Edges', {xb zb});
s = surf(xx, 0.2*ones(size(xx)), zz, n'/sum(n,'All')*100,'EdgeColor','None','FaceAlpha',1)


xlabel(['L, m'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
ylabel(['$\Lambda_m$, s$^{-1}$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');
zlabel(['$d, -$'],'FontSize',F,'FontWeight','bold','Interpreter','latex');

    view(45,45)
    set(gca, 'FontSize', F);
    axis('square')
    xlim([0 800])
    ylim([-0.02 0.2])
    zlim([1 3])

co=colorbar('Location','east');
co.Color='k'
set(co,'Position',[0.5952    0.75    0.0111    0.1])

hold on
co.Label.String = '%';
co.Label.Interpreter = 'latex';
co.Label.FontSize = F;
   
caxis([0 2]), set(co,'Limits', [0 2])
set(co,'Ticks', [0 2])

% return
%% Clustering

X = [Euc, Lya, Ene, Dimen];

%For reproducibility, set the random seed.
rng(3);
options = statset('MaxIter',10000);

subp=[0,3,6,9];

for k=[2:1:4];
initialCond2 = randsample(1:k,length(X),true);
gm = fitgmdist(X,k,'CovarianceType','diagonal',...
    'SharedCovariance',true,...
    'Options',options,...
    'Start',initialCond2);
idx = cluster(gm,X);

if k == 4;
subplot(3,3,subp(k))
hold on
plot3(X(idx==1,1),X(idx==1,2),X(idx==1,4),'m.')
plot3(X(idx==2,1),X(idx==2,2),X(idx==2,4),'k.','MarkerSize',2)
plot3(X(idx==3,1),X(idx==3,2),X(idx==3,4),'b.','MarkerSize',2)
plot3(X(idx==4,1),X(idx==4,2),X(idx==4,4),'.','Color',[.5 .5 .5],'MarkerSize',2)

else
subplot(3,3,subp(k))
hold on
plot3(X(idx==1,1),X(idx==1,2),X(idx==1,4),'r.','MarkerSize',2)
plot3(X(idx==2,1),X(idx==2,2),X(idx==2,4),'k.','MarkerSize',2)
plot3(X(idx==3,1),X(idx==3,2),X(idx==3,4),'b.','MarkerSize',2)
plot3(X(idx==4,1),X(idx==4,2),X(idx==4,4),'m.','MarkerSize',2)
end

grid on
xlim([0 800])
ylim([-0.02 0.2])
zlim([1 3])

view(45,45)

text(1000, 0.3, 3, ['k=' num2str(k)],...
    'FontWeight','bold','Interpreter','latex','FontSize',F)

% l=legend({'1','2','3','4'},...
% 'Location', 'northeast','Interpreter','latex','FontSize',F,'AutoUpdate','off')

xlabel(['L, m'],'FontSize',F-2,'FontWeight','bold','Interpreter','latex');
ylabel(['$\Lambda_m$, s$^{-1}$'],'FontSize',F-2,'FontWeight','bold','Interpreter','latex');
zlabel(['$d, -$'],'FontSize',F-2,'FontWeight','bold','Interpreter','latex');

set(gca, 'FontSize', F-2);
axis('square')

end 

%% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/Latex/plots/global_invariants_custers'];
saveas(gcf, [saveas_f, '.png'], 'png')

return
%% Evaluate Clustering

X = [Euc, Lya, Ene, Dimen];

k = 1:10;
nK = numel(k);
Sigma = {'diagonal','full'};
nSigma = numel(Sigma);
SharedCovariance = {true,false};
SCtext = {'true','false'};
nSC = numel(SharedCovariance);
RegularizationValue = 0.01;
options = statset('MaxIter',10000);

% Preallocation
gm = cell(nK,nSigma,nSC);         
aic = zeros(nK,nSigma,nSC);
bic = zeros(nK,nSigma,nSC);
converged = false(nK,nSigma,nSC);

% Fit all models
for m = 1:nSC
    for j = 1:nSigma
        for i = 1:nK
            gm{i,j,m} = fitgmdist(X,k(i),...
                'CovarianceType',Sigma{j},...
                'SharedCovariance',SharedCovariance{m},...
                'RegularizationValue',RegularizationValue,...
                'Options',options);
            aic(i,j,m) = gm{i,j,m}.AIC;
            bic(i,j,m) = gm{i,j,m}.BIC;
            converged(i,j,m) = gm{i,j,m}.Converged;
        end
    end
end

allConverge = (sum(converged(:)) == nK*nSigma*nSC)

figure
bar(reshape(aic,nK,nSigma*nSC))
title('AIC For Various $k$ and $\Sigma$ Choices','Interpreter','latex')
xlabel('$k$','Interpreter','Latex')
ylabel('AIC')
legend({'Diagonal-shared','Full-shared','Diagonal-unshared',...
    'Full-unshared'})

figure
bar(reshape(bic,nK,nSigma*nSC))
title('BIC For Various $k$ and $\Sigma$ Choices','Interpreter','latex')
xlabel('$k$','Interpreter','Latex')
ylabel('BIC')
legend({'Diagonal-shared','Full-shared','Diagonal-unshared',...
    'Full-unshared'})


% idxC1 = find(P(:,1)>= 0.9);
% idxC2 = find(P(:,2)>= 0.9);
% idxC3 = find(P(:,3)>= 0.9);
% idxC4 = find(P(:,4)>= 0.9);