% funcao recebe 3 parametros de entrada:
%   matriz = um conjunto de dados que será usado para treino e teste
%   treino = um inteiro que mostra o valor da porcentagem que será retirado
%       do parâmetro "matriz" para treino. ex.: 80 = 80% para treino, 
%       50 = 50% para treino, etc.
%
function [trein,test] = embaralhaMatTreinTest(matriz,treino) 

    matriz=matriz(randperm(size(matriz,1)),:);
    contlin = size(matriz,1);
    qtdLinTreino = contlin*(treino/100);
    inicioLinTeste = qtdLinTreino+1;
    trein = matriz(1:qtdLinTreino,:);
    test = matriz(inicioLinTeste:end,:);
    
    
end