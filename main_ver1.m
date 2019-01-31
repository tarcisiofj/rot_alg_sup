% ====================  =============  ====================================
%
% Área de definição de variáveis
%
%
numfaixa=3;         % quantidade de faixas dos valores a serem discretizado,
                    %  maior q 1;
V=0 ;                   % porcentagem de abrangencia dos valore do rótulo, 
                    %  ex. -10 e +10
l=0;                % num linhas da tabela;
tabela=cell(0,5);   % tabela que armazena: cluster,atributo,
                    %  valor_faixa_min,valor_faix_max,qtd_vezes_atr_NaFaixa
%
%%%                    


% Importa o base de dados (dos 3 parâmetros o 1o. é a base, o 2o. é o
% delimitador dos campos e 3o. é a linha de cabeçalho qeu existe)
base=importdata('seedsL.txt',',',1);

% Pega a primeira linha da base de dados
cab= base.textdata;

% Rotina de geração de melhor faixa %

% Inicia a discretização. Ao final do loop uma variavel matrizCompleta irá
% guardar em da linha uma estrutura seguida de matriz discretizada e
% delimitações das faixas, onde cada linha corresponderá a linha da tabela
% descritora gerada pela função geraMatrizArranjo.


% Será criado a partir da funcao geraMatrizArranjo uma tabela que servira
% de roteiro(descritor), onde cada linha determinara qual a quantidade de
% faixas que será feita a divisao dos dados em cada coluna. 
% ex. [ 2 3 2 ] usando essa matriz como descritora será feita a 
% discretização da 1a.col com 2 faixas, a 2a. col com 3 faixas e a 3a. col 
% com 2 faixas.
% ex. da funcao em funcionamento abaixo:
% m=geraMatrizArranjo(size(base.data,2)-1,[2 3 4 5 6 7 8 9 10]);
% A matriCompleta vai tera combinação de todas as tabelas referente a
% tabela descritora.
 m=geraMatrizArranjo(size(base.data,2)-1,[3]);
 md=flip(m,2); % espelha a matriz m;
 parada=2000;
 %md = [4 4 4 4 4 10 4 10 10];
 for loop =1: size(md,1)
     for cols=1: size(md,2)
        [mat_disc,faix] = discretizar(base.data(:,cols),'EFD',md(loop,cols));
        tabelaAux.matriz(:,cols)=mat_disc(:,1);
        tabelaAux.faixas(cols)=faix;
        clear mat_disc;
        [mat_disc,faix] = discretizar(base.data(:,cols),'EWD',md(loop,cols));
        tabelaAux2.matriz(:,cols)=mat_disc(:,1);
        tabelaAux2.faixas(cols)=faix;
        clear mat_disc;

     end     
     matrizCompleta{loop,1}=tabelaAux; % linha 1
     matrizCompleta{loop,2}=tabelaAux2;
          
     if(loop==parada) 
       disp('linhas matriz completa ');
       disp(loop);
       parada=parada+loop;
     end
     
 end
 
 %% Rotina de execução e impressão

           %based.data = [mat_disc base.data(:,end)];
           rotinaAlgSupervisionados_NB_CART_KNN;
           matriz_atr_imp = atrImportantes(vet_acerto,V);
           contReg=0;
           
 for metodoDisc=1:2
        metodoDiscretizacao=metodoDisc; %EFD =1, EWD=2
        if metodoDiscretizacao==1
            fprintf('\n\n======= RESULTADO  EFD ==========');
        else
             fprintf('\n\n======= RESULTADO  EWD ==========');
        end
           linhaTabDescritora=1; % Se o vetor iniciar com 3 a primeira linha vai ser R=3 para todos os atributos. 
           
           
           clear('based','qtdElemFaix','eleFaixMatDisc','tabela');
                     
           mat_disc = matrizCompleta{linhaTabDescritora,metodoDiscretizacao}.matriz;
           based.data = [mat_disc base.data(:,end)];
           [y_disc]=getGrupos(based);
           
          % fprintf('\n\n======= RESULTADO COM FAIXAS 3 - EFD ==========');
           % ============================================
           % IMPRESSAO DOS GRUPOS E ATRIBUTOS RELEVANTES
           % ============================================
           %
           fprintf('\n\n======= Atributos Relevantes ==========');
           for grp=1:length(matriz_atr_imp(:,1))
               %disp(['Grupo ',num2str(grp),':']);
               fprintf('\nGrupo  %d: ',grp);
               for col = 1 : size((matriz_atr_imp(grp,:)),2)
                   atr = matriz_atr_imp(grp,col);
                   if atr ~= 0
                       %disp([' ',cell2mat(cab(atr))]);
                       fprintf(' %s  ',cell2mat(cab(atr)));
                   end
               end
           end
           fprintf('\n======= ================== ===========');
           
           % ========================================================================
           %
           % Percorre por cada cluster e discretiza cada grupo gerando uma matriz
           % discretizada toda vez q mudar o grp(cluster).
           %

           n=0; l=0;
           for grp=1:length(matriz_atr_imp(:,1))
               
               
               
               matriz_grupo = y_disc(grp).mat; % variável que recebe o grupo identificado
               % por grp (grupo 1, grupo 2, etc)
               
               % Percorrer toda matriz discretizada do grupo n-1 (na variavel "y" os
               % grupos começam do ZERO ao UM) e verifica a faixa que mais se
               % repete por atributo;
                c=0; % contador do registro eleFaixMatDisc;
               for frc=1:size(matriz_grupo,2) % percorrer todas as colunas da matriz
                   n=n+1;
                   c=c+1;
                   % Funcao recebe uma coluna e retorna a quantidade de elementos
                   % de cada faixa em um vetor.
                   % md é a tabela descritora que irá dizer qual é o número de faixas
                   qtdElemFaix{grp,frc} = numElements(matriz_grupo(:,frc),md(linhaTabDescritora,frc));
                   [elem,ind]=max(qtdElemFaix{grp,frc});
                   eleFaixMatDisc(n).grp=grp;
                   eleFaixMatDisc(n).atr=frc;
                   eleFaixMatDisc(n).qtdRep=elem;
                   eleFaixMatDisc(n).faixa=ind;
                   %eleFaixMatDisc(n).faixaA0=;
                   
                   
               end
               %===== =================================================================
               
               % percorre as colunas da matriz de atributos importantes, onde cada
               % linha(grp) corresponde a um cluster incrementado acima;
               for col=1:length(matriz_atr_imp(grp,:))
                   atr = matriz_atr_imp(grp,col);
                   if atr~=0 % Só vai entrar no if, enquanto existir atributo para ser
                       % lido na linha da matriz_atr_imp. Quando for ZERO é
                       % porque não existe mais atributo(rotulo) a ser lido.
                       l=l+1;
                       tabela{l,1}=grp;
                       tabela{l,2}=cab(atr);
                       
                       % A mair quantidade de elementos do vetor discretizado é
                       % utilizado para dizer a importância da faixa.
                       % Ex.: [1 1 1 2 2 2 2 2 3 3 3 ]
                       % o número que mais se repete é o 2, então a faixa 2 é a mais
                       % importante do atributo escolhido. Então agora é só definir
                       % qual o intervalo da faixa 2 do atributo selecionado em 'atr'.
                       
                       for indice=1: length(eleFaixMatDisc)
                           if eleFaixMatDisc(indice).atr==atr && eleFaixMatDisc(indice).grp==grp
                               ind=eleFaixMatDisc(indice).faixa;           % n. da faixa que o rotulo tem maior frequencia
                               faix = matrizCompleta{linhaTabDescritora,metodoDiscretizacao}.faixas(atr).a0; % limites das faixas
                               tabela{l,5}=eleFaixMatDisc(indice).qtdRep; % quantidade de elementos no rotulo
                           end
                       end
                       
                       if ind==1                   % se for a primeira faixa
                           tabela{l,3}=faix.min;
                           tabela{l,4}=faix.(['f',int2str(ind)]);
                       else
                           if ind==md(linhaTabDescritora,atr)        % se for a última faixa                     ;
                               tabela{l,3}=faix.(['f',int2str(ind-1)]);
                               tabela{l,4}=faix.max;
                           else                    % não sendo a primeira e nem a última
                               tabela{l,3}=faix.(['f',int2str(ind-1)]);
                               tabela{l,4}=faix.(['f',int2str(ind)]);
                           end
                           
                       end
                       tabela{l,6}=atr;
                       contReg=contReg+1;
                       reg(contReg).grp=grp;
                       reg(contReg).rot=atr;
                       reg(contReg).faixa_inf=tabela{l,3};
                       reg(contReg).faixa_sup=tabela{l,4};
                       
                   end
                   
               end
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %
           % Rotina impressao Faixas que mais se repetem
           % por grupo
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           fprintf('\n\n===== Quantidades de elementos nas FAIXAS de cada ATRIBUTO =====\n');
           for grp=1:size(matriz_atr_imp(:,1))
               matriz_grupo = y_disc(grp).mat;
               fprintf('\nGRUPO %d:  ',grp);
               for f=1:size(matriz_grupo,2)
                   fprintf('\n%s = %d faixas:',cell2mat(cab(f)),size(qtdElemFaix{grp,f},2));
                   fprintf('\nFaixa \tQtd Elementos');
                   for v=1:size(qtdElemFaix{grp,f},2)
                       fprintf('\n%d \t%d',v,qtdElemFaix{grp,f}(1,v));
                   end
               end
               
           end
           
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %
           % Rotina impressao Faixas que mais se repetem
           % por grupo
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %
           fprintf('\n\n===== Faixas dos Atributos que mais se repetem por GRUPO =====\n');
           grupo_atual=0;
           for e=1 : size(eleFaixMatDisc,2)
               grupo=eleFaixMatDisc(e).grp;
               if grupo~=grupo_atual
                   fprintf('\nGrupo : %d',grupo);
                   fprintf('\nAtributo \tFaixa \tQtd_Rep\n');
                   grupo_atual=grupo;
               end
               fprintf('%s \t%d \t%d\n',cell2mat(cab(eleFaixMatDisc(e).atr)),eleFaixMatDisc(e).faixa,eleFaixMatDisc(e).qtdRep);
           end
           
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %
           % Rotina rótulos / atributor / faixas
           % por grupo
           %
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %
           fprintf('\n\n===== RESULTADO =====\n');
           fprintf('\nGrupo \t#Elem \tAtributo \tFaixa_Min~Faixa_Max \tAcerto \t\tErros \t#Tx_Erros');
           
           for l=1:size(tabela,1)
               fprintf('\n%d \t%d \t%s \t[%f ~ %f] \t%d \t\t%d \t%f',tabela{l,1},size(y_disc(tabela{l,1}).mat(:,tabela{l,6}),1),cell2mat(tabela{l,2}),tabela{l,3},tabela{l,4},tabela{l,5},((size(y_disc(tabela{l,1}).mat(:,tabela{l,6}),1))-tabela{l,5}),((size(y_disc(tabela{l,1}).mat(:,tabela{l,6}),1)-tabela{l,5})*100)/(size(y_disc(tabela{l,1}).mat(:,tabela{l,6}),1)));
           end

            fprintf('\n\n======= TABELA EM PORCENTAGEM DOS ATRIBUTOS IMPORTANTES ==========\n');
            disp(vet_acerto);
            matrizCompleta{linhaTabDescritora,metodoDiscretizacao}.faixas.a0
 end
 