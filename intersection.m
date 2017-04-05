i= 1;

textFileName = ['point.txt']; % assign filename to variable: textFileName

fid = fopen(textFileName, 'rt'); % open the file

         D = textscan(fid, '%f %f %f '); % scan the file and put all columns of that
                                          %file inside D.
         fclose(fid);       % close the file.
         vectorx = D{1};    % first element in D is assigned to a vector called vectorx
         vectory = D{2};    % likewise
         vectorr = D{3};    % likewise
    thetaInDegrees = 0:0.0001:180;    %0 <= theta <= 360 degrees.
    thetaInRadians = thetaInDegrees * (pi/180);  % convert degrees to radians.
         for i= 1:length(vectorx)  % loop. length(vectorx): gives you the length of
                                   % that vector.
 x = vectorx(i) + vectorr(i) * cos(thetaInRadians);         %( vectorx(i),vectory(i)) centre of the circle                        
 y = vectory(i) + vectorr(i) * sin(thetaInRadians);       % x,y are circumference coordinates of a circle
pdecirc(vectorx(i),vectory(i),vectorr(i)) % draw circle

fileID = fopen('coordinates.txt','w'); %open file called coordinates.txt

fprintf(fileID,'%6s %12s\r\n','x','y'); % columns called x and z

fprintf(fileID,'%6.2f %12.8f\r\n',x,y); % fill in the file using computations of x,y

fclose(fileID); % close the file

hold on

end

type coordinates.txt %print the circumference coordinates 