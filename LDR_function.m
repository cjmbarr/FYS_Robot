clc; close all;



    [MidAngle,LDRVoltData]=LDR_Scan(frontScanServo,ldrPin,LilGuy);
    PlotUSPolar(LDRVoltData);
    
    function [MidAngle,LDRVoltData]=LDR_Scan(frontScanServo,ldrPin,LilGuy)
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
    midAngleandPos=LDRVoltData(Logic);
    MidAngleMat=midAngleandPos(:,1);
    MidAngle=(min(MidAngleMat)+max(MidAngleMat))/2;
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


