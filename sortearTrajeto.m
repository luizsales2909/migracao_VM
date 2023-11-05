function [trajeto, ponto_inicial, penultimo_ponto] = sortearTrajeto()
    global trajeto ponto_inicial penultimo_ponto;
    filename_trajetos = 'C:\\Users\\luizs\\cloudsim-3.0.3\\30_caminho_mais_curto.shp';  % Caminho do arquivo .shp
    S_trajetos = shaperead(filename_trajetos);  % Leitura do arquivo .shp
    indice_trajeto = randi([1 numel(S_trajetos)]);  % Seleção aleatória de um trajeto
    trajeto_sorteado = S_trajetos(indice_trajeto);  % Atualização da variável local com o trajeto sorteado
    trajeto = [trajeto_sorteado.X; trajeto_sorteado.Y]';  % Processamento das coordenadas X e Y do trajeto
    trajeto = trajeto(1:end-1, :);  % Consideração do trajeto apenas até o penúltimo ponto
    ponto_inicial = [trajeto(1,1), trajeto(1,2)];  % Definição do ponto inicial como o primeiro ponto do trajeto
    penultimo_ponto = [trajeto(end,1), trajeto(end,2)];  % Definição do penúltimo ponto como o último ponto do trajeto
end
