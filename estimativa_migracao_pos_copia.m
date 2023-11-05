function [tempo_total_migracao, tempo_inatividade, tamanho_vm_enviada] = estimativa_migracao_pos_copia(tamanho_pagina, largura_banda, latencia_rede, velocidade_leitura, velocidade_escrita)
    % Converte a largura de banda de Mbps para MB/s
    largura_banda = largura_banda / 8;
    
    % Define o total de páginas
    total_paginas = 32;
    
    % Calcula o tamanho total dos dados
    tamanho_total_dados = total_paginas * tamanho_pagina;
    
    % Calcula o tempo de transferência
    tempo_transferencia = tamanho_total_dados / largura_banda;
    
    % Inicializa o tempo de cópia
    tempo_copia = 0;
    
    % Calcula o tempo de cópia para inatividade e pós-cópia
    for paginas_por_rodada = [8, 24]
        tamanho_dados_rodada = paginas_por_rodada * tamanho_pagina;
        tempo_copia = tempo_copia + (tamanho_dados_rodada / largura_banda + latencia_rede / 1000); % Convertendo latência de ms para s
    end
    
    % Calcula o tempo total de migração
    tempo_total_migracao = tempo_copia + tempo_transferencia;
    
    % Calcula o tempo para suspender a VM
    tempo_suspensao = (8 * tamanho_pagina) / largura_banda; % Considerando a transferência de 8 páginas durante a inatividade da VM
    
    % Calcula o tempo para retomar a VM
    tempo_retomada = (8 * tamanho_pagina) / min(velocidade_leitura, velocidade_escrita) + latencia_rede / 1000; % Convertendo latência de ms para s
    
    % Calcula o tempo de inatividade
    tempo_inatividade = tempo_suspensao + tempo_retomada;
    
    % Adiciona o tempo de inatividade ao tempo total de migração
    tempo_total_migracao = tempo_total_migracao + tempo_inatividade;
    
    % Calcula os dados enviados
    tamanho_vm_enviada = tamanho_total_dados * (1 + (8 + 24) / total_paginas);
end

