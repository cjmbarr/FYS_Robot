clc; close all;
%%
clc; close all;

% [usRangeData] = scanServo(frontUSsensor, frontScanServo);   
% PlotUSPolar(usRangeData);
    
potVoltage = readVoltage(myKAR,potPin);
batteryLevel = potVoltage * 3
fprintf("Battery Voltage is %0.0f\n",batteryLevel)
powerOutput = 12.0821 / batteryLevel;

% function findMinValues(
minAngles = [];
 
while isempty(minAngles)
    [usRangeData] = scanServo(frontUSsensor, frontScanServo);   
    thresholdDistance = 0.370;
    distanceData = usRangeData(:,2)
    angleData = usRangeData(:,1)
    lengthDistance = length(distanceData)
    minAngles = angleData(distanceData < thresholdDistance)
   if isempty(minAngles)
       Spin(90,myKAR,in1,in2,in3,in4,enA,enB,0,powerOutput);
       Move(-12,myKAR,in1,in2,in3,in4,enA,enB,-1,powerOutput);
   else
       Spin(0,myKAR,in1,in2,in3,in4,enA,enB,0,powerOutput);
       Move(0,myKAR,in1,in2,in3,in4,enA,enB,0,powerOutput);
   end
end

    minDistance = mean(distanceData(distanceData < thresholdDistance)) * 100
    objectAngle = mean(minAngles)
    distanceS = minDistance;
    thetaS = objectAngle;
    [thetaR,distanceR] = ParallaxConversion(thetaS,distanceS,1.8,7.1,8.9);
    spin = thetaR;
    move = distanceR;
    Spin(spin,myKAR,in1,in2,in3,in4,enA,enB,thetaR,powerOutput);
    Move(move,myKAR,in1,in2,in3,in4,enA,enB,distanceR,powerOutput);
    pause(5)
    Move(move,myKAR,in1,in2,in3,in4,enA,enB,-1,powerOutput);
  


% % function for calculations
function [usRangeData] = scanServo(frontUSsensor, frontScanServo)
 writePosition(frontScanServo, 0.5); % Set servo to center
 pause(0.5)
 fprintf('Get ready for some scanning!\n');
 
    usRangeData = zeros(181,2); % Creates the data array
    n = linspace(1,0,181);
    usRangeData(:,1) = [-90:90]';
    for  i = 1:181 % starts a for loop to update the array for every position
        writePosition(frontScanServo,n(i));
        pause(0.0015) % Give time for the servo to read and move again
        first_read = (readDistance(frontUSsensor));
        while first_read == Inf
            first_read = (readDistance(frontUSsensor));
        end
        pause(0.0015)
        second_read = (readDistance(frontUSsensor));
        while second_read == Inf
            second_read = (readDistance(frontUSsensor));
        end
        pause(0.0015)
        third_read = (readDistance(frontUSsensor));
        while third_read == Inf
            third_read = (readDistance(frontUSsensor));
        end
        usRangeData(i,2) = (first_read+second_read+third_read)/3;
        if usRangeData(i,2) > 0.5
            usRangeData(i,2) = 0.5;
        end
        pause(0.0015)
    end
 
    writePosition(frontScanServo, 0.5); % Return servo to center, because we're respectful in this house
end

function [thetaR, distanceR] = ParallaxConversion(thetaS, distanceS, sensorRangeOffset, parallaxOffset, robotRangeOffset) 
distanceR = sqrt((distanceS .* sind(thetaS)).^2 + (distanceS .* cosd(thetaS) + robotRangeOffset).^2)
thetaR = atand(distanceS .* sind(thetaS) ./ (distanceS .* cosd(thetaS) + robotRangeOffset)) 
end

% 2 revs = 0.402 meters = 40.2 cm
function Spin(spin,myKAR,in1,in2,in3,in4,enA,enB,thetaR,powerOutput)
    speedMotors = 2;
    spinTime = abs((spin/90)*0.80)
    % Assign Left and Right Rotation Direction
    if thetaR <= 0
    writeDigitalPin(myKAR,in1,1); writeDigitalPin(myKAR,in2,0); % A
    writeDigitalPin(myKAR,in4,0); writeDigitalPin(myKAR,in3,1); % B
    else
    writeDigitalPin(myKAR,in1,0); writeDigitalPin(myKAR,in2,1); % A
    writeDigitalPin(myKAR,in4,1); writeDigitalPin(myKAR,in3,0); % B   
    end
    % Assign Speed to both motors
    writePWMVoltage(myKAR,enA,speedMotors*powerOutput); % Left
    writePWMVoltage(myKAR,enB,speedMotors*powerOutput); % Right
    pause(spinTime);
    % Assign Speed = 0 to both motors
    writePWMVoltage(myKAR,enA,0); writePWMVoltage(myKAR,enB,0); % speed zero

    pause(1);
end


function Move(move,myKAR,in1,in2,in3,in4,enA,enB,distanceR,powerOutput)
    speedMotors = 3;
    % Assign Left and Right Rotation Direction
    if distanceR >= 0
    writeDigitalPin(myKAR,in1,0); writeDigitalPin(myKAR,in2,1); % A
    writeDigitalPin(myKAR,in4,0); writeDigitalPin(myKAR,in3,1); % B
    else
    writeDigitalPin(myKAR,in1,1); writeDigitalPin(myKAR,in2,0); % A
    writeDigitalPin(myKAR,in4,1); writeDigitalPin(myKAR,in3,0); % B
    end
    % Assign Speed to both motors
    writePWMVoltage(myKAR,enA,speedMotors*powerOutput); % Left
    writePWMVoltage(myKAR,enB,speedMotors*0.80*powerOutput); % Right
    pause(abs((move/40.2)*(0.89)))

    % Stop Moving
    writePWMVoltage(myKAR,enA,0); writePWMVoltage(myKAR,enB,0);
end

