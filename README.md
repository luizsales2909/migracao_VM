# migracao_VM
Algoritmo de gerenciamento de mobilidade de dispositivos e migração de serviços em computação em névoa em MATLAB
Permitir o gerenciamento de mobilidade de dispositivos e migração de serviços em computação em névoa

Mais detalhes podem ser encontrados no seguinte artigo: Sales, Luiz Carlos Silva de, "Mecanismo de Seleção de Políticas de Migração  de  Máquinas Virtuais Função de  Diferentes Demandas de Recursos."  (2023)

## Executando o algoritmo no MATLAB 2023b:

Faça o download do conjunto de funções no repositorio github: https://github.com/luizsales2909/migracao_VM;

Abra o MATLAB;

Abra o arquivo Manhattan_cenario;

Forneça as variáveis globais de configuração da rede;

Inicie a simulação;

Imprimima resultados quando a simulação terminar para relatório_acumulativo

Analise os resultados;

Faça os ajustes no algoritmo;

### Requisitos
* MATLAB


## Variáveis globais de configuração da rede de computação em névoa
Exemplo:
*largura_banda = 100; % em Mbps
*tamanho_VM = 1280; % em MB
*limite_maximo_cobertura = 500; % em metros
*V_Media = 40 * 1000 / 3600; % 40 km/h transformando para m/s
*total_paginas = 32; % Número total de páginas a serem copiadas na primeira rodada
*paginas_modificadas_por_rodada = [4, 3, 2]; % Número de páginas modificadas em cada rodada subsequente
*tamanho_pagina = 40; % em MB
*latencia_rede = 10; % em milesegundos
*velocidade_leitura = 500; % MB/s
*velocidade_escrita = 200; % MB/s
