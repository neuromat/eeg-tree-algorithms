function [Summary, SetInd] = CountCtt(BinaryTrees)
Summary={};
Summary{1,1}='Rithm';
Summary{2,1}='Vol/Ctt';
Summary{1,2}='Ter';
Summary{1,3}='Ter';
Summary{1,4}='Ter';
Summary{1,5}='Ter';

Summary{2,2}='NonEmpty';
Summary{2,3}='2ctt';
Summary{2,4}='1Nctt';
Summary{2,5}='0Nctt';

Summary{1,6}='Qua';
Summary{1,7}='Qua';
Summary{1,8}='Qua';
Summary{1,9}='Qua';
Summary{1,10}='Qua';

Summary{2,6}='NonEmpty';
Summary{2,7}='2ctt';
Summary{2,8}='1Nctt';
Summary{2,9}='0Nctt';
Summary{2,10}='00Nctt';

SetInd=Summary;
%%
Cont2=0;Cont1=0;Cont0=0;Cont20=0;
cont2=0;cont1=0;cont0=0;cont00=0;
d=size(BinaryTrees);
for v=1:d(1)-1
%%    %%%%% Ternary %%%%%%
    CountTerBr=BinaryTrees{v+1,2}; %% Matriz resumo
    Summary{v+2,1}=BinaryTrees{v+1,1};
    ind_2a=[1,2,5]; ind_2r=[3,4,6,7,8];
    ind_1r=[3,6];
    ind_0r=[4,7];
    TEmptyInd=[];
    TEmptyCount=0;
    T2Ind=[];
    T1NInd=[];
    T0NInd=[];
    T2Count=0;
    T1NCount=0;
    T0NCount=0;
    
    D=size(CountTerBr);
    for e=1:D(1)
        Tree_e=CountTerBr(e,:);
        S=sum(Tree_e);
        if S==0
            TEmptyInd=[TEmptyInd,e];
            TEmptyCount=TEmptyCount+1;
            continue
        elseif S>0 && sum(Tree_e(ind_2a))==0 
            T2Count=T2Count+1;
            T2Ind=[T2Ind,e];
        end
        if sum(Tree_e(ind_1r))>0
            T1NInd=[T1NInd,e];
            T1NCount=T1NCount+1;
        end
        
        if sum(Tree_e(ind_0r))>0
            T0NInd=[T0NInd,e];
            T0NCount=T0NCount+1;
        else
        end

    end
    Summary{v+2,2}=D(1) - TEmptyCount;
    Summary{v+2,3}=T2Count;
    Summary{v+2,4}=T1NCount;
    Summary{v+2,5}=T0NCount;
    
    SetInd{v+2,2}=TEmptyInd;
    SetInd{v+2,3}=T2Ind;
    SetInd{v+2,4}=T1NInd;
    SetInd{v+2,5}=T0NInd;
    %%    %%%% Quaternary
    CountQuaBr=BinaryTrees{v+1,3};
    ind_2a=5; ind_2r=[1,2,3,4,6,7,8];
    ind_1r=[1,2,6];
    ind_0r=[7,4,3];
    QEmptyInd=[];
    QEmptyCount=0;
    Q2Ind=[];
    Q1NInd=[];
    Q0NInd=[];
    Q00NInd=[];
    Q2Count=0;
    Q1NCount=0;
    Q0NCount=0;
    Q00NCount=0;
   
    D=size(CountQuaBr);
    for e=1:D(1)
        Tree_e=CountQuaBr(e,:);
        S=sum(Tree_e);
        if S==0
            QEmptyInd=[QEmptyInd,e];
            QEmptyCount=QEmptyCount+1;
            continue
        elseif S>0 && sum(Tree_e(ind_2a))==0 
            Q2Count=Q2Count+1;
            Q2Ind=[Q2Ind,e];
            
        end
        if sum(Tree_e(ind_1r))>0
            Q1NInd=[Q1NInd,e];
            Q1NCount=Q1NCount+1;
        end
        
        if sum(Tree_e(ind_0r))>0
            Q0NInd=[Q0NInd,e];
            Q0NCount=Q0NCount+1;
            if Tree_e(4)>0
                Q00NInd=[Q00NInd,e];
                Q00NCount=Q00NCount+1;
            end
        end
               
    end
    Summary{v+2,6}=D(1)-QEmptyCount;
    Summary{v+2,7}=Q2Count;
    Summary{v+2,8}=Q1NCount;
    Summary{v+2,9}=Q0NCount;
    Summary{v+2,10}=Q00NCount;

    SetInd{v+2,6}=QEmptyInd;
    SetInd{v+2,7}=Q2Ind;
    SetInd{v+2,8}=Q1NInd;
    SetInd{v+2,9}=Q0NInd;
    SetInd{v+2,10}=Q00NInd; 
end 

end
    
    
    