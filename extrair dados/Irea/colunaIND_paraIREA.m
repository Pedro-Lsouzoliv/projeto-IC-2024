%Codigo para inserir id na tabela de individuos irea
arquivo= 'C:\Users\pokel\Desktop\Pedro\UFBA- Bi cit\Ic UFBA\dados digit spam\Segundo round\estatistica\MediasIndDigSPAM.xlsx';
tabela= readtable(arquivo);

pessoas=[];
id=[]; %coluna a ser integrada
contador= 0;
pessoas= string(pessoas);

for i=1:height(tabela)
identidade= string(tabela.Participante(i));
parte1= extractBefore(identidade,5);

if ~ismember (parte1,pessoas)
pessoas(end+1)= parte1;
contador= contador+1;
end

id(end+1) = contador;

end
id = id(:);%Garante que vai ser uma coluna (� equivalente ao que o ' faz para transpor)

tabela.id = id;
writetable (tabela, 'mediasIndDigspam_gp.xlsx');
%vou extraindo. Se n for membro � pq mudou a pessoa. Contador +1