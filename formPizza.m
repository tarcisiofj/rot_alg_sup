% Irá retornar 
function [dqtd,legenda] = formPizza(tab_rotulos)
    dqtd = tab_rotulos(:,end);
    str='';
    %legenda = (length(tab_rotulos(:,end)));
    for i=1 : length(tab_rotulos(:,end))
        %for j=1 : length(tab_rotulos(i,1:end-1))
            str = ['Atributo: ',num2str(tab_rotulos(i,1)),' Faixa: ',num2str(tab_rotulos(i,2)),'~',num2str(tab_rotulos(i,3))];
            
        %end
        legenda(i)=cellstr(str);
    end    
    
    
end
%(['a',int2str(i-1)]).(['f',int2str(k)]))