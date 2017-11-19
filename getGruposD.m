% Funcao que recebe um arquivo txt no formato de :
% atributo0,atributo1,atributo2,...,atributoN,classe 
% Sendo que a primeira linha é o cabecalho de cada atributo, separado 
% por vírgulas;
% E retorna uma matriz a partir dos dados do arquivo txt;
% JJÁ COM A MATRIZ DISCRETIZADA
function [y] = getGruposD(arquivo)

% fisher=importdata(arquivo,',',1);
% [linhas,cols]=size(fisher.data);
% cabecalho= fisher.textdata;

fisher = arquivo;
% Separa em numero de linhas, e colunas
[linhas,cols]=size(fisher.data);

% crio abaixo um arquivo com todos os valores possíveis de classes,
% referente a coluna indicada (Coluna 5 do arquivo da base dados).
classes=unique(fisher.data(:,end));
%mat=zeros(fix(linhas/length(classes)),cols-1);
mat=zeros(1,cols-1);
celula=struct('mat',mat,'grp',0);
vet_grupos(1,length(classes)).mat=mat;
vet_grupos(1,length(classes)).grp=0;


% Percorrer a base separando todas as classes em grupos(arquivos)
% distintos;
% Aqui ele faz um loop ate o final do arquivo de classes, para pegar o
% valor de cada classe;
for c=1:size(classes)
   classe=classes(c); 
   cont_l_grp=0;   % Variável que irá contar quantas linhas cada grupo terá;
   mat=zeros(1,cols-1);
   celula=struct('mat',mat,'grp',0); % zera celula
   
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
y=vet_grupos;
end