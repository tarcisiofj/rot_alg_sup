function regRotul = qtdElemGrp(rotulosPorLinha,registrosGrp,grupo,reg)
i=0;
% for lin = 1 : size(registrosGrp,1)            % percorrer todos os registros do grupo (linhas)
%     linhaGrupo = registrosGrp(lin,:);         % recebea linha do registro de cada grupo
%     
%     for linRotul=1 : size(rotulosPorLinha,2)   % percorre todos os rotulos
%         rotulo = rotulosPorLinha(linRotul);
%     
%         if rotulo~=0                    % entra no if se o rotulo existir no vetor
%             i=i+1;
%             numero=0;
%             for r=1 : size(reg,2)
%                
%                 if reg(r).grp==grupo && reg(r).rot==rotulo
%                    
%                     if  linhaGrupo(rotulo)>=reg(r).faixa_inf && linhaGrupo(rotulo)<reg(r).faixa_sup
%                        
%                         regRotul(i).rot=rotulo;
%                         regRotul(i).numero=numero+1;
%                         regRotul(i).linhaReg=lin;
%                         
%                     end
%                 end
%      
%             end
%         end
%     end
% end
% 
% for r=1:size(regRotul,2)
%     
% end

for lin=1 : size(reg,2)
    g=reg(lin).grp;
    rot=reg(lin).rot;
    
    for l=1 : size(registrosGrp,1)
        if g==
        if registrosGrp(l,rot)>
    end
end



end