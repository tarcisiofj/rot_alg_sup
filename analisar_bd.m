function [ ok ] = analisar_bd( BD )
    disp(' ');
    disp(' ');
    disp('########### Analisando Base de Dados ###########');
    disp(' ');
    
    % Total de Elementos
    disp(['    - Total de elementos: ' num2str(size(BD, 1))]);
    
    % Indexização dos Elementos
    ok = true;
    for i=1:size(BD, 1)
        if BD(i,1) ~= i
            ok = false;
            break;
        end
    end
    if ok == true
        disp('    - Indexação dos elementos: ok!');
    else
        disp('    * Indexação dos elementos: error!');
    end
    
    % Dados por Atributo
    disp(' ');
    disp('                      min     max     mean     std             #uni');
    for i=2:size(BD, 2)
        disp(['    - Atributo ' num2str(i) ':      ' num2str(min(BD(:,i))) '     ' num2str(max(BD(:,i))) '     ' num2str(mean(BD(:,i))) '     ' num2str(std(BD(:,i))) '     ' num2str(size(unique(BD(:,i)),1))]);
    end
    
    disp(' ');
    disp('################################################');
    disp(' ');
    disp(' ');
end

