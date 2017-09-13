% recebe como entrada o "vet_acertos" uma matriz que contem todas as
% porcentagens de acertos de cada atributo. Esses acertos são referentes
% aos algoritmos de aprendizado de máquina em cima da base de dados.
% Essa função tem a intenção de retornar a partir da entrada, uma matriz
% com os índices dos acertos referentes ao limite imposto pela variável V.
% onde V informa a partir do maior elemento, V's acima e V's abaixo. 
% Ex. se o maior valor for 65, na linha 1, qeu representa um grupo com seus
% valores de acertos, e V for 10, então todos os valores de 65-V e 65+V
% entram no retorno desta função. 65-V=55 e 65+V=75, logo os índices dos 
% valores entre 55 e 75 irão entrar na matriz de retorno desta função.
function matRot = atrImportantes(matriz_acertos,V) 
    mRot=zeros(1,1);  %size(matriz_acertos);
    for i=1 : length(matriz_acertos(:,1))
        vet = matriz_acertos(i,:);
        vMax=max(vet);
        limInf= vMax-V;
        limSup= vMax+V;
        col=0;
        for j= 1 : length(vet)           
            valor = vet(j);            
            if ( (valor<=limSup) && (valor>=limInf))
                col=col+1;
                mRot(i,col)=j;
            end
            
        end
        
        
    end
    matRot=mRot;
end