function [ EletBranches, TreeByElet] = TerTreeEstimation (ALLEEG,TerBranches,c,proj,Corte)
%% Estimating the Ternary context trees
NumElet=ALLEEG(1).nbchan;
for e=1:NumElet %%eletrodos
    Tree={};
    CountBranches=[];
    %% Testing branches with length 3
    for s=1:4
        Br=TerBranches{s,1};
        Y1_e=[];
        Y2_e=[];
        %% Seleciona os arquivos de EEGs
        ctt_1=Br(1);
        for i=3:25
            if isequal(char(ctt_1), ALLEEG(i).setname(1:3))
                Y1_e=ALLEEG(i).data(e,:,:);
            end
        end
        ctt_2=Br(2);
        for i=3:25
            if isequal(char(ctt_2), ALLEEG(i).setname(1:3))
                Y2_e=ALLEEG(i).data(e,:,:);
            end
        end
        %% Testa o ramo
        S=Statistic (Y1_e,Y2_e,[],c,proj);
        if S>=Corte %% leis diferentes
            CountBranches(s)=1;
            Tree=[Tree, Br];
        else CountBranches(s)=0;
        end
    end    
    %%  Testing {02,12}
    if CountBranches(1)+CountBranches(2)==0 %{012,112} + {002,120}
        Br=TerBranches{5,1};
        ctt_1=Br(1);
        for i=3:25
            if isequal(char(ctt_1), ALLEEG(i).setname(1:3))
                Y1_e=ALLEEG(i).data(e,:,:);
            end
        end
        ctt_2=Br(2);
        for i=3:25
            if isequal(char(ctt_2), ALLEEG(i).setname(1:3))
                Y2_e=ALLEEG(i).data(e,:,:);
            end
        end
        %% Testa o ramo
        S=Statistic (Y1_e,Y2_e,[],c,proj);
        if S>=Corte %% leis diferentes
            CountBranches(5)=1; %volutario,eletrodo,ramo
            Tree=[Tree, {'02','12'}];
        else CountBranches(5)=0;
        end
    elseif CountBranches(1)==0 && CountBranches(2)==1
        Tree=[Tree, {'12'}]; CountBranches(5)=0;
    elseif CountBranches(1)==1 && CountBranches(2)==0
        Tree=[Tree, {'02'}]; CountBranches(5)=0;
    elseif CountBranches(1)==1 && CountBranches(2)==1
        CountBranches(5)=0;
    end
    %%  Testa {01,11,21}
    if CountBranches(3)==0 %{021,121}
        Br=TerBranches{6,1};
        ctt_1=Br(1);
        for i=3:25
            if isequal(char(ctt_1), ALLEEG(i).setname(1:3))
                Y1_e=ALLEEG(i).data(e,:,:);
            end
        end
        ctt_2=Br(2);
        for i=3:25
            if isequal(char(ctt_2), ALLEEG(i).setname(1:3))
                Y2_e=ALLEEG(i).data(e,:,:);
            end
        end
        ctt_3=Br(3);
        for i=3:25
            if isequal(char(ctt_3), ALLEEG(i).setname(1:3))
                Y3_e=ALLEEG(i).data(e,:,:);
            end
        end
        %% Testa o ramo
        S=Statistic (Y1_e,Y2_e,Y3_e,c,proj);
        if S>=Corte %% leis diferentes
            CountBranches(6)=1; %volutario,eletrodo,ramo
            Tree=[Tree, {'01','11','21'}];
        else CountBranches(6)=0;
        end
    else Tree=[Tree, '01', '11']; CountBranches(6)=0;
    end
    %%  Testa {00,10,20}
    if CountBranches(4)==0 %{021,121}
        Br=TerBranches{7,1};
        ctt_1=Br(1);
        for i=3:25
            if isequal(char(ctt_1), ALLEEG(i).setname(1:3))
                Y1_e=ALLEEG(i).data(e,:,:);
            end
        end
        ctt_2=Br(2);
        for i=3:25
            if isequal(char(ctt_2), ALLEEG(i).setname(1:3))
                Y2_e=ALLEEG(i).data(e,:,:);
            end
        end
        ctt_3=Br(3);
        for i=3:25
            if isequal(char(ctt_3), ALLEEG(i).setname(1:3))
                Y3_e=ALLEEG(i).data(e,:,:);
            end
        end
        
        %% Testa o ramo
        S=Statistic (Y1_e,Y2_e,Y3_e,c,proj);
        if S>=Corte %% leis diferentes
            CountBranches(7)=1; %volutario,eletrodo,ramo
            Tree=[Tree, {'00','10','20'}];
        else CountBranches(7)=0;
        end
    else Tree=[Tree, '00','10'];CountBranches(7)=0;
    end
    %%  Testa {0,1,2}
    if sum(CountBranches(1:7))==0 %{021,121}
        Br=TerBranches{8,1};
        ctt_1=Br(1);
        for i=3:25
            if isequal(char(ctt_1), ALLEEG(i).setname(1:3))
                Y1_e=ALLEEG(i).data(e,:,:);
            end
        end
        ctt_2=Br(2);
        for i=3:25
            if isequal(char(ctt_2), ALLEEG(i).setname(1:3))
                Y2_e=ALLEEG(i).data(e,:,:);
            end
        end
        ctt_3=Br(3);
        for i=3:25
            if isequal(char(ctt_3), ALLEEG(i).setname(1:3))
                Y3_e=ALLEEG(i).data(e,:,:);
            end
        end
        
        %% Testa o ramo
        S= Statistic (Y1_e,Y2_e,Y3_e,c,proj);
        if S>=Corte %% leis diferentes
            CountBranches(8)=1; %volutario,eletrodo,ramo
            Tree=[Tree, {'0','1','2'}];
        else CountBranches(8)=0;
        end
    else
        CountBranches(8)=0;
        ind_2a=[1,2,5]; ind_2r=[3,4,6,7];
        ind_1a=[3,6]; ind_1r=[1,2,5,4,7];
        ind_0a=[4,7]; ind_0r=[1,2,3,6,5];
        if sum(CountBranches(ind_2a))==0 && sum(CountBranches(ind_2r))>0
            Tree=[Tree, '2']; end
        if sum(CountBranches(ind_1a))==0 && sum(CountBranches(ind_1r))>0
            Tree=[Tree, '1']; end
        if sum(CountBranches(ind_0a))==0 && sum(CountBranches(ind_0r))>0
            Tree=[Tree, '0'];
        end
    end
    TreeByElet{1,e}=Tree;
    EletBranches(e,:)=CountBranches;
end

end

