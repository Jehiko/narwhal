%Elapsed time is 237802.449561 seconds. ~66h

tic

clear all
close all
clc

% marker diameter
di=15;

%font
F=18;

%% DATA
load '/Volumes/Extreme SSD/NARWHAL/dive.mat'

T = Date + datenum('1900-01-01 00:00:00'); %rethink

%% Select time interval 

start = datenum('2013-08-15 14:00:00');
% finish = datenum('2013-08-16 00:00:00');
finish = datenum('2013-11-06 18:00:00');
index= (T >= start & T < finish);

t = T(index); 
dp = Depth(index);

R={dp};
T={'Depth'};
L={'m'};
LIM1={[0 700]};
LIM2={[0 100]};

tx={[1100]};
ty={[25]};
tz={[-400]};

fname={'DepthNarwhal'};
number_of_vectors=numel(R);


%% animation

tau = 375;% sec = samples
DIM = 3;

%make time vector of right length for colorMap
Ti = length(t)-(DIM-1)*tau;
t=t(1:Ti);

for o=[1]

% phase space plot
y = phasespace(R{o},DIM,tau);

    if DIM == 2;
        y = [y zeros([length(y) 1])];
    end

h = figure('Position',[1624         392         937         953]);%,'doublebuffer','off','Visible','Off');

%old 
% h = figure('Position',[1633         864         928         481]);%,'doublebuffer','off','Visible','Off');

movegui(h, 'onscreen');
rect = get(h,'Position'); 
rect(1:2) = [0 0]; 
vidObj = VideoWriter(['/Volumes/Extreme SSD/NARWHAL/VIDEO/' fname{o} '_raw_CWT_2minstep.mp4'],'MPEG-4');
vidObj.Quality = 100;
vidObj.FrameRate = 30;
open(vidObj);

I = 60*2;

for i = 60*121:I:length(y)-60*120;
% for i = 60*21:I:length(y)-tau*2; % 1 unit step = 1 sec
    
    S = 60;
    
    col=t; 
    col_d=R{o};
    
    
    subplot(2,2,2)
    %%
    plot3(y(i-S*20:i,1),y(i-S*20:i,2),y(i-S*20:i,3),'k-','LineWidth',0.5,'Color',[0.6 0.6 0.6]);

    hold on
    plot3(y(i-S*15:i,1),y(i-S*15:i,2),y(i-S*15:i,3),'k-','LineWidth',2,'Color',[0.5 0.5 0.5]);
    plot3(y(i-S*10:i,1),y(i-S*10:i,2),y(i-S*10:i,3),'k-','LineWidth',3,'Color',[0.4 0.4 0.4]);
    plot3(y(i-S*5:i,1),y(i-S*5:i,2),y(i-S*5:i,3),'k-','LineWidth',5,'Color',[0.3 0.3 0.3]);
    plot3(y(i-S*1:i,1),y(i-S*1:i,2),y(i-S*1:i,3),'k-','LineWidth',7,'Color',[0.2 0.2 0.2]);
    
    plot3(y(i,1),y(i,2),y(i,3),'go','MarkerFaceColor', 'g','MarkerSize',10);
    
    %show where is it now on x-axis
    plot3(y(i,1),700,0,'ro','MarkerFaceColor', 'r','MarkerSize',6);
    
    text(tx{o}, ty{o}, tz{o}, [num2str(datestr(t(i)))], 'FontSize', F-2, 'BackgroundColor','w')
    
    %%
    s=scatter3(y(:,1), y(:,2), y(:,3), 'r.');
    s.MarkerEdgeAlpha = 0.01;
    %%
    
    
    xlim(LIM1{o})
    ylim(LIM1{o})
    zlim(LIM1{o})
    
    xticks([0:200:700])
    yticks([0:200:700])
    zticks([0:200:700])
    
    axis('square')
    grid on
    view(135,30)
    
    set(gca, 'FontSize', F-4);
    title('Embed. Depth (full)','FontSize',F+5,'Interpreter','latex','FontWeight','bold');
    xlabel(['x(t), ' L{o}],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    ylabel(['x(t+$\tau$), ' L{o}],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    zlabel(['x(t+$2\tau$), ' L{o}],'FontSize',F,'FontWeight','bold','Interpreter','latex');
%     set(gca,'Zdir','reverse')
    
    hold off
    %%
    subplot(2,2,1)
    plot(t(i-S*20:i,1),R{o}(i-S*20:i,1),'k-','LineWidth',0.5,'Color',[0.6 0.6 0.6]);

    hold on
    plot(t(i-S*15:i,1),R{o}(i-S*15:i,1),'k-','LineWidth',2,'Color',[0.5 0.5 0.5]);
    plot(t(i-S*10:i,1),R{o}(i-S*10:i,1),'k-','LineWidth',3,'Color',[0.4 0.4 0.4]);
    plot(t(i-S*5:i,1),R{o}(i-S*5:i,1),'k-','LineWidth',5,'Color',[0.3 0.3 0.3]);
    plot(t(i-S*1:i,1),R{o}(i-S*1:i,1),'k-','LineWidth',7,'Color',[0.2 0.2 0.2]);
%     
    plot(t(i,1),R{o}(i,1),'ro','MarkerFaceColor', 'r','MarkerSize',10);
    plot(t(i:i+tau,1),R{o}(i:i+tau,1),'r-','MarkerFaceColor', 'r','MarkerSize',7);
    plot(t(i:i+tau*2,1),R{o}(i:i+tau*2,1),'r-','MarkerFaceColor', 'r','MarkerSize',5);

    plot(t(i+tau,1),R{o}(i+tau,1),'ro','MarkerFaceColor', 'r','MarkerSize',7);
    plot(t(i+tau*2,1),R{o}(i+tau*2,1),'ro','MarkerFaceColor', 'r','MarkerSize',5);

    v = mean([diff(R{o}(i-1:i)) diff(R{o}(i:i+1))]);
    
    text(t(i,1),R{o}(i,1)+50, [num2str(v) ' m/s'], 'FontSize', F-2, 'Color','b')

    
    xlim([t(i-S*20,1) t(i+tau*2,1)])
    ylim(LIM1{o})
    datetick('x','keeplimits','keepticks')
    
    axis('square')
    grid on
     
    set(gca, 'FontSize', F-4);
 
    title('Depth (t, t+$\tau$, t+2$\tau$)','FontSize',F+5,'Interpreter','latex','FontWeight','bold');
    ylabel('Depth, m','FontSize',F,'FontWeight','bold','Interpreter','latex');
    set(gca,'Ydir','reverse')
    
    hold off
    
    %% CWT
    ax2=subplot(2,2,3);
    
        [wt1,f1] = cwt(R{o}(i-S*60*2:i+S*60*2,1),1);
        t1 = t(i-S*60*2:i+S*60*2);
        hp=pcolor(t1,log2(f1),abs(wt1));
        
        shading interp; c=colorbar('Location','southoutside');
        
        xlim([t(i-S*20,1) t(i+tau*2,1)])
        
        datetick('x','keeplimits','keepticks')
        
        caxis([0, 120]), set(c,'Limits', [0 120]);

    set(gca, 'Position', [0.1300    0.1690    0.3337    0.2822])
    set(gca,'Ydir','reverse')
    set(gca, 'FontSize', F-4);
    line([t(i) t(i)],[-12 -1],'Color','w','LineStyle','--');
    
    yticks(log2([1/1200 1/600 1/300 1/60 1/6]))
    yticklabels({'20','10','5','1','0.1'})
    
    title('CWT','FontSize',F+5,'Interpreter','latex','FontWeight','bold');

    ylabel('Period, min','FontSize',F,'FontWeight','bold','Interpreter','latex');
    
    grid on
    ax2.GridColor = 'w';
    set(gca,'layer','top')
    
    hold off
    
    %%
    ax3=subplot(2,2,4);
    
    plot3(y(i-S*20:i,1),y(i-S*20:i,2),y(i-S*20:i,3),'k-','LineWidth',0.5,'Color',[0.6 0.6 0.6]);

    hold on
    plot3(y(i-S*15:i,1),y(i-S*15:i,2),y(i-S*15:i,3),'k-','LineWidth',2,'Color',[0.5 0.5 0.5]);
    plot3(y(i-S*10:i,1),y(i-S*10:i,2),y(i-S*10:i,3),'k-','LineWidth',3,'Color',[0.4 0.4 0.4]);
    plot3(y(i-S*5:i,1),y(i-S*5:i,2),y(i-S*5:i,3),'k-','LineWidth',5,'Color',[0.3 0.3 0.3]);
    plot3(y(i-S*1:i,1),y(i-S*1:i,2),y(i-S*1:i,3),'k-','LineWidth',7,'Color',[0.2 0.2 0.2]);
    
    plot3(y(i,1),y(i,2),y(i,3),'go','MarkerFaceColor', 'g','MarkerSize',10);
    
    %show where is it now on x-axis
    plot3(y(i,1),100,0,'ro','MarkerFaceColor', 'r','MarkerSize',6);
    
    %
    s1=scatter3(y(:,1), y(:,2), y(:,3), 'r.');
    s1.MarkerEdgeAlpha = 0.01;
    %
    
    xlim(LIM2{o})
    ylim(LIM2{o})
    zlim(LIM2{o})
    
    xticks([0:50:100])
    yticks([0:50:100])
    zticks([0:50:100])
    
    axis('square')
    grid on
    view(135,30)
     
    set(gca, 'FontSize', F-4);
 
    title('Embed. Depth (shallow)','FontSize',F+5,'Interpreter','latex','FontWeight','bold');
    xlabel(['x(t), ' L{o}],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    ylabel(['x(t+$\tau$), ' L{o}],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    zlabel(['x(t+$2\tau$), ' L{o}],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    
% set(gcf, 'Position', [1341         967        1218         378])
%     set(gca, 'Position', [0.5300    0.1100    0.3337    0.8150])
%     set(gca,'Zdir','reverse')
    hold off
    
    %% CWT closer look at short periods
%     ax3=subplot(2,2,4);
%     
%     [wt1,f1] = cwt(R{o}(i-S*20:i+tau*2,1),'bump',1);
%     
%         t1 = t(i-S*20:i+tau*2);
%         
%         hp=pcolor(t1,log2(f1),abs(wt1));
% 
%         shading interp; c=colorbar('Location','southoutside');
%         
%         xlim([t(i-S*20,1) t(i+tau*2,1)])
%         
%         datetick('x','keeplimits','keepticks')
%         
%         caxis([0, 6]), set(c,'Limits', [0 6]);
% 
% %     set(gca, 'Position', [0.1300    0.1100    0.3337    0.2950])
%     set(gca,'Ydir','reverse')
%     set(gca, 'FontSize', F-4);
%     line([t(i) t(i)],[-12 -1],'Color','w','LineStyle','--');
%     
%     ylim([-12.0038 -1.2038])
%     
%     yticks(log2([1/1200 1/600 1/300 1/60 1/6]))
%     yticklabels({'20','10','5','1','0.1'})
%     ylabel('Period, min','FontSize',F,'FontWeight','bold','Interpreter','latex');
%     
%     hold off
    
    %%
    movegui(h, 'onscreen');
    drawnow;
    writeVideo(vidObj,getframe(gcf,rect));
    hold off
end
close(vidObj); %clf
end

toc