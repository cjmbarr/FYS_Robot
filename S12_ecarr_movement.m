
Spin(45,myKAR,in1,in2,in3,in4,enA,enB,0);
Move(-10,myKAR,in1,in2,in3,in4,enA,enB,-1);


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

