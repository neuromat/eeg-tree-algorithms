function Tree = TreeEstimator (X, Y ,l, alpha, Alphabet, Proj, Corte)
c=sqrt(-1/2*(log(alpha/2)));
T=CompletTree(l, X, Alphabet);  %% Gera uma arvore K
%%
for s=1:l
    m=l+1-s;
    Cut={};
    d_T=length(T(1,:));
    for n=1:d_T
        if length(T{1,n})==m
            w1=T{1,n};
            a1=w1(2:end);
            %% Checa se foi testado por causa de um irmao
            Check1=0;
            if ~isempty(Cut)
                for i = 1:length(Cut)
                    if isequal(Cut{i},w1)
                        Check1=1;
                        break
                    end
                end
            end
            %% Checa se precisa testar
            for u=1:d_T
                w2=T{1,u};
                Check2=0;
                if length(w2)>length(w1)
                    a2=w2(end-length(a1)+1:end);
                    if isempty(a1)
                        Check2=1;
                    elseif ~isempty(a1) && isequal(a1,a2) && ~isequal(w1,w2)
                        Check2=1;
                        break
                    end
                end
            end
            
            %% Seleciona o ramo de w1
            if  Check1+Check2==0
                Br={w1};
                a1=w1(2:end);
                for u=1:d_T
                    w2=T{1,u};
                    a2=w2(2:end);
                    if isequal(a1,a2) && ~isequal(w1,w2)
                        Br=[Br,T{1,u}];
                    end
                end
                
                %% Verifica as ocorrencia de cada ctxt do ramo
                d_Br=length(Br(1,:));
                if d_Br > 1
                    for v=1:d_Br
                        Br{2,v}=0; %conta as ocorrencias de cada ctxt do ramo
                        Br{3,v}=[];%guarda os indices de ocorrencia
                    end
                    for v=1:d_Br
                        for z=1:(length(X)-l+1)
                            x=length(Br{1,v});
                            if  isequal( X(z:z+x-1),Br{1,v})
                                Br{2,v}=Br{2,v}+1;
                                Br{3,v}=[Br{3,v},z+x-1];
                            end
                        end
                    end      
                    %%
                    Y1_e=Y(1,:,Br{3,1});
                    Y2_e=Y(1,:,Br{3,2});
                    if d_Br==3, Y3_e=Y(1,:,Br{3,3}); else Y3_e=[]; end
                    S=Statistic(Y1_e,Y2_e,Y3_e,c,Proj); %% Numero de rej das proj \in {0,1, ..., proj}
                    if S<Corte;
                        Cut=[Cut,Br(1,:)];
                    end
                else Cut=[Cut,Br(1,:)];
                end
            end
        end
    end
    %%   Corta os ramos
    if ~isempty(Cut)
         T = CutBranches( T, Cut );
     end
Tree=T;

end
end
