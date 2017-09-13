
rotina_AlgoritmosSupervisionados;
matriz_atr_imp = atrImportantes(vet_acerto,5);
for grp=1:length(matriz_atr_imp(:,1))
     %[mat_disc,faix] = discretizar(y(grp).mat,'ML',3);
     [mat_disc,faix] = discretizarT(y(grp).mat,3);
     for col=1:length(matriz_atr_imp(grp,:))
        atr = matriz_atr_imp(grp,col);
        if atr~=0
            coluna = mat_disc(:,atr);
            qtdElem=numElements(coluna);
            [elem,ind]=max(qtdElem);
              
        end
     end
end
            


