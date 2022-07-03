% /Volumes/Extreme SSD/NARWHAL

close all
clear all

load '/Volumes/Extreme SSD/NARWHAL/dive.mat'

%font
f=18;

plot(Date, -Depth)

t = Date + datenum('1900-01-01 00:00:00');

ylabel('Depth (m)');
xlabel('Summer 2013')
ylim([-1000 1])

% (Date(2)-Date(1))*3600*24 = ~ 1 s

% return

%% Self-Mutual Information test to determine the time delay

figure
h(1)=subplot(1,2,1), hold on
h(2)=subplot(1,2,2), hold on

M=[];
F=[];

INT=6;

for i=[1:INT:24*83]*60^2;

bloc = Depth(i:(i+INT*60^2),1);    

%SMInfo
TAU=600*3; %30-min
tau_f = 375;
part = round(length(bloc)^(1/3)*2); %number of boxes for the partition Rice rule for bin number
mi=mutual(detrend(bloc,'constant'), part, TAU);
    
M=[M; mi];

% fnn test to determine the embedding dimension
    %mindim - minimal dimension of the delay vectors 	1
    %maxdim - maximal dimension of the delay vectors 	5
    %tau - delay of the vectors 	1
    %rt - ratio factor 	10-20
    
    Dmin=1; Dmax=4;
    rat = 3; %@5 flattens to m=3, @2 to m=4

out=false_nearest(bloc,Dmin,Dmax,tau_f,rat);
fnn = out(:,2)';

F=[F; fnn];
    
end

%save smi_fnn.mat M F
%load '/Volumes/Extreme SSD/NARWHAL/smi_fnn.mat' 
%60^2*24
axes(h(1))
plot([0:1:TAU],M,'-', 'LineWidth',0.5,'Color',[0.5 0.5 0.5]);
hold on
plot([0:1:TAU],median(M),'k-', 'LineWidth',3);

    title('Self-Mutual Info.','FontSize',f,'Interpreter','latex');
    xlabel('Delay $\tau$ (sec)','FontSize',f,'Interpreter','latex');
    ylabel('$I(\tau)$, bits','FontSize',f,'Interpreter','latex');
    grid on; 
    ylim([0 1])
    xlim([0 TAU])
    line([0 TAU],[1/exp(1) 1/exp(1)],'Color','r','LineStyle','--','LineWidth',2) %
    line([tau_f tau_f],[0 5],'Color','b','LineStyle','--')
    text(tau_f*1.1, 4,[num2str(tau_f) ' sec'],'FontSize',f,'Interpreter','latex','Color','b')
    text(TAU*0.9, 0.5,'$\frac{1}{e}$','FontSize',25,'Interpreter','latex','Color','r','BackgroundColor','w')
    axis('square')
    set(gca, 'FontSize', f);

axes(h(2))        

plot([Dmin:1:Dmax],F(:,1:4),'-', 'LineWidth',0.5,'Color',[0.5 0.5 0.5]);
hold on
plot([Dmin:1:Dmax],median(F(:,1:4)),'k-', 'LineWidth',3);

    title('False Negative Neighbors','FontSize',f,'Interpreter','latex');
    ylabel('$FNN(m),-$','FontSize',f,'Interpreter','latex');
    xlabel('Embedding Dimension, $m$','FontSize',f,'Interpreter','latex');
    grid on;
    ylim([0 1])
    xlim([1 Dmax])
    line([3 3],[0 1],'Color','b','LineStyle','--')
    axis('square')
    set(gca, 'FontSize', f);

set(gcf, 'Position', [1794         771         658         322])
    
% %% SAVE PLOT
saveas_f = ['/Volumes/Extreme SSD/NARWHAL/plots/SMI_FNN_t375_r3'];
saveas(gcf, [saveas_f, '.png'], 'png')