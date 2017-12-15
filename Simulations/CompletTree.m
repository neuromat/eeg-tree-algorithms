function K=CompletTree(l,X,Alphabet)
%% Find Alphabet

%% Gera todas as seq possiveis de tamanho l 
% Alphabet = '012';  %%%%%% Must to be generalized
A=unique(nchoosek(repmat(Alphabet, 1, l), l), 'rows');
K={};
%% Verifica a osorrencia das seq na amostra
d=size(A);
for i=1:(d(1))
    c=[];
    for j=1:l
        c = [c , A(i,j)];
    end
    K{1,i}=c;
end
if ~isempty(K)
    for n=1:(length(K))
        K{2,n}=0;
    end
end

%% Conta quantas vezes apareceu e exclui os que aparecem menos de 2 vezes
To_exclude=[];
for r=1:length(K) 
    for n=1:(length(X)-l+1)
        if isequal( X(n:n+l-1),K{1,r})
            K{2,r}=K{2,r}+1; %% contagem dos ctts
        end
    end
    if K{2,r}==0
       To_exclude=[To_exclude, r];
    end
end

K(:,To_exclude)=[];
end