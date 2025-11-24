%% Script interattivo calcolo coppie 3R

disp("=== Calcolo coppie di un Manipolatore 3R ===")

% Input lunghezze
L = input("Inserisci le lunghezze dei link [a1 a2 a3] (es. [0.4 0.3 0.25]): ");

% Input giunti (in gradi → convertiti in rad)
theta_deg = input("Inserisci gli angoli dei giunti in gradi [t1 t2 t3]: ");
theta = deg2rad(theta_deg);

% Input forze applicate
W = input("Inserisci la forza [Fx Fy Fz] (es. peso 10N verso il basso → [0 -10 0]): ");

% Calcolo coppie
tau = tau_3R(L(1), L(2), L(3), theta(1), theta(2), theta(3), W(1), W(2), W(3));

% Output
disp("Coppie necessarie ai giunti [τ1 τ2 τ3] = ");
disp(tau.');