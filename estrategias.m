function [cloudlet_alvo] = estrategias(necessidade_var, abordagem_var, estrategia_var, politica_var, bts_conectado_Cloudlet, posicao_usuario)
    global bts_conectado_Cloudlet posicao_usuario cloudlet_alvo trajeto
    global necessidade_var abordagem_var estrategia_var politica_var posicao_usuario
    % Inicialize a estrutura cloudlet_alvo
    cloudlet_alvo = struct('Indice', [], 'X', [], 'Y', []);
    
    % Calcule as distâncias entre o usuário e todas as cloudlets
    distancias = sqrt((bts_conectado_Cloudlet(:,5) - posicao_usuario(1)).^2 + (bts_conectado_Cloudlet(:,6) - posicao_usuario(2)).^2);
    
    % Se a estratégia for E1 (menor latência)
    if strcmp(estrategia_var, 'E1')
        % Selecione as duas cloudlets mais próximas do usuário
        [~, indices] = mink(distancias, 2); % Encontra os índices das duas menores distâncias

        % Chame a função sortearLatenciaCloudlets para obter a matriz de latências
        latencias = sortearLatenciaCloudlets(indices);
        
        % Selecione a cloudlet com menor latência entre as duas cloudlets mais próximas
        [~, indice_menor_latencia] = min(latencias);
        
        % O índice da cloudlet alvo é um dos índices das duas cloudlets mais próximas
        indice = indices(indice_menor_latencia);
        
    % Se a estratégia for E2 (menor distância entre o usuário e as cloudlets mais próximas)
    elseif strcmp(estrategia_var, 'E2')
        [~, indice] = min(distancias); % Encontra o índice da menor distância
        
    % Se a estratégia for E3 (menor distância para a cloudlet conectada ao BTS mais próximo do usuário no momento da abordagem)
    elseif strcmp(estrategia_var, 'E3')
        distancias_BTSs = sqrt((bts_conectado_Cloudlet(:,2) - posicao_usuario(1)).^2 + (bts_conectado_Cloudlet(:,3) - posicao_usuario(2)).^2);
        [~, indice] = min(distancias_BTSs);
    end
    
    % Atribua as coordenadas Indice (coluna 4), x (coluna 5) e y (coluna 6) da cloudlet alvo
    cloudlet_alvo.Indice = bts_conectado_Cloudlet(indice, 4);
    cloudlet_alvo.X = bts_conectado_Cloudlet(indice, 5);
    cloudlet_alvo.Y = bts_conectado_Cloudlet(indice, 6);
    
    return;
end
