% Recebe um vetor e de acordo com a variável numfaixa é aplicado a funcao
% de discretizacao com seus parametros
function vet = aplicaFaixa(vetor,numfaixa)

    vet = discretizar(vetor,'EFD',numfaixa);

end