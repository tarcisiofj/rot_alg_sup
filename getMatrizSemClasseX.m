% Funcao retorna um vetor com os numeros das colunas, menos a que esta
% definica como parametro "classe"
function [y] = getMatrizSemClasseX(bd,classe)
    % Retorna em c o numero de colunas de bd;
    c=length(bd(end,:));
    cont=0;
    vetor=zeros(1,c-1);
    for ind=1:c
        if(ind~=classe)
            cont=cont+1;
            vetor(1,cont)=ind;
        end
    end  
    y=vetor;
end
