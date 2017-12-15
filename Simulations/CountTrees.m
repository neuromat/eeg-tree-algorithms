function BinaryTrees = CountTrees(SetTrees)
%%%%%% Para árvore de tamanho 3
BinaryTrees{1,1}=SetTrees{1,1};
BinaryTrees{1,2}='TerBynaryTree';
BinaryTrees{1,3}='QuaBynaryTree';
for v=2:length(SetTrees(:,1))
    BinaryTrees{v,1}=SetTrees{v,1};
    TerC=[];
    QuaC=[];
    for e=1:length(SetTrees{v,2})
        %%%%% Ternary %%%%%%%%%%%%%%%%%%
        TerTree=SetTrees{v,2}{e};
        d_T=length(TerTree);
        terc=zeros(1,8);
        if d_T==3
            terc(8)=1;
        elseif d_T>0
            for k=1:d_T
                if isequaln(TerTree{k},[1 1 2]) 
                    terc(1)=1;
                elseif isequaln(TerTree{k},[1 0 2])
                    terc(2)=1;
                elseif isequaln(TerTree{k},[1 2 1])
                    terc(3)=1;
                elseif isequaln(TerTree{k},[1 2 0])
                    terc(4)=1;
                elseif isequaln(TerTree{k},[2 1])
                    terc(6)=1;
                elseif isequaln(TerTree{k},[2 0])
                    terc(7)=1;
                end
            end
            for k=1:d_T
                if isequaln(TerTree{k},[1 2]) && terc(2)==0
                    terc(5)=1;
                end
            end
        end
        TerC(e,:)=terc;
        %%%%%% Quaternario
        QuaTree=SetTrees{v,3}{e};
        d_Q=length(QuaTree);
        quac=zeros(1,8);
        if d_Q==3
            quac(8)=1;
        elseif d_Q>0
            for k=1:d_Q
                if isequaln(QuaTree{k},[1 2 1]) 
                    quac(1)=1;
                elseif isequaln(QuaTree{k},[1 0 1])
                    quac(2)=1;
                elseif isequaln(QuaTree{k},[1 2 0])
                    quac(3)=1;
                elseif isequaln(QuaTree{k},[2 0 0])
                    quac(4)=1;
                elseif isequaln(QuaTree{k},[1 2])
                    quac(5)=1;
                end
            end
            for k=1:d_Q
                if isequaln(QuaTree{k},[2 1]) && quac(2)==0
                    quac(6)=1;
                end
                if isequaln(QuaTree{k},[0 0]) && quac(3)==0
                    quac(7)=1;
                end
            end
        end
        QuaC(e,:)=quac;
    end
    BinaryTrees{v,2}=TerC;
    BinaryTrees{v,3}=QuaC;
end
end