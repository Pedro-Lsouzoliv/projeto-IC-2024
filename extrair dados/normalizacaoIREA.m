diretorio = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados digit spam\Segundo round\ascdigit';
destino = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados digit spam\Segundo round\irea normalizado';
arquivo = dir(fullfile(diretorio,'\*iREA_MoS*'));

for j = 1:length(arquivo)    
caminhoOriginal = fullfile(diretorio, arquivo(j).name);
data = readtable(caminhoOriginal,'Delimiter', '\t');

%definição dos valores minimos e máximos
coluna = 4; 
xmin = inf;
xmax = 0;

for i = 1:height(data)
    
    if data{i, coluna} > 0 && data{i, coluna} < xmin
        xmin = data{i, coluna};
    end
    if data{i, coluna} > xmax
        xmax = data{i, coluna};
    end
    
end
disp (arquivo(j).name)
disp (xmax)
disp (xmin)

% Percorrer linha por linha 
for i = 1:height(data)
    data{i, coluna} = (data{i, coluna} - xmin) / (xmax - xmin);
end
 %mudança do nome
[~, nomeBase, ext] = fileparts(arquivo(j).name);
    novoNome = [nomeBase 'm' ext]; 
    caminhoNovo = fullfile(destino, novoNome);
    writetable(data, caminhoNovo, 'Delimiter', '\t', 'WriteVariableNames', true);
    disp(['Arquivo modificado salvo como: ', novoNome]);
end