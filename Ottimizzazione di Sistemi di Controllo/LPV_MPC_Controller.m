function u_opt = LPV_MPC_Controller(xc, uc, x_des, N, Q, R, S, u_max, u_min, k, tau)
    
    global G W

    %--------------------------------------
    % Andiamo a linearizzare il modello intorno al punto (xc,uc)
    [Ac, Bc, Pc] = LPV_MPC_System(xc, uc);
    %x_mpc = zeros(size(xc,1),N);

    % dinamica del sistema linearizzato
    A = (eye(size(Ac, 2)) + tau*Ac);
    B = tau*Bc;
    P_system = tau*Pc;

    R_bar = [];
    Q_bar = [];
    T_bar = A;
    X = A;
    P_a = B;
    P = B;
   % costruzione della matrice R_bar, T_bar, P
    
    for i = 1:1:N
        R_bar = blkdiag(R_bar, R);
        if(i < N)
            Q_bar = blkdiag(Q_bar, Q);
        end
        if (i > 1)
            X = X*A;
            T_bar = [T_bar; X];
            P_a = A*P_a;
            P = [P; P_a];
        end
        
    end
   
    
    Q_bar = blkdiag(Q_bar, S);
    S_bar = P;
    c = 1;
    
    for i = size(B, 2) + 1 : size(B, 2) : size(B, 2)*(N-1) + 1
        S_bar(:, i:i+size(B, 2)-1) = [zeros(size(A,2)*c, size(B,2)); S_bar(1:size(A, 2)*N-size(A, 2)*c, 1:size(B,2))];
        c = c + 1;
    end
    

    Y = 2*(Q + T_bar' * Q_bar * T_bar);
    H = 2*(R_bar + S_bar' * Q_bar * S_bar);
    F = 2*(T_bar'*Q_bar*S_bar)';
    init = zeros(size(H, 2), 1);
    
    % ----- matrici per i vincoli di disuguaglianza -----%
    G = [];
    G1 = [];
    G2 = [];
    
    W = u_max(1)*ones(2*size(B,2)*N,1);   % vincolo sul primo controllo
    W(end/2 + 1:end) = -u_min(1);
    W(2:2:end) = u_max(2);                % vincolo sul secondo controllo
    W(end/2 + 2:2:end) = -u_min(2);
    
    for i = 1:N
        G1 = blkdiag(G1, eye(size(B,2)));
        G2 = blkdiag(G2, -eye(size(B,2)));
    end
    
    G = [G1;G2];
    
    x_mpc(:,1) = xc;
    
    % l'errore doveva essere nella x_des
    
    for i = 1:N
        x_error = x_mpc(:,i) - x_des(:,k+i);
        
        objective = @(u) 0.5*u'*H*u + x_error'*F'*u;                                  % funzione obiettivo
        options = optimoptions('fmincon', 'Display', 'off');                    % opzioni di ottimizzazione
        u = fmincon(objective, init, [], [], [], [], [], [], @mycon, options);
        u_opt = [u(1); u(2)];
        x_mpc(:,i+1) = A*x_mpc(:,i) + B*u_opt + P_system;
    end
    %disp(norm(x_error));
end

function [c, ceq] = mycon(u)
    
    global G W
    
    c =  G*u-W;   % Vincoli di disuguaglianza
    ceq = [];     % Vincoli di uguaglianza
end
