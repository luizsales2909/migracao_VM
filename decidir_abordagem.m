% Definir o tamanho dos arrays
n = 1;

% Criar arrays aleatórios para qualidade do sinal, latência da rede, largura de banda e tamanho da VM
qualidade_do_sinal = rand(1, n);
latencia_da_rede = rand(1, n);
largura_de_banda = rand(1, n);
tamanho_da_VM = rand(1, n);

% Definir os limites para cada parâmetro
limite_qualidade_do_sinal = .5;
limite_latencia_da_rede = .5;
limite_largura_de_banda = .5;
limite_tamanho_da_VM = .5;

% Sortear valores para um usuário e decidir a abordagem a ser adotada
for i = 1:n
    abordagem = escolher_abordagem(qualidade_do_sinal(i), latencia_da_rede(i), largura_de_banda(i), tamanho_da_VM(i), limite_qualidade_do_sinal, limite_latencia_da_rede, limite_largura_de_banda, limite_tamanho_da_VM);
    disp(['A abordagem a ser adotada para o usuário ' num2str(i) ' é ' abordagem]);
end

% Função para decidir a abordagem a ser adotada
function abordagem = escolher_abordagem(qualidade_do_sinal, latencia_da_rede, largura_de_banda, tamanho_da_VM, limite_qualidade_do_sinal, limite_latencia_da_rede, limite_largura_de_banda, limite_tamanho_da_VM)
    % Inicializar contadores para abordagem estática e dinâmica
    estatica = 0;
    dinamica = 0;

    % Verificar cada parâmetro e incrementar o contador apropriado
    if qualidade_do_sinal > limite_qualidade_do_sinal
        estatica = estatica + 1;
    else
        dinamica = dinamica + 1;
    end

    if latencia_da_rede < limite_latencia_da_rede
        estatica = estatica + 1;
    else
        dinamica = dinamica + 1;
    end

    if largura_de_banda > limite_largura_de_banda
        estatica = estatica + 1;
    else
        dinamica = dinamica + 1;
    end

    if tamanho_da_VM < limite_tamanho_da_VM
        estatica = estatica + 1;
    else
        dinamica = dinamica + 1;
    end

    % Decidir a abordagem a ser adotada com base na maioria
    if estatica > dinamica
        abordagem = 'estatica';
    else
        abordagem = 'dinamica';
    end
end

