function [X, Y, SimuSetTrees, SimuSummary]= Simulation(base_rootdir, N, l, alpha, beta, proj)
%% %% Simulate the model
rootdir =  fullfile(base_rootdir, 'Processed_data');
files= dir( fullfile( rootdir, '*.mat'));

%% %%%%%%%%% Binomial %%%%%%%%%
Z=binornd(proj,alpha,1,1000); %%%%%% CHECK PARAMETERS
Corte=quantile(Z,1-beta);

%% Statiscal protocol
SimuSetTrees={};
SimuSetTrees{1,1}='Vol\Ryth'; SimuSetTrees{1,2}='Ter';SimuSetTrees{1,3}='Qua';
Y{1,1}='Vol\Ryth'; Y{1,2}='Ternary';Y{1,3}='Quaternary';
X{1,1}='Vol\Ryth'; X{1,2}='Ternary';X{1,3}='Quaternary';
%%
for v=1:length(files)
    load(fullfile( rootdir, files(v).name ) );
    X_ter=Valsa(N, 2);  %function
    X_qua=Samba(N, 2);  %function
    Vol=ALLEEG(1).setname(end-2:end);
    X{v+1,1}=Vol;
    X{v+1,2}=X_ter;
    X{v+1,3}=X_qua;
    SimuSetTrees{v+1,1}=Vol;
    Y{v+1,1}=Vol;
%%    %%%%%%%%  Bootstrap in Y %%%%%%%%%
    Yter={};
    Yter{1,1}=ALLEEG(3).data; %2
    d(1)= length(Yter{1,1}(1,1,:));
    Yter{2,1}=ALLEEG(10).data;%21
    d(2)= length(Yter{2,1}(1,1,:));
    Yter{3,1}=ALLEEG(8).data; %11 
    d(3)= length(Yter{3,1}(1,1,:));
    Yter{4,1}=ALLEEG(9).data; %01
    d(4)= length(Yter{4,1}(1,1,:));
    Yter{5,1}=ALLEEG(12).data; %20
    d(5)= length(Yter{5,1}(1,1,:));
    Yter{6,1}=ALLEEG(11).data; %10
    d(6)= length(Yter{6,1}(1,1,:));
    Yter{7,1}=ALLEEG(13).data; %00
    d(7)= length(Yter{7,1}(1,1,:));
    Yqua={};
    Yqua{1,1}=ALLEEG(26).data; %2
    D(1)= length(Yqua{1,1}(1,1,:));
    Yqua{2,1}=ALLEEG(32).data; %21
    D(2)= length(Yqua{2,1}(1,1,:));
    Yqua{3,1}=ALLEEG(31).data; %01
    D(3)= length(Yqua{3,1}(1,1,:));
    Yqua{4,1}=ALLEEG(34).data; %20
    D(4)= length(Yqua{4,1}(1,1,:));
    Yqua{5,1}=ALLEEG(33).data; %10
    D(5)= length(Yqua{5,1}(1,1,:));
    Yqua{6,1}=ALLEEG(41).data; %200
    D(6)= length(Yqua{6,1}(1,1,:));
    Yqua{7,1}=ALLEEG(40).data; %100
    D(7)= length(Yqua{7,1}(1,1,:));
    Yqua{8,1}=ALLEEG(35).data; %%% 00!!
    D(8)= length(Yqua{8,1}(1,1,:));
    %% Amostrar os dados
    
%%%%%%%%%%%%%%%%%%%% Ternary %%%%%%%
    Rythm='Ter';
    tau=[2,21,11,01,20,10,00];
    ctt=2;
    YBoots=[];
    for n=1:N
        ctt= Find_ctt(Rythm, ctt, X_ter(n));
        ind=strfind(tau,ctt);
        chunk=randsample(d(ind) ,1);
        YBoots(:,:,n)=Yter{ind,1}(:,:,chunk); %{vol, Ter}{elet, ctt}
    end
    Y{v+1,2}=YBoots;
    %%%%%%%%%%%%%%%%%%%% Quaternary %%%%%%%
    Rythm='Qua';
    tau=[2,21,01,20,10,200,100,000];
    ctt=2;
    YBoots=[];
    for n=1:N
        ctt= Find_ctt(Rythm, ctt, X_qua(n));
        ind=strfind(tau,ctt);
        chunk=randsample(D(ind),1);
        YBoots(:,:,n)=Yqua{ind,1}(:,:,chunk); %{vol, Ter}{elet, ctt}
    end
    Y{v+1,3}=YBoots;
    
    %% Tree estimation on the Bootstrap sample
    TerTrees={};
    QuaTrees={};
    for e=1:length(Y{v+1,2}(:,1,1))
        TerTrees{e}=TreeEstimator(X{v+1,2}, Y{v+1,2}(e,:,:), l, alpha, [0 1 2], proj, Corte);  %% Gera uma arvore K
        QuaTrees{e}=TreeEstimator(X{v+1,3}, Y{v+1,3}(e,:,:), l, alpha, [0 1 2], proj, Corte);  %% Gera uma arvore K
    end
    SimuSetTrees{v+1,2}=TerTrees;
    SimuSetTrees{v+1,3}=QuaTrees;
end
BinaryTrees = CountTrees(SimuSetTrees);
[SimuSummary , ~] = CountCtt(BinaryTrees);
end
