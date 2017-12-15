function X = Valsa(N,ctt)
X=[]; 
X=[X,ctt];  
e=0.2;
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
    elseif X(n-2)==2 && X(n-1)<2
        if U<e  %% U(n-1)<e  se quiser guardar as uniformes
            X(n)=0;
        else X(n)=1;
        end
    else 
        X(n)=2;
    end
end
end
