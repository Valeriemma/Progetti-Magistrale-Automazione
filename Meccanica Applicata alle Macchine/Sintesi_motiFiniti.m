close all
clear 
clc


%delta_th1 = 35;     %escursione movente
%delta_th3 = 18;     %escursione cedente
%x_f = 20;           %escursione forcellone


th1_deg = [90 107 125];
th3_deg = [-53.9747 -45.5094 -35.6569]; 

th1_rad = deg2rad(th1_deg);
th3_rad = deg2rad(th3_deg);

phi = pi - th1_rad;
psi = -th3_rad; 


[a,b,c,d] = eq_freudenstain(phi,psi);




