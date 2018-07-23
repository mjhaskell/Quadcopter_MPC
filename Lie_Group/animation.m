function new_animation(in,P)

    % process inputs to function
    pn       = in(1);
    pe       = in(2);
    h        = in(3);
%     phi      = in(4);
%     theta    = in(5);
%     psi      = in(6);
    R        = reshape(in(4:12),3,3);
    t        = in(13);
    
    % drawing parameters
    d = 1;%P.d;
    
    % define persistent variables 
    persistent copter_handle
   
    % first time function is called, initialize plot and persistent vars
    if t==0
%           phi = 0 * pi/180;
%           theta = 0 * pi/180;
%           psi = 45 * pi/180;
%           d = 1;
%           pn = -2.5;
%           pe = -2.5;
%           h  = 4;
        
        figure(1), clf;
        view(-45,20)
        hold on
        grid on
        plot3(0,0,0,'k.','MarkerSize',3); % plot global origin
        plot3([0;1],[0;0],[0;0],'b')
        plot3([0;0],[0;-1],[0;0],'r')
        plot3([0;0],[0;0],[0;-1],'g')
        xlim([-5 5])
        ylim([-5 5])
        zlim([-1 9])
        xlabel('North')
        ylabel('East')
        zlabel('Altitude')
        title('Quadcopter Simulation')
        
        copter_handle = drawCopter(pn,pe,h,R,d, []);
                 
    % at every other time step, redraw ball and beam
    else 
        drawCopter(pn,pe,h,R,d,copter_handle);
    end
end

%
%=======================================================================
% drawCopter
% draw the entire copter
% return handle if last argument is empty, otherwise use last arg as handle
%=======================================================================
%
function handle = drawCopter(pn,pe,h,R2v,d,handle)
  X = [0, d, 0, -d, 0];
  Y = [0, 0, d, 0, -d];
  Z = [0, 0, 0, 0, 0];
  P = [X;Y;Z];
  
  R2m = rot(0,0,pi);
%   R2v = rot(psi,theta,phi);
%   R2v = expm(skew([phi;theta;psi]));
  R = R2m*R2v;
  P = R*P + R2m*[pn;pe;-h];
  
  if isempty(handle)
    handle(1) = plot3(P(1,1:2),P(2,1:2),P(3,1:2),'b','LineWidth',3);
    handle(2) = plot3(P(1,2),P(2,2),P(3,2),'k.','MarkerSize',25);
    handle(3) = plot3([P(1,1);P(1,3)],[P(2,1);P(2,3)],[P(3,1);P(3,3)],'b','LineWidth',3);
%     handle(3) = plot3([P(1,1);P(1,3)],[P(2,1);P(2,3)],[P(3,1);P(3,3)],'r','LineWidth',3);
    handle(4) = plot3(P(1,3),P(2,3),P(3,3),'k.','MarkerSize',25);
    handle(5) = plot3([P(1,1);P(1,4)],[P(2,1);P(2,4)],[P(3,1);P(3,4)],'g','LineWidth',3);
    handle(6) = plot3(P(1,4),P(2,4),P(3,4),'k.','MarkerSize',25);
    handle(7) = plot3([P(1,1);P(1,5)],[P(2,1);P(2,5)],[P(3,1);P(3,5)],'g','LineWidth',3);
    handle(8) = plot3(P(1,5),P(2,5),P(3,5),'k.','MarkerSize',25);
    handle(9) = plot3(P(1,1),P(2,1),P(3,1),'k.','MarkerSize',35);
    handle(10) = plot3([P(1,1);5;P(1,1)],[P(2,1);P(2,1);5],[-1;P(3,1);P(3,1)],'kx','MarkerSize',7);
%     handle(10) = plot3(P(1,1),P(2,1),-1,'kx','MarkerSize',7);
    legend([handle(10)],{'Projections'},'location',[.04 .88 .23 .05]);
  else
    set(handle(1),'XData',P(1,1:2),'YData',P(2,1:2),'ZData',P(3,1:2));
    set(handle(2),'XData',P(1,2),'YData',P(2,2),'ZData',P(3,2));
    set(handle(3),'XData',[P(1,1);P(1,3)],'YData',[P(2,1);P(2,3)],'ZData',[P(3,1);P(3,3)]);
    set(handle(4),'XData',P(1,3),'YData',P(2,3),'ZData',P(3,3));
    set(handle(5),'XData',[P(1,1);P(1,4)],'YData',[P(2,1);P(2,4)],'ZData',[P(3,1);P(3,4)]);
    set(handle(6),'XData',P(1,4),'YData',P(2,4),'ZData',P(3,4));
    set(handle(7),'XData',[P(1,1);P(1,5)],'YData',[P(2,1);P(2,5)],'ZData',[P(3,1);P(3,5)]);
    set(handle(8),'XData',P(1,5),'YData',P(2,5),'ZData',P(3,5));
    set(handle(9),'XData',P(1,1),'YData',P(2,1),'ZData',P(3,1));
    set(handle(10),'XData',[P(1,1);5;P(1,1)],'YData',[P(2,1);P(2,1);5],'ZData',[-1;P(3,1);P(3,1)]);
%     set(handle(10),'XData',P(1,1),'YData',P(2,1),'ZData',-1);
    drawnow
  end
end