function ButtonWait(LilGuy,b_Pin,l_Pin,d_time)
%a: robot name
%b_Pin: button pin
%1_Pin: led pin
%d_time: time to leave light on
%Print status in comm window
fprintf('\nPress that thang to find out');
buttonSt=0;
while buttonSt==0
    buttonSt=readDigitalPin(LilGuy, b_Pin);
% LED Lights up based of buttonSt
    writeDigitalPin(LilGuy, l_Pin, 1); % ON
    pause(d_time);
    writeDigitalPin(LilGuy, l_Pin, 0); % OFF
    pause(d_time)
end
    fprintf("\nButton wait over \n");
end