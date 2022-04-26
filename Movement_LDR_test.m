%General Notes:
%Need to update Range_Det in Det_LDR with US function that scans the
%distance to the exit

%Spin may be fixed now that the if statements include motor calibration,
%still have to check though

%Will probably be within a while loop. Could use Range_Det to when the loop
%breaks.

%Issues: 
%also may have an issue with the orientation towards middle of lights (mid
%angle could be the problem~fixed?

%may need to nix calVoltLDR, using a new way of determining ldr critial 
% voltages now


calVoltLDR=readVoltage(LilGuy,ldrPin);
BatVolt=readVoltage(LilGuy,potPin);
disp(BatVolt)
[AngleRange,MidAngle,LDRVoltData,Volt_STD]=LDR_Scan(frontScanServo,ldrPin,LilGuy,calVoltLDR);
    PlotUSPolar(LDRVoltData);
[Angle_Det,Range_Det]=Det_LDR(AngleRange,MidAngle,Volt_STD);

SpinAndMove(Angle_Det,Range_Det,LilGuy,in1,in2,in3,in4,enA,enB);  
function [AngleRange,MidAngle,LDRVoltData,Volt_STD]=LDR_Scan(frontScanServo,ldrPin,LilGuy,calVoltLDR)

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
        Volt_STD=std(LDRVoltData(:,2));
Logic=LDRVoltData(:,2)<mean(LDRVoltData(:,2))-Volt_STD;
Crit_Angles=LDRVoltData(:,1);
%Uses a calibration value to filter readings to for a difference of
%voltage from the ambient readings the sensor registers
    midAngleCrit=Crit_Angles(Logic);
    %Indexes angles to filter potential angles of lights
%     MidAngleMat=midAngleCrit(:,1);
    %Matrix contains only potential angles
    MidAngle=(min(midAngleCrit)+max(midAngleCrit))/2;
    %Produces an angle between the max and min values of the critical
    %angles
    AngleRange=abs(max(midAngleCrit))-abs(min(midAngleCrit));
    %Produces a range of values between the critical angles
    
    end

function [Angle_Det,Range_Det]=Det_LDR(AngleRange,MidAngle,Volt_STD)
%Determines whether or not the robot moves and/or spins based off of how
%much of a difference there is between the light sources. If only one
%source is detected, there will be a very small difference in angles. If
%not, the robot can use the Mid angle to orient itself and move.

if abs(AngleRange)<10 | Volt_STD<0.14
    Range_Det=0;
    Angle_Det=90;
else 
    Angle_Det=MidAngle;
    Range_Det= 0.1;
end

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
