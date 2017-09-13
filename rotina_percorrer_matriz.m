[l,c]=size(B);
parada=1;
while parada<=c
    classe=parada;
    parada;
    for i=1:c;
        disp('oi')
    end
    parada=parada+1;
end

% No 1o. for, um loop é iniciado e vai até o número de linhas;
% No 2.o for, um loop é iniciado e vai até o número de colunas; 
for p=1:size(B,1)
    disp(p);
    p;
    for i=1:size(B,2);
        disp(B(p,i));
    end
end
