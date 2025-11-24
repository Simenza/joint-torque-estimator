%% Script interattivo calcolo coppie URXe
clear all; clc;
load torque_URXe.mat   % carica torque_f

disp("=== Calcolo coppie di un Manipolatore URXe ===")

%% Input
L = [0.1625 0.425 0.3922 0.1333 0.0997 0.0996];
theta_deg = input("Inserisci gli angoli dei giunti in gradi [t1 t2 t3 t4 t5 t6]: ");
theta = deg2rad(theta_deg);   % converti in radianti
W = input("Inserisci le forze [Fx Fy Fz Mx My Mz]: ");

%% Calcolo coppie statiche
tau = torque_f(L, theta, W);
disp("Coppie ai giunti = ")
disp(tau.')

Tbase = [ 1  0  0  0;   
          0 -1  0  0;    
          0  0 -1  0.1625; 
          0  0  0  1 ];

d = L;

L1 = Link('a',0,'d',d(1),'alpha',pi/2);
L2 = Link('a',d(2),'d',0,'alpha',0);
L3 = Link('a',d(3),'d',0,'alpha',0);
L4 = Link('a',0,'d',d(4),'alpha',pi/2);
L5 = Link('a',0,'d',d(5),'alpha',-pi/2);
L6 = Link('a',0,'d',d(6),'alpha',0);

Rob1 = SerialLink([L1 L2 L3 L4 L5 L6], 'name','URXe');
Rob1.base = Tbase;

%% Disegno iniziale
figure(1); clf; hold on;
Rob1.plot(theta);
Rob1.teach(theta);
title("URXe - Visualizzazione coppie");
drawnow;

%% Mostra label dei giunti nell'angolo in alto a destra
ax = gca;
xlims = ax.XLim;
ylims = ax.YLim;
zlims = ax.ZLim;

label_x = xlims(2);                  
label_y = ylims(2);                  
label_z = zlims(2);                  

for i = 1:6
    text(label_x, label_y, label_z - (i-1)*0.1, ...
        sprintf('J%d: %.2f Nm', i, tau(i)), ...
        'FontSize',12,'Color','r','FontWeight','bold', ...
        'HorizontalAlignment','right');
end
