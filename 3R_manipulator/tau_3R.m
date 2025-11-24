function tau = tau_3R(a1, a2, a3, t1, t2, t3, Fx, Fy, Fz)
% Calcola le coppie ai giunti per un manipolatore planare 3R

% Carica la funzione simbolica già salvata
load("tau_3R.mat","tau_f");

% Calcola tau fornendo i parametri
tau = tau_f([a1 a2 a3], [t1 t2 t3], [Fx Fy Fz]);

end