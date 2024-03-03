function U = computeControls(x,reference,t)

c1 = 300;
c2 = 300;
c3 = 300;
c4 = 300;


Bc = [ cos(x(3)), -sin(x(3))*x(4);
       sin(x(3)),  cos(x(3))*x(4)];

M1 = [reference.Xdes_2dot(t);
      reference.Ydes_2dot(t)];

M2 = [c1*(x(1) - reference.Xdes(t)) + c2*(cos(x(3))*x(4) - reference.Xdes_dot(t));
      c3*(x(2) - reference.Ydes(t)) + c4*(sin(x(3))*x(4) - reference.Ydes_dot(t))];


U = Bc\(M1+M2);

% psi = sqrt(z(2)^2+z(4)^2);
% psi = hypot(z(2),z(4));
% Bc = [ z(2)/psi, -z(4);
%        z(4)/psi,  z(2)];
% 
% M1 = [reference.Xdes_2dot(t);
%       reference.Ydes_2dot(t)];
% 
% M2 = [c1*(z(1) - reference.Xdes(t)) + c2*(z(2) - reference.Xdes_dot(t));
%       c3*(z(3) - reference.Ydes(t)) + c4*(z(4) - reference.Ydes_dot(t))];
% 
% U = Bc\(M1+M2);
% U = inv(Bc)*(M1+M2);

end