clear all
close all
clc

syms t

th1_deg = 90:0.1:125;

n = size(th1_deg);
n = n(2);

th3_deg = zeros(1,n);

differentialCoefficients = zeros(n,3); %[R, R', R"]

% p1 =    -0.04238  (-0.04243, -0.04233)
% p2 =       0.319  (0.3188, 0.3193)
% p3 =     -0.2223  (-0.2228, -0.2218)
% p4 =       1.926  (1.926, 1.926)

p1 = -0.04243;  
p2 = 0.3188;  
p3 = -0.2228; 
p4 = 1.926;  
th1_rad = deg2rad(th1_deg);

th2_rad = th1_rad;

lunghezze = zeros(n, 3);
% si procede con il calcolo dei coefficienti R, R', R"

for i = 1:1:n
    differentialCoefficients(i, 1) = 3*p1*th1_rad(i)^2 + 2*p2*th1_rad(i) + p3;
    differentialCoefficients(i, 2) = 6*p1*th1_rad(i) + 2*p2;
    differentialCoefficients(i, 3) = 6*p1;
    lambda = deg2rad(9.5);
    f = 1;    %telaio

  % [manovella        biella           bilanciere]
    [lunghezze(i, 1), lunghezze(i, 2), lunghezze(i, 3)] = thirdOrderSintesys(f,differentialCoefficients(i, 1),differentialCoefficients(i, 2), differentialCoefficients(i, 3),lambda, th2_rad(i));
end

% una volta ricavati i coefficienti differenziali, 
% verifico se sono corretti con l analisi.


th2_rad_s = zeros(1,n);
th3_rad_s = zeros(1,n);

index = 155;     

r1 = lunghezze(index, 1);       % Manovella     
r2 = lunghezze(index, 2);       % Biella        
r3 = lunghezze(index, 3);       % Bilanciere    
r4 = 1;                         % Telaio        

for i = 1 : 1 : n
    % Scrivo le mie varibili per andare a trovare th3
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

        th3_rad_s(i) = root1;
    else

        th3_rad_s(i) = root2;
    end

    % Mi trovo th2 andando a sostituire i valori di th3 appena trovati
    y(i) = - r1*sin(th1_rad(i)) - r3*sin(th3_rad_s(i));
    x(i) = r4 - r1*cos(th1_rad(i)) - r3*cos(th3_rad_s(i));

    th2_rad_s(i) = atan2(y(i),x(i));

end

th2_deg_s = rad2deg(th2_rad_s);
th3_deg_s = rad2deg(th3_rad_s); 

TxAngle_s = 180 + th3_deg_s - th2_deg_s;

figure(3)
plot(th1_deg,TxAngle_s);
xlabel("Fork Angle (deg)");
ylabel("Trasmission Angle Synthesis (deg)");

%cftool
% tramite l analisi è stata ricalcolata la relaizione tra theta1 e theta3.

p1_s =  -0.04308;
p2_s = 0.3219;
p3_s = -0.2278;
p4_s = -1.212; 

R_estimated = zeros(1, 3);
R_estimated(1) = 3*p1_s*th1_rad(index)^2 + 2*p2_s*th1_rad(index) + p3_s;
R_estimated(2) = 6*p1_s*th1_rad(index) + 2*p2_s;
R_estimated(3) = 6*p1_s;

