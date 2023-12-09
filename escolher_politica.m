function [politica] = escolher_politica(qualidade_do_sinal, latencia_da_rede, largura_de_banda, tamanho_da_VM)

    n = 10; % Número de cloudlets
    % Criar arrays aleatórios para qualidade do sinal, latência da rede, largura de banda e tamanho da VM
    qualidade_do_sinal = rand(1, n);
    latencia_da_rede = rand(1, n);
    largura_de_banda = rand(1, n);
    tamanho_da_VM = rand(1, n);

    % Inicialize a variável política
    politica = '';

    % Defina os pesos para os diferentes parâmetros
    peso_qualidade_do_sinal = 1;
    peso_latencia_da_rede = 1;
    peso_largura_de_banda = 1;
    peso_tamanho_da_VM = 1;

    % Normalize os parâmetros de entrada para a mesma escala
    qualidade_do_sinal = qualidade_do_sinal / max(qualidade_do_sinal);
    latencia_da_rede = latencia_da_rede / max(latencia_da_rede);
    largura_de_banda = largura_de_banda / max(largura_de_banda);
    tamanho_da_VM = tamanho_da_VM / max(tamanho_da_VM);

    % Calcule a pontuação para cada cloudlet com base nos parâmetros fornecidos
    pontuacao = peso_qualidade_do_sinal * qualidade_do_sinal - peso_latencia_da_rede * latencia_da_rede + peso_largura_de_banda * largura_de_banda - peso_tamanho_da_VM * tamanho_da_VM;

    % Calcule a média da pontuação
    media_pontuacao = mean(pontuacao);

    % Se a média da pontuação for maior que 0, use a política de pré-cópia
    if media_pontuacao > 0
        politica = 'pre-copia';
    % Caso contrário, use a política de pós-cópia
    else
        politica = 'pos-copia';
    end

    return;
end
