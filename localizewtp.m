clc;
    N = 4;  % number of anchors
    M = 1;  % number of mobile nodes
    
    noisePow = 20;  % it means that the accuracy of distance measurement is 90 %
                    % for instance the inaccuracy of a 1m measured distance
                    % is around .1 meter.

    networkSize = 100;  % we consider a 100by100 area that the mobile can wander
    
          loc   = [0                     0; % set the anchor at 4 vertices of the region
                   networkSize           0;
                   0           networkSize;
                   networkSize networkSize];

    % building a random location for the mobile node
    mobileLoc  = networkSize*rand(M,2)
    
    % Plot the scenario
    f1 = figure(1);
    clf
    plot(loc(:,1),loc(:,2),'ko','MarkerSize',12,'lineWidth',2);
    grid on
    hold on
    
    pt=100;
    % Computing the Euclidian distances    
        % very fast computation :)
        % distance   = sqrt(sum( (anchorLoc - repmat(mobileLoc,N,1)).^2 , 2));
        
        % easy to understand computation
        m=1;
        distance = zeros(N,1);
        
        for n = 1 : N
                distance(n) = sqrt( (loc(n,1)-mobileLoc(m,1)).^2 + ...
                                            (loc(n,2)-mobileLoc(m,2)).^2  );
                                        P(n)=pt/distance(n)^2;
        end
        k=zeros(4,4);
        cx=zeros(4,4);
        cy=zeros(4,4);
        r=zeros(4,4);
        
        for i=1:4
            for j=1:4
                if i~=j
                    k(i,j)=P(i)/P(j);
                    cx(i,j)=(loc(j,1)-k(i,j)*loc(i,1))/(1-k(i,j));
                    cy(i,j)=(loc(j,2)-k(i,j)*loc(i,2))/(1-k(i,j));
                    r(i,j)=sqrt(((loc(j,1)-k(i,j)*loc(i,1))^2)/((1-k(i,j))^2)-(loc(j,1)^2-k(i,j)*loc(i,1)^2)/(1-k(i,j))+((loc(j,2)-k(i,j)*loc(i,2))^2)/((1-k(i,j))^2)-(loc(j,2)^2-k(i,j)*loc(i,2)^2)/(1-k(i,j)));
                end
            end
        end
        
        
                circle([cx(1,2),cy(1,2)],r(1,2),1000,':'); 
                hold on
                circle([cx(1,3),cy(1,3)],r(1,3),1000,':'); 
                hold on
                circle([cx(1,4),cy(1,4)],r(1,4),1000,':'); 
                hold on
                circle([cx(2,1),cy(2,1)],r(2,1),1000,':'); 
                hold on
                circle([cx(2,3),cy(2,3)],r(2,3),1000,':'); 
                hold on
                circle([cx(2,4),cy(2,4)],r(2,4),1000,':'); 
                hold on
                circle([cx(3,1),cy(3,1)],r(3,1),1000,':'); 
                hold on
                circle([cx(3,2),cy(3,2)],r(3,2),1000,':'); 
                hold on
                circle([cx(3,4),cy(3,4)],r(3,4),1000,':'); 
                hold on
        [xout,yout] = circcirc(cx(1,2),cy(1,2),r(1,2),cx(1,3),cy(1,3),r(1,3));
    
    if xout(1)>=0 && xout(1)<=100 && yout(1)>=0 && yout(1)<=100
        mobileLocEst(:,1)=xout(1);
        mobileLocEst(:,2)=yout(1);
    else
        mobileLocEst(:,1)=xout(2);
        mobileLocEst(:,2)=yout(2);
    end
        
        mobileLocEst
        
        
    
    
    
    
    plot(mobileLoc(:,1),mobileLoc(:,2),'b+','MarkerSize',12,'lineWidth',2);
    hold on
    plot(mobileLocEst(:,1),mobileLocEst(:,2),'ro','MarkerSize',5,'lineWidth',2);
    hold on
    
    axis([0 100 1 100])
    