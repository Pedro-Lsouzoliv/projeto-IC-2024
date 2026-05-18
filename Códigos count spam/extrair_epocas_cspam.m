%Código para extrair épocas do count spam
%fase de teste para ver erro no final
pasta = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados cspam sets';
ListaArquivos = dir(fullfile(pasta,'*.set'));
caminhoasc = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados cspam sets\asccount';
pasta = char(pasta);
caminhoasc = char(caminhoasc);

seq1 = [4, 5, 5, 5, 4, 4, 3, 5, 5, 3, 4, 5, 4, 5, 5, 3, 4, 4, 3, 5, 4, 3, 5, 3, 4, 3, 5, 5, 5, 5, 4, 3, 3, 5, 4, 3, 4, 4, 5, 3, 3];
seq2 = [3, 3, 4, 4, 5, 5, 5, 5, 5, 5, 4, 5, 4, 4, 5, 3, 3, 4, 3, 4, 3, 5, 4, 5, 5, 4, 5, 3, 5, 3, 3, 3, 4, 4, 5, 4, 5, 3, 4, 3, 5];

corte_i= 6; %cortes das epocas começa em 6 para remover baseline
corte_f3= 19.5; 
corte_f4= 25.5; 
corte_f5= 31.5; %adicionei 1.5 s para ter uma margem de proteção contra transição de telas


%% Aqui começa de verdade
for j=1: length(ListaArquivos)
    
 seqU = []; %Sequencia utilizada
 s = 1; %contador da sequencia 
 
contador3 = 0; %contadores que definem a enumeração dos nomes dos arquivos
contador4 = 0;
contador5 = 0;
rejeitados= 0; %contador de épocas rejeitadas por pessoa

 %entra identificador de sequencia 
 nomeoriginal = char(ListaArquivos(j).name);
 segundo_digito = regexp(nomeoriginal, '^\d(\d)', 'tokens');
 if ~isempty(segundo_digito)
  segundo_digito = segundo_digito{1}{1};
  if ismember(segundo_digito,{'1', '4', '5', '6'})
   seqU = seq1;
  else
  seqU = seq2;
  end
 end
 
%função de criar tabela no excel
tabela = table([],[],[],'variablenames',{'n_de_telas','tempo_total','status'});

 %agora a parte do eeg
 EEG = pop_loadset('filename', nomeoriginal, 'filepath', pasta);
 [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0); 
 EEG1= pop_eegfiltnew (EEG,'locutoff',8, 'hicutoff',12.99);%filtro em alpha
 
for i=1 : length (EEG1.event)
%entram as funções principais do script
    if ~strcmp(EEG1.event(i).type, '1') %elimina evento que seja diferente de '1'
        continue;
    end
    
 if i+1 > length(EEG1.event)
    intervalo_break = (EEG1.pnts - EEG1.event(i).latency) / EEG1.srate; 
else
    intervalo_break = (EEG1.event(i+1).latency - EEG1.event(i).latency) / EEG1.srate;
end

 if intervalo_break <= 9 %o tempo da ultima piscada ate o teste é de 8seg, mas coloquei uma margem de erro
    continue;
 end

lat = EEG1.event(i).latency;

EEG_temp = EEG1;
EEG_temp.event = struct('type', '1', 'latency', lat);
EEG_temp = eeg_checkset(EEG_temp, 'eventconsistency');

    switch seqU(s) 
        
        case 3
         epoca3 = pop_epoch(EEG_temp, {'1'}, [corte_i , corte_f3], 'epochinfo', 'yes');
         try
             epoca3= pop_eegthresh(epoca3, 1, [1:epoca3.nbchan], -50, 50, 0, 19.5, 0, 1); %!!!
             contador3 = contador3 + 1;

              if epoca3.trials ~= 0 
               status = 0; %tudo ok 
               novo_nome_asc = sprintf('%s_3d%d.asc', nomeoriginal(1:end-4), contador3);
               pop_export(epoca3, fullfile(caminhoasc, novo_nome_asc), 'transpose', 'on');
              else
               status = 1; %epoca deletada   
               rejeitados = rejeitados +1;
              end
         catch
             status = 1;  
             rejeitados = rejeitados +1;
         end
         
        case 4
         epoca4 = pop_epoch(EEG_temp, {'1'}, [corte_i , corte_f4], 'epochinfo', 'yes');
           try
             epoca4= pop_eegthresh(epoca4, 1, [1:epoca4.nbchan], -50, 50, 0, 25.5, 0, 1); 
             contador4 = contador4 + 1;

              if epoca4.trials ~= 0
              status = 0;    
              novo_nome_asc = sprintf('%s_4d%d.asc', nomeoriginal(1:end-4), contador4);
              pop_export(epoca4, fullfile(caminhoasc, novo_nome_asc), 'transpose', 'on');
              else
               status = 1;  
               rejeitados = rejeitados +1;
              end
           catch
               status = 1;  
               rejeitados = rejeitados +1;
           end

        case 5
         epoca5 = pop_epoch(EEG_temp, {'1'}, [corte_i , corte_f5], 'epochinfo', 'yes');
           try
             epoca5= pop_eegthresh(epoca5, 1, [1:epoca5.nbchan], -50, 50, 0, 31.5, 0, 1); 
             contador5 = contador5 + 1;

               if epoca5.trials ~= 0
               status = 0;    
               novo_nome_asc = sprintf('%s_5d%d.asc', nomeoriginal(1:end-4), contador5);
               pop_export(epoca5, fullfile(caminhoasc, novo_nome_asc), 'transpose', 'on');
               else
                status = 1;  
                rejeitados = rejeitados +1;
               end
           catch
               status = 1;  
               rejeitados = rejeitados +1;
           end

    end   
    linha= {seqU(s), intervalo_break, status};
    tabela(end+1,:)= cell2table(linha, 'VariableNames', tabela.Properties.VariableNames);
    s = s+1;
end  
%construção da tabela
caminhotab = 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados cspam sets\tabelas dos sujeitos';

  nometabela = [nomeoriginal(1:end-4),'.xlsx'];
  writetable(tabela,fullfile(caminhotab,nometabela));
  disp ([nometabela, '- tabela criada com sucesso, vamo q vamo!!']);
  disp (['o total de epocas rejeitadas foi:',num2str(rejeitados)]);
end   