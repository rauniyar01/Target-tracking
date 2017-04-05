    clc;
    
    
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
    %% Localisation %%
    
               
    
    N = 4;  % number of anchors
    M = 1;  % number of mobile nodes
    
    noisePow = 0;  

    networkSize = 10;  
    th=3/4;
    mobileLocEst(1,:)=tg1(1,:);
    t=1;
    
    k=1;
    
    for i=0:10:100
                   for j=0:10:100       % nodes
                       d2(k,t)=(tg1(t,1)-j)^2+(tg1(t,2)-i)^2;    %d^2
                       Pr(k,t)=Pt1/d2(k,t);
                       
                       k=k+1;
                   end
    end
    
    for t=2:num
    %t=1;
    k=1;
    cn=1;
    for i=0:10:100
                   for j=0:10:100       % nodes
                       d2(k,t)=(tg1(t,1)-j)^2+(tg1(t,2)-i)^2;    %d^2
                       Pr(k,t)=Pt1/d2(k,t);
                       if(Pr(k,t)>=th)
                           r(k,t-1)=sqrt((mobileLocEst(t-1,1)-nodes(k,1))^2+(mobileLocEst(t-1,2)-nodes(k,2))^2);
                           r(k,t)=r(k,t-1)*sqrt(Pr(k,t-1)/Pr(k,t));
                           Xc(cn)=j;
                           Yc(cn)=i;
                           R(cn)=r(k,t);
                              circle([j,i],r(k,t),1000,':'); 
                                hold on
                           cn=cn+1;
                       end
                       k=k+1;
                   end
    end

    [xout,yout] = circcirc(Xc(1),Yc(1),R(1),Xc(2),Yc(2),R(2));
    ipc(1)=(xout(1)-Xc(3))^2+(yout(1)-Yc(3))^2-R(3)^2;%intersection point check
    ipc(2)=(xout(2)-Xc(3))^2+(yout(2)-Yc(3))^2-R(3)^2;
    if ipc(1)<=0.01
        mobileLocEst(t,1)=xout(1)
        mobileLocEst(t,2)=yout(1)
    elseif ipc(2)<=0.01
        mobileLocEst(t,1)=xout(2)
        mobileLocEst(t,2)=yout(2)
    else
        errordlg('No intersection point','File Error');
    end
    plot(mobileLocEst(t,1),mobileLocEst(t,2),'ro','MarkerSize',5,'lineWidth',2);
    hold on
    end
    grid on
    line(mobileLocEst(:,1),mobileLocEst(:,2));
    axis([0 100 0 100])
   % legend('Nodes','Active cell','Actual target location','Tracked Target location',...
         %  'Location','Best')
   
    
    
    
    
    