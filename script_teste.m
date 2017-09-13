

% Importa o banco de dados, adicionando em um matriz
fisher=importdata('Fisher.txt',',',1);
[linhas,cols]=size(fisher.data);

% crio abaixo um arquivo com todos os valores possíveis de classes,
% referente a coluna indicada (Coluna 5 do arquivo da base dados).
classes=unique(fisher.data(:,5));

mat=zeros(linhas/length(classes),cols-1);
celula=struct('mat',mat,'grp',0);
vet_grupos(1,length(classes)).mat=mat;
vet_grupos(1,length(classes)).grp=0;

% Percorrer a base separando todas as classes em grupos(arquivos)
% distintos;
% Aqui ele faz um loop ate o final do arquivo de classes, para pegar o
% valor de cada classe;
for c=1:size(classes)
   classe=classes(c); 
   % Variável que irá contar quantas linhas cada grupo terá;
    cont_l_grp=0;  
   % Em posse do valor da classe, ele percorre a base e compara o valor da
   % coluna que possui classe com o valor da classe do momento;
   for ind_linhas=1:size(fisher.data)
       % A coluna de classe tem que está na última coluna do arquivo de
       % base de dados (end=='últimaColuna');
      if fisher.data(ind_linhas,end) == classe
          cont_l_grp=cont_l_grp+1;
          celula.mat(cont_l_grp,:)=fisher.data(ind_linhas,1:end-1);
          
      end     
   end
    % monta-se a variavel celula com o tipo de grupo do momento;
    celula.grp=classe;
    vet_grupos(1,c)=celula;         
end
