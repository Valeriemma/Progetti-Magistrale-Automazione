clc;
clear all;
close all;

s = tf('s');
P = 1/(s-1);
W2 = 2/(s+10);
W1 = 1/(s+1);
C = 1;
S = minreal(1/(1+P*C));
T = minreal(P*C/(1+P*C));

k_vector = [0.2 ,1.1, 5/3, 2.1, 3];

figure(2);
hold on;

T = minreal(P*k_vector(1)/(1+P*k_vector(1)));
bode(W2*T);
legend('W2T');

S = minreal(1/(1+P*k_vector(1)));
bode(W1*S);

legend('W2T','W1S');
grid on;
hold off;

figure(3);

nyquist(P*k_vector(1));

figure(4)
rlocus(W2*T);


