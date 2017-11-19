% Funcao que recebe o grupo e uma estrutura que armazena
% grupos,rotulos e faixa. Com o intuito de simplismente retornar um vetor
% de rotulos do grupo que foi passado por parâmetro.
% 
function [rotulos] = getRotulReg(grupo,reg)
    
    ind=0;
    for i=1 : size(reg,2)
       if reg(i).grp==grupo
          ind=ind+1;
          rotulos(ind)=reg(i).rot; 
       end
        
    end



end