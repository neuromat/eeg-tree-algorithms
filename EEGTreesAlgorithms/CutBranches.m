function T_w = CutBranches( T, Cut )
T_w=T(1,:);
if  isequal({[1],[2],[0]},Cut)+isequal({[1],[0],[2]},Cut)+isequal({[2],[1],[0]},Cut)+isequal({[2],[0],[1]},Cut)+isequal({[0],[2],[1]},Cut)+isequal({[0],[1],[2]},Cut)==1;
    T_w={};
else
    %%
    Ind=[];
    Add={};
    for r=1:length(Cut(1,:))
        u=Cut{1,r};
        Appear=false;
        a = 1;
        while ~Appear && a < length(Add)+1
            Appear = isequal(Add{a},u(2:end));
            a = a + 1;
        end
        if ~Appear, Add = [Add, u(2:end)]; end
        %% Verifico os indices a ser cortado
        for s=1:(length(T(1,:)))
            v=T{1,s};
            if length(v) < length(u)
                continue
            elseif isequal(v,u)
                Ind=[Ind,s];
            end
        end
    end
    T_w(:,Ind)=[];
    T_w=[Add,T_w];
end
end
