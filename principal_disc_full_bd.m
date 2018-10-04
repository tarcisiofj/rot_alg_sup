
% ====================  =============  ====================================
%
% Área de definição de variáveis
%
%
numfaixa=3;         % quantidade de faixas dos valores a serem discretizado,
                    %  maior q 1;
V=0;                % porcentagem de abrangencia dos valore do rótulo, 
                    %  ex. -10 e +10
l=0;                % num linhas da tabela;
tabela=cell(0,5);   % tabela que armazena: cluster,atributo,
                    %  valor_faixa_min,valor_faix_max,qtd_vezes_atr_NaFaixa
%
%%%                    


% Importa o base de dados (dos 3 parâmetros o 1o. é a base, o 2o. é o
% delimitador dos campos e 3o. é a linha de cabeçalho qeu existe)
base=importdata('seeds.txt',',',1);

% Pega a primeira linha da base de dados
cab= base.textdata;

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
% m=geraMatrizArranjo(size(base.data,2)-1,[2 3 4 5 6 7 8 9 10]);
 m=geraMatrizArranjo(size(base.data,2)-1,[3 4 5 6]);
 md=flip(m,2); % espelha a matriz m;
 parada=4000;
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
     mat(loop)=loop;
     clear tabelaAux;
     clear tabelaAux2;
     if(loop==parada) 
       disp('linhas matriz completa ');
       disp(loop);
       parada=parada+loop;
     end
       
 
 end

 % Será realizado testes com os algoritmos com os dados da tabela
 % descritor "matrizCompleta", utilizando o o rotulo original de cada linha
 % para medir qual maior valor.
 parada=4000;
 for loop =1 : size(matrizCompleta,1)
     
     %%%% CART
%      nb=fitctree(matrizCompleta{loop,1}.matriz,base.data(:,end),'Crossval','on');  
%      isErro = kfoldLoss(nb);
%      acerto=100-(isErro*100);
%      matrizPlot(loop,1)=acerto;
%      
%      nb=fitctree(matrizCompleta{loop,2}.matriz,base.data(:,end),'Crossval','on');  
%      isErro = kfoldLoss(nb);
%      acerto=100-(isErro*100);
%      matrizPlot(loop,2)=acerto;

     %%%%%% NAIVE BAYES
     nb=fitcnb(matrizCompleta{loop,1}.matriz,base.data(:,end),'DistributionNames','kernel','Crossval','on');
     isErro = kfoldLoss(nb);
     acerto=100-(isErro*100);
     matrizPlot(loop,1)=acerto;
     nb=fitcnb(matrizCompleta{loop,2}.matriz,base.data(:,end),'DistributionNames','kernel','Crossval','on');
     isErro = kfoldLoss(nb);
     acerto=100-(isErro*100);
     matrizPlot(loop,2)=acerto;
      if(loop==3000) 
       disp('linhas matriz plot ');
       disp(loop);
       parada=parada+loop;
     end
     
 end

figure;
plot(matrizPlot(:,1));
figure;
plot(matrizPlot(:,2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Escolhe a linha(maiorValorInd) e coluna na matrizCompleta que possui o
% melhor resultado de discretização, onde o valor a coluna define o tipo de
% discretização aplicado.

%[mat_disc,faix] = discretizar(base.data(:,1:end-1),'EFD',numfaixa);
if max(max(matrizPlot(:,1))) == max(max(matrizPlot(:,2)))
    [maiorvalorEFD, maiorValorIndEFD]=max(matrizPlot(:,1));
    [maiorvalorEWD, maiorValorIndEWD]=max(matrizPlot(:,2));
    if maiorValorIndEFD > maiorValorIndEWD
        maiorValorInd=maiorValorIndEWD;
        metodoDiscretizacao=2;
    else
        maiorValorInd=maiorValorIndEFD;
        metodoDiscretizacao=1;
    end
else
    if max(max(matrizPlot(:,1))) > max(max(matrizPlot(:,2)))
        [maiorvalor, maiorValorInd]=max(matrizPlot(:,1));
        metodoDiscretizacao=1;
    else
        [maiorvalor, maiorValorInd]=max(matrizPlot(:,2));
        metodoDiscretizacao=2;
    end
end

%mat_disc = matrizCompleta{maiorValorInd,metodoDiscretizacao}.matriz;
FAIXA_3=1; % Indicar qual linha da tabela descritora "md" está a combinação
           % de todas as colunas serem divididas em três faixas;

for nvezes=1:3
    if nvezes==1
        if metodoDiscretizacao==1
            fprintf('\n\n======= RESULTADO  EFD ==========');
        else
             fprintf('\n\n======= RESULTADO  EWD ==========');
        end
        mat_disc = matrizCompleta{maiorValorInd,metodoDiscretizacao}.matriz;
        based.data = [mat_disc base.data(:,end)];
        rotina_AlgoritmosSupervisionados_arvoreDecisao;
        matriz_atr_imp = atrImportantes(vet_acerto,V);
        contReg=0;
        
        
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
        
        % Funcao retorna a matriz discretizada e as faixas de cada
        % atributo(a0,a1,a2...);
        % Tem como entrada a matriz do grupo, tipo de discreticação (EWD,EFD) e
        % o número de faixas que desejar separar.
        n=0;l=0;
        for grp=1:length(matriz_atr_imp(:,1))
            
            
            
            matriz_grupo = y(grp).mat; % variável que recebe o grupo identificado
            % por grp (grupo 1, grupo 2, etc)
            
            % Percorrer toda matriz discretizada do grupo n-1 (na variavel "y" os
            % grupos começam do ZERO ao UM) e verifica a faixa que mais se
            % repete por atributo;
            c=0;  % contador do registro eleFaixMatDisc;
            for frc=1:size(matriz_grupo,2) % percorrer todas as colunas da matriz
                n=n+1;
                c=c+1;
                % Funcao recebe uma coluna e retorna a quantidade de elementos
                % de cada faixa em um vetor.
                % md é a tabela descritora que irá dizer qual é o número de faixas
                qtdElemFaix{grp,frc} = numElements(matriz_grupo(:,frc),md(maiorValorInd,frc));
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
                            faix = matrizCompleta{maiorValorInd,metodoDiscretizacao}.faixas(atr).a0; % limites das faixas
                            tabela{l,5}=eleFaixMatDisc(indice).qtdRep; % quantidade de elementos no rotulo
                        end
                    end
                    
                    if ind==1                   % se for a primeira faixa
                        tabela{l,3}=faix.min;
                        tabela{l,4}=faix.(['f',int2str(ind)]);
                    else
                        if ind==md(maiorValorInd,atr)        % se for a última faixa                     ;
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
            matriz_grupo = y(grp).mat;
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
            fprintf('\n%d \t%d \t%s \t[%f ~ %f] \t%d \t\t%d \t%f',tabela{l,1},size(y(tabela{l,1}).mat(:,tabela{l,6}),1),cell2mat(tabela{l,2}),tabela{l,3},tabela{l,4},tabela{l,5},((size(y(tabela{l,1}).mat(:,tabela{l,6}),1))-tabela{l,5}),((size(y(tabela{l,1}).mat(:,tabela{l,6}),1)-tabela{l,5})*100)/(size(y(tabela{l,1}).mat(:,tabela{l,6}),1)));
        end
        fprintf('\n\n======= TABELA EM PORCENTAGEM DOS ATRIBUTOS IMPORTANTES ==========\n');
        disp(vet_acerto);

   else
       if nvezes==2
           metodoDiscretizacao=1; %EFD
           mat_disc = matrizCompleta{FAIXA_3,metodoDiscretizacao}.matriz;
           clear('based','y','n_grupos','cols','vet_acertos','vet_cel_semClasse','matriz_atr_imp','matriz_grupo','qtdElemFaix','eleFaixMatDisc','tabela');
          
           based.data = [mat_disc base.data(:,end)];
           rotina_AlgoritmosSupervisionados_arvoreDecisao;
           matriz_atr_imp = atrImportantes(vet_acerto,V);
           contReg=0;
           
           fprintf('\n\n======= RESULTADO COM FAIXAS 3 - EFD ==========');
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
           
           % Funcao retorna a matriz discretizada e as faixas de cada
           % atributo(a0,a1,a2...);
           % Tem como entrada a matriz do grupo, tipo de discreticação (EWD,EFD) e
           % o número de faixas que desejar separar.
           n=0; l=0;
           for grp=1:length(matriz_atr_imp(:,1))
               
               
               
               matriz_grupo = y(grp).mat; % variável que recebe o grupo identificado
               % por grp (grupo 1, grupo 2, etc)
               
               % Percorrer toda matriz discretizada do grupo n-1 (na variavel "y" os
               % grupos começam do ZERO ao UM) e verifica a faixa que mais se
               % repete por atributo;
               c=0;  % contador do registro eleFaixMatDisc;
               for frc=1:size(matriz_grupo,2) % percorrer todas as colunas da matriz
                   n=n+1;
                   c=c+1;
                   % Funcao recebe uma coluna e retorna a quantidade de elementos
                   % de cada faixa em um vetor.
                   % md é a tabela descritora que irá dizer qual é o número de faixas
                   qtdElemFaix{grp,frc} = numElements(matriz_grupo(:,frc),md(FAIXA_3,frc));
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
                               faix = matrizCompleta{FAIXA_3,metodoDiscretizacao}.faixas(atr).a0; % limites das faixas
                               tabela{l,5}=eleFaixMatDisc(indice).qtdRep; % quantidade de elementos no rotulo
                           end
                       end
                       
                       if ind==1                   % se for a primeira faixa
                           tabela{l,3}=faix.min;
                           tabela{l,4}=faix.(['f',int2str(ind)]);
                       else
                           if ind==md(FAIXA_3,atr)        % se for a última faixa                     ;
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
               matriz_grupo = y(grp).mat;
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
               fprintf('\n%d \t%d \t%s \t[%f ~ %f] \t%d \t\t%d \t%f',tabela{l,1},size(y(tabela{l,1}).mat(:,tabela{l,6}),1),cell2mat(tabela{l,2}),tabela{l,3},tabela{l,4},tabela{l,5},((size(y(tabela{l,1}).mat(:,tabela{l,6}),1))-tabela{l,5}),((size(y(tabela{l,1}).mat(:,tabela{l,6}),1)-tabela{l,5})*100)/(size(y(tabela{l,1}).mat(:,tabela{l,6}),1)));
           end

            fprintf('\n\n======= TABELA EM PORCENTAGEM DOS ATRIBUTOS IMPORTANTES ==========\n');
            disp(vet_acerto);
      
       
       else
           
           
           metodoDiscretizacao=2; %EWD
           clear('based','y','n_grupos','cols','vet_acertos','vet_cel_semClasse','matriz_atr_imp','matriz_grupo','qtdElemFaix','eleFaixMatDisc','tabela');
           mat_disc = matrizCompleta{FAIXA_3,metodoDiscretizacao}.matriz;
           
           
           based.data = [mat_disc base.data(:,end)];
           rotina_AlgoritmosSupervisionados_arvoreDecisao;
           matriz_atr_imp = atrImportantes(vet_acerto,V);
           contReg=0;
           
           fprintf('\n\n======= RESULTADO COM FAIXAS 3 - EWD ==========');
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
           
           % Funcao retorna a matriz discretizada e as faixas de cada
           % atributo(a0,a1,a2...);
           % Tem como entrada a matriz do grupo, tipo de discreticação (EWD,EFD) e
           % o número de faixas que desejar separar.
           n=0; l=0;
           for grp=1:length(matriz_atr_imp(:,1))
               
               
               
               matriz_grupo = y(grp).mat; % variável que recebe o grupo identificado
               % por grp (grupo 1, grupo 2, etc)
               
               % Percorrer toda matriz discretizada do grupo n-1 (na variavel "y" os
               % grupos começam do ZERO ao UM) e verifica a faixa que mais se
               % repete por atributo;
               c=0;  % contador do registro eleFaixMatDisc;
               for frc=1:size(matriz_grupo,2) % percorrer todas as colunas da matriz
                   n=n+1;
                   c=c+1;
                   % Funcao recebe uma coluna e retorna a quantidade de elementos
                   % de cada faixa em um vetor.
                   % md é a tabela descritora que irá dizer qual é o número de faixas
                   qtdElemFaix{grp,frc} = numElements(matriz_grupo(:,frc),md(FAIXA_3,frc));
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
                               faix = matrizCompleta{FAIXA_3,metodoDiscretizacao}.faixas(atr).a0; % limites das faixas
                               tabela{l,5}=eleFaixMatDisc(indice).qtdRep; % quantidade de elementos no rotulo
                           end
                       end
                       
                       if ind==1                   % se for a primeira faixa
                           tabela{l,3}=faix.min;
                           tabela{l,4}=faix.(['f',int2str(ind)]);
                       else
                           if ind==md(FAIXA_3,atr)        % se for a última faixa                     ;
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
               matriz_grupo = y(grp).mat;
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
               fprintf('\n%d \t%d \t%s \t[%f ~ %f] \t%d \t\t%d \t%f',tabela{l,1},size(y(tabela{l,1}).mat(:,tabela{l,6}),1),cell2mat(tabela{l,2}),tabela{l,3},tabela{l,4},tabela{l,5},((size(y(tabela{l,1}).mat(:,tabela{l,6}),1))-tabela{l,5}),((size(y(tabela{l,1}).mat(:,tabela{l,6}),1)-tabela{l,5})*100)/(size(y(tabela{l,1}).mat(:,tabela{l,6}),1)));
           end
           fprintf('\n\n======= TABELA EM PORCENTAGEM DOS ATRIBUTOS IMPORTANTES ==========\n');
           disp(vet_acerto);
           
       end
   end    
end

%based.data = [mat_disc base.data(:,end)];

% Rotina que faz gerar a matriz de porcentagem de acertos
%rotina_AlgoritmosSupervisionados_arvoreDecisao;
%matriz_atr_imp = atrImportantes(vet_acerto,V);
%contReg=0;


% ============================================
% IMPRESSAO DOS GRUPOS E ATRIBUTOS RELEVANTES
% ============================================
%
% fprintf('\n\n======= Atributos Relevantes ==========');
% for grp=1:length(matriz_atr_imp(:,1))
%     %disp(['Grupo ',num2str(grp),':']);
%     fprintf('\nGrupo  %d: ',grp);
%     for col = 1 : size((matriz_atr_imp(grp,:)),2)
%         atr = matriz_atr_imp(grp,col);
%         if atr ~= 0
%             %disp([' ',cell2mat(cab(atr))]);
%             fprintf(' %s  ',cell2mat(cab(atr)));
%         end
%     end
% end
% fprintf('\n======= ================== ===========');
% %
%==============================================


% ========================================================================
%
% Percorre por cada cluster e discretiza cada grupo gerando uma matriz
% discretizada toda vez q mudar o grp(cluster). 
% 

 % Funcao retorna a matriz discretizada e as faixas de cada
    % atributo(a0,a1,a2...); 
    % Tem como entrada a matriz do grupo, tipo de discreticação (EWD,EFD) e
    % o número de faixas que desejar separar.
% n=0;
% for grp=1:length(matriz_atr_imp(:,1))
%        
% 
%    
%     matriz_grupo = y(grp).mat; % variável que recebe o grupo identificado
%                                  % por grp (grupo 1, grupo 2, etc)
%     
%     % Percorrer toda matriz discretizada do grupo n-1 (na variavel "y" os 
%     % grupos começam do ZERO ao UM) e verifica a faixa que mais se
%     % repete por atributo;
%     c=0;  % contador do registro eleFaixMatDisc;
%     for frc=1:size(matriz_grupo,2) % percorrer todas as colunas da matriz
%         n=n+1; 
%         c=c+1;
%         % Funcao recebe uma coluna e retorna a quantidade de elementos 
%         % de cada faixa em um vetor.
%         % md é a tabela descritora que irá dizer qual é o número de faixas
%         qtdElemFaix{grp,c} = numElements(matriz_grupo(:,frc),md(maiorValorInd,frc)); 
%         [elem,ind]=max(qtdElemFaix{grp,c});
%         eleFaixMatDisc(n).grp=grp;
%         eleFaixMatDisc(n).atr=frc;
%         eleFaixMatDisc(n).qtdRep=elem;
%         eleFaixMatDisc(n).faixa=ind;
%         %eleFaixMatDisc(n).faixaA0=;
%         
%         
%     end
%     %===== =================================================================
%     
%     
%     
%     %grpFaixa(grp).faixa=faix;
%     
%     % percorre as colunas da matriz de atributos importantes, onde cada 
%     % linha(grp) corresponde a um cluster incrementado acima;     
%      for col=1:length(matriz_atr_imp(grp,:))
%         atr = matriz_atr_imp(grp,col);
%         
%         if atr~=0 % Só vai entrar no if, enquanto existir atributo para ser
%                   % lido na linha da matriz_atr_imp. Quando for ZERO é 
%                   % porque não existe mais atributo(rotulo) a ser lido.
%             
%             l=l+1;
%             tabela{l,1}=grp;
%             tabela{l,2}=cab(atr);
%             
%             %vet_elem_faixa = y(grp).mat(:,atr);
%             %%coluna = matriz_grupo(:,atr);
%             
%             % A mair quantidade de elementos do vetor discretizado é 
%             % utilizado para dizer a importância da faixa.
%             % Ex.: [1 1 1 2 2 2 2 2 3 3 3 ] 
%             % o número que mais se repete é o 2, então a faixa 2 é a mais
%             % importante do atributo escolhido. Então agora é só definir
%             % qual o intervalo da faixa 2 do atributo selecionado em 'atr'.
%             
%             %%qtdElem=numElements(coluna,numfaixa);
%             %%[elem,ind]=max(qtdElem);     
%             for indice=1: length(eleFaixMatDisc)
%                 if eleFaixMatDisc(indice).atr==atr && eleFaixMatDisc(indice).grp==grp
%                     ind=eleFaixMatDisc(indice).faixa;           % n. da faixa que o rotulo tem maior frequencia                              
%                     faix = matrizCompleta{maiorValorInd,metodoDiscretizacao}.faixas(atr).a0; % limites das faixas
%                     tabela{l,5}=eleFaixMatDisc(indice).qtdRep; % quantidade de elementos no rotulo
%                 end
%             end            
%             
% %             if ind==1                   % se for a primeira faixa            
% %                X = ['(',num2str(atr),',',num2str(faix.(['a',int2str(atr-1)]).min),'~',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind)])),')'];             
% %                %qtd_e = numElemNaFaixa(vet_elem_faixa, faix.(['a',int2str(atr-1)]).min, faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]),true);
% %                tabela{l,3}=faix.(['a',int2str(atr-1)]).min;     
% %                tabela{l,4}=faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]);
% %             else
% %                 if ind==numfaixa        % se for a última faixa 
% %                     X = ['(',num2str(atr),',',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)])),'~',num2str(faix.(['a',int2str(atr-1)]).max),')'];
% %                     %qtd_e = numElemNaFaixa(vet_elem_faixa,faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)]), faix.(['a',int2str(atr-1)]).max,false);
% %                     tabela{l,3}=faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)]);     
% %                     tabela{l,4}=faix.(['a',int2str(atr-1)]).max;
% %                 else                    % não sendo a primeira e nem a última
% %                         X = ['(',num2str(atr),',',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)])),'~',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind)])),')'];
% %                         %qtd_e = numElemNaFaixa(vet_elem_faixa,faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)]), faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]) ,false);
% %                          tabela{l,3}=faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)]); 
% %                          tabela{l,4}=faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]);
% %                 end
% % 
% %             end
%             if ind==1                   % se for a primeira faixa                           
%                tabela{l,3}=faix.min;     
%                tabela{l,4}=faix.(['f',int2str(ind)]);
%             else
%                 if ind==md(maiorValorInd,atr)        % se for a última faixa                     ;
%                     tabela{l,3}=faix.(['f',int2str(ind-1)]);     
%                     tabela{l,4}=faix.max;
%                 else                    % não sendo a primeira e nem a última
%                     tabela{l,3}=faix.(['f',int2str(ind-1)]); 
%                     tabela{l,4}=faix.(['f',int2str(ind)]);
%                 end
% 
%             end
%           tabela{l,6}=atr; 
%           contReg=contReg+1;
%           reg(contReg).grp=grp;
%           reg(contReg).rot=atr;
%           reg(contReg).faixa_inf=tabela{l,3};
%           reg(contReg).faixa_sup=tabela{l,4};
%           
%         end
%        
%      end
% 
%      
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Rotina impressao Faixas dos atributos 
% por grupo
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% fprintf('\n\n===== Faixas dos Atributos por GRUPO =====\n');
% for grp=1:size(matriz_atr_imp(:,1),1)
%     fprintf('\nGRUPO %d\n',grp);
%     if numfaixa>1
%         for ic = 1 : (size(cab,2)-1)
%             fprintf('%s = ',cell2mat(cab(ic)));
%             
%             
%             for f=1:numfaixa
%                 if (f==1)
%                     fprintf('\t[%f ~ %f]  ',grpFaixa(grp).faixa.(['a',int2str(ic-1)]).min,grpFaixa(grp).faixa.(['a',int2str(ic-1)]).f1);
%                     
%                     
%                 else if (f==numfaixa)
%                         fprintf('\t]%f ~ %f]\n',grpFaixa(grp).faixa.(['a',int2str(ic-1)]).(['f',int2str(f-1)]),grpFaixa(grp).faixa.(['a',int2str(ic-1)]).max);
%                     else
%                         fprintf('\t]%f ~ %f] ',grpFaixa(grp).faixa.(['a',int2str(ic-1)]).(['f',int2str(f-1)]),grpFaixa(grp).faixa.(['a',int2str(ic-1)]).(['f',int2str(f)]));
%                     end
%                 end
%             end
%         end
%     end
%     
%     
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% % Rotina impressao Faixas que mais se repetem
% % por grupo
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fprintf('\n\n===== Quantidades de elementos nas FAIXAS de cada ATRIBUTO =====\n');
% for grp=1:size(matriz_atr_imp(:,1))
%     matriz_grupo = y(grp).mat;
%     fprintf('\nGRUPO %d:  ',grp);
%     for f=1:size(matriz_grupo,2)
%         fprintf('\n%s = %d faixas:',cell2mat(cab(f)),size(qtdElemFaix{grp,f},2));
%         fprintf('\nFaixa \tQtd Elementos');
%         for v=1:size(qtdElemFaix{grp,f},2)
%             fprintf('\n%d \t%d',v,qtdElemFaix{grp,f}(1,v));
%         end
%     end
%     
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% % Rotina impressao Faixas que mais se repetem
% % por grupo
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% fprintf('\n\n===== Faixas dos Atributos que mais se repetem por GRUPO =====\n');
% grupo_atual=0;
% for e=1 : size(eleFaixMatDisc,2)
%     grupo=eleFaixMatDisc(e).grp;
%     if grupo~=grupo_atual
%        fprintf('\nGrupo : %d',grupo); 
%        fprintf('\nAtributo \tFaixa \tQtd_Rep\n'); 
%        grupo_atual=grupo;
%     end
%     fprintf('%s \t%d \t%d\n',cell2mat(cab(eleFaixMatDisc(e).atr)),eleFaixMatDisc(e).faixa,eleFaixMatDisc(e).qtdRep);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% % Rotina rótulos / atributor / faixas
% % por grupo
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% fprintf('\n\n===== RESULTADO =====\n');
% fprintf('\nGrupo \t#Elem \tAtributo \tFaixa_Min~Faixa_Max \tAcerto \t\tErros \t#Tx_Erros');
% 
% for l=1:size(tabela,1)
%     %if tabela{l,6}==1
%         fprintf('\n%d \t%d \t%s \t[%f ~ %f] \t%d \t\t%d \t%f',tabela{l,1},size(y(tabela{l,1}).mat(:,tabela{l,6}),1),cell2mat(tabela{l,2}),tabela{l,3},tabela{l,4},tabela{l,5},((size(y(tabela{l,1}).mat(:,tabela{l,6}),1))-tabela{l,5}),((size(y(tabela{l,1}).mat(:,tabela{l,6}),1)-tabela{l,5})*100)/(size(y(tabela{l,1}).mat(:,tabela{l,6}),1)));
%      %   fprintf('\n%d \t%s \t%d \t[%f ~ %f]',tabela{l,1},cell2mat(tabela{l,2}),tabela{l,5},tabela{l,3},tabela{l,4});
%     %else            
%       %  fprintf('\n%d \t%s \t%d \t]%f ~ %f]',tabela{l,1},cell2mat(tabela{l,2}),tabela{l,5},tabela{l,3},tabela{l,4});
%     %end
% end
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Rotina quantidade de elementos nos rótulos
% por grupo
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fprintf('\n\n===== Erros =====\n');
% fprintf('Grupo \t#Elem \tAtributos \tAcertos \ttx_Erros(%)');
% for g=1:size(matriz_atr_imp,1)
%     %[lin,c] = size(y(g).mat);
%     for rot=1 : size(matriz_atr_imp,2)
%         rotulo = matriz_atr_imp(g,rot);
%         cont=0;
%         if rotulo~=0
%             qtd = estaFaixa(reg,g,rotulo,y(g).mat(:,rotulo),grpFaixa);
%             %disp(['Cluster=' ,num2str(g),' #Elem =',num2str(size(y(g).mat(:,rotulo),1)),cab(rotulo),' - Erros = ',size(y(g).mat(:,rotulo),1)-qtd,'']);
%             fprintf('\n%d \t%d \t%s \t%d \t\t%f',g,size(y(g).mat(:,rotulo),1),cell2mat(cab(rotulo)),qtd,((size(y(g).mat(:,rotulo),1)-qtd)*100)/(size(y(g).mat(:,rotulo),1)));
%             
%         end
%         
%     end
%     
% 
%    
% end


%
% rotina faz verifica se o valor respectivo do rotulo na linha esta
% presente em todos os rotulos. ex. se possuo um cluster onde foram
% identificados 2 rótulos, então testarei se em cada registro do grupo 
% possue valor respectivo do 1º rótulo e também no 2º rótulo. Caso exista
% valores nos respectivos rótulos no registro, isso quer dizer que o
% registro de fato define o rótulo.
% fprintf('\n\n');
% for g = 1 : size(matriz_atr_imp,1) % Pega cada linha da matriz_atr_imp
%                                    % que significa o grupo. Nessa matriz
%                                    % define os rótulos(col) de cada grupo.
%     cont=0;
%     
%     matrizPorGrupo = y(g).mat;     % var recebe todos os registros do grupo 
%     for l = 1 : size(matrizPorGrupo,1)
%         vetRot=matriz_atr_imp(g,:); % var recebe um vetor com todos os rótulos
%         status=true;  % variável de controle para saber se na linha de registro
%                       % do grupo existem valores em seus respectivos rótulos.
%         loop=0;
%         for rot = 1 : size(vetRot,2) % percorre o vetor de rótulos
%             rotulo=vetRot(rot);
%             if rotulo~=0 % se houver rótulo válido no vetor
%                 valor = matrizPorGrupo(l,rotulo);
%                 
%                 for linR = 1 : size(reg,2)
%                     if (reg(linR).grp==g) && (reg(linR).rot==vetRot(rot))
%                         % Caso o valor pertença a primeira faixa
%                         if ( valor<=grpFaixa(g).faixa.(['a',int2str(rot-1)]).f1 )
%                             loop=1;
%                             if valor>=reg(linR).faixa_inf && valor<=reg(linR).faixa_sup
%                                 status=status && true;
%                             else
%                                 status=status && false;
%                             end
%                             
%                         else
%                             if valor>=reg(linR).faixa_inf && valor<reg(linR).faixa_sup
%                                 status=status && true;
%                             else
%                                 status=status && false;
%                             end
%                             
%                         end                        
%                     end
%                 end
%             end
%         end
%         if status && loop
%             cont=cont+1;
%         end
%     end
%     
%     disp(['Cluster=' ,num2str(g),' #Elem =',num2str(size(y(g).mat,1)),' - Nº Reg do Rótulo = ',num2str(cont)]);
%     figure;
%     vl=[(size(y(g).mat,1)-cont) cont];
%     pie(vl,[0 1]);
%     title(['Cluster ',num2str(g)]);
%     legend('Registros Não-Rótulos','Registros Rótulo(s)');
%     
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       Rotina de desenhar graficos
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% grps = unique(cell2table(tabela(:,1)));'' ''  
% 
% 
%         
% for gr = 1 : size(grps)
%     lin=1;
%     %tabelaGrp=cell();
%     for linTab = 1 : length(tabela(:,1))
%         if gr==tabela{linTab,1}
%                tabelaGrp(lin,:)=tabela(linTab,:);
%                lin=lin+1;
%         end
%     end
%    [val,leg] = formPizza(tabelaGrp{:,2:end});
%    figure;
%    pie(val,val);
%    legend(leg);
%    val=0;
%    leg='';
% end
            


