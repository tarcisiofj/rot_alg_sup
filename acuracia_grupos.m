registro_ok=-1;
registros_rotulo=0;
grp_old=-1;
for n = 1:length(y)
    n_grp=y(n).grp;
    for num_lin = 1: size(base.data,1) % percorrer todoas as linhas
%         if (num_lin==186 && n_grp==7)
%             fprintf('g 7');
%         end
        if n_grp == base.data(num_lin,end) % se a linha pertencer  ao grupo certo entra para executar o for
            for num_col = 1:(size(base.data,2)-1) % percorrer todas as colunas até o atributo antes da classe
                for dd=1:size(reg,2) % percorre toda  tabela com os rotulos
                    if reg(dd).grp == n_grp
                        if reg(dd).rot == num_col
                            if ( reg(dd).faixa_inf == grpFaixa(n_grp).faixa.(['a',int2str(reg(dd).rot)-1]).min ) && ( reg(dd).faixa_sup == grpFaixa(n_grp).faixa.(['a',int2str(reg(dd).rot)-1]).f1 )
                                if base.data(num_lin,num_col) >= reg(dd).faixa_inf && base.data(num_lin,num_col) <= reg(dd).faixa_sup
                                    registro_ok=0;
                                else
                                    registro_ok=1;
                                    break
                                end
                           % else if ( reg(dd).faixa_inf == grpFaixa(n_grp).faixa.(['a',int2str(reg(dd).rot)-1]).(['f',int2str(numfaixa-1)] ) && ( reg(dd).faixa_sup == grpFaixa(n_grp).faixa.(['a',int2str(reg(dd).rot)-1]).max )
                            else                           
                                if base.data(num_lin,num_col) > reg(dd).faixa_inf && base.data(num_lin,num_col) <= reg(dd).faixa_sup
                                    registro_ok=0;
                                else
                                    registro_ok=1;
                                    break
                                end
                            end
                        end
                        
                    end
                end
                if registro_ok == 1 %&& num_col == (size(base.data,2)-1)
                    break
                end
            end   

        end
        if registro_ok==0
            registros_rotulo=registros_rotulo+1;
            
        end
        registro_ok=-1;
    end
    if grp_old~=n_grp
        fprintf('\nGrupo %d com %d registros',n_grp,registros_rotulo);
        grp_old=n_grp;
        registros_rotulo=0;
    end
end