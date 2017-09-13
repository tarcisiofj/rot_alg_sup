
tipo = 1; % Dados:
          % 1 - Contínuo
          % 2 - Discreto / Categórico
nFaixas = 5;
if tipo == 1
    [BDQ, faixas] = discretizar(BD, 'EFD', nFaixas);
    
    % Histograma de todos os atributos (global)
    hist(BDQ(:,2:size(BDQ, 2)), nFaixas);
    title('Histograma');
    hold on
    Y = floor((size(BDQ, 1) / nFaixas));
    for i=1:nFaixas
        Y = [Y, floor((size(BDQ, 1) / nFaixas))];
    end
    
    plot(Y);
else
    faixas = -1;
    BDQ = BD;
end
