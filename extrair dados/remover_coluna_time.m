%mesma coisa do remover coluna, mas criando arquivos novos
%rapaz, esse aqui ta top
path = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados cspam sets\asccount';%pasta de destino dos arquivos novos
lista = dir(fullfile(path, '*.asc'));

for i = 1:length(lista)
    arquivo_atual = fullfile(path, lista(i).name);
    
    % Lê como tabela
    T = readtable(arquivo_atual, 'FileType', 'text', 'Delimiter', '\t');

    % Remove a primeira coluna
    T(:,1) = [];

    % Escreve de volta
    writetable(T, arquivo_atual, 'Delimiter', '\t', 'FileType', 'text', 'WriteVariableNames', true);

    disp(['Arquivo atualizado: ', lista(i).name]);
end
