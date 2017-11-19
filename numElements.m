% Funcao retorna um vetor com o número de elementos de cada valor distinto
% do parâmetro "vetor", que foi passado.
% Ex.: vetor = [ 1 2 2 3 3 2 1 1 1 3 3 3 ] 
% mr = numElementos(vetor)  => mr = [4 3 5]
% @"vetor" é um parâmetro com os números da coluna matriz base de dados
% discretizada.
function mr = numElements(vetor,numFaixa)
    n_elementos=zeros(1);
    %vetor_unicos = unique(vetor);
    %coluna_matriz = matriz_discret(:,col);
    for i=1:numFaixa
            faixa = i;
            soma=0;
            for j=1:length(vetor)
                if faixa==vetor(j)
                    soma=soma+1;
                end                
            end
            n_elementos(1,i)=soma;                
        
    end
    mr=n_elementos;
end