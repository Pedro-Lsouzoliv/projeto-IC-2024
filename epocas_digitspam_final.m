%codigo mais atualizado do digit
%gera tabela por individuo para saber quantidade de epocas excluidas
%crie uma pasta para as tabelas e substitua o caminho na linha 112
arquivoset = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados digit spam\Segundo round\Sets';
cd(arquivoset);
diretorioasc = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados digit spam\Segundo round\asc test';
lista_arquivos = dir(fullfile(arquivoset, '*.set'));

% Métricas dos cortes
corte_i = 0;
corte_f_3d = 3.0;
corte_f_5d = 5.0;
corte_f_7d = 7.0;

rejeitados= 0;

for i = 1:length(lista_arquivos)
    nomeDoset = lista_arquivos(i).name;
    EEG = pop_loadset('filename', nomeDoset, 'filepath', arquivoset);
    [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0);

    % Filtra as ondas em alpha
    EEG1 = pop_eegfiltnew(EEG, 'locutoff', 8, 'hicutoff', 12.99);

    contador3 = 0;
    contador5 = 0;
    contador7 = 0;
    
    
%função de criar tabela no excel
tabela = table(string([]),[],'variablenames',{'n_de_telas','status'});
 
    for j = 1:length(EEG1.event)
        % Tipo do evento atual
       tipo = string(EEG1.event(j).type);
        if tipo ~= "3d" && tipo ~= "5d" && tipo ~= "7d"
           continue; % evita conflito com a tabela e economiza tempo
        end
        
        eventotipo = EEG1.event(j).type;
        if ~ischar(eventotipo)
            eventotipo = char(string(eventotipo));
        end

        % Latência do evento
        lat = EEG1.event(j).latency;

        % Cria EEG temporário só com esse evento
        EEG_temp = EEG1;
        EEG_temp.event = struct('type', eventotipo, 'latency', lat);
        EEG_temp = eeg_checkset(EEG_temp, 'eventconsistency');

        switch eventotipo
            case '3d'
                epoca3 = pop_epoch(EEG_temp, {'3d'}, [corte_i, corte_f_3d], 'epochinfo', 'yes');
                try
                    epoca3 = pop_eegthresh(epoca3, 1, [1:epoca3.nbchan], -50, 50, 0, 3.0, 0, 1);
                    if epoca3.trials ~= 0
                        status = 0; %epoca recortada com sucesso
                        contador3 = contador3 + 1;
                        novo_nome_asc = sprintf('%s_3d%d.asc', nomeDoset(1:end-4), contador3);
                        pop_export(epoca3, fullfile(diretorioasc, novo_nome_asc), 'time', 'off', 'transpose', 'on');
                    else
                        status = 1; %epoca deletada   
                        rejeitados = rejeitados +1;
                    end
                catch
                    status= 1; %eeg vazio 
                    rejeitados = rejeitados +1;
                end

            case '5d'
                epoca5 = pop_epoch(EEG_temp, {'5d'}, [corte_i, corte_f_5d], 'epochinfo', 'yes');
                try
                    epoca5 = pop_eegthresh(epoca5, 1, [1:epoca5.nbchan], -50, 50, 0, 5.0, 0, 1);
                    if epoca5.trials ~= 0
                        status = 0;
                        contador5 = contador5 + 1;
                        novo_nome_asc = sprintf('%s_5d%d.asc', nomeDoset(1:end-4), contador5);
                        pop_export(epoca5, fullfile(diretorioasc, novo_nome_asc), 'time', 'off', 'transpose', 'on');
                    
                    else
                        status = 1; %epoca deletada   
                        rejeitados = rejeitados +1;
                    end
                catch
                    status= 1; %eeg vazio
                    rejeitados= rejeitados +1;
                end

            case '7d'
                epoca7 = pop_epoch(EEG_temp, {'7d'}, [corte_i, corte_f_7d], 'epochinfo', 'yes');
                try
                    epoca7 = pop_eegthresh(epoca7, 1, [1:epoca7.nbchan], -50, 50, 0, 7.0, 0, 1);
                    if epoca7.trials ~= 0
                        status = 0;
                        contador7 = contador7 + 1;
                        novo_nome_asc = sprintf('%s_7d%d.asc', nomeDoset(1:end-4), contador7);
                        pop_export(epoca7, fullfile(diretorioasc, novo_nome_asc), 'time', 'off', 'transpose', 'on');
                    else
                        status = 1; %epoca deletada   
                        rejeitados = rejeitados +1;
                    end
                catch
                    status= 1; %epoca deletada
                    rejeitados= rejeitados +1;
                end
        end
    linha= {eventotipo,status};
    tabela(end+1,:)= cell2table(linha, 'VariableNames', tabela.Properties.VariableNames);
    end
  %crie uma pasta num local q vc queira e depois substitui o caminho 
  caminhotab = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados digit spam\Segundo round\tabelas individuais';

  nometabela = [nomeDoset(1:end-4),'.xlsx'];
  writetable(tabela,fullfile(caminhotab,nometabela));
  disp ([nometabela, '- tabela criada com sucesso, vamo q vamo!!']);
end
 disp (['o total de epocas rejeitadas foi:',num2str(rejeitados)]);