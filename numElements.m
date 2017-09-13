function mr = numElements(vetor)
    n_elementos=zeros(1);
    vetor_unicos = unique(vetor);
    %coluna_matriz = matriz_discret(:,col);
    for i=1:length(vetor_unicos)
            valor = vetor_unicos(i);
            soma=0;
            for j=1:length(vetor)
                if valor==vetor(j)
                    soma=soma+1;
                end
                n_elementos(1,i)=soma;                
            end
        
    end
    mr=n_elementos;
end