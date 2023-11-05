function [VM, bts_inicial, cloudlet_inicial] = iniciarVM(bts_conectado_Cloudlet, ponto_inicial, limite_maximo_cobertura)
    global bts_conectado_Cloudlet ponto_inicial limite_maximo_cobertura cloudlet_inicial
    % Definição do tamanho da VM
    tamanho_VM = 1280; % tamanho da VM é 1280 MB

    % Identificar a BTS mais próxima do ponto inicial
    distancias = sqrt(sum((bts_conectado_Cloudlet(:, 2:3) - ponto_inicial).^2, 2));
    [~, idx] = min(distancias);
    
    % Identificar a cloudlet conectada à BTS mais próxima
    cloudlet_inicial = struct('Indice', bts_conectado_Cloudlet(idx, 4), 'X', bts_conectado_Cloudlet(idx, 5), 'Y', bts_conectado_Cloudlet(idx, 6)); 

    % Identificar a BTS mais próxima
    bts_inicial = struct('Indice', bts_conectado_Cloudlet(idx, 1), 'X', bts_conectado_Cloudlet(idx, 2), 'Y', bts_conectado_Cloudlet(idx, 3)); 

    % Iniciar a VM na cloudlet mais próxima
    VM = struct('Cloudlet', cloudlet_inicial, 'Tamanho', tamanho_VM); 

    % Exibir uma mensagem indicando que a VM foi iniciada
    disp(['VM de tamanho ', num2str(tamanho_VM), ' MB iniciada na cloudlet ', num2str(cloudlet_inicial.X), ', ', num2str(cloudlet_inicial.Y)]); 

    % Adicionar um círculo azul com 30% de transparência ao redor da cloudlet que inicia a migração da VM
    theta = 0:0.01:2*pi;
    X = cloudlet_inicial.X + limite_maximo_cobertura*cos(theta);
    Y = cloudlet_inicial.Y + limite_maximo_cobertura*sin(theta);
    h1 = fill(X,Y,'g');  
    set(h1,'facealpha',.3);

    % Adicionar um círculo amarelo com 30% de transparência ao redor da BTS inicial de handoff do usuário
    X_bts = bts_inicial.X + limite_maximo_cobertura*cos(theta);
    Y_bts = bts_inicial.Y + limite_maximo_cobertura*sin(theta);
    h2 = fill(X_bts,Y_bts,'y');  
    set(h2,'facealpha',.3);
    
    return;
end
