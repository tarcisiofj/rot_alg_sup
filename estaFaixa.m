function [qtd] = estaFaixa(reg,grp,rot,lista_valores,grpFaixa)
    qtd=0;
    for lin= 1 : size(lista_valores)
        valor=lista_valores(lin);
        for i= 1 : size(reg,2)
            if reg(i).grp==grp && reg(i).rot==rot 
                if ( valor<=grpFaixa(grp).faixa.(['a',int2str(rot-1)]).f1 )
                    if valor>=reg(i).faixa_inf && valor<=reg(i).faixa_sup
                        qtd=qtd+1;
                    end
                else                 
                    if valor>reg(i).faixa_inf && valor<=reg(i).faixa_sup
                        qtd=qtd+1;
                    end
                end
                
            end
        end
        
    end    
end