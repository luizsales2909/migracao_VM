function [contador_handoffs, contador_cloudlets, penultimo_ponto, handoff_array, cloudlet_alvo_array, vm_migration_list, posicao_usuario] = handoff_VM(bts_conectado_Cloudlet, limite_maximo_cobertura, V_Media, trajeto, necessidade_var, cloudlet_inicial, estrategia_var, abordagem_var, politica_var)
    global posicao_usuario bts_conectado_Cloudlet limite_maximo_cobertura V_Media trajeto necessidade_var cloudlet_inicial estrategia_var abordagem_var politica_var
    global total_paginas paginas_por_rodada tamanho_pagina largura_banda latencia_rede tempo_suspensao tempo_retomada
    handoff_array = [];
    cloudlet_alvo_array = [];  
    vm_migration_list = [];  
    vm_migration_positions = [];  
    posicao_usuario = [trajeto(1,1), trajeto(1,2)];
    distancias = sqrt((bts_conectado_Cloudlet(:,2) - posicao_usuario(1)).^2 + (bts_conectado_Cloudlet(:,3) - posicao_usuario(2)).^2);
    [~, indice] = min(distancias);
    BTS_atual = bts_conectado_Cloudlet(indice, 2:3);  
    contador_handoffs = 0;
    contador_cloudlets = 0;  
    bts_handoff = [];
    
    % Inicializa as variáveis de rastreamento
    tempo_total_migracao_somatorio = 0;
    tempo_inatividade_somatorio = 0;
    tamanho_vm_enviada_somatorio = 0;
    
    hold on;  
    for i=2:size(trajeto, 1)
        distancia=norm(trajeto(i,:)-posicao_usuario);
        tempo=distancia/V_Media;
        t=linspace(0,1,ceil(tempo));
        pontos_intermediarios=(1-t')*posicao_usuario+t'*trajeto(i,:);
        for j=1:size(pontos_intermediarios,1)
            posicao_usuario=pontos_intermediarios(j,:);
            distancia_BTS_atual=norm(BTS_atual-posicao_usuario);
            if distancia_BTS_atual>=0.75*limite_maximo_cobertura
                distancias=sqrt((bts_conectado_Cloudlet(:,2)-posicao_usuario(1)).^2+(bts_conectado_Cloudlet(:,3)-posicao_usuario(2)).^2);
                [~, indice]=min(distancias);
                if ~isequal(BTS_atual, bts_conectado_Cloudlet(indice,2:3))
                    BTS_atual=bts_conectado_Cloudlet(indice,2:3);
                    contador_handoffs=contador_handoffs+1;
                    bts_handoff=[bts_handoff; BTS_atual];
                    handoff_array=[handoff_array; BTS_atual];
                    disp(['Handoff realizado para a BTS ', num2str(BTS_atual)]);  
                    
                    if ~isequal(cloudlet_inicial.Indice, bts_conectado_Cloudlet(indice,4))
                        [cloudlet_alvo] = estrategias(necessidade_var, abordagem_var, estrategia_var, politica_var, bts_conectado_Cloudlet, posicao_usuario)
                        
                        contador_cloudlets = contador_cloudlets + 1;
                        cloudlet_alvo_array = [cloudlet_alvo_array; cloudlet_alvo];
                        vm_migration_list = [vm_migration_list; cloudlet_alvo];
                        vm_migration_positions = [vm_migration_positions; cloudlet_alvo.X, cloudlet_alvo.Y];  
                        
                        disp(['Migração de VM realizada para a Cloudlet ', num2str(cloudlet_alvo.Indice)]);
                        
                        % Chama a função politicas
                        %[tempo_total_migracao, tempo_inatividade, tamanho_vm_enviada] = politicas(total_paginas, paginas_por_rodada, tamanho_pagina, largura_banda, latencia_rede, tempo_suspensao, tempo_retomada);
                        [tempo_total_migracao, tempo_inatividade, tamanho_vm_enviada] = politicas(total_paginas, paginas_por_rodada, tamanho_pagina, largura_banda, latencia_rede, tempo_suspensao, tempo_retomada);
                        % Atualiza as variáveis de rastreamento
                        tempo_total_migracao_somatorio = tempo_total_migracao_somatorio + tempo_total_migracao;
                        tempo_inatividade_somatorio = tempo_inatividade_somatorio + tempo_inatividade;
                        tamanho_vm_enviada_somatorio = tamanho_vm_enviada_somatorio + tamanho_vm_enviada;
                        
                        cloudlet_inicial = cloudlet_alvo;
                    end
                end
            end
            plot(posicao_usuario(1), posicao_usuario(2), 'ro');
            drawnow;
        end
    end
    theta=0:0.01:2*pi; 
    for k=1:size(bts_handoff,1)
        X=bts_handoff(k,1)+limite_maximo_cobertura*cos(theta);
        Y=bts_handoff(k,2)+limite_maximo_cobertura*sin(theta);
        h=fill(X,Y,'y');  
        set(h,'facealpha',.3);  
    end
    for k=1:size(vm_migration_positions,1)
        X=vm_migration_positions(k,1)+limite_maximo_cobertura*cos(theta);
        Y=vm_migration_positions(k,2)+limite_maximo_cobertura*sin(theta);
        h=fill(X,Y,'g'); 
        set(h,'facealpha',.3);  
    end
    penultimo_ponto = [trajeto(end-1, 1), trajeto(end-1, 2)];
    
    % Verifica se o arquivo já existe
    if ~isfile('relatorio_acumulativo.txt')
        % Abre o arquivo para escrita
        fileID = fopen('relatorio_acumulativo.txt','w');
        
        % Escreve o cabeçalho do relatório
        fprintf(fileID, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'necessidade_var', 'abordagem_var', 'estrategia_var', 'politica_var', 'Total de Handoffs Realizados', 'Total de Migrações de VM Realizadas', 'Soma do Tempo Total de Migração', 'Soma do Tempo de Inatividade', 'Soma do Tamanho das VMs Migradas');
        
        % Fecha o arquivo
        fclose(fileID);
    end
    
    % Abre o arquivo para anexação
    fileID = fopen('relatorio_acumulativo.txt','a');
    
    % Escreve as informações da simulação atual no relatório
    fprintf(fileID, '%s\t%s\t%s\t%s\t%d\t%d\t%.2f\t%.2f\t%.2f\n', necessidade_var, abordagem_var, estrategia_var, politica_var, contador_handoffs, contador_cloudlets, tempo_total_migracao_somatorio, tempo_inatividade_somatorio, tamanho_vm_enviada_somatorio);

    % Fecha o arquivo
    fclose(fileID);
    
    disp('Lista de Handoffs realizados');
end