numfaixa=3; % quantidade de faixas dos valores a serem discretizado
V=10;       % porcentagem de abrangencia dos valore do rótulo, ex. -10 e +10
l=0;        % num linhas da tabela;
rotina_AlgoritmosSupervisionados;
matriz_atr_imp = atrImportantes(vet_acerto,V);

% vai passando por cada cluster
% 
for grp=1:length(matriz_atr_imp(:,1))

    [mat_disc,faix] = discretizar(y(grp).mat,'EFD',numfaixa);
     %[mat_disc,faix] = discretizarT(y(grp).mat,3);
     disp(['Cluster ',num2str(grp),'=']);
    
     % percorre a matriz de atributos importantes, onde cada linha
     % corresponde a um cluster;
     % 
     for col=1:length(matriz_atr_imp(grp,:))
        atr = matriz_atr_imp(grp,col);
        
        if atr~=0
            l=l+1;
            tabela(l,1)=grp;
            tabela(l,2)=atr;
            
            vet_elem_faixa = y(grp).mat(:,atr);
            coluna = mat_disc(:,atr);
            % A mair quantidade de elementos do vetor discretizado é 
            % utilizado para dizer a importância da faixa.
            % Ex.: [1 1 1 2 2 2 2 2 3 3 3 ] 
            % o número que mais se repete é o 2, então a faixa 2 é a mais
            % importante do atributo escolhido. Então agora é só definir
            % qual o intervalo da faixa 2 do atributo selecionado em 'atr'.
            qtdElem=numElements(coluna);
            [elem,ind]=max(qtdElem);           
            if ind==1    % se for a primeira faixa            
               X = ['(',num2str(atr),',',num2str(faix.(['a',int2str(atr-1)]).min),'~',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind)])),')'];
               qtd_e = numElemNaFaixa(vet_elem_faixa, faix.(['a',int2str(atr-1)]).min, faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]));
               tabela(l,3)=faix.(['a',int2str(atr-1)]).min;     
               tabela(l,4)=faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]);
               % X = ['Atributo ',num2str(atr),' : Faixa: ',num2str(faix.(['a',int2str(atr-1)]).min),' ~ ',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]))];
            else
                if ind==numfaixa      % se for a última faixa 
                    X = ['(',num2str(atr),',',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)])),'~',num2str(faix.(['a',int2str(atr-1)]).max),')'];
                    qtd_e = numElemNaFaixa(vet_elem_faixa,faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)]), faix.(['a',int2str(atr-1)]).max );
                    tabela(l,3)=faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)]);     
                    tabela(l,4)=faix.(['a',int2str(atr-1)]).max;
                    %X=['Atributo ',num2str(atr),' : Faixa: ',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)])),' ~ ',num2str(faix.(['a',int2str(atr-1)]).max)];
                else  % não sendo a primeira e nem a última
                    %if ind==numfaixa                    
                        X = ['(',num2str(atr),',',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)])),'~',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind)])),')'];
                        qtd_e = numElemNaFaixa(vet_elem_faixa,faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)]), faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]) );
                         tabela(l,3)=faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)]); 
                         tabela(l,4)=faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]);
                        %X= ['Atributo ',num2str(atr),' : Faixa: ',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)])),' ~ ',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]))];
                    %end
                end

            end
           
          disp(X);
          disp(qtd_e);
          tabela(l,5)=qtd_e;
          
          
        end
       
     end
end
            


