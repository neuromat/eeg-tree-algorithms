function [SetTrees, Summary]=EEGTrees(base_rootdir, proj, alpha, beta)

% clearvars -except base_rootdir
rootdir = fullfile( base_rootdir, 'Processed_data');
files =  dir( fullfile( rootdir, '*.mat' ) );

c=sqrt(-1/2*(log(alpha/2)));
Z=binornd(proj,alpha,1,1000); %%%%%% CHECK PARAMETERS
Corte=quantile(Z,1-beta); %num. de rejeicoes aceitaveis das 100 projecoes
%%
SetTrees={};
SetTrees{1,1}='Vol\Trees';
SetTrees{1,2}='TerByElet';
SetTrees{1,3}='QuaByElet';
BinaryTrees={};
BinaryTrees{1,1}='Vol\Trees';
BinaryTrees{1,2}='TerBinary';
BinaryTrees{1,3}='QuaBinary';
%%
for v=1:length(files)
    clearvars -except v rootdir files  c proj Corte SetTrees Branches alpha beta BinaryTrees
    load(fullfile( rootdir, files(v).name ) );
    Vol=ALLEEG(1).setname(4:end);
    SetTrees{v+1,1}=Vol;
    %% Ternary Context trees
    TerTreeByElet={};
    Branches={{'112','012'};
        {'002','102'};
        {'121','021'};
        {'120','020'};
        {'12_','02_'};
        {'01_','11_','21_'};
        {'00_','10_','20_'};
        {'0_T','1_T','2_T'}
        };
    %% Estimating the Ternary context trees
    [TerEletBranches, TerTreeByElet] = TerTreeEstimation(ALLEEG,Branches,c,proj,Corte);
    SetTrees{v+1,2}=TerTreeByElet;
    BinaryTrees{v+1,2}=TerEletBranches;
    %% Quaternary Context Trees
    QuaTreeByElet={};
    QuaEletBranches=[];
    Branches={{'121','021'};
        {'101','001'};
        {'120','020'};
        {'200','100','000',};
        {'12_','02_'};
        {'01_','21_'};
        {'00_','10_','20_'};
        {'0_Q','1_Q','2_Q'}
        };
    %% Estimating the Ternary context trees
    [QuaEletBranches, QuaTreeByElet] = QuaTreeEstimation (ALLEEG,Branches,c,proj,Corte);
    SetTrees{v+1,3}=QuaTreeByElet;
    BinaryTrees{v+1,3}=QuaEletBranches;
    disp(Vol);
end

[Summary, ~] = CountCtt(BinaryTrees);
end

% save(NameToSave,'SetTrees', 'Resumo', 'SetInd', 'Corte', 'criterio', 'proj' , 'c', 'Ecorte', 'alpha', 'Bootstrap' , 'beta' )