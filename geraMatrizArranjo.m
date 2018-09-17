function [matriz] = geraMatrizArranjo(num_atributo,vet_faixas)

natrib = num_atributo;%length(tabe(1,:)); % numero de atributos, definindo o tanto de colunas
faixas = vet_faixas; %[2 3]; % as faixas q serão utilizadas
nfaixas= size(faixas,2); % o número de faixas, para servir de cálculo do número de linhas da tabela
num_linhas = nfaixas^natrib; % define o número de linhas da tabela a ser criada;
%tabEspH = flip(tabe,2); % tabela espelhada horizontalmente;
matrizArranjo = zeros(num_linhas,natrib);
ind=0; % auxiliar, pois fará o papel do número da coluna a ser preenchida.
matriz=matrizArranjo;

while ind<natrib
    %if ind~=(natrib-1)
    %ind=ind+1;
    %end
    l=1;
    while l<num_linhas
        for elem = 1:nfaixas
            for qtdElem = 1:nfaixas^ind % repetir o numero de vezes cada elemento da faixa aparece em sequencia
                matriz(l,ind+1) = faixas(elem);
                l = l+1;
            end
        end
        
    end
    ind=ind+1;
end
end
