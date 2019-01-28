a = arduino ('COM3','UNO','Libraries','Servo'); %allows for coding to the arduino

s1 = servo(a,'D3', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
s2 = servo(a,'D4', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
s3 = servo(a,'D5', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
%------------------------------------------------
%               ALL THE VARIABLES
%------------------------------------------------
chip1 = 0;      % Value of the first different chip
chip2 = 0;      % Value of the second different chip
chip3 = 0;      % Value of the third different chip
chip4 = 0;      % Value of the fourth different chip
chip5 = 0;      % Value of the fifth different chip
tolerance = .09; % The tolerance of the readings, giving a range

turnRight = 0;  % The value that makes the continuous servo (s1) turn right
turnLeft = 1;   % the value that makes the continuous servo (s1) turn left
noTurn = .49;   % The value that makes the continuous servo (s1) stop

bucket1 = .085; % The value that makes the micro servo (s2), turn to bucket 1
bucket2 = .35;  % The value that makes the micro servo (s2), turn to bucket 2
bucket3 = .85;  % The value that makes the micro servo (s3), turn to bucket 3
bucket4 = 0;    % The value that makes the micro servo (s3), turn to bucket 4
bucket5 = .26;  % The value that makes the micro servo (s3), turn to bucket 5

pause1 = .7;    % The time given to let the continuous servo (s1) turn about one full rotation to the left.
pause2 = .7;    % the time given to let the continuous servo (s1) turn about one full rotation to the right.
%-------------------------------------------------
%               The Voltage Reading
%-------------------------------------------------
analog = zeros(1,25);            % Holds voltage reads, for specific chip
digital = zeros(1,7);            % Holds the average of the readings for each chip that runs through
test = 0;                        % Sets inital test number                   % Set inital average of this test to 0                      % Sets initial count number
writePosition (s1, noTurn);      % Sets s1 to not rotate
writePosition (s2, bucket1);     % Sets s2 to bucket 1
writePosition (s3, bucket5);     % Sets s3 to bucket 5  
    
for x = 1:7                      % Run 7 times, for 7 chips
    test = test +1;              % Increases test number each run  
    allValues = 0;   
    pause(1.5);  
    count = 0;% Pauses between each reading of the chips
    for index = 1:25             % Run values 1 through 9
        
        analog(index) = readVoltage(a,'A0'); % Read from arduino photoresistor
        pause (.1);                          % Slows down read speed
        plot (analog);                       % Plots values
        ylim([-1 6]);                        % Set y limits of plot
        ylabel('Reading');                   % Label y axis
        allValues = analog(index) + allValues;
        count = count +1;                    % Increases count each run from 1 to 25
    end                                      % End for loop
    avgValue = allValues/count;              % Finds average of the readings for the test number 
    fprintf ('test %d = %.4f \n', test, avgValue) % Prints values
    digital(x) = avgValue;                   % Puts each average value into array
  
    
    if (x == 1)                     % If the first chip is being read then these things will happen.
    chip1 = digital(1);                     % Sets the reading from the first chip as chip1
    writePosition (s2, bucket1);            % The rest moves that chip into bucket1
    writePosition (s1, turnLeft);
    pause(pause1);
    writePosition (s1, noTurn);
    end
if (x > 1)                          % If the chip being read isn't first then these things will happen
     if (digital(x)<chip1+tolerance)&&(digital(x)>chip1-tolerance) % If the chip being read is in the range of chip1, it will go to the bucket holding chip1 
         writePosition (s2, bucket1);                               % The rest moves that chip into bucket1
         writePosition (s1, turnLeft);
         pause(pause1);
         writePosition (s1, noTurn);
     end
    if (chip2 == 0)                 % If there is no data for chip2, this will happen.
        if (digital(x)>chip1+tolerance)||(digital(x)<chip1-tolerance)  % If the chip being read is out side the range of chip1, it sets chip2 to this chip reading.
            chip2 = digital(x);
            writePosition (s2, bucket2);
            writePosition (s1, turnLeft);
            pause(pause1);
            writePosition (s1, noTurn);
            continue
        end
     else
        if (digital(x)<chip2+tolerance)&&(digital(x)>chip2-tolerance) % iF there is data for chip2 and the chip beign read is within the bounds of the chip2 range, the chip being read will be sent to bucket 2.
            writePosition (s2, bucket2);
            writePosition (s1, turnLeft);
            pause(pause1);
            writePosition (s1, noTurn); 
            continue
        end 
    end
    % The rest is similar to what happens if (chip2 == 0).
    if (chip3 == 0) 
        if ((digital(x)>chip2+tolerance)||(digital(x)<chip2-tolerance))&&((digital(x)>chip1+tolerance)||(digital(x)<chip1-tolerance))
                chip3 = digital(x);
                writePosition (s3, bucket3);
                writePosition (s1, turnRight);
                pause(pause2);
                writePosition (s1, noTurn);
                continue
        end
    else 
        if (digital(x)<chip3+tolerance)&&(digital(x)>chip3-tolerance)
            writePosition (s3, bucket3);
            writePosition (s1, turnLeft);
            pause(pause2);
            writePosition (s1, noTurn);
            continue
        end 
    end
    if (chip4 == 0)
            if ((digital(x)>chip3+tolerance)||(digital(x)<chip3-tolerance))&&((digital(x)>chip2+tolerance)||(digital(x)<chip2-tolerance))&&((digital(x)>chip1+tolerance)||(digital(x)<chip1-tolerance))
            chip4 = digital(x);
            writePosition (s3, bucket4);
            writePosition (s1, turnRight);
            pause(.54);
            writePosition (s1, noTurn);
            
            continue
            end
    else
        if (digital(x)<chip4+tolerance)&&(digital(x)>chip4-tolerance)
            writePosition (s3, bucket4); 
            writePosition (s1, turnRight);
            pause(pause2);  
            writePosition (s1, noTurn);
            
        continue
        end
    end
    if (chip5 == 0)
        if ((digital(x)>chip4+tolerance)||(digital(x)<chip4-tolerance))&&((digital(x)>chip3+tolerance)||(digital(x)<chip3-tolerance))&&((digital(x)>chip2+tolerance)||(digital(x)<chip2-tolerance))&&((digital(x)>chip1+tolerance)||(digital(x)<chip1-tolerance))
            chip5 = digital(x);
            writePosition (s3, bucket5);
            writePosition (s1, turnRight);
            pause(pause2);
            writePosition (s1, noTurn);
            
        continue
        end
    else
        if (digital(x)<chip5+tolerance)&&(digital(x)>chip5-tolerance)
            writePosition (s3, bucket5);
            writePosition (s1, turnRight);
            pause(pause2);
            writePosition (s1, noTurn);
            continue
        end
    end
    
end
end  
clear %clears all the data from matlab workspace