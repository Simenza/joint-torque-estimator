%% Script interattivo calcolo coppie URXe

disp("=== Calcolo coppie di un Manipolatore URXe ===")

% Input lunghezze
L = input("Inserisci le lunghezze dei link [d1 a2 a3 d4 d5 d6] (es. [0.4 0.3 0.25 0.15 0.1 0.1]): ");

% Input giunti (in gradi → convertiti in rad)
theta_deg = input("Inserisci gli angoli dei giunti in gradi [t1 t2 t3 t4 t5 t6]: ");
theta = deg2rad(theta_deg);

% Input forze applicate
W = input("Inserisci le forze e i momenti [Fx Fy Fz Mx My Mz] (es. peso 10N verso il basso → [0 -10 0 0 0 0]): ");

% Calcolo coppie
torque = torque_URXe(L(1), L(2), L(3), L(4), L(5), L(6), theta(1), theta(2), theta(3), theta(4), theta(5), theta(6), W(1), W(2), W(3), W(4), W(5), W(6));

% Output
disp("Coppie necessarie ai giunti [τ1 τ2 τ3 τ4 τ5 τ6] = ");
disp(torque.');

Tbase=[1  0  0 0; 
       0 -1  0 0;
       0  0 -1 0.8;
       0  0 0 1];

d_vals = L;

L1 = Link('a',0,'d',d_vals(1),'alpha',pi/2);
L2 = Link('a',d_vals(2),'d',0,'alpha',0);
L3 = Link('a',d_vals(3),'d',0,'alpha',0);
L4 = Link('a',0,'d',d_vals(4),'alpha',pi/2);
L5 = Link('a',0,'d',d_vals(5),'alpha',-pi/2);
L6 = Link('a',0,'d',d_vals(6),'alpha',0);
Rob1 = SerialLink([L1 L2 L3 L4 L5 L6], 'name', 'URXe');
Rob1.base = Tbase;
Rob1.teach(theta);

pause();

Rob1.plot(theta','fps',25,'movie','es1movie.mp4');