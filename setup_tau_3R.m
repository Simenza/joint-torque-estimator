% SETUP SYMBOLICO per manipolatore 3R
clear all; clc;

disp("Generazione funzione τ(q) = Jᵀ·W ...");

% Variabili simboliche
syms a1 a2 a3 t1 t2 t3 real
syms Wx Wy Wz real

%  Cinematica diretta (posizione end-effector)
DH = [a1 0 0 t1; ...
      a2 0 0 t2; ...
      a3 0 0 t3];

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


Ja = [Jg(1:2, :); 1 1 1];

%  Forza esterna sull'end effector
W = [Wx; Wy; Wz];

%  Coppie ai giunti tau = Jᵀ·W
tau = simplify(Ja.' * W);

%  Creazione funzione numerica: tau_f(a,L,theta,W)
tau_f = matlabFunction(tau, "Vars", { [a1 a2 a3], [t1 t2 t3], [Wx Wy Wz] });

%  Salvataggio, salvo tau_f in tau_3R.mat
save("tau_3R.mat", "tau_f");

disp("Funzione simbolica generata e salvata come tau_3R.mat");