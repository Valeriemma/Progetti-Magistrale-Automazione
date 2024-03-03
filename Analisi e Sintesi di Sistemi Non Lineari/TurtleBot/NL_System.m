function dzdt = NL_System(x,u)
    v = u(1);
    u2 = u(2);

    % psi = sqrt(z(2)^2+z(4)^2);
    psi = hypot(z(2),z(4));

    dz1dt = z(2);
    dz2dt = z(2)*v/psi - z(4)*u2;
    dz3dt = z(4);
    dz4dt = z(4)*v/psi + z(2)*u2;

    dzdt = [dz1dt; dz2dt; dz3dt; dz4dt];
end
