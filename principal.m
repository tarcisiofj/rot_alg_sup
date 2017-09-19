numfaixa=4;
V=15;
rotina_AlgoritmosSupervisionados;
matriz_atr_imp = atrImportantes(vet_acerto,V);

for grp=1:length(matriz_atr_imp(:,1))

    [mat_disc,faix] = discretizar(y(grp).mat,'EWD',numfaixa);
     %[mat_disc,faix] = discretizarT(y(grp).mat,3);
     disp(['Cluster ',num2str(grp),'=']);
    
     for col=1:length(matriz_atr_imp(grp,:))
        atr = matriz_atr_imp(grp,col);
        if atr~=0
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
               % X = ['Atributo ',num2str(atr),' : Faixa: ',num2str(faix.(['a',int2str(atr-1)]).min),' ~ ',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]))];
            else
                if ind==numfaixa      % se for a última faixa 
                    X = ['(',num2str(atr),',',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)])),'~',num2str(faix.(['a',int2str(atr-1)]).max),')'];
                    %X=['Atributo ',num2str(atr),' : Faixa: ',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)])),' ~ ',num2str(faix.(['a',int2str(atr-1)]).max)];
                else  % não sendo a primeira e nem a última
                    %if ind==numfaixa                    
                        X = ['(',num2str(atr),',',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)])),'~',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind)])),')'];
                        %X= ['Atributo ',num2str(atr),' : Faixa: ',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind-1)])),' ~ ',num2str(faix.(['a',int2str(atr-1)]).(['f',int2str(ind)]))];
                    %end
                end

            end
           
          disp(X);
              
        end
       
     end
end
            


