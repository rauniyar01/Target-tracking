%% Setting Parameters
clc;
    N = 4;  % number of anchors
    M = 2;  % number of mobile nodes
    
    noisePow = 20;  % it means that the accuracy of distance measurement is 90 %
                    % for instance the inaccuracy of a 1m measured distance
                    % is around .1 meter.

    networkSize = 100;  % we consider a 100by100 area that the mobile can wander
    
    anchorLoc   = [0                     0; % set the anchor at 4 vertices of the region
                   networkSize           0;
                   0           networkSize;
                   networkSize networkSize];

    % building a random location for the mobile node
    mobileLoc  = networkSize*rand(M,2);
    
    % Computing the Euclidian distances    
        % very fast computation :)
        % distance   = sqrt(sum( (anchorLoc - repmat(mobileLoc,N,1)).^2 , 2));
        
        % easy to understand computation
        m=2;
        distance = zeros(N,2);
        for m=1:2
        for n = 1 : N
                distance(n,m) = sqrt( (anchorLoc(n,1)-mobileLoc(m,1)).^2 + ...
                                            (anchorLoc(n,2)-mobileLoc(m,2)).^2  );
        end
        end
    % Plot the scenario
    f1 = figure(1);
    clf
    plot(anchorLoc(:,1),anchorLoc(:,2),'ko','MarkerSize',12,'lineWidth',2);
    grid on
    hold on
    plot(mobileLoc(:,1),mobileLoc(:,2),'b+','MarkerSize',12,'lineWidth',2);
    hold on
    line(mobileLoc(:,1),mobileLoc(:,2));
    ang=zeros(4,1);
    % noisy measurements
    distanceNoisy = distance; %+ distance.*noisePow./100.*(rand(N,2)-1/2);
    Difference=zeros(4,1);
    k=1;
    
    for n=1:N
    Difference(n)=distanceNoisy(n,1)-distanceNoisy(n,2);
    
    end
    s=sort(Difference);
    
    for i=4:-1:3
        
            if s(i)==Difference(1)
                ang(k)=135;
                k=k+1;
                ang(k)=315;
                k=k+1;
            elseif s(i)==Difference(2)
                ang(k)=225;
                k=k+1;
                ang(k)=405;
                k=k+1;
            elseif s(i)==Difference(3)
                ang(k)=45;
                k=k+1;
                ang(k)=225;
                k=k+1;
            elseif s(i)==Difference(4)
                ang(k)=315;
                k=k+1;
                ang(k)=495;
                k=k+1;    
            end
    end
    
    a=sort(ang);
    
    if (a(4)-a(1))>360
        b=[a(1) a(4)];
    else
        b=[a(2) a(3)];
    end
    
    if b(1)>360
        b(1)=b(1)-360;
    end
    if b(2)>360
        b(2)=b(2)-360;
    end
    
    b
    
    