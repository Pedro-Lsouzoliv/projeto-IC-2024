%c�digo para transformar .cnt em set: � legal criar uma pasta s� para os
%dados .set antes e substitui no c�digo 
%importante deixar o eeglab aberto tbm :)


%Pasta com dados brutos (em cnt)
pastacnt = "C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados count spam";

%pasta para onde v�o os arquivos transformados
pastaSET = "C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados cspam sets";

%cria uma lista com os nomes dos arquivos
arquivos = dir(fullfile(pastacnt,'*.cnt'));
lista_de_nomes = {arquivos.name};
%---------------------------------------------------------------


for i=1 : length(arquivos)
    %pegar os nomes para for�ar nos arquivos
    nome_original= lista_de_nomes{i};
    [~, nome_sem_ext,~] = fileparts(nome_original);
    nomeforc = nome_sem_ext;
    nomeset = [nome_sem_ext,'.set'];
    
    caminhocnt =fullfile(pastacnt,nome_original);
    %--------------------------------------------
    %Agora fazer os processos normais 
    EEG= pop_loadeep_v4 (char(caminhocnt));
    EEG.setname = nomeforc;
    
    EEG = pop_select(EEG, 'nochannel', {'EOG', 'EKG'});
    EEG = pop_eegfiltnew(EEG, 'locutoff', 0.5, 'hicutoff', 45);
    
    EEG.filename = nomeset; 
    EEG.filepath = char(pastaSET); 
    
    EEG = pop_saveset(EEG, 'filename', EEG.filename, 'filepath', EEG.filepath);
    disp('>>> Arquivo salvo COM SUCESSO! <<<');
end
