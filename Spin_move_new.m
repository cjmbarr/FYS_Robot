%Will be insterted into loop/function after determining angle and/or
%distance
clc; close all;

BatVolt=readVoltage(LilGuy,potPin);
fprintf('Battery Voltage is %f volts\n',BatVolt)
spin = input('How many degrees do you want the robot to spin counterclockwise?\n');
move = input('How many centimeters do you want the robot to move?\n');
SpinAndMove(spin,move,LilGuy,in1,in2,in3,in4,enA,enB);

% 2 revs = 0.402 meters = 40.2 cm
function SpinAndMove(spin,move,LilGuy,in1,in2,in3,in4,enA,enB)
    speedMotors = 5;
    if spin<0%turn left for neg angles
        writeDigitalPin(LilGuy,in1,0); writeDigitalPin(LilGuy,in2,1); % A
 writeDigitalPin(LilGuy,in4,0); writeDigitalPin(LilGuy,in3,1); % B

writePWMVoltage(LilGuy,enA,0); 
writePWMVoltage(LilGuy,enB,speedMotors);%left turn
pause((abs(spin)/180)*0.51);
writePWMVoltage(LilGuy,enA,0); writePWMVoltage(LilGuy,enB,0); % speed zero
    
elseif spin>0 %turn right for pos angles
writePWMVoltage(LilGuy,enA,speedMotors); 
writePWMVoltage(LilGuy,enB,0);%left turn

     pause((spin/180)*0.51+0.5);%might have to fix b/c chord was blocking right turn
   writePWMVoltage(LilGuy,enA,0); writePWMVoltage(LilGuy,enB,0); % speed zero
    end
    pause(2)
%move forward
writePWMVoltage(LilGuy,enA,speedMotors); % Left
 writePWMVoltage(LilGuy,enB,speedMotors); % Right
pause(((move/40.2)*(0.48)))
writePWMVoltage(LilGuy,enA,0); writePWMVoltage(LilGuy,enB,0);
end


