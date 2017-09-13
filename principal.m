
rotina_AlgoritmosSupervisionados;
matriz_atr_imp = atrImportantes(vet_acerto,7);
for grp=1:length(matriz_atr_imp(:,1))
     [mat_disc,faix] = discretizar(y(grp).mat,'EFD',3);
     %[mat_disc,faix] = discretizarT(y(grp).mat,3);
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
              
        end
     end
end
            


