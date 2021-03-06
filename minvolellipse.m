
clc;
P=rand(2,5);
[d N] = size(P);

Q = zeros(d+1,N);
Q(1:d,:) = P(1:d,1:N);
Q(d+1,:) = ones(1,N);



count = 1;
err = 1;
tolerance=0.01;
u = (1/N) * ones(N,1);          



while err > tolerance
    X = Q * diag(u) * Q';      
    M = diag(Q' * inv(X) * Q);  
    [maximum j] = max(M);
    step_size = (maximum - d -1)/((d+1)*(maximum-1));
    new_u = (1 - step_size)*u ;
    new_u(j) = new_u(j) + step_size;
    count = count + 1;
    err = norm(new_u - u);
    u = new_u;
end




U = diag(u);


A = (1/d) * inv(P * U * P' - (P * u)*(P*u)' );


C = P * u;



 
 
N = 20; %





if length(C) == 3,
    Type = '3D';
elseif length(C) == 2,
    Type = '2D';
else
    display('Cannot plot an ellipse with more than 3 dimensions!!');
    return
end


[U D V] = svd(A);

if strcmp(Type, '2D'),
    
    a = 1/sqrt(D(1,1));
    b = 1/sqrt(D(2,2));

    theta = [0:1/N:2*pi+1/N];

   
    state(1,:) = a*cos(theta); 
    state(2,:) = b*sin(theta);

  
    X = V * state;
    X(1,:) = X(1,:) + C(1);
    X(2,:) = X(2,:) + C(2);
    
elseif strcmp(Type,'3D'),
    
    a = 1/sqrt(D(1,1));
    b = 1/sqrt(D(2,2));
    c = 1/sqrt(D(3,3));
    [X,Y,Z] = ellipsoid(0,0,0,a,b,c,N);
    
    
    XX = zeros(N+1,N+1);
    YY = zeros(N+1,N+1);
    ZZ = zeros(N+1,N+1);
    for k = 1:length(X),
        for j = 1:length(X),
            point = [X(k,j) Y(k,j) Z(k,j)]';
            P = V * point;
            XX(k,j) = P(1)+C(1);
            YY(k,j) = P(2)+C(2);
            ZZ(k,j) = P(3)+C(3);
        end
    end
end



if strcmp(Type,'2D'),
    plot(X(1,:),X(2,:));
    hold on;
    plot(C(1),C(2),'r*');
    hold on;
    plot(P(1,:),P(2,:),'b*');
    axis equal, grid
else
    mesh(XX,YY,ZZ);
    axis equal
    hidden off
end
