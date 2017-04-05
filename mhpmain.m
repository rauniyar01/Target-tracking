clc;
close all;
clear all;


%% Establish a 100*100 area sensor network %%
%s = struct('pr', {}, 'process', {},'cellhead', {},'pwrnow', {}, 'pwrnext', {},'x',{},'y',{},'txrx',{});
f1 = figure(1);
    clf
        k=1;
        s(1).txrx=0;
               for i=0:10:100
                   for j=0:10:100
                       
                       s(k).x=j;
                       s(k).y=i;
                       
                       s(k).pwrnow=1;
                       s(k).pwrnext=0;
                       if rem(s(k).x/10,2)==1 && rem(s(k).y/10,2)==1
                            s(k).cellhead=1;
                            s(k).txrx=0;
                            if s(k).x>10        %% set the transmit location
                                a=s(k).x-20;
                            else
                              a=10;
                            end
                            if s(k).y>10
                                b=s(k).y-20;
                            else
                                b=10;
                            end
                            if s(k).x==10 && s(k).y==10
                                a=0;
                                b=0;
                            end
                                s(k).transmitloc=[a b];
                            
                       else
                            s(k).cellhead=0;
                       end
                       
                       k=k+1;
                   end
               end
               
               
    
    grid on
    for k=1:121
        
                       if s(k).pwrnow==1
                           if s(k).cellhead==1
                                plot(s(k).x,s(k).y,'go','MarkerSize',9,'lineWidth',3);
                                hold on
                           else
                                plot(s(k).x,s(k).y,'go','MarkerSize',5,'lineWidth',2);
                                hold on
                           end
                            
                       else
                            if s(k).cellhead==1
                                plot(s(k).x,s(k).y,'go','MarkerSize',9,'lineWidth',3);
                                hold on
                           else
                                plot(s(k).x,s(k).y,'ro','MarkerSize',5,'lineWidth',2);
                                hold on
                           end
                       end
    end
    
 %% Input %%
    
    num=input('number of iterations to predict');
    
    Pt1=100;    % Transmitted power of target1
    
    
    for t=1:num
        tg1(t,1)=input('x-coordinate of target');
        tg1(t,2)=input('y-coordinate of target');
       
  
    %plot(tg1(:,1),tg1(:,2),'b+','MarkerSize',5,'lineWidth',2);
    Pt1=100;
    %hold on;
    for k=1:121
        d2=(tg1(t,1)-s(k).x)^2+(tg1(t,2)-s(k).y)^2;    %d^2
                       s(k).pr=Pt1/d2;
                       
    end
    
    %% Transmit to neighbourhood sensors %%
    r=15;
    
    for k=1:121
        n=1;
        for j=1:121
            d=sqrt((s(k).x-s(j).x)^2+(s(k).y-s(j).y)^2);
            if d<=r
                s(k).rcpr(n,:)=[s(j).x s(j).y s(j).pr];
                n=n+1;
            end
        end
    end
    
    %% processing at cellhead %%
    th=0.4;
    for k=1:121
        if s(k).cellhead==1
            n=0;
            for j=1:9
                if s(k).rcpr(j,3)>=th
                    n=n+1;
                end
            end
            
            if n>=5
                for j=2:1:9
                    for i=j-1:-1:1
                        if s(k).rcpr(i,3)<s(k).rcpr(i+1,3)
                            
                            temp=s(k).rcpr(i+1,:);
                            s(k).rcpr(i+1,:)=s(k).rcpr(i,:);
                            s(k).rcpr(i,:)=temp;
                        end
                    end
                end
                noisePow = 0; 
                networkSize = 10;  
                distance = zeros(4,1);
                for i=1:4
                   anchorLoc(i,1)=s(k).rcpr(i,1); 
                   anchorLoc(i,2)=s(k).rcpr(i,2); 
                   
                   distance(i) = sqrt(Pt1/s(k).rcpr(i,3));
                end
                
                % noisy measurements
    distanceNoisy = distance + distance.*noisePow./100.*(rand(4,1)-1/2);
    
    % using gussian newton to solve the problem
    
    numOfIteration = 5;
    
    % Initial guess (random locatio)
    mobileLocEst(t,:) = min(anchorLoc)+networkSize*rand(1,2);
    % repeatation
    for i = 1 : numOfIteration
        % computing the esimated distances
        distanceEst   = sqrt(sum( (anchorLoc - repmat(mobileLocEst(t,:),4,1)).^2 , 2));
        % computing the derivatives
            % d0 = sqrt( (x-x0)^2 + (y-y0)^2 )
            % derivatives -> d(d0)/dx = (x-x0)/d0
            % derivatives -> d(d0)/dy = (y-y0)/d0
        distanceDrv   = [(mobileLocEst(t,1)-anchorLoc(:,1))./distanceEst ... % x-coordinate
                         (mobileLocEst(t,2)-anchorLoc(:,2))./distanceEst];   % y-coordinate
        % delta 
        delta = - (distanceDrv.'*distanceDrv)^-1*distanceDrv.' * (distanceEst - distanceNoisy);
        % Updating the estimation
        mobileLocEst(t,:) = mobileLocEst(t,:) + delta.';
        
    end
    s(k).targetLocation=mobileLocEst(t,:);
    s(k).txrx=s(k).targetLocation;
    m=k;
    
    while m~=1
    xt=s(m).transmitloc(1);
    yt=s(m).transmitloc(2);
    X=[s(m).x xt];
    Y=[s(m).y yt];
    line(X,Y);
    for l=1:121
        if s(l).x==xt && s(l).y==yt
           s(l).txrx=s(m).txrx; 
           break
        end
    end
    m=l;
    end
    
    
    
    plot(mobileLocEst(t,1),mobileLocEst(t,2),'b+','MarkerSize',12,'lineWidth',2);
    hold on
                  s(k).pwrnext=1;
    for l=1:121
        if s(l).cellhead==1
        dch=sqrt((s(k).x-s(l).x)^2+(s(k).y-s(l).y)^2);  %distance between cellheads
            if dch<30
                s(l).pwrnext=1;                         %transmitting next power flag to adjacent cellheads
                for m=1:121
                    dtch=sqrt((s(l).x-s(m).x)^2+(s(l).y-s(m).y)^2);  %distance from cellhead to sensors
                    if dtch<=r
                        s(m).pwrnext=1;                 %transmitting next power flag from cellheads to its sensors
                    end
                end
            end
            
        end
    end
    
            end
        end
        
    end
    
    for k=1:121
        s(k).pwrnow=s(k).pwrnext;
        s(k).pwrnext=0;
                       if s(k).pwrnow==1
                           if s(k).cellhead==1
                                plot(s(k).x,s(k).y,'go','MarkerSize',9,'lineWidth',3);
                                hold on
                           else
                                plot(s(k).x,s(k).y,'go','MarkerSize',5,'lineWidth',2);
                                hold on
                           end
                            
                       else
                            if s(k).cellhead==1
                                plot(s(k).x,s(k).y,'go','MarkerSize',9,'lineWidth',3);
                                hold on
                           else
                                plot(s(k).x,s(k).y,'ro','MarkerSize',5,'lineWidth',2);
                                hold on
                           end
                       end
    end
    
    
    end
      
    line(mobileLocEst(:,1),mobileLocEst(:,2));