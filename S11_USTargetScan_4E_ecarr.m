clc; close all;

 writePosition(frontScanServo, 0.5); % Set servo to center
 pause(0.5)
 fprintf('Get ready for some scanning!\n');
    usRangeData = zeros(181,3); % Creates the data array
    persistent i
    for n = linspace(1,0,180) % starts a for loop to update the array for every position
        writePosition(frontScanServo,n);
        pause(0.0015) % Give time for the servo to read and move again
        usRangeData(,1) = (-180*(readPosition(frontScanServo)-0.5));
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
        usRangeData((round(180*n)+1),2) = (first_read+second_read+third_read)/3;
        pause(0.0015)
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