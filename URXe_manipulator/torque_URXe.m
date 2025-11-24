function torque = torque_URXe(d1, a2, a3, d4, d5, d6, t1, t2, t3, t4, t5, t6, Fx, Fy, Fz, Mx, My, Mz)
% Calcola le coppie ai giunti per un manipolatore del tipo URDXe

% Carica la funzione simbolica già salvata
load("torque_URXe.mat","torque_f");

% Calcola tau fornendo i parametri
torque = torque_f([d1 a2 a3 d4 d5 d6], [t1 t2 t3 t4 t5 t6], [Fx Fy Fz Mx My Mz]);

end