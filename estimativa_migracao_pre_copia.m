function [tempo_total_migracao, tempo_inatividade, tamanho_vm_enviada] = estimativa_migracao_pre_copia(total_paginas, paginas_modificadas_por_rodada, tamanho_pagina, largura_banda, latencia_rede, velocidade_leitura, velocidade_escrita)
    % Converte a largura de banda de Mbps para MB/s
    largura_banda = largura_banda / 8;
    
    % Calcula o tamanho total dos dados
    tamanho_total_dados = total_paginas * tamanho_pagina;
    
    % Calcula o tempo de transferência
    tempo_transferencia = tamanho_total_dados / largura_banda;
    
    % Calcula o tempo de cópia para cada rodada
    tamanho_dados_rodada = sum(paginas_modificadas_por_rodada) * tamanho_pagina;
    tempo_copia = tamanho_dados_rodada / largura_banda + latencia_rede / 1000 * length(paginas_modificadas_por_rodada);
    
    % Calcula o tempo de suspensão e retomada com base nas velocidades de leitura e escrita do disco
    tempo_suspensao = (tamanho_total_dados + tamanho_dados_rodada) / velocidade_leitura;
    tempo_retomada = (tamanho_total_dados + tamanho_dados_rodada) / velocidade_escrita;
    
    % Calcula o tempo total de migração e inatividade
    tempo_total_migracao = tempo_copia + tempo_transferencia + tempo_suspensao + tempo_retomada;
    tempo_inatividade = tempo_suspensao + tempo_retomada;
    
    % Calcula os dados enviados
    tamanho_vm_enviada = tamanho_total_dados + tamanho_dados_rodada;
end
