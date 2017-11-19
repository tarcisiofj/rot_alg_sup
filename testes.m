
for g=1:size(matriz_atr_imp,1)
    %[lin,c] = size(y(g).mat);
    for rot=1 : size(matriz_atr_imp,2)
        rotulo = matriz_atr_imp(g,rot);
        cont=0;
        if rotulo~=0
            
          
          for l=1 : size(y(g).mat,1)  % percorrer todas as linhas da tabela do grupo g  
          
           stat= estaFaixa(reg,g,rotulo,y(g).mat(l,rotulo));
            if stat==1
                cont=cont+1;
            end
          end
            disp(['grupo' ,g,cab(rotulo),' = ',cont,'']);
        end
        
    end
    

   
end