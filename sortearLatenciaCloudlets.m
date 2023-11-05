function [latencias] = sortearLatenciaCloudlets(indices)
    % Declara bts_cloudlet_conectado_Cloudlet como uma variável global
    global bts_cloudlet_conectado_Cloudlet;
    
    % Inicialize a matriz de latências com zeros
    latencias = zeros(1, length(indices));
    
    % Para cada cloudlet mais próxima
    for i = 1:length(indices)
        % Sorteie aleatoriamente um valor de latência
        latencia = rand();
        
        % Adicione a latência à matriz de latências
        latencias(i) = latencia;
    end
    
    % Agora, a matriz 'latencias' contém a latência para cada cloudlet mais próxima
    
    return;
end
