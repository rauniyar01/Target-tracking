networkSize = 100;  % we consider a 100by100 area that the mobile can wander
    
    
               k=1;
               for i=10:10:100
                   for j=10:10:100
                       anchorLoc(k,:)=[j i];
                       if(k<100)
                       k=k+1;
                       else
                           break;
                       end
                   end
               end
 
    f1 = figure(1);
    clf
    plot(anchorLoc(:,1),anchorLoc(:,2),'ko','MarkerSize',5,'lineWidth',2);
    grid on
    hold on
    plot(anchorLoc(5,1),anchorLoc(5,2),'b+','MarkerSize',12,'lineWidth',2);