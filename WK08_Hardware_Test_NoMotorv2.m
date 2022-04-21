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
    writeDigitalPin(myKAR, ledPin, 1); % ON
    pause(2);
    writeDigitalPin(myKAR, ledPin, 0); % OFF
    fprintf("\t1 - Done LED Control\n");
% Button Test
    buttonLevel = readDigitalPin(myKAR, buttonPin);
    fprintf('\t2 - Button condition is %0.0f, 0 => OFF\t1 => ON\n',buttonLevel);
% Battery Voltage Test
    actualBattVolts = 11.00; initialVoltsReading = 3.38; 
    calScale = actualBattVolts / initialVoltsReading;
    potVoltage = readVoltage(myKAR,potPin);
    batteryLevel = potVoltage * calScale;
    fprintf('\t3 - Battery Voltage = %0.2fV from a Sensor Voltage of %0.2fV\n',batteryLevel,potVoltage);
% Ultrasonic Range Test
    distance = readDistance(frontUSsensor);
    fprintf('\t4 - Current distance is %0.1f cm.\n',distance*100);
% Buzzer Test
    toneFreq = 2400; toneTime = 0.5;
    playTone(myKAR, tonePin, toneFreq, toneTime);
    pause(toneTime); % need pause to wait for tone to play before "clear" command below
    fprintf('\t5 - Done Buzzer Control\n');
% Light Dependent Resistor Test
    ldrVoltage = readVoltage(myKAR,ldrPin);
    fprintf('\t6 - LDR voltage = %0.3fV\n',ldrVoltage);
% Thermistor Test
    tempVoltage = readVoltage(myKAR,tempPin);
    fprintf('\t7 - Themistor voltage = %0.3fV\n',tempVoltage);
% Solid State Relay Control
    writeDigitalPin(myKAR, ssrPin, 1); % ON 
    pause(2);
    writeDigitalPin(myKAR, ssrPin, 0); % OFF
    fprintf('\t8 - Done SSR Control\n');
% Servo Test (temporarily commented out)
%     centerValue = 0.5; writePosition (frontScanServo, centerValue);
%     % Random Input -90 to 90 
%     desiredPosition = randi(181)-91;
%     % Convert angle to 0-1
%     desiredPosition = round(-1/180 * desiredPosition + centerValue,3);
%     % Send 1st position,
%     writePosition (frontScanServo, desiredPosition); % send position
%     pause(0.5);
%     % Return to center
%     writePosition (frontScanServo, centerValue);
    fprintf('\t9 - Servo Test Not included - temporarily \n');
% Test motors Forward 0.5 seconds
    
% Test Complete
    fprintf("Hardware Test Complete\n")
    close all
