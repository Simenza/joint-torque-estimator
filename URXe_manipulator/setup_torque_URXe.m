% SETUP SYMBOLICO per manipolatore UR5e
clear all; clc;

disp("Generazione funzione τ(q) = Jᵀ·W ...");

% Variabili simboliche
syms d1 a2 a3 d4 d5 d6 t1 t2 t3 t4 t5 t6 real
syms Wx Wy Wz Mx My Mz real

%  Cinematica diretta (posizione end-effector)
DH = [0 pi/2 d1  t1; ...
      a2 0    0  t2; ...
      a3 0    0  t3;
      0  pi/2 d4 t4;
      0 -pi/2 d5 t5;
      0  0    d6 t6];

n = size(DH,1);
P = sym(zeros(3,n));
z = sym(zeros(3,n));
T = eye(4);

for i=1:n
    a = DH(i,1);  alpha = DH(i,2);  d = DH(i,3);  theta = DH(i,4);

    Ai = [ cos(theta)  -sin(theta)*cos(alpha)  sin(theta)*sin(alpha)  a*cos(theta);
           sin(theta)  cos(theta)*cos(alpha)   -cos(theta)*sin(alpha)  a*sin(theta);
           0           sin(alpha)              cos(alpha)              d;
           0           0                       0                       1];

    T = simplify(T * Ai);  % Update the transformation matrix
    P(:, i) = T(1:3, 4);  % Extract the position of the end-effector
    z(:, i) = T(1:3, 3);  % Extract the z-axis direction
end

% Compute the Jacobian matrix J
Jg = sym(zeros(6, n));
P0 = [0;0;0];
z0 = [0;0;1];

for i=1:n
    if i==1
        Pi = P0;
        zi = z0;
    else
        Pi = P(:,i-1);
        zi = z(:,i-1);
    end
    Jg(:,i) = [cross(zi, P(:,n) - Pi); zi];
end


% Jacobiano analitico
R = T(1:3, 1:3);

yaw   = atan2(R(2,1), R(1,1));
pitch = atan2(-R(3,1), sqrt(R(3,2)^2 + R(3,3)^2));
roll  = atan2(R(3,2), R(3,3));

E = [1, 0,            -sin(pitch);
     0, cos(roll),     sin(roll)*cos(pitch);
     0, -sin(roll),    cos(roll)*cos(pitch)];

Ei = inv(E);

Ja = simplify([eye(3), zeros(3); zeros(3), Ei]*Jg);

%  Forza esterna sull'end effector
W = [Wx; Wy; Wz; Mx; My; Mz];

%  Coppie ai giunti tau = Jᵀ·W
torque = Ja.' * W;

%  Creazione funzione numerica: tau_f(a,L,theta,W)
torque_f = matlabFunction(torque, "Vars", { [d1, a2, a3, d4, d5, d6], [t1 t2 t3 t4 t5 t6], [Wx Wy Wz Mx My Mz]});

%  Salvataggio, salvo torque_f in torque_URXe.mat
save("torque_URXe.mat", "torque_f");

disp("Funzione simbolica generata e salvata come torque_URXe.mat");
