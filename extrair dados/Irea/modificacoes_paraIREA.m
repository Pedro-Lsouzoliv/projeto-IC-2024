diretorio= 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\Dados\Sets_Amanda\arquivos_asc';%local dos arquivos mosyn
arquivos = dir(fullfile(diretorio,'*iREA*.txt')); 

%crio diretorio para os dados modificados
diretorionovo = fullfile(diretorio,'IreaNormalizados');
if ~exist(diretorionovo, 'dir')
    mkdir(diretorionovo);
    disp(['Sucesso! A pasta "', diretorionovo, '" foi criada.']);
else 
    disp(['A pasta "', diretorionovo, '" ja existe no diretorio atual.']);
end

for i = 1:length(arquivos)
    caminho = fullfile(diretorio, arquivos(i).name);
    fprintf('Acessando arquivo: %s\n', arquivos(i).name);
    data = readtable(caminho, 'Delimiter', '\t');
    %------------------------------------------------------------------------
    %Parte da Normalização
    %Definição dos valores minimos e máximos
    coluna = 4; 
    valores = data{:,coluna};
    valores_validos = valores(valores > 0);
    
    if isempty(valores_validos)
    warning('Nenhum valor positivo na coluna %d', coluna);
    continue;
    else
        xmin = min(valores_validos);
        xmax = max(valores_validos);
    end
    
    %normalizacao
    for linha = 1:height(data)
        if data{linha, coluna} > 0
            data{linha, coluna} = (data{linha, coluna} - xmin) / (xmax - xmin);
        else
            data{linha, coluna} = NaN;
        end
    end
    %----------------------------------------------------------
    %Parte de tratamento do nome do arquivo
    arq = arquivos(i).name;
    [~, nome, ext] = fileparts(arq);
    partes = strsplit(nome, '_');
    
    celula_a_corrigir = partes{3};
    prefixo = celula_a_corrigir(1:2);
    numero = str2double(celula_a_corrigir(3:end));
    partes{3} = sprintf('%s_%02d', prefixo, numero);
    
    partes_unidas = {partes{1}, partes{3}, 'G1', partes{4}, partes{5}};

    nome_puro = strjoin(partes_unidas, '_');
    novo_nome = [nome_puro, ext];
    novo_caminho = fullfile(diretorionovo, novo_nome);
    writetable (data, novo_caminho, 'Delimiter', '\t');
    fprintf('Renomeado para: %s\n', novo_nome);
end