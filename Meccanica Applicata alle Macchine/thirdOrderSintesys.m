function [movente, biella, cedente] = thirdOrderSintesys(f, R, R_1, R_2, lambda, theta2)

% angolo tra l'asse di collineazione e la biella;
psi = atan(R*(1-R)/R_1); 

% diametro del cerchio di Carter-Hall
dc = 3*((R^2*(1-R)^2 + R_1^2)*f)/((1-R)*(R*(1-R)^3 + 2*R^2*(1-R)^2 + 3*R_1^2 + R_2*(1-R)));

% calcolo lunghezza manovella e bilanciere
P24_P13 = dc*cos(lambda+psi);
A_P13 = P24_P13*sin(psi)/abs(sin(pi-theta2+lambda));
A0_P13 = P24_P13*sin(lambda+psi)/abs(sin(pi-theta2));

% lunghezza manovella
P24_A0 = f*R/(1-R);
A0_A = P24_A0*sin(lambda)/sin(theta2 - lambda);

P24_B0 = f/(1-R);

P13_B0 = sqrt(P24_P13^2 + P24_B0^2 - 2*P24_B0*P24_P13*cos(lambda+psi));
alfa = theta2-lambda;
delta = pi-alfa;
P13_B = P24_P13*sin(psi)/sin(delta);

sbeta = sin(theta2)*A0_P13/P13_B0;
cbeta = sqrt(1-sbeta^2);
beta = atan2(sbeta, cbeta);

gamma = 2*pi - beta - delta-theta2;

% lunghezza bilanciere
B0_B = P24_B0*sin(lambda)/sin(gamma);

% calcolo lunghezza biella
P24_B = B0_B*sin(beta)/sin(lambda);
P24_A = A0_A*sin(pi-theta2)/sin(lambda);
AB = P24_B - P24_A;

biella = AB;
movente = A0_A;
cedente = B0_B;

end