%General Notes:
%Need to update Range_Det in movement Det_LDR with something that scans the
%distance to the exit

%Spin may be fixed now that the if statements include motor calibration,
%still have to check though

%Will probably be within a while loop. Could use Range_Det to when the loop
%breaks.


[AngleRange,MidAngle,LDRVoltData]=LDR_Scan(frontScanServo,ldrPin,LilGuy);
    PlotUSPolar(LDRVoltData);
[Angle_Det,Range_Det]=Det_LDR(AngleRange);

SpinAndMove(Angle_Det,Range_Det,LilGuy,in1,in2,in3,in4,enA,enB);  

function [Angle_Det,Range_Det]=Det_LDR(AngleRange)
%Determines whether or not the robot moves and/or spins based off of how
%much of a difference there is between the light sources. If only one
%source is detected, there will be a very small difference in angles. If
%not, the robot can use the Mid angle to orient itself and move.
if AngleRange<5
    Range_Det=0;
    Angle_Det=90;
else 
    Angle_Det=MidAngle;
    Range_Det= 0.5;
end

end
function [AngleRange,MidAngle,LDRVoltData]=LDR_Scan(frontScanServo,ldrPin,LilGuy)
calVoltLDR=readVoltage(LilGuy,ldrPin);
    writePosition(frontScanServo, 0.5); % Centers servo
pause(0.5)
 fprintf('Scanning for light...\n');
    LDRVoltData = zeros(181,2); % Preallocates array
    for n = linspace(1,0,180) % for loop to updates the array for every 1 degree
        writePosition(frontScanServo,n);
        pause(0.0015) % Buffer to prevent shaking
        LDRVoltData((round(180*n)+1),1) = (-180*(readPosition(frontScanServo)-0.5));
        LDRVoltData((round(180*n)+1),2) =readVoltage(LilGuy,ldrPin);
        
    end
        
        pause(0.0015)
        writePosition(frontScanServo, 0.5);
Logic=LDRVoltData(:,2)<calVoltLDR;
%Uses a calibration value to filter readings to for a difference of
%voltage from the ambient readings the sensor registers
    midAngleandPos=LDRVoltData(Logic);
    %Indexes data to find potential voltages and angles of lights
    MidAngleMat=midAngleandPos(:,1);
    %Matrix contains only potential angles
    MidAngle=(min(MidAngleMat)+max(MidAngleMat))/2;
    %Produces an angle between the max and min values of the critical
    %angles
    AngleRange=abs(max(MidAngleMat))-abs(min(MidAngleMat));
    %Produces a range of values between the critical angles
    end

     function PlotUSPolar(LDRVoltData)
    % polar plot
    figure('Name','Sample Polar Plot')
    angle = LDRVoltData(:,1);
    rangeData = LDRVoltData(:,2);
    polarplot(deg2rad(angle), rangeData ,'b--','LineWidth',1);
    pax = gca;
    pax.ThetaDir = 'clockwise';
    pax.ThetaZeroLocation = 'top';
    pax.ThetaLim = [-90,90];
    pax.RLim = [0,7];
    fprintf('polar plot done');
    end



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
writeDigitalPin(LilGuy,in1,0); writeDigitalPin(LilGuy,in2,1); % A
 writeDigitalPin(LilGuy,in4,0); writeDigitalPin(LilGuy,in3,1); % B

    writePWMVoltage(LilGuy,enA,speedMotors); 
writePWMVoltage(LilGuy,enB,0);%right turn

     pause((spin/180)*0.51);%might have to fix b/c chord was blocking right turn
   writePWMVoltage(LilGuy,enA,0); writePWMVoltage(LilGuy,enB,0); % speed zero
    end
    pause(2)
%move forward
writePWMVoltage(LilGuy,enA,speedMotors); % Left
 writePWMVoltage(LilGuy,enB,speedMotors); % Right
pause(((move/40.2)*(0.48)))
writePWMVoltage(LilGuy,enA,0); writePWMVoltage(LilGuy,enB,0);
end
