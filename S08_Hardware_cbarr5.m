% Week 8 Hardware Test
% Separates Arduino connection setup
% Maintains connection and allows for quicker run process.
% Setup create during Arduino connection.
% NO clear or close commands - This MAINTAINS existing Arduino Connection
% Must use the same connection name as Arduino Connetion file.
clc; close all; % wipes command window output
%====START Test====
    % add pause to delay quick start
    fprintf("Hardware Test starts in 3 seconds...\n")
    pause(3); 
% LED Test
    writeDigitalPin(Tadashi, ledPin, 1); % ON
    pause(2);
    writeDigitalPin(Tadashi, ledPin, 0); % OFF
    fprintf("\t1 - Done LED Control\n");
% Button Test
    buttonLevel = readDigitalPin(Tadashi, buttonPin);
    fprintf('\t2 - Button condition is %0.0f, 0 => OFF\t1 => ON\n',buttonLevel);
% Battery Voltage Test
    actualBattVolts = 11.00; initialVoltsReading = 3.38; 
    calScale = actualBattVolts / initialVoltsReading;
    potVoltage = readVoltage(Tadashi,potPin);
    batteryLevel = potVoltage * calScale;
    fprintf('\t3 - Battery Voltage = %0.2fV from a Sensor Voltage of %0.2fV\n',batteryLevel,potVoltage);
% Ultrasonic Range Test
    distance = readDistance(frontUSsensor);
    fprintf('\t4 - Current distance is %0.1f cm.\n',distance*100);
% Buzzer Test
    toneFreq = 2400; toneTime = 0.5;
    playTone(Tadashi, tonePin, toneFreq, toneTime);
    pause(toneTime); % need pause to wait for tone to play before "clear" command below
    fprintf('\t5 - Done Buzzer Control\n');
% Light Dependent Resistor Test
    ldrVoltage = readVoltage(Tadashi,ldrPin);
    fprintf('\t6 - LDR voltage = %0.3fV\n',ldrVoltage);
% Thermistor Test
    tempVoltage = readVoltage(Tadashi,tempPin);
    fprintf('\t7 - Themistor voltage = %0.3fV\n',tempVoltage);
% Solid State Relay Control
    writeDigitalPin(Tadashi, ssrPin, 1); % ON 
    pause(2);
    writeDigitalPin(Tadashi, ssrPin, 0); % OFF
    fprintf('\t8 - Done SSR Control\n');
% Servo Test (temporarily commented out)
    centerValue = 0.5; writePosition (frontScanServo, centerValue);
    % Random Input -90 to 90 
    desiredPosition = randi(181)-91;
    % Convert angle to 0-1
    desiredPosition = round(-1/180 * desiredPosition + centerValue,3);
    % Send 1st position,
    writePosition (frontScanServo, desiredPosition); % send position
    pause(0.5);
    % Return to center
    writePosition (frontScanServo, centerValue);
%    fprintf('\t9 - Servo Test Not included - temporarily \n');
% Test motors Forward 0.5 seconds
     % Set Speed Variable 0-5, but normally 2 or more -test it out?
 speedMotors = 2;
 % Assign Left and Right Rotation Direction
 writeDigitalPin(Tadashi,in1,0); writeDigitalPin(Tadashi,in2,1); % A
 writeDigitalPin(Tadashi,in4,1); writeDigitalPin(Tadashi,in3,0); % B
 % Assign Speed to both motors
 writePWMVoltage(Tadashi,enA,speedMotors); % Left
 writePWMVoltage(Tadashi,enB,speedMotors); % Right
 pause(0.25);
 % Assign Speed = 0 to both motors
 writePWMVoltage(Tadashi,enA,0); writePWMVoltage(Tadashi,enB,0); % speed zero
 fprintf('\t10 - Move Forward Complete\n');
% Test Complete
 fprintf("Hardware Test Complete\n")
 close all
% Test Complete
    fprintf("Hardware Test Complete\n")
    close all
