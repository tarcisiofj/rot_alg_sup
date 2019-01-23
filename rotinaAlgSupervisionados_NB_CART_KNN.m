[y]=getGrupos(base);
n_grupos=length(y(end,:));

%iris_ok - naive bayes - distributionNames = mvmn

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
               
        %=================================================================
        %%% Para aplicar NaiveBayes descomentar a linha abaixo de acordo
        %%% com  a distribuição desejada, kernel ou crossval
        %nb=fitcnb(grupo(:,vet_col_semClasse),grupo(:,classe),'DistributionNames','kernel');
        
        nb=fitcnb(grupo(:,vet_col_semClasse),grupo(:,classe),'DistributionNames','kernel','CrossVal','on');
        
        isErro = kfoldLoss(nb);
        
        %=================================================================
        
        %=================================================================
        %%% Para aplicar o algoritmo para CART descomente linha referente
        % ao tipo de base de com valores continuos(regression) ou
        % discretizado (classification)
        
        % regression tree
                %nb=fitrtree(grupo(:,vet_col_semClasse),grupo(:,classe));
               % nb=fitrtree(grupo(:,vet_col_semClasse),grupo(:,classe),'Crossval','on');
        
        % classification tree
                  % TIRA AQUI COMENTARIO P CART. 
                  %nb=fitctree(grupo(:,vet_col_semClasse),grupo(:,classe),'Crossval','on');
        
        % metodo para achar a matriz de confusão    
        %islabel = resubPredict(nb);
        %mc = confusionmat(grupo(:,classe),islabel);
        
        % Taxa de erro em cima dos dados do grupo apresentados e classe
        % esclhida
        %isErro = resubLoss(nb);
        
        % TIRA AQUI O COMENTARIO TB PARA CART. 
        %isErro = kfoldLoss(nb,'LossFun','ClassifErr');
        
        %===============================================================
        
        %===============================================================
        %%% Aplicaçao com o algoritmo knn
        
          % TIRA AQUI COMENTARIO P KNN. 
          %knn=fitcknn(grupo(:,vet_col_semClasse),grupo(:,classe),'CrossVal','on','NumNeighbors',4);
          % TIRA TB AQUI COMENTARIO P KNN.   
          %isErro = kfoldLoss(knn);
                
        
        %===============================================================
       
        
        %===============================================================
        
        % Guardar em uma estrutura de dados o valor de acerto de cada
        % classe por ;
        % Pode ser definido um vetor, onde sua posição define o grupo, e o
        % conteúdo da célula o valor;  
        vet_acerto(ngrp,classe)=100-(isErro*100);
        
        
       
    end  
end
