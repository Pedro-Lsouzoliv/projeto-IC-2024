%Aplicar e fazer as modifica��es se precisar reconhecer o G1 e mais
%o Pedro de 2026 supoe que esse codigo eh necessario para a mascara de garcia reconhecer o arquivos
diretorio = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados digit spam\Segundo round\irea normalizado';
arquivos = dir(fullfile(diretorio, '*.txt')); 

for i = 1:length(arquivos)
    caminho = fullfile(diretorio, arquivos(i).name);
    fprintf('Acessando arquivo: %s\n', arquivos(i).name);
    
    [~, nome, ext] = fileparts(arquivos(i).name);

    % Express�o regular para encontrar algo como 3d2, 4d13 etc.
    padrao = '(?<prefixo>\d+d)(?<numero>\d+)';

    token = regexp(nome, padrao, 'names');

    if isempty(token)
        warning('Formato n�o reconhecido em: %s', nome);
        continue;
    end

    % Ajusta o n�mero com zero � esquerda se necess�rio
    if length(token.numero) == 1
        numero_corrigido = ['0', token.numero];
    else
        numero_corrigido = token.numero;
    end

    novo_nome_base = regexprep(nome, padrao, [token.prefixo '_' numero_corrigido]);
    novo_nome_completo = [novo_nome_base, ext];
    novo_caminho = fullfile(diretorio, novo_nome_completo);
    
    movefile(caminho, novo_caminho);
    fprintf('Renomeado para: %s\n', novo_nome_completo);
end
