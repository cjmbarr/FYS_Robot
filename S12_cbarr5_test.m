clc; close all;

[usRangeData] = USTargetScan(frontScanServo,frontUSsensor);
minAngle = findMin(usRangeData);
%drive towards object function








function [usRangeData] = USTargetScan(frontScanServo,frontUSsensor)
 writePosition(frontScanServo, 0.5); % Set servo to center
 pause(0.5)
 fprintf('Get ready for some scanning!\n');
    usRangeData = zeros(181,2); % Creates the data array
    persistent i
    i = 1;
    for n = linspace(1,0,181) % starts a for loop to update the array for every position
        writePosition(frontScanServo,n);

        pause(0.0015) % Give time for the servo to read and move again
        usRangeData(i,1) = i-91;
        first_read = (readDistance(frontUSsensor));
        while first_read == Inf
            first_read = (readDistance(frontUSsensor));
        end
        second_read = (readDistance(frontUSsensor));
        while second_read == Inf
            second_read = (readDistance(frontUSsensor));
        end
        third_read = (readDistance(frontUSsensor));
        while third_read == Inf
            third_read = (readDistance(frontUSsensor));
        end
        usRangeData(i,2) = (first_read+second_read+third_read)/3;
        pause(0.0015)
        i = i+1;
    end
    PlotUSPolar(usRangeData);
    writePosition(frontScanServo, 0.5); % Return servo to center, because we're respectful in this house
 

    function PlotUSPolar(usRangeData)
    % polar plot
    figure('Name','Sample Polar Plot')
    angle = usRangeData(:,1);
    rangeData = usRangeData(:,2);
    polarplot(deg2rad(angle), rangeData ,'b--','LineWidth',1);
    pax = gca;
    pax.ThetaDir = 'clockwise';
    pax.ThetaZeroLocation = 'top';
    pax.ThetaLim = [-90,90];
    pax.RLim = [0,0.6];
    fprintf('polar plot done\n');
    end
end

function minAngle = findMin(usRangeData)
    angle = [-90:1:91];
    minValues = [false, (usRangeData(2:end-1)) < usRangeData(1:end-2) & usRangeData(2:end-1)<usRangeData(3:end)];
    ObjectDistance = usRangeData(minValues);
    ObjectAngle = angle(minValues(182:end));
    t = [ObjectAngle;ObjectDistance]';
    table = array2table(t,'VariableNames',{'Angle', 'Distance'});
    disp(table);
    USmean = mean(usRangeData);
    [minDist, minIndex] = min(ObjectDistance,[],2);
    if minDist >= (USmean-0.1)
        %turn 90 function here
        [usRangeData] = USTargetScan(frontScanServo,frontUSsensor);
        findMin(usRangeData);
    else
    minAngle = ObjectAngle(minIndex);
    end
end