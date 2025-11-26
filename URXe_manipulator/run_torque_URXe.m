%% Script dinamico calcolo coppie URXe
clear all; clc;
load torque_URXe.mat   % carica torque_f

disp("=== Modalità dinamica URXe ===");

%% Costanti
L = [0.1625 0.425 0.3922 0.1333 0.0997 0.0996];

% Configurazione iniziale
theta_deg = [0 0 0 0 0 0];
theta = deg2rad(theta_deg);

% Payload iniziale
W = [0 0 0 0 0 0];   % [Fx Fy Fz Mx My Mz]

%% Figure
figure(1); clf; hold on;

% Prima visualizzazione
Rob1 = SerialLink( ...
    [ Link('a',0,'d',L(1),'alpha',pi/2), ...
      Link('a',L(2),'d',0,'alpha',0), ...
      Link('a',L(3),'d',0,'alpha',0), ...
      Link('a',0,'d',L(4),'alpha',pi/2), ...
      Link('a',0,'d',L(5),'alpha',-pi/2), ...
      Link('a',0,'d',L(6),'alpha',0) ], ...
    'name', 'URXe');

Rob1.base = [1 0 0 0; 0 -1 0 0; 0 0 -1 0.1625; 0 0 0 1];

Rob1.plot(theta);
title("URXe - Coppie ai giunti in tempo reale");

%% LOOP dinamico
while true

    % CHIEDI all'utente cosa vuole aggiornare
    disp(" ");
    disp("1) Cambia angoli dei giunti");
    disp("2) Cambia payload (forze e momenti)");
    disp("3) Esci");
    scelta = input("Seleziona opzione: ");

    if scelta == 3
        break;
    end

    % --- Aggiornamento angoli ---
    if scelta == 1
        theta_deg = input("Inserisci nuovi angoli [t1 t2 t3 t4 t5 t6] in gradi: ");
        theta = deg2rad(theta_deg);
    end

    % --- Aggiornamento payload ---
    if scelta == 2
        W = input("Inserisci forze e momenti [Fx Fy Fz Mx My Mz]: ");
    end

    %% Ricalcolo coppie statiche
    tau = torque_f(L, theta, W);
    disp("Coppie aggiornate (Nm):");
    disp(tau.');

    %% Aggiorna grafica robot
    Rob1.animate(theta);
    drawnow;

    %% Cancella vecchie etichette
    delete(findall(gca, 'Type', 'text'));

    %% Scrivi nuove etichette
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

end

disp("Modalità dinamica terminata.");