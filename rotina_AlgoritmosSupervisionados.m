%y=getGrupos('condjogo_disc.txt');

y=getGrupos('fisheriris.txt');
n_grupos=length(y(end,:));


cols = length(y(1).mat(end,:));
vet_acerto(n_grupos)=0;

 
 % Vai fazer um loop percorrendo todos os grupos;
for ngrp=1:n_grupos
    % O n_esimo grupo escolhido para fazer os teste com o algoritmo
    % supervisionado;
    grupo=y(ngrp).mat;
    for cols_mat=1: (length(grupo(end,:)))
        % Aqui é selecionado a coluna que será classe, inicialmente a
        % coluna 1 ate a ultima coluna da matriz;
        classe=cols_mat;
        % Funcao retorna nesta variavel as colunas que não sao classes da
        % matriz;
        vet_col_semClasse=getMatrizSemClasseX(grupo,classe);
        
        nb=fitcnb(grupo(:,vet_col_semClasse),grupo(:,classe),'DistributionNames','mvmn');
        %nb=fitcnb(grupo(:,vet_col_semClasse),grupo(:,classe),'DistributionNames','kernel');
        %islabel = resubPredict(nb);
        %mc = confusionmat(grupo(:,classe),islabel);
        
        % Taxa de erro em cima dos dados do grupo apresentados e classe
        % esclhida
        isErro = resubLoss(nb,'LossFun','ClassifErr');
        
        % Guardar em uma estrutura de dados o valor de acerto de cada
        % classe;
        % Pode ser definido um vetor, onde sua posição define o grupo, e o
        % conteúdo da célula o valor;  
        vet_acerto(ngrp,classe)=100-(isErro*100);
        
      
       
    end  
end

matrizInd = atrImportantes(vet_acerto,5);

% percorrer os grupos e recuperar os que tiveram maior porcentagem de
% acerto na matriz vet_acerto;
%for  g=1:(n_grupos)
%   maiorElem=max(vet_acerto(g,:));
%   vetor=vet_grupo(g,:);
   
    
%end
    
 
