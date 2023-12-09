largura_banda = 100;
tamanho_VM = 1280;
limite_maximo_cobertura = 500;
V_Media = 40 * 1000 / 3600;
total_paginas = 32; % Número total de páginas a serem copiadas na primeira rodada
paginas_modificadas_por_rodada = [4, 3, 2]; % Número de páginas modificadas em cada rodada subsequente
tamanho_pagina = 40; % em MB
latencia_rede = 10; % em milesegundos
velocidade_leitura = 500; % MB/s
velocidade_escrita = 200; % MB/s
global velocidade_leitura velocidade_escrita bts_conectado_Cloudlet posicao_usuario cloudlet_inicial trajeto
global necessidade_var abordagem_var estrategia_var politica_var
global cloudlet_alvo trajeto V_Media limite_maximo_cobertura
global total_paginas tamanho_pagina largura_banda latencia_rede
% Leitura do arquivo shapefile
filename = 'C:\\Users\\luizs\\Documents\\cloudsim-3.0.3\\Vias_Vetorizadas.shp';
S = shaperead(filename);

% Definição da área de interesse
poly_x = [583511, 586861, 590633,587451];
poly_y = [4511250, 4509700, 4517250, 4519250];

% Criação da grade dentro da área de interesse
d = 700;
x_lim = [min(poly_x) max(poly_x)]; 
y_lim = [min(poly_y) max(poly_y)];
n_x = ceil((x_lim(2) - x_lim(1)) / d);
n_y = ceil((y_lim(2) - y_lim(1)) / d);

% Inicialização das matrizes x e y
x = zeros(n_y, n_x);
y = zeros(n_y, n_x);

% Preenchimento das matrizes x e y com as coordenadas dos pontos da grade
for i = 1:n_y
    for j = 1:n_x
        x(i, j) = x_lim(1) + (j-1)*d;
        y(i, j) = y_lim(1) + (i-1)*d;
        if mod(i, 2) == 0
            x(i, j) = x(i, j) + d/2;
        end
    end
end

% Seleção das células que estão dentro do polígono definido por poly_x e poly_y
in_poly = inpolygon(x(:), y(:), poly_x, poly_y);
x = x(in_poly);
y = y(in_poly);

% Criação das BTSs nas posições das células selecionadas
bts_todas_array = zeros(length(x), 2);
for i = 1:length(x)
    bts_todas_array(i, :) = [x(i), y(i)];
end

% Seleção das cloudlets entre as BTSs
cloudlet_indices = round(linspace(1,length(x(:)),15));
cloudlet_x = x(cloudlet_indices);
cloudlet_y = y(cloudlet_indices);

% Associação de cada BTS à cloudlet mais próxima
D_bts_cloudlets = sqrt((x(:) - cloudlet_x(:)').^2 + (y(:) - cloudlet_y(:)').^2);
[~, sortedIndices_bts_cloudlets] = sort(D_bts_cloudlets);
bts_cloudlet_array = zeros(length(x), 3);
for i = 1:length(x)
    nearest_cloudlet = sortedIndices_bts_cloudlets(i,1);
    bts_cloudlet_array(i, :) = [x(i), y(i), nearest_cloudlet];
end

% Remoção das linhas vazias na matriz bts_cloudlet_array
bts_cloudlet_array( ~any(bts_cloudlet_array,2), : ) = [];

% Visualização do cenário em um gráfico

% Criação da matriz de adjacência para representar as conexões entre as BTSs e as cloudlets
% Visualização do cenário em um gráfico
figure('Name', 'Cenário Manhattan')
mapshow(S)
hold on
colors = hsv(length(x(:)));

% Desenho das BTSs e suas áreas de cobertura
for i = 1:length(x(:))
    plot(x(i), y(i), '^', 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', 'k');
    viscircles([x(i), y(i)], 500, 'Color', colors(i,:), 'LineWidth',0.5,'EnhanceVisibility',false);
end

% Desenho das cloudlets
for i = cloudlet_indices
    plot(x(i), y(i), '.', 'MarkerSize',20,'Color','r');
end

% Cálculo da distância euclidiana entre as cloudlets e desenho das conexões entre elas
euclideanDistMatrix = @(X,Y) sqrt(bsxfun(@plus,dot(X,X,2)',dot(Y,Y,2))-2*(X*Y'));
D = euclideanDistMatrix([cloudlet_x(:), cloudlet_y(:)], [cloudlet_x(:), cloudlet_y(:)]);
D(D==0) = inf; 
[sortedD, sortedIndices] = sort(D); 
for i=1:length(cloudlet_x)
    line([cloudlet_x(i), cloudlet_x(sortedIndices(1,i))], [cloudlet_y(i), cloudlet_y(sortedIndices(1,i))], 'Color','r','LineStyle','-');
    line([cloudlet_x(i), cloudlet_x(sortedIndices(2,i))], [cloudlet_y(i), cloudlet_y(sortedIndices(2,i))], 'Color','r','LineStyle','-');
end

% Criação da matriz de adjacência para representar as conexões entre as BTSs e as cloudlets
adj_matrix_bts = zeros(length(x));
D_bts_cloudlets = sqrt((x(:) - cloudlet_x(:)').^2 + (y(:) - cloudlet_y(:)').^2);
[sortedD_bts_cloudlets, sortedIndices_bts_cloudlets] = sort(D_bts_cloudlets, 2); 

% Índices das BTSs que não são cloudlets
non_cloudlet_indices = setdiff(1:length(x), cloudlet_indices);

% Criação do array bts_array sem as BTSs que também são cloudlets
bts_array = [non_cloudlet_indices', x(non_cloudlet_indices), y(non_cloudlet_indices)];

% Criação do array bts_conectado_Cloudlet com as coordenadas x e y para as BTSs e cloudlets
bts_conectado_Cloudlet = [(1:length(x))', x(:), y(:), sortedIndices_bts_cloudlets(:,1), cloudlet_x(sortedIndices_bts_cloudlets(:,1)), cloudlet_y(sortedIndices_bts_cloudlets(:,1))];

% Criação do array bts_cloudlet_conectado_Cloudlet com as coordenadas x e y para as BTSs que também são cloudlets
bts_cloudlet_conectado_Cloudlet = bts_conectado_Cloudlet(ismember((1:length(x))', cloudlet_indices), :);

% Criação do array cloudlet_array
cloudlet_array = [cloudlet_indices', cloudlet_x(:), cloudlet_y(:)];

% Atualização da matriz de adjacência para representar as conexões entre as BTSs e as cloudlets
for i=1:length(x)
    if ismember(i, cloudlet_indices)
        continue;
    end
    nearest_cloudlet = sortedIndices_bts_cloudlets(i,1);
    adj_matrix_bts(i, nearest_cloudlet) = 1;
    adj_matrix_bts(nearest_cloudlet, i) = 1;
    line([x(i), cloudlet_x(nearest_cloudlet)], [y(i), cloudlet_y(nearest_cloudlet)], 'Color','m','LineStyle','-');
end

% Definição dos rótulos dos eixos do gráfico
xlabel('Distância (m)')
ylabel('Distância (m)')

[necessidade_var, abordagem_var, estrategia_var, politica_var] = simulacao()
[trajeto, ponto_inicial, penultimo_ponto] = sortearTrajeto()
[VM, bts_inicial, cloudlet_inicial] = iniciarVM(bts_conectado_Cloudlet, ponto_inicial, limite_maximo_cobertura)
[contador_handoffs, contador_cloudlets, penultimo_ponto, handoff_array, cloudlet_alvo_array, vm_migration_list, posicao_usuario] = handoff_VM(bts_conectado_Cloudlet, limite_maximo_cobertura, V_Media, trajeto, necessidade_var, cloudlet_inicial, estrategia_var, abordagem_var, politica_var)
[cloudlet_alvo] = estrategias(necessidade_var, abordagem_var, estrategia_var, politica_var, bts_conectado_Cloudlet, posicao_usuario)