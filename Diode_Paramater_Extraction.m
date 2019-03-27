
clear;
clc;
close all; 

Is = 0.01e-12; %pico Amps
Ib = 0.1e-12;  %pico Amps
Vb = 1.3;       %Voltage
Gp = 0.1;       %ohms^-1

V = linspace(-1.95,0.7,200);
I = Is*(exp(1.2/0.025*V) - 1) + Gp*V - Ib*exp((-1.2/0.025)*(V+Vb));

I2 = (rand([1 200])*0.4 +0.8).*I;

figure(1)
subplot(1,2,1)
plot(V,I2);
title('Diode Current vs Voltage')
xlabel('')
ylabel('Current')
hold on

subplot(1,2,2)
semilogy(V,I2);
title('Diode Current vs Voltage')
xlabel('')
ylabel('Current with 20% variance')
hold on


Ifit_4 = polyfit(V,I2,4);
Ifit_8 = polyfit(V,I2,8);

Idata_4 = polyval(Ifit_4,V);
Idata_8 = polyval(Ifit_8,V);

subplot(1,2,1)
plot(V,Idata_4);
plot(V,Idata_8);
hold on

subplot(1,2,2)
semilogy(V,Idata_4);
semilogy(V,Idata_8);
hold on

figure(2)
% fitting a and C
fo_ac = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff_ac = fit(V',I2',fo_ac);
If_ac = ff_ac(V');

% fitting a,b and c
fo_abc = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff_abc = fit(V',I2',fo_abc);
If_abc = ff_abc(V');

%fitting abcd
fo_abcd = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
ff_abcd = fit(V',I2',fo_abcd);
If_abcd = ff_abcd(V);

subplot(1,2,1)
plot(If_ac);
hold on
plot(If_abc);
hold on
plot(If_abcd);
hold on
title('Diode Current vs Voltage')
xlabel('')
ylabel('Current')

subplot(1,2,2)
semilogy(V,If_ac);
semilogy(V,If_abc);
semilogy(V,If_abcd);
title('Diode Current vs Voltage')
xlabel('')
ylabel('Current with 20% variance')
hold on

inputs = V.';
targets = I.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
view(net)
Inn = outputs;

figure(3)
subplot(1,2,1)
plot(V,I2)
hold on
plot(V,outputs')
hold on
subplot(1,2,2)
semilogy(V,I2)
hold on
semilogy(V,outputs')
hold on