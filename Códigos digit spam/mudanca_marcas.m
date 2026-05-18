folderpath = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\Base de dados digitspam\Sets'; %colocar o nome da pasta com os sets
cd(folderpath);
caminhof = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados digit spam\Segundo round\Sets';
ListaArquivos = dir(fullfile(folderpath, '*.set'));


for j=1:length(ListaArquivos)
    nomeoriginal = ListaArquivos(j).name;
    EEG = pop_loadset('filename', nomeoriginal, 'filepath', folderpath); % Carregar os dados do EEG que possuem os eventos
    [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0);
    
    % Definir o intervalo de tempo máximo entre eventos já no eeglab
   intervalo_maximo = 2; % em segundos
   intervalo_maximo = intervalo_maximo * EEG.srate; % converter para pontos de amostragem
   

  for i = 1:length(EEG.event) -6
    fprintf('Processando evento %d de %d\n', i, length(EEG.event)-6 );% Encontrar eventos marcados como "1" e verificar o tempo entre eles
    % Verificar se há uma sequência de eventos "1"
    if strcmp(EEG.event(i).type, '1') && strcmp(EEG.event(i+1).type, '1') && strcmp(EEG.event(i+2).type, '1')
        
        % Calcular os intervalos entre os eventos consecutivos
        intervalo_1_2 = EEG.event(i+1).latency - EEG.event(i).latency;
        intervalo_2_3 = EEG.event(i+2).latency - EEG.event(i+1).latency;
        intervalo_3_4 = EEG.event(i+3).latency - EEG.event(i+2).latency;
        intervalo_4_5 = EEG.event(i+4).latency - EEG.event(i+3).latency;
        intervalo_5_6 = EEG.event(i+5).latency - EEG.event(i+4).latency;
        intervalo_6_7 = EEG.event(i+6).latency - EEG.event(i+5).latency;

        % Condição para renomear o primeiro evento como "7d"
         if intervalo_1_2 <= intervalo_maximo && intervalo_2_3 <= intervalo_maximo && intervalo_3_4 <= intervalo_maximo && intervalo_4_5 <= intervalo_maximo && intervalo_5_6 <= intervalo_maximo && intervalo_6_7 <= intervalo_maximo
            EEG.event(i).type = '7d';
            EEG.event(i+1).type = 'd';
            EEG.event(i+2).type = 'd';
            EEG.event(i+3).type = 'd';
            EEG.event(i+4).type = 'd';
            EEG.event(i+5).type = 'd';
            EEG.event(i+6).type = 'd';
        end

        % Condição para renomear o primeiro evento como "5d"
        if intervalo_1_2 <= intervalo_maximo && intervalo_2_3 <= intervalo_maximo && intervalo_3_4 <= intervalo_maximo && intervalo_4_5 <= intervalo_maximo &&  intervalo_5_6 >= intervalo_maximo  
            EEG.event(i).type = '5d';
            EEG.event(i+1).type = 'd';
            EEG.event(i+2).type = 'd';
            EEG.event(i+3).type = 'd';
            EEG.event(i+4).type = 'd';
        end

        % Condição para renomear o primeiro evento como "3d"
        if intervalo_1_2 <= intervalo_maximo && intervalo_2_3 <= intervalo_maximo && intervalo_3_4 >= intervalo_maximo
            EEG.event(i).type = '3d';
            EEG.event(i+1).type = 'd';
            EEG.event(i+2).type = 'd';
        end
    end 

  end
  %para n desconsiderar a ultima serie de 5d
  if  strcmp(EEG.event(i+2).type, '1')
            EEG.event(i+2).type = '5d';
            EEG.event(i+3).type = 'd';
            EEG.event(i+4).type = 'd';
            EEG.event(i+5).type = 'd';
            EEG.event(i+6).type = 'd';
  end

  EEG = eeg_checkset(EEG, 'eventconsistency'); %verifica se existe alguma inconsistencia nos dados antes de salvar
  [~, name, ext] = fileparts(nomeoriginal);
    novoNome = sprintf('%s_%d%s', name, j, ext); % Cria o novo nome sequencial(era só pra diferenciar) 
    EEG.setname = novoNome; 
    pop_saveset(EEG, 'filename', novoNome, 'filepath', caminhof); % Salva o arquivo .set modificado
end 
