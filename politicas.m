function [tempo_total_migracao, tempo_inatividade, tamanho_vm_enviada] = politicas(total_paginas, paginas_por_rodada, tamanho_pagina, largura_banda, latencia_rede, tempo_suspensao, tempo_retomada)
    global politica_var total_paginas velocidade_leitura velocidade_escrita paginas_modificadas_por_rodada;
    
    if politica_var == "P1"
        % Chame a função com os parâmetros desejados
        [tempo_total_migracao, tempo_inatividade, tamanho_vm_enviada] = estimativa_migracao_pre_copia(total_paginas, paginas_modificadas_por_rodada, tamanho_pagina, largura_banda, latencia_rede, velocidade_leitura, velocidade_escrita);
    elseif politica_var == "P2"
        [tempo_total_migracao, tempo_inatividade, tamanho_vm_enviada] = estimativa_migracao_pos_copia(tamanho_pagina, largura_banda, latencia_rede, velocidade_leitura, velocidade_escrita);
    else
        error('Política não reconhecida. Use "P1" para pré-cópia e "P2" para pós-cópia.');
    end
end
