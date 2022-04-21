clc; close all;


% spin = input('How many degrees do you want the robot to spin counterclockwise?\n');
move = input('How many centimeters do you want the robot to move?\n');
SpinAndMove(spin,move,Tadashi,in1,in2,in3,in4,enA,enB);

% 2 revs = 0.402 meters = 40.2 cm
function SpinAndMove(spin,move,Tadashi,in1,in2,in3,in4,enA,enB)
    speedMotors = 5;
    % Assign Left and Right Rotation Direction
    writeDigitalPin(Tadashi,in1,0); writeDigitalPin(Tadashi,in2,1); % A
    writeDigitalPin(Tadashi,in4,1); writeDigitalPin(Tadashi,in3,0); % B
    % Assign Speed to both motors
    writePWMVoltage(Tadashi,enA,speedMotors); % Left
    writePWMVoltage(Tadashi,enB,speedMotors); % Right
    pause((spin/90)*0.51);
    % Assign Speed = 0 to both motors
    writePWMVoltage(Tadashi,enA,0); writePWMVoltage(Tadashi,enB,0); % speed zero

    pause(1);


    % Assign Left and Right Rotation Direction
    writeDigitalPin(Tadashi,in1,0); writeDigitalPin(Tadashi,in2,1); % A
    writeDigitalPin(Tadashi,in4,0); writeDigitalPin(Tadashi,in3,1); % B
    % Assign Speed to both motors
    writePWMVoltage(Tadashi,enA,speedMotors); % Left
    writePWMVoltage(Tadashi,enB,speedMotors); % Right
    pause(((move/40.2)*(0.48)))

    % Stop Moving
    writePWMVoltage(Tadashi,enA,0); writePWMVoltage(Tadashi,enB,0);

end