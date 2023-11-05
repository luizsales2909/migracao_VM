function [necessidade_var, abordagem_var, estrategia_var, politica_var] = simulacao()
    %global necessidade_var abordagem_var estrategia_var politica_var;
    necessidades = ["Alta demanda de largura de banda", "Baixa demanda de largura de banda", "Conexão de rede instável", "Demanda variável de recursos", "Movimento rápido", "Necessidades imprevisíveis", "Movimento previsível", "Restrições de energia", "Manutenção de hardware", "Balanceamento de carga"];
    indice = randi([1 numel(necessidades)]);
    necessidade_var = necessidades(indice);
    necessidadesEstaticas = ["Baixa demanda de largura de banda", "Conexão de rede instável", "Movimento previsível", "Restrições de energia", "Manutenção de hardware"];
    necessidadesDinamicas = ["Alta demanda de largura de banda", "Demanda variável de recursos", "Movimento rápido", "Necessidades imprevisíveis"];
    if any(necessidade_var == necessidadesEstaticas)
        abordagem_var = 'Estática';
    elseif any(necessidade_var == necessidadesDinamicas)
        abordagem_var = 'Dinâmica';
    else
        abordagem_var = 'Estática';
    end
    if any(necessidade_var == ["Alta demanda de largura de banda", "Demanda variável de recursos", "Necessidades imprevisíveis"])
        estrategia_var = 'E1';
    elseif any(necessidade_var == ["Baixa demanda de largura de banda", "Movimento previsível"])
        estrategia_var = 'E2';
    elseif any(necessidade_var == ["Conexão de rede instável", "Movimento rápido"])
        estrategia_var = 'E3';
    else
        estrategia_var = 'E1';
    end
    if any(necessidade_var == ["Alta demanda de largura de banda", "Demanda variável de recursos", "Movimento rápido", "Necessidades imprevisíveis"])
        politica_var = 'P2';
    elseif any(necessidade_var == ["Baixa demanda de largura de banda", "Movimento previsível"])
        politica_var = 'P1';
    else
        politica_var = 'P2';
    end
    disp(['Necessidade: ', necessidade_var])
    disp(['Abordagem: ', abordagem_var])
    disp(['Estratégia: ', estrategia_var])
    disp(['Política: ', politica_var])
end

