function qtd = numElemNaFaixa(vet_elem,faixa_min,faixa_max,isMinima)

% Funcao retorna a quantidade(qtd) de elementos do atr na faixa 
% designada para cada atributo:
%
% vet_elem : vetor com elementos a serem contados na determinada faixa;
% faixa    : intervalo de valores definido para cada atributo;
% taMinima : verdadeiro ou falso caso esteja na primeira faixa
qtd=0;
for ind_elem= 1:length(vet_elem)
    elem=vet_elem(ind_elem);
    if isMinima
        if( (elem>=faixa_min) && (elem<=faixa_max) ) 
            qtd=qtd+1;
        end
    else if( (elem>faixa_min) && (elem<=faixa_max) )
            qtd=qtd+1;
        end
    end





end