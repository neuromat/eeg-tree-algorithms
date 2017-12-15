function X = Samba(N,ctt)%tau={2,21,11,01,20,10,00}
e=0.2;
%   %%% prob de apagamento
% p_2=e;      % p_21=e;       % p_11=1;
% p_01=1;     % P_10=1;       % p_00=1;

X=[]; %%% chain with memory of variable length  
X=[X,ctt];  %% condi�ao inicial
% N=20;  %%%numero de passos
% e=0.2; 
%% gerando a cadeia oculta
%U=[]; %%% se quiser guardar as uniformes
for n=(length(X)+1):N
    %U=[U,rand]; %% se quiser guardar as uniformes
    U=rand;
    if X(n-1)==2
        if U<e  %% U(n-1)<e  se quiser guardar as uniformes
            X(n)=0;
        else X(n)=1;
        end
    elseif X(n-2)==2
        X(n)=0;
    elseif X(n-3)==2
        if U<e
            X(n)=0;
        else X(n)=1;
        end
    elseif X(n-4)==2
        X(n)=2;
    end
end
end