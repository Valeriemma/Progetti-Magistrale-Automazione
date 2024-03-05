% INPUT:
%   Come vettori di input siamo andati a prendere i valori di 
%   3 angoli del movente e rispettivamente del cedente,
%   relazionati dalla funzione.
%
%   phi: [phi(1) phi(2) phi(3)];
%   psi: [psi(1) psi(2) psi(3)];

% OUTPUT:
%   Come output abbiamo le lunghezze delle aste del quadrilatero
%   normalizzate per il telaio (preso unitario).
%
%   a = manovella;
%   b = biella;
%   c = bilanciere;
%   d = telaio;



function [a,b,c,d] = eq_freudenstain(phi,psi)

     if(nargin < 2)
        error("Too few input arguments.");
    end
    
    if(nargout < 4)
        error("Too few output arguments.");
    end

    syms R1 R2 R3

    eq1 = R1*cos(phi(1)) - R2*cos(psi(1)) + R3 == cos(phi(1)-psi(1));
    eq2 = R1*cos(phi(2)) - R2*cos(psi(2)) + R3 == cos(phi(2)-psi(2));
    eq3 = R1*cos(phi(3)) - R2*cos(psi(3)) + R3 == cos(phi(3)-psi(3));
    
    eqns = [eq1, eq2, eq3];

    S = solve(eqns,[R1 R2 R3]);

    if(S.R1 == 0 || S.R2 == 0)
        error("R1 = 0 or R2 = 0. You cannot divide by zero!");
    end

    d = 1;
   
    c = d/S.R1;

    a = d/S.R2;

    b = sqrt(a^2+c^2+d^2-2*a*c*S.R3);
end