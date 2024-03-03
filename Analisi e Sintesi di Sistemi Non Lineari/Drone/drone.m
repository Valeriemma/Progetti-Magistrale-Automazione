clc
clear
close all





tspan = [0, 100];
x0 = [10;10;10];
[t, x] = ode45(@(t, x) NL_system(x), tspan, x0);
figure(1)
plot(x(:, 1), x(:, 2));
grid on

figure(2)
hold on
plot(t, x(:, 1));
plot(t, x(:, 2));
plot(t, x(:, 3));

grid on








function x_dot = NL_system(x)
    
    
    Kv = 0.1; 
    M = 3;
    a = 2*Kv/M *sqrt(M*9.81/Kv);
    tau = 2;
    x1 = x(1);
    x2 = x(2);
    x3 = x(3);
    
%     u = -(x3 + (x2 + Kv/M * tau/2 *x3^2 + tau*a*x3)*(Kv*tau/M * x3 + tau*a)) - (x2*(a*tau + x3) - x3);

    u = -(x3 + (x2 + Kv/M * tau/2 *x3^2 + tau*a*x3)*(Kv*tau/M * x3 + tau*a))+...
    -x3 - (1/(8*a^3*tau^2*(1 + 2*tau)^2*(1 + tau + a^2*tau^3)^2)) * ...
    (2 + 2*a^4*tau^5 + a^2*tau^3*(4 + Kv*M*x2) + a^3*Kv*M*tau^4*x3 + ...
    2*a*tau^2*(a + Kv*M*x3) + tau*(2 + a*Kv*M*x3)) * ...
    (-4*(1 + tau)^2*x2 + 4*a^5*tau^7*x3 + 4*a*tau^2*(1 + tau)*x3 + ...
    2*a^3*tau^4*(2 + tau*(4 + Kv*M*x2))*x3 + ...
    a^4*tau^5*(4*x1 + 8*tau*x1 + 4*tau*x2 + Kv*M*tau*x3^2) + ...
    a^2*tau^2*(4*(1 + 3*tau + 2*tau^2)*x1 + ...
    Kv*M*tau*(tau*x2^2 + x3^2 + 2*tau*x3^2))) - ...
    (a*tau + (Kv*x3)/M) * ...
    (x2 + ((-2 - 4*tau - 2*tau^2 + 2*a^4*tau^6 + a^2*Kv*M*tau^4*x2 + ...
    a^3*Kv*M*tau^5*x3) * ...
    (-4*(1 + tau)^2*x2 + 4*a^5*tau^7*x3 + ...
    4*a*tau^2*(1 + tau)*x3 + ...
    2*a^3*tau^4*(2 + tau*(4 + Kv*M*x2))*x3 + ...
    a^4*tau^5*(4*x1 + 8*tau*x1 + 4*tau*x2 + Kv*M*tau*x3^2) + ...
    a^2*tau^2*(4*(1 + 3*tau + 2*tau^2)*x1 + ...
    Kv*M*tau*(tau*x2^2 + x3^2 + 2*tau*x3^2)))) / ...
    (8*a^4*tau^4*(1 + 2*tau)^2*(1 + tau + a^2*tau^3)^2));
    dx1 = x2;
    dx2 = Kv/M*x3^2 + a*x3;
    dx3 = -1/tau * x3 + u;
    x_dot = [dx1;dx2;dx3];

end