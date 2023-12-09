function estrategia = selecionar_estrategia(qualidade_do_sinal, latencia_da_rede, largura_de_banda, tamanho_da_VM)
    % Inicializar a variável estrategia
    estrategia = '';
    % Definir o tamanho dos arrays
    n = 5;
    % Criar arrays aleatórios para qualidade do sinal, latência da rede, largura de banda e tamanho da VM
    qualidade_do_sinal = rand(1, n);
    latencia_da_rede = rand(1, n);
    largura_de_banda = rand(1, n);
    tamanho_da_VM = rand(1, n);

    % Definir os pesos para os diferentes parâmetros
    peso_qualidade_do_sinal = 1;
    peso_latencia_da_rede = 1;
    peso_largura_de_banda = 1;
    peso_tamanho_da_VM = 1;
    
    % Calcule a pontuação para cada estratégia com base nos parâmetros fornecidos
    pontuacao_E1 = peso_qualidade_do_sinal * mean(qualidade_do_sinal) + peso_latencia_da_rede * (1 - mean(latencia_da_rede));
    pontuacao_E2 = peso_largura_de_banda * mean(largura_de_banda) + peso_tamanho_da_VM * (1 - mean(tamanho_da_VM));
    pontuacao_E3 = peso_qualidade_do_sinal * mean(qualidade_do_sinal) + peso_largura_de_banda * mean(largura_de_banda);
    
    % Selecione a estratégia com a maior pontuação
    [~, indice] = max([pontuacao_E1, pontuacao_E2, pontuacao_E3]);
    
    % Atribua a estratégia selecionada à variável estrategia
    if indice == 1
        estrategia = 'E1';
    elseif indice == 2
        estrategia = 'E2';
    else
        estrategia = 'E3';
    end
    
    return;
end
