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

% start = datenum('2013-08-15 14:00:00');
% finish = datenum('2013-11-06 18:00:00');
% index= (T >= start & T < finish);
% 
% t = T(index); 
% dp = Depth(index);

% T={'Depth'};

o=1;
L={'m'};
LIM1={[0 800]};

tx={[1100]};
ty={[25]};
tz={[-400]};

%% State-space reconstruction via Time-delay embedding

tau = 375;% sec = samples
DIM = 3;


h = figure('Position',[1533         679         538         584]);%,'doublebuffer','off','Visible','Off');

movegui(h, 'onscreen');
rect = get(h,'Position'); 
rect(1:2) = [0 0]; 
vidObj = VideoWriter(['/Volumes/Extreme SSD/NARWHAL/VIDEO/days_steps.mp4'],'MPEG-4');
vidObj.Quality = 100;
vidObj.FrameRate = 10;
open(vidObj);

h(1)=subplot(1,1,1)

for i = 0:0.25:83; % 1 unit step = 1 day
    
    start = datenum('2013-08-15 12:00:00')+i;
    finish = start+0.25;
    index= (T >= start & T < finish);

    t = T(index); 
    dp = Depth(index);
    
    y = phasespace(dp,DIM,tau);
    
    axes(h(1))
    plot3(y(:,1),y(:,2),y(:,3),'k-','LineWidth',0.5,'Color','k')%[0.6 0.6 0.6]);

    formatOut = 'dd/mm hh';   
    text(800, 0, 1000, ...
        [num2str(datestr(start, formatOut)) ' - ' num2str(datestr(finish, formatOut))], 'FontSize', F-2, 'BackgroundColor','w')
    
    xlim(LIM1{o})
    ylim(LIM1{o})
    zlim(LIM1{o})
    
    xticks([0:200:800])
    yticks([0:200:800])
    zticks([0:200:800])
    
    axis('square')
    grid on
%     view(135,-45)
    view(135,30)
      
    set(gca, 'FontSize', F-4);
    title('State-space (6 h blocks)','FontSize',F+5,'Interpreter','latex','FontWeight','bold');
    xlabel(['x(t), ' L{o}],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    ylabel(['x(t+$\tau$), ' L{o}],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    zlabel(['x(t+$2\tau$), ' L{o}],'FontSize',F,'FontWeight','bold','Interpreter','latex');
    
set(gcf, 'Position', [1533         679         538         584])
set(gca, 'Position', [0.1300    0.1100    0.7750    0.8150])
%     set(gca,'Zdir','reverse')

    movegui(h, 'onscreen');
    drawnow;
    writeVideo(vidObj,getframe(gcf,rect));
    hold off
    
end

close(vidObj);

return

%% plot Depth vs d/dt

xb = linspace(0,700,50);
yb = linspace(-6.5,6.5,13);
[xx,yy]=meshgrid(xb,yb,10);

[n,c]=hist3([Depth(1:100000-1) diff(Depth(1:100000))], 'Edges', {xb yb});

contour(xx, yy, n.', 'Fill','on','LevelStep',1)
colormap('pink')

ax = gca;
ax.GridColor = 'w'

c=colorbar('Location','east')
    
c.Color='w'

hold on
c.Label.String = 'n';
c.Label.Interpreter = 'latex';
c.Label.FontSize = F-4;
colormap parula
   
caxis([0 1000]), set(c,'Limits', [0 1000])
