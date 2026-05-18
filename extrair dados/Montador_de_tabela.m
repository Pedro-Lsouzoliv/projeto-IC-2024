%o codigo da uma mudada para o digit spam

diretorio= 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados digit spam\Segundo round\ascdigit';%local dos arquivos mosyn
arquivos = dir(fullfile(diretorio,'*sTime*.txt')); 

Sujeitos= {};
pessoas= {};%salva apenas a primeira parte do nome
indv= []; %assumir um valor para cada sujeito
contador= 0;
tarefa= [];
ndearestas= {};
graumedio= {};
clusterm= {};
pathlength={};
cva= {};
cvna={};

for i = 1:length(arquivos)
    caminho = fullfile(diretorio, arquivos(i).name);
    arq = arquivos(i).name;
    [~, nome, ~] = fileparts(arq);
    partes = strsplit(nome, '_');
    
    %a partir da separa��o, pega apenas o id e a tarefa e junta no nome
    if length(partes) == 6 %esse cen�rio foi um especifico do sujeito 2217
        partes_corrigidas = {partes{1},partes{4}};
        taskd= partes{4};%pega a parte da tarefa para fazer a coluna tarefa
    elseif length(partes) == 5
        partes_corrigidas = {partes{1},partes{3}};
        taskd= partes{3};
    else
        warning('Formato inesperado em: %s', nome);
        continue
    end
    nome_puro = strjoin(partes_corrigidas, '_');
    
    num_tarefa = regexp(taskd,'^(\d+)d', 'tokens');%identifica o padr�o e depois captura o numero
    num_tarefa = str2double(num_tarefa{1}{1});
    
    id= partes{1};
     if ~ismember (id,pessoas)
        contador = contador+1;
        pessoas{end+1}=id;
     end
    
    %leitura dos dados
    dados = readtable(caminho, 'Delimiter','\t');
    %colunas com os dados + calculos
    coluna1 = dados{:,1};
    coluna2 = dados{:,2};
    coluna3 = dados{:,3};
    coluna4 = dados{:,4};
    coeficiente = coluna2 / coluna1 ;
    coeficiente2 = coluna4 / coluna3 ;

    %atualiza os �ndices
    Sujeitos{end+1} = nome_puro;
    indv(end+1) = contador;
    tarefa(end+1)= num_tarefa;
    ndearestas{end+1} = coluna1;
    clusterm{end+1}= coluna3;
    cva{end+1}= coeficiente2;
    cvna{end+1}= coeficiente;
end

%preciso fazer uma limpa nesses dois ultimos depois
%Ps: Aqui n necessariamente é outro diretorio viu, rapha? É que na epoca eu n pensei em resetar o loop mudando apenas o tipo de arquivo e fiz dessa forma :/

arquivos = dir(fullfile(diretorio,'*Degree*.txt')); 
fprintf('Mudando de diretorio ');
for i=1:length(arquivos)
    caminho = fullfile(diretorio, arquivos(i).name);
    dados = readtable(caminho, 'Delimiter','\t');
    coluna2 = dados{:,2};
    media = mean(coluna2);
    graumedio{end+1} = media;
end  

arquivos = dir(fullfile(diretorio,'*PathLength*.txt')); 
fprintf('Mudando de diretorio dnv');
for i=1:length(arquivos)
    caminho = fullfile(diretorio, arquivos(i).name);
    dados = readtable(caminho, 'Delimiter','\t');
    coluna2 = dados{:,2};%!!
    media = mean(coluna2);%!!
    pathlength{end+1}=media;
end  

%tabela
tabela = table(Sujeitos',indv',tarefa',ndearestas',graumedio',clusterm',pathlength',cva',cvna','VariableNames', {'Sujeitos','indv','tarefa','arestamedia','graumedio','clusterm','pathlength','cva','cvna'});
writetable(tabela, 'Tabelastat_geral2.xlsx')

%valida��o (bora rezar)
n = length(Sujeitos);
assert(isequal(n,length(indv),length(tarefa), length(ndearestas), length(clusterm), length(cva), length(cvna), length(graumedio), length(pathlength)), ...
    'Erro: as colunas da tabela t�m tamanhos diferentes!');