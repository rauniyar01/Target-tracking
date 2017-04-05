networkSize = 100;  % we consider a 100by100 area that the mobile can wander
    
    anchorLoc   = [0                     0; % set the anchor at 4 vertices of the region
                   networkSize           0;
                   0           networkSize;
                   networkSize networkSize];
               
               nx=0:10:100;
               ny=0:10:100;
 
    f1 = figure(1);
    clf
    plot(nx,0,'ko','MarkerSize',12,'lineWidth',2);
    grid on
    hold on