function EEG_Processing( base_rootdir, destdir)
 rootdir = fullfile( base_rootdir);
 if ~exist( destdir, 'dir' )
    mkdir( destdir );
end
 files = dir( fullfile( rootdir, '*.raw' ) );
%% PRE-PROCESSING
for k=1:length( files )
    clearvars -except k rootdir files destdir base_rootdir
    ALLEEG={};
    %% Importing
    EEG = pop_readegi( fullfile( rootdir, files(k).name ), [], [], 'GSN_HydroCel_129.sfp' );
    EEG.setname = files(k).name(1:end-4);
    EEG.filename=EEG.setname;
    volname=EEG.filename(1:3);
    %% Filtering
    HP = 1;
    LP = 30;
    ddata = double(EEG.data);
    order = 4;
    datafiltered = filterpass( ddata', HP,  EEG.srate, 'high',  order);
    datafiltered = filterpass( datafiltered, LP,  EEG.srate, 'low' , order);
    EEG.data = datafiltered';
    %% Channel Rejection and Rerefence
    std_fac = [-3 3];
    freqs = [1:29 59;2:30 61];
    freqs = reshape(freqs,2,size(freqs,2));
    [EEG_chan_rej indelec] = pop_rejchanspec( EEG, 'freqlims', freqs, 'stdthresh', repmat( std_fac, size(freqs,1), 1 ) );
    EEG_chan_rej = pop_reref( EEG_chan_rej,[] );
    EEG=EEG_chan_rej;
    %% Only 10_20 channel set
    Conj_10_20={'E9','E11','022','E24','E33','E36','E45','E52','E58','E62','E70','E83','E92', 'E96','E104','E108','E122','E124'};         
    EEG = pop_select( EEG, 'channel', Conj_10_20 );
    %% Sharing in blocks
    eventcells = squeeze( struct2cell( EEG.event ) );
    foundevents = find( strcmp( eventcells(1,:), 'sil ' ) ); % vetor das posicoes em que o evento aparace em eventcells
    indices = cell2mat( {EEG.event(foundevents).latency} ); % vetor das latências desse evento
    if length( indices ) > 13
        EEG_b1 = pop_select( EEG, 'point', [indices(1)  indices(14)] );
        EEG_b1.filename=['B1' EEG_b1.filename];
    else
        warning( sprintf( 'could not segment file %s, too small (less than 1 block)', files(k).name ) )
    end
    if length( indices ) > 28
        EEG_b2 = pop_select( EEG, 'point', [indices(15)  indices(29)] );
        EEG_b2.filename=['B2' EEG_b2.filename];
    else
        warning( sprintf( 'could not segment file %s, too small (less than 2 blocks)', files(k).name ) )
    end
    %% Sharing in Rythms
    indices = getEventPointsIndices( EEG_b1, 'sil ' ); %encontra as latencias dos sil's
    inds = strfind( files(k).name, '_' );
    ritmo = files(k).name(inds(end)+1);
    if strcmpi( ritmo , 'T' ),
       ritmo_nome = 'Ter';
       ind=1;
       elseif strcmpi( ritmo, 'Q' );
       ritmo_nome = 'Qua';
       ind=2;
       elseif strcmpi( ritmo, 'I' );
       ritmo_nome = 'Ind';
       ind=3;
    end
    EEG_ritmo = pop_select( EEG_b1, 'point', [indices(1)  indices(4)] );
    EEG_ritmo.filename=[ritmo_nome 'B1' EEG_ritmo.setname];
    ALLEEG_aux={};
    ALLEEG_aux=eeg_store(ALLEEG_aux,  EEG_ritmo,ind);
    ALLEEG_aux(ind).setname=[ritmo_nome 'B1' EEG.setname];
    for r=1:2
        ritmo = files(k).name(inds(end)+1+r);
        if strcmpi( ritmo , 'T' ),
           ritmo_nome = 'Ter'; ind=1;
           elseif strcmpi( ritmo, 'Q' );
           ritmo_nome = 'Qua'; ind=2;
           elseif strcmpi( ritmo, 'I' );
           ritmo_nome = 'Ind'; ind=3;
        end
        EEG_ritmo = pop_select( EEG_b1, 'point', [indices(r*5)  indices(4+5*r)] );
        EEG_ritmo.filename=[ritmo_nome 'B1' EEG_ritmo.setname];
        ALLEEG_aux=eeg_store(ALLEEG_aux,  EEG_ritmo,ind);
        ALLEEG_aux(ind).setname=[ritmo_nome 'B1' EEG.setname];
    end
    indices = getEventPointsIndices( EEG_b2, 'sil ' );
    ritmo = files(k).name(inds(end)+3);
    if strcmpi( ritmo , 'T' ),
       ritmo_nome = 'Ter'; ind=1;
       elseif strcmpi( ritmo, 'Q' );
       ritmo_nome = 'Qua'; ind=2;
       elseif strcmpi( ritmo, 'I' );
       ritmo_nome = 'Ind'; ind=3;
    end
    EEG_ritmo = pop_select( EEG_b2, 'point', [indices(2)  indices(5)] );
    EEG_ritmo.filename=[ritmo_nome 'B2' EEG_ritmo.setname];
    ALLEEG_aux=eeg_store(ALLEEG_aux,  EEG_ritmo,ind+3);
    ALLEEG_aux(ind+3).setname=[ritmo_nome 'B2' EEG.setname];
    for r=1:2
        ritmo = files(k).name(inds(end)+3-r);
        if strcmpi( ritmo , 'T' ),
          ritmo_nome = 'Ter'; ind=1;
        elseif strcmpi( ritmo, 'Q' );
          ritmo_nome = 'Qua'; ind=2;
        elseif strcmpi( ritmo, 'I' );
          ritmo_nome = 'Ind'; ind=3;
        end
        EEG_ritmo = pop_select( EEG_b2, 'point', [indices(r*5+2)  indices(5*(r+1))] );
        EEG_ritmo.filename=[ritmo_nome 'B2' EEG_ritmo.setname];
        ALLEEG_aux=eeg_store(ALLEEG_aux,  EEG_ritmo,ind+3);
        ALLEEG_aux(ind+3).setname=[ritmo_nome 'B2' EEG.setname];
    end
    %% Merging Dataset
    EEG_ter=pop_mergeset(ALLEEG_aux(1),ALLEEG_aux(4));
    ALLEEG=eeg_store(ALLEEG,  EEG_ter,1);
    ALLEEG(1).setname=['Ter' EEG_ter.filename(6:8)];

    EEG_qua=pop_mergeset(ALLEEG_aux(2),ALLEEG_aux(5));
    ALLEEG=eeg_store(ALLEEG,  EEG_qua,2);
    ALLEEG(2).setname=['Qua'  EEG_qua.filename(6:8)];
    %% Sharing by the strings of stimulus
    for m=1:2 %Rythm files
        %%%%%%%%% cutting single units events
        EEG_2=ALLEEG(m);
        EEG_2 = pop_epoch( EEG_2, {'v2  '} , [-0.05 0.4] );
        EEG_2 = pop_rmbase( EEG_2, [-50 0] );
        EEG_2.setname=[ '2_' ALLEEG(m).setname];
        ALLEEG=eeg_store(ALLEEG, EEG_2);
        
        EEG_1=ALLEEG(m);
        EEG_1 = pop_epoch( EEG_1, {'v1a ', 'v1b '} , [-0.05 0.4] );
        EEG_1 = pop_rmbase( EEG_1, [-50 0] );
        EEG_1.setname=[ '1_' ALLEEG(m).setname];
        ALLEEG=eeg_store(ALLEEG, EEG_1);
       
        EEG_0=ALLEEG(m);
        if ~isempty( strfind( EEG_0.setname, 'Ter' ) )
            EEG_0=ALLEEG(m);
            EEG_0 = pop_epoch( EEG_0, {'miss'} , [-0.05 0.4] );
            EEG_0 = pop_rmbase( EEG_0, [-50 0] );
            EEG_0.setname=[ '0_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_0);
        elseif ~isempty( strfind( EEG_0.setname, 'Qua' ) )
            EEG_0=ALLEEG(m);
            EEG_0 = pop_epoch( EEG_0, {'miss', 'v0  ' } , [-0.05 0.4] );
            EEG_0 = pop_rmbase( EEG_0, [-50 0] );
            EEG_0.setname=[ '0_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_0);
        end
        %%
        %%%%%%%%% cutting the x2 strings
        EEG_x2 = ALLEEG(m);
        ind_12=[];
        ind_02=[];
        for j=2:length(EEG_x2.event)
            if strcmp(EEG_x2.event(1,j).type,'v2  ') && strcmp(EEG_x2.event(1,j-1).type,'v1b ');
                ind_12=[ind_12, j];
            elseif strcmp(EEG_x2.event(1,j).type,'v2  ') && strcmp(EEG_x2.event(1,j-1).type,'miss');
                ind_02=[ind_02, j];
            end
        end
        aux=[];
        EEG_clean12 = EEG_x2;
        for j=1:length(EEG_x2.event)
            if ~ismember(j,ind_12);
                aux=[aux,j];
            end
        end
        EEG_clean12.event(aux)=[];
        EEG_12 = pop_epoch( EEG_clean12, {'v2  '} , [-0.05 0.4] );
        EEG_12 = pop_rmbase( EEG_12, [-50 0] );
        EEG_12.setname=[ '12_' ALLEEG(m).setname];
        ALLEEG=eeg_store(ALLEEG, EEG_12);
        aux=[];
        EEG_clean02 = EEG_x2;
        for j=1:length(EEG_x2.event)
            if ~ismember(j,ind_02);
                aux=[aux,j];
            end
        end
        EEG_clean02.event(aux)=[];
        EEG_02 = pop_epoch( EEG_clean02, {'v2  '}, [-0.05 0.4]);
        EEG_02 = pop_rmbase( EEG_02, [-50 0] );
        EEG_02.setname=[ '02_' ALLEEG(m).setname];
        ALLEEG=eeg_store(ALLEEG, EEG_02);
        %%%%%%%%% cutting the x1 strings
        EEG_x1 = ALLEEG(m);
        ind_11=[];
        ind_01=[];
        ind_21=[];
        if ~isempty( strfind( EEG_x1.setname, 'Ter' ) )
            for j=2:length(EEG_x1.event)
                if strcmp(EEG_x1.event(1,j).type,'v1b ') && strcmp(EEG_x1.event(1,j-1).type,'miss');
                    ind_01=[ind_01, j];
                elseif strcmp(EEG_x1.event(1,j).type,'v1b ') && strcmp(EEG_x1.event(1,j-1).type,'v1a ');
                    ind_11=[ind_11, j];
                elseif strcmp(EEG_x1.event(1,j).type,'v1a ');
                    ind_21=[ind_21, j];
                end
            end
            aux=[];
            EEG_clean11 = EEG_x1;
            for j=1:length(EEG_x1.event)
                if ~ismember(j,ind_11);
                    aux=[aux,j];
                end
            end
            EEG_clean11.event(aux)=[];
            EEG_11 = pop_epoch( EEG_clean11, {'v1b '} , [-0.05 0.4] );
            EEG_11 = pop_rmbase( EEG_11, [-50 0] );
            EEG_11.setname=[ '11_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_11);
            aux=[];
            EEG_clean01 = EEG_x1;
            for j=1:length(EEG_x1.event)
                if ~ismember(j,ind_01);
                    aux=[aux,j];
                end
            end
            EEG_clean01.event(aux)=[];
            EEG_01 = pop_epoch( EEG_clean01, {'v1b '} , [-0.05 0.4] );
            EEG_01 = pop_rmbase( EEG_01, [-50 0] );
            EEG_01.setname=[ '01_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_01);
            aux=[];
            EEG_clean21 = EEG_x1;
            for j=1:length(EEG_x1.event)
                if ~ismember(j,ind_21);
                    aux=[aux,j];
                end
            end
            EEG_clean21.event(aux)=[];
            EEG_21 = pop_epoch( EEG_clean21, {'v1a '} , [-0.05 0.4] );
            EEG_21 = pop_rmbase( EEG_21, [-50 0] );
            EEG_21.setname=[ '21_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_21);
        end
        if ~isempty( strfind( EEG_x1.setname, 'Qua' ) )
            for j=3:length(EEG_x1.event)
                if strcmp(EEG_x1.event(1,j).type,'v1b ');
                    ind_01=[ind_01, j];
                elseif strcmp(EEG_x1.event(1,j).type,'v1a ');
                    ind_21=[ind_21, j];
                end
            end
            aux=[];
            EEG_clean01 = EEG_x1;
            for j=1:length(EEG_x1.event)
                if ~ismember(j,ind_01);
                    aux=[aux,j];
                end
            end
            EEG_clean01.event(aux)=[];
            EEG_01 = pop_epoch( EEG_clean01, {'v1b '} , [-0.05 0.4]);
            EEG_01 = pop_rmbase( EEG_01, [-50 0] );
            EEG_01.setname=[ '01_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_01);
            aux=[];
            EEG_clean21 = EEG_x1;
            for j=1:length(EEG_x1.event)
                if ~ismember(j,ind_21);
                    aux=[aux,j];
                end
            end
            EEG_clean21.event(aux)=[];
            EEG_21 = pop_epoch( EEG_clean21, {'v1a '} , [-0.05 0.4] );
            EEG_21 = pop_rmbase( EEG_21, [-50 0] );
            EEG_21.setname=[ '21_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_21);
        end
        %%%%%%%%% cutting the x0 strings
        EEG_x0 = ALLEEG(m);
        if ~isempty( strfind( EEG_x0.setname, 'Ter' ) )
            ind_10=[];
            ind_20=[];
            ind_00=[];
            for j=3:length(EEG_x0.event)
                if strcmp(EEG_x0.event(1,j).type,'miss') && strcmp(EEG_x0.event(1,j-1).type,'v1a ');
                    ind_10=[ind_10, j];
                elseif strcmp(EEG_x0.event(1,j).type,'miss') && strcmp(EEG_x0.event(1,j-1).type,'v2  ');
                    ind_20=[ind_20, j];
                elseif strcmp(EEG_x0.event(1,j).type,'miss') && strcmp(EEG_x0.event(1,j-1).type,'miss');
                    ind_00=[ind_00, j];
                end
            end
            aux=[];
            EEG_clean10 = EEG_x0;
            for j=1:length(EEG_x0.event)
                if ~ismember(j,ind_10);
                    aux=[aux,j];
                end
            end
            EEG_clean10.event(aux)=[];
            EEG_10 = pop_epoch( EEG_clean10, {'miss'} , [-0.05 0.4] );
            EEG_10 = pop_rmbase( EEG_10, [-50 0] );
            EEG_10.setname=[ '10_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_10);
            aux=[];
            EEG_clean20 = EEG_x0;
            for j=1:length(EEG_x0.event)
                if ~ismember(j,ind_20);
                    aux=[aux,j];
                end
            end
            EEG_clean20.event(aux)=[];
            EEG_20 = pop_epoch( EEG_clean20, {'miss'} , [-0.05 0.4] );
            EEG_20 = pop_rmbase( EEG_20, [-50 0] );
            EEG_20.setname=[ '20_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_20);
            aux=[];
            EEG_clean00 = EEG_x0;
            for j=1:length(EEG_x0.event)
                if ~ismember(j,ind_00);
                    aux=[aux,j];
                end
            end
            EEG_clean00.event(aux)=[];
            EEG_00 = pop_epoch( EEG_clean00, {'miss'} , [-0.05 0.4] );
            EEG_00 = pop_rmbase( EEG_00, [-50 0] );
            EEG_00.setname=[ '00_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_00);
        end
        if ~isempty( strfind( EEG_x0.setname, 'Qua' ) )
            ind_10=[];
            ind_20=[];
            ind_00=[];
            for j=3:length(EEG_x0.event)
                if strcmp(EEG_x0.event(1,j).type,'v0  ') && strcmp(EEG_x0.event(1,j-1).type,'v1a ');
                    ind_10=[ind_10, j];
                elseif strcmp(EEG_x0.event(1,j).type,'miss') && strcmp(EEG_x0.event(1,j-1).type,'v2  ');
                    ind_20=[ind_20, j];
                elseif strcmp(EEG_x0.event(1,j).type,'miss') && strcmp(EEG_x0.event(1,j-1).type,'v0  ');
                    ind_00=[ind_00, j];
                elseif strcmp(EEG_x0.event(1,j).type,'v0  ') && strcmp(EEG_x0.event(1,j-1).type,'miss');
                    ind_00=[ind_00, j];
                end
            end
            aux=[];
            EEG_clean10 = EEG_x0;
            for j=1:length(EEG_x0.event)
                if ~ismember(j,ind_10);
                    aux=[aux,j];
                end
            end
            EEG_clean10.event(aux)=[];
            EEG_10 = pop_epoch( EEG_clean10, {'v0  '} , [-0.05 0.4] );
            EEG_10 = pop_rmbase( EEG_10, [-50 0] );
            EEG_10.setname=[ '10_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_10);
            aux=[];
            EEG_clean20 = EEG_x0;
            for j=1:length(EEG_x0.event)
                if ~ismember(j,ind_20);
                    aux=[aux,j];
                end
            end
            EEG_clean20.event(aux)=[];
            EEG_20 = pop_epoch( EEG_clean20, {'miss'} , [-0.05 0.4] );
            EEG_20 = pop_rmbase( EEG_20, [-50 0] );
            EEG_20.setname=[ '20_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_20);
            aux=[];
            EEG_clean00 = EEG_x0;
            for j=1:length(EEG_x0.event)
                if ~ismember(j,ind_00);
                    aux=[aux,j];
                end
            end
            EEG_clean00.event(aux)=[];
            EEG_00 = pop_epoch( EEG_clean00, {'miss','v0  '}, [-0.05 0.4]);
            EEG_00 = pop_rmbase( EEG_00, [-50 0] );
            EEG_00.setname=[ '00_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_00);
        end
        %%%%%%%%% cutting the xx2 strings
        EEG_xx2 = ALLEEG(m);
        if ~isempty( strfind( EEG_xx2.setname, 'Ter' ) )
            ind_002=[];
            ind_102=[];
            ind_012=[];
            ind_112=[];
            for j=3:length(EEG_xx2.event)
                if strcmp(EEG_xx2.event(1,j-1).type,'miss') && strcmp(EEG_xx2.event(1,j-2).type,'miss');
                    ind_002=[ind_002, j];
                elseif strcmp(EEG_xx2.event(1,j-1).type,'miss') && strcmp(EEG_xx2.event(1,j-2).type,'v1a ');
                    ind_102=[ind_102, j];
                elseif strcmp(EEG_xx2.event(1,j-1).type,'v1b ') && strcmp(EEG_xx2.event(1,j-2).type,'miss');
                    ind_012=[ind_012, j];
                elseif strcmp(EEG_xx2.event(1,j-1).type,'v1b ') && strcmp(EEG_xx2.event(1,j-2).type,'v1a ');
                    ind_112=[ind_112, j];
                end
            end
            if ~isempty(ind_002)
                aux=[];
                EEG_clean002 = EEG_xx2;
                for j=1:length(EEG_xx2.event)
                    if ~ismember(j,ind_002);
                        aux=[aux,j];
                    end
                end
                EEG_clean002.event(aux)=[];
                EEG_002 = pop_epoch( EEG_clean002, {'v2  '} , [-0.05 0.4] );
                EEG_002 = pop_rmbase( EEG_002, [-50 0] );
                EEG_002.setname=[ '002_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_002);
            end
            if ~isempty(ind_102)
                aux=[];
                EEG_clean102 = EEG_xx2;
                for j=1:length(EEG_xx2.event)
                    if ~ismember(j,ind_102);
                        aux=[aux,j];
                    end
                end
                EEG_clean102.event(aux)=[];
                EEG_102 = pop_epoch( EEG_clean102, {'v2  '} , [-0.05 0.4] );
                EEG_102 = pop_rmbase( EEG_102, [-50 0] );
                EEG_102.setname=[ '102_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_102);
            end
            if ~isempty(ind_012)
                aux=[];
                EEG_clean012 = EEG_xx2;
                for j=1:length(EEG_xx2.event)
                    if ~ismember(j,ind_012);
                        aux=[aux,j];
                    end
                end
                EEG_clean012.event(aux)=[];
                EEG_012 = pop_epoch( EEG_clean012, {'v2  '} , [-0.05 0.4] );
                EEG_012 = pop_rmbase( EEG_012, [-50 0] );
                EEG_012.setname=[ '012_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_012);
            end
            
            if ~isempty(ind_112)
                aux=[];
                EEG_clean112 = EEG_xx2;
                for j=1:length(EEG_xx2.event)
                    if ~ismember(j,ind_112);
                        aux=[aux,j];
                    end
                end
                EEG_clean112.event(aux)=[];
                EEG_112 = pop_epoch( EEG_clean112, {'v2  '} , [-0.05 0.4] );
                EEG_112 = pop_rmbase( EEG_112, [-50 0] );
                EEG_112.setname=[ '112_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_112);
            end
        end
        %%%%%%%%% cutting the xx1 strings
        EEG_xx1 = ALLEEG(m);
        if ~isempty( strfind( EEG_xx1.setname, 'Ter' ) )
            ind_211=[];
            ind_201=[];
            ind_121=[];
            ind_021=[];
            for j=3:length(EEG_xx1.event)
                if strcmp(EEG_xx1.event(1,j).type,'v1b ') && strcmp(EEG_xx1.event(1,j-1).type,'v1a ');
                    ind_211=[ind_211, j];
                elseif strcmp(EEG_xx1.event(1,j).type,'v1b ') && strcmp(EEG_xx1.event(1,j-1).type,'miss');
                    ind_201=[ind_201, j];
                elseif strcmp(EEG_xx1.event(1,j).type,'v1a ') && strcmp(EEG_xx1.event(1,j-2).type,'v1b ');
                    ind_121=[ind_121, j];
                elseif strcmp(EEG_xx1.event(1,j).type,'v1a ') && strcmp(EEG_xx1.event(1,j-2).type,'miss');
                    ind_021=[ind_021, j];
                end
            end
            aux=[];
            EEG_clean211 = EEG_xx1;
            for j=1:length(EEG_xx1.event)
                if ~ismember(j,ind_211);
                    aux=[aux,j];
                end
            end
            EEG_clean211.event(aux)=[];
            EEG_211 = pop_epoch( EEG_clean211, {'v1b '} , [-0.05 0.4]);
            EEG_211 = pop_rmbase( EEG_211, [-50 0] );
            EEG_211.setname=[ '211_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_211);
            aux=[];
            EEG_clean201 = EEG_xx1;
            for j=1:length(EEG_xx1.event)
                if ~ismember(j,ind_201);
                    aux=[aux,j];
                end
            end
            EEG_clean201.event(aux)=[];
            EEG_201 = pop_epoch( EEG_clean201, {'v1b '} , [-0.05 0.4]);
            EEG_201 = pop_rmbase( EEG_201, [-50 0] );
            EEG_201.setname=[ '201_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_201);
            aux=[];
            EEG_clean121 = EEG_xx1;
            for j=1:length(EEG_xx1.event)
                if ~ismember(j,ind_121);
                    aux=[aux,j];
                end
            end
            EEG_clean121.event(aux)=[];
            EEG_121 = pop_epoch( EEG_clean121, {'v1a '} , [-0.05 0.4]);
            EEG_121 = pop_rmbase( EEG_121, [-50 0] );
            EEG_121.setname=[ '121_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_121);
            aux=[];
            EEG_clean021 = EEG_xx1;
            for j=1:length(EEG_xx1.event)
                if ~ismember(j,ind_021);
                    aux=[aux,j];
                end
            end
            EEG_clean021.event(aux)=[];
            EEG_021 = pop_epoch( EEG_clean021, {'v1a '} , [-0.05 0.4] );
            EEG_021 = pop_rmbase( EEG_021, [-50 0] );
            EEG_021.setname=[ '021_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_021);
        end
        if ~isempty( strfind( EEG_xx1.setname, 'Qua' ) )
            ind_101=[];
            ind_001=[];
            ind_121=[];
            ind_021=[];
            for j=3:length(EEG_xx1.event)
                if strcmp(EEG_xx1.event(1,j).type,'v1b ') && strcmp(EEG_xx1.event(1,j-2).type,'v1a ');
                    ind_101=[ind_101, j];
                elseif strcmp(EEG_xx1.event(1,j).type,'v1b ') && strcmp(EEG_xx1.event(1,j-2).type,'miss');
                    ind_001=[ind_001, j];
                elseif strcmp(EEG_xx1.event(1,j).type,'v1a ') && strcmp(EEG_xx1.event(1,j-2).type,'v1b ');
                    ind_121=[ind_121, j];
                elseif strcmp(EEG_xx1.event(1,j).type,'v1a ') && strcmp(EEG_xx1.event(1,j-2).type,'miss');
                    ind_021=[ind_021, j];
                end
            end
            aux=[];
            EEG_clean101 = EEG_xx1;
            for j=1:length(EEG_xx1.event)
                if ~ismember(j,ind_101);
                    aux=[aux,j];
                end
            end
            EEG_clean101.event(aux)=[];
            EEG_101 = pop_epoch( EEG_clean101, {'v1b '} , [-0.05 0.4] );
            EEG_101 = pop_rmbase( EEG_101, [-50 0] );
            EEG_101.setname=[ '101_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_101);
            aux=[];
            EEG_clean001 = EEG_xx1;
            for j=1:length(EEG_xx1.event)
                if ~ismember(j,ind_001);
                    aux=[aux,j];
                end
            end
            EEG_clean001.event(aux)=[];
            EEG_001 = pop_epoch( EEG_clean001, {'v1b '} , [-0.05 0.4] );
            EEG_001 = pop_rmbase( EEG_001, [-50 0] );
            EEG_001.setname=[ '001_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_001);
            aux=[];
            EEG_clean121 = EEG_xx1;
            for j=1:length(EEG_xx1.event)
                if ~ismember(j,ind_121);
                    aux=[aux,j];
                end
            end
            EEG_clean121.event(aux)=[];
            EEG_121 = pop_epoch( EEG_clean121, {'v1a '} , [-0.05 0.4] );
            EEG_121 = pop_rmbase( EEG_121, [-50 0] );
            EEG_121.setname=[ '121_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_121);
            aux=[];
            EEG_clean021 = EEG_xx1;
            for j=1:length(EEG_xx1.event)
                if ~ismember(j,ind_021);
                    aux=[aux,j];
                end
            end
            EEG_clean021.event(aux)=[];
            EEG_021 = pop_epoch( EEG_clean021, {'v1a '} , [-0.05 0.4] );
            EEG_021 = pop_rmbase( EEG_021, [-50 0] );
            EEG_021.setname=[ '021_' ALLEEG(m).setname];
            ALLEEG=eeg_store(ALLEEG, EEG_021);
        end
        %%%%%%%%% cutting the xx0 strings
        EEG_xx0 = ALLEEG(m);
        if ~isempty( strfind( EEG_xx0.setname, 'Qua' ) )
            ind_100=[];
            ind_200=[];
            ind_120=[];
            ind_020=[];
            for j=3:length(EEG_xx0.event)
                if strcmp(EEG_xx0.event(1,j).type,'miss') && strcmp(EEG_xx0.event(1,j-2).type,'v1a ');
                    ind_100=[ind_100, j];
                elseif strcmp(EEG_xx0.event(1,j).type,'v0  ') && strcmp(EEG_xx0.event(1,j-1).type,'miss');
                    ind_200=[ind_200, j];
                elseif strcmp(EEG_xx0.event(1,j).type,'miss') && strcmp(EEG_xx0.event(1,j-2).type,'v1b ');
                    ind_120=[ind_120, j];
                elseif strcmp(EEG_xx0.event(1,j).type,'miss') && strcmp(EEG_xx0.event(1,j-1).type,'v2  ') && strcmp(EEG_xx0.event(1,j-2).type,'miss');
                    ind_020=[ind_020, j];
                end
            end
            if ~isempty(ind_100)
                aux=[];
                EEG_clean100 = EEG_xx0;
                for j=1:length(EEG_xx0.event)
                    if ~ismember(j,ind_100);
                        aux=[aux,j];
                    end
                end
                EEG_clean100.event(aux)=[];
                EEG_100 = pop_epoch( EEG_clean100, {'miss'} , [-0.05 0.4] );
                EEG_100 = pop_rmbase( EEG_100, [-50 0] );
                EEG_100.setname=[ '100_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_100);
            end
            
            if ~isempty(ind_200)
                aux=[];
                EEG_clean200 = EEG_xx0;
                for j=1:length(EEG_xx0.event)
                    if ~ismember(j,ind_200);
                        aux=[aux,j];
                    end
                end
                EEG_clean200.event(aux)=[];
                EEG_200 = pop_epoch( EEG_clean200, {'v0  '} , [-0.05 0.4] );
                EEG_200 = pop_rmbase( EEG_200, [-50 0] );
                EEG_200.setname=[ '200_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_200);
            end
            
            if ~isempty(ind_120)
                aux=[];
                EEG_clean120 = EEG_xx0;
                for j=1:length(EEG_xx0.event)
                    if ~ismember(j,ind_120);
                        aux=[aux,j];
                    end
                end
                EEG_clean120.event(aux)=[];
                EEG_120 = pop_epoch( EEG_clean120, {'miss'} , [-0.05 0.4] );
                EEG_120 = pop_rmbase( EEG_120, [-50 0] );
                EEG_120.setname=[ '120_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_120);
            end
            if ~isempty(ind_020)
                aux=[];
                EEG_clean020 = EEG_xx0;
                for j=1:length(EEG_xx0.event)
                    if ~ismember(j,ind_020);
                        aux=[aux,j];
                    end
                end
                EEG_clean020.event(aux)=[];
                EEG_020 = pop_epoch( EEG_clean020, {'miss'} , [-0.05 0.4] );
                EEG_020 = pop_rmbase( EEG_020, [-50 0] );
                EEG_020.setname=[ '020_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_020);
            end
        end
        if ~isempty(strfind( EEG_xx0.setname, 'Ter' ) )
            ind_120=[];
            ind_020=[];
            ind_200=[];
            ind_210=[];
            for j=3:length(EEG_xx0.event)
                if strcmp(EEG_xx0.event(1,j).type,'miss') && strcmp(EEG_xx0.event(1,j-2).type,'v1b ');
                    ind_120=[ind_120, j];
                elseif strcmp(EEG_xx0.event(1,j).type,'miss') && strcmp(EEG_xx0.event(1,j-2).type,'miss');
                    ind_020=[ind_020, j];
                elseif strcmp(EEG_xx0.event(1,j).type,'miss') && strcmp(EEG_xx0.event(1,j-1).type,'miss');
                    ind_200=[ind_200, j];
                elseif strcmp(EEG_xx0.event(1,j).type,'miss') && strcmp(EEG_xx0.event(1,j-1).type,'v1a ');
                    ind_210=[ind_210, j];
                end
            end
            if ~isempty(ind_120)
                aux=[];
                EEG_clean120 = EEG_xx0;
                for j=1:length(EEG_xx0.event)
                    if ~ismember(j,ind_120);
                        aux=[aux,j];
                    end
                end
                EEG_clean120.event(aux)=[];
                EEG_120 = pop_epoch( EEG_clean120, {'miss'} , [-0.05 0.4] );
                EEG_120 = pop_rmbase( EEG_120, [-50 0] );
                EEG_120.setname=[ '120_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_120);
            end
            
            if ~isempty(ind_020)
                aux=[];
                EEG_clean020 = EEG_xx0;
                for j=1:length(EEG_xx0.event)
                    if ~ismember(j,ind_020);
                        aux=[aux,j];
                    end
                end
                EEG_clean020.event(aux)=[];
                EEG_020 = pop_epoch( EEG_clean020, {'miss'} , [-0.05 0.4]);
                EEG_020 = pop_rmbase( EEG_020, [-50 0] );
                EEG_020.setname=[ '020_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_020);
            end
            if ~isempty(ind_200)
                aux=[];
                EEG_clean200 = EEG_xx0;
                for j=1:length(EEG_xx0.event)
                    if ~ismember(j,ind_200);
                        aux=[aux,j];
                    end
                end
                EEG_clean200.event(aux)=[];
                EEG_200 = pop_epoch( EEG_clean200, {'miss'} , [-0.05 0.4] );
                EEG_200 = pop_rmbase( EEG_200, [-50 0] );
                EEG_200.setname=[ '200_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_200);
            end
            if ~isempty(ind_210)
                aux=[];
                EEG_clean210 = EEG_xx0;
                for j=1:length(EEG_xx0.event)
                    if ~ismember(j,ind_210);
                        aux=[aux,j];
                    end
                end
                EEG_clean210.event(aux)=[];
                EEG_210 = pop_epoch( EEG_clean210, {'miss'} , [-0.05 0.4]);
                EEG_210 = pop_rmbase( EEG_210, [-50 0] );
                EEG_210.setname=[ '210_' ALLEEG(m).setname];
                ALLEEG=eeg_store(ALLEEG, EEG_210);
            end
        end
    end
    cd(destdir);
    filename=['Data_' volname];
    save( filename, 'ALLEEG');
    cd(fullfile( base_rootdir));
end

end