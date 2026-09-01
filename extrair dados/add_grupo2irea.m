diretorio= 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados cspam sets\asccount';%local dos arquivos mosyn
arquivos = dir(fullfile(diretorio,'*iREA*.txt')); 

%Para o count spam sao 5 partes, mas no digit sao 7. pedro de 2026 discorda, mas vamos ver
%construir o tutorial para esse código plmmds. Anotação de 2026 pq eu n entendi nada
%Esse add grupo eh so por conta da mascara do codigo de garcia.


for i = 1:length(arquivos)
    caminho = fullfile(diretorio, arquivos(i).name);
    fprintf('Acessando arquivo: %s\n', arquivos(i).name);
    arq = arquivos(i).name;
    [~, nome, ext] = fileparts(arq);
    partes = strsplit(nome, '_');

    partes_unidas = {partes{1}, partes{2}, partes{3}, 'G1', partes{4}, partes{5}};
    
    nome_puro = strjoin(partes_unidas, '_');
    novo_nome = [nome_puro, ext];
    novo_caminho = fullfile(diretorio, novo_nome);
    
    movefile(caminho, novo_caminho); % renomeia o arquivo no sistema
    fprintf('Renomeado para: %s\n', novo_nome);
    
end