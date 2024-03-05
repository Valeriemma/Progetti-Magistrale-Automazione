close all
clear 
clc

%%%%%%%%% ANALISI 

% INPUT: i nostri input sarebbero le lunghezze delle aste prese sul
% brevetto: r1, r2, r3, r4.

% Definisco le dimensioni delle aste, misurate accuratamente dal brevetto
r1 = 1.3;       % Manovella     
r2 = 5.6;       % Biella        
r3 = 3;         % Bilanciere    
r4 = 7.25;      % Telaio        

% Lunghezze aste normalizzate dal telaio
vect_norm = [r1 r2 r3 r4]/r4;

% Definisco la massima escursione del movente
th1_degmax = 125;
th1_radmax = deg2rad(th1_degmax);

% Mi costruisco il mio vettore di theta1 
th1_deg = 90 : 1 : th1_degmax;
th1_rad = deg2rad(th1_deg);

% Fisso theta4
theta4 = pi;

% Fisso velocità movente senso antiorario
w1 = 1;

% Inizializzazioni delle strutture che serviranno per l'algoritmo
range = size(th1_deg);
range = range(2);

y = zeros(1,range);
x = zeros(1,range);

th2_rad = zeros(1,range);
th3_rad = zeros(1,range);

w2 = zeros(1,range);
w3 = zeros(1,range);

% alpha
alpha2 = zeros(1,range);
alpha3 = zeros(1,range);

syms t;

for i = 1 : 1 : range
    % Scrivo le mie varibili per andare r1 trovare th3
    A = 2 * r1 * r3 * sin(th1_rad(i));
    B = - 2 * r3 * r4 + 2 * r1 * r3 * cos(th1_rad(i));
    C = r1^2 - r2^2 + r3^2 + r4^2 - 2 * r1 * r4 * cos(th1_rad(i));

    % Definisco la mia equazione di 2° grado da risolvere
    eq = t^2*(C-B) + 2*A*t + B + C == 0;

    res = solve(eq,t);

    root1 = 2 * atan(res(1));
    root2 = 2 * atan(res(2));

    % Prendo la radice negativa dal risultato dell'equazione di 2° grado
    if root1 < 0

        th3_rad(i) = root1;
    else

        th3_rad(i) = root2;
    end

    % Mi trovo th2 andando r1 sostituire i valori di th3 appena trovati
    y(i) = - r1*sin(th1_rad(i)) - r3*sin(th3_rad(i));
    x(i) = r4 - r1*cos(th1_rad(i)) - r3*cos(th3_rad(i));

    th2_rad(i) = atan2(y(i),x(i));

    % Ora mi calcolo le velocità angolari
    % Lo faccio siccome ho [J]{w} = {r2}, senza appesantire l'onerosità di
    % calcolo vado r1 scrivermi direttamente {w} = ([J]^-1){r2}
    detV = r2*r3*sin(th3_rad(i)-th2_rad(i));

    w2(i) =   w1 * r1 * r3 * sin(th1_rad(i) - th3_rad(i))/detV;
    w3(i) =   w1 * r1 * r2 * sin(th2_rad(i) - th1_rad(i))/detV;

    % Ora mi calcolo le accelerazioni angolari
    detA = -r2*r3*sin(th2_rad(i) - th3_rad(i));

    b1 = r1*cos(th1_rad(i)) * w1^2 + r2*cos(th2_rad(i)) * w2(i)^2 + r3*cos(th3_rad(i)) * w3(i)^2;
    b2 = r1*sin(th1_rad(i)) * w1^2 + r2*sin(th2_rad(i)) * w2(i)^2 + r3*sin(th3_rad(i)) * w3(i)^2;

    alpha2(i) = (r3*cos(th3_rad(i))*b1 + r3*sin(th3_rad(i))*b2)/detA;
    alpha3(i) = -(r2*cos(th2_rad(i))*b1 + r2*sin(th2_rad(i))*b2)/detA;
    
end

th2_deg = rad2deg(th2_rad);
th3_deg = rad2deg(th3_rad); 
TxAngle_rad = pi + th3_rad - th2_rad;
TxAngle_deg = rad2deg(TxAngle_rad);

%cftool;

% Grafico gli andamenti 
% Su punto r1

figure(1);

subplot(3,1,1);

plot(th1_deg,th2_deg);
xlabel("Theta1 (deg)");
ylabel("Theta2 (deg)");

subplot(3,1,2);

plot(th1_deg,w2);
xlabel("Theta1 (deg)");
ylabel("W2 (rad/s)");

subplot(3,1,3);

plot(th1_deg,alpha2);
xlabel("Theta1");
ylabel("Alpha2 (rad/s^2)");

% Su punto r2

figure(2);

subplot(3,1,1);

plot(th1_deg,th3_deg);
xlabel("Theta1 (deg)");
ylabel("Theta3 (deg)");

subplot(3,1,2)

plot(th1_deg,w3);
xlabel("Theta1 (deg)");
ylabel("W3 (rad/s)");

subplot(3,1,3);

plot(th1_deg,alpha3);
xlabel("Theta1 (deg)");
ylabel("Alpha3 (rad/s^2)");

% Angolo di trasmissione

figure(3)
plot(th1_deg,TxAngle_deg);
xlabel("Fork Angle (deg)");
ylabel("Trasmission Angle (deg)");










