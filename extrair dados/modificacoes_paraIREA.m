diretorio= 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados cspam sets\asccount';%local dos arquivos mosyn
arquivos = dir(fullfile(diretorio,'*iREA*.txt')); 

for i = 1:length(arquivos)
    caminho = fullfile(diretorio, arquivos(i).name);
    fprintf('Acessando arquivo: %s\n', arquivos(i).name);
    arq = arquivos(i).name;
    [~, nome, ext] = fileparts(arq);
    partes = strsplit(nome, '_');
    
    celula_a_corrigir = partes{3};
    prefixo = celula_a_corrigir(1:2);
    numero = str2double(celula_a_corrigir(3:end));
    partes{3} = sprintf('%s_%02d', prefixo, numero);
    

    partes_unidas = {partes{1}, partes{2}, partes{3}, 'G1', partes{4}, partes{5}};
    
    
    nome_puro = strjoin(partes_unidas, '_');
    novo_nome = [nome_puro, ext];
    novo_caminho = fullfile(diretorio, novo_nome);
    
    movefile(caminho, novo_caminho); % renomeia o arquivo no sistema
    fprintf('Renomeado para: %s\n', novo_nome);
    
end