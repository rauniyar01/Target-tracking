    clc;
    clear all;
    close all;
    
               k=1;
               for i=0:10:100
                   for j=0:10:100
                       nodes(k,:)=[j i];
                       k=k+1;
                   end
               end
 
    f1 = figure(1);
    clf
    plot(nodes(:,1),nodes(:,2),'ko','MarkerSize',5,'lineWidth',2);
    grid on
    hold on
    
    %% Input %%
    
    num=input('number of iterations to predict');
    
    Pt1=100;    % Transmitted power of target1
    
    for t=1:num
        tg1(t,1)=input('x-coordinate of target');
        tg1(t,2)=input('y-coordinate of target');
       
    end
    %plot(tg1(:,1),tg1(:,2),'b+','MarkerSize',5,'lineWidth',2);
    
    %hold on;
    %% Gauss-Newton Localization for 1st iteration %%
    
               
    %% Setting Parameters
    N = 4;  % number of anchors
    M = 1;  % number of mobile nodes
    
    noisePow = 0;  
    networkSize = 10;  
    th=3/4;
    for t=1:num
    %t=1;
    k=1;
    cn=1;
    for i=0:10:100
                   for j=0:10:100       % nodes
                       d2=(tg1(t,1)-j)^2+(tg1(t,2)-i)^2;    %d^2
                       Pr(k)=Pt1/d2;
                       if(Pr(k)>=th)
                           anchorLoc(cn,:)=nodes(k,:);
                           cn=cn+1;
                       end
                       k=k+1;
                   end
    end

   
    mobileLoc=tg1(t,:);
    % Computing the Euclidian distances    
        % very fast computation :)
        % distance   = sqrt(sum( (anchorLoc - repmat(mobileLoc,N,1)).^2 , 2));
        
        % easy to understand computation
        m=1;
        distance = zeros(N,1);
        for n = 1 : N
                distance(n) = sqrt( (anchorLoc(n,1)-mobileLoc(m,1)).^2 + ...
                                            (anchorLoc(n,2)-mobileLoc(m,2)).^2  );
        end
    % Plot the scenario
    
    plot(anchorLoc(:,1),anchorLoc(:,2),'go','MarkerSize',12,'lineWidth',2);
    grid on
    hold on
    plot(mobileLoc(:,1),mobileLoc(:,2),'b+','MarkerSize',12,'lineWidth',2);
    
    % noisy measurements
    distanceNoisy = distance + distance.*noisePow./100.*(rand(N,1)-1/2);
    
    % using gussian newton to solve the problem
    
    numOfIteration = 5;
    
    % Initial guess (random locatio)
    mobileLocEst = networkSize*rand(1,2);
    % repeatation
    for i = 1 : numOfIteration
        % computing the esimated distances
        distanceEst   = sqrt(sum( (anchorLoc - repmat(mobileLocEst,N,1)).^2 , 2));
        % computing the derivatives
            % d0 = sqrt( (x-x0)^2 + (y-y0)^2 )
            % derivatives -> d(d0)/dx = (x-x0)/d0
            % derivatives -> d(d0)/dy = (y-y0)/d0
        distanceDrv   = [(mobileLocEst(1)-anchorLoc(:,1))./distanceEst ... % x-coordinate
                         (mobileLocEst(2)-anchorLoc(:,2))./distanceEst];   % y-coordinate
        % delta 
        delta = - (distanceDrv.'*distanceDrv)^-1*distanceDrv.' * (distanceEst - distanceNoisy);
        % Updating the estimation
        mobileLocEst = mobileLocEst + delta.';
    end
    
    plot(mobileLocEst(:,1),mobileLocEst(:,2),'ro','MarkerSize',12,'lineWidth',2);
    end
    legend('Nodes','Active cell','Actual target location','Tracked Target location',...
           'Location','Best')
   
    
    
    
    
    