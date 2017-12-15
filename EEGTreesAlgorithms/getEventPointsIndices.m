function pointIndices = getEventPointsIndices( EEG, eventtype )

eventcells = squeeze( struct2cell( EEG.event ) );
foundevents = find( strcmp( eventcells(1,:), eventtype ) ); % vetor das posicoes em que o evento aparace em eventcells
pointIndices = cell2mat( {EEG.event(foundevents).latency} ); % vetor das latências desse evento

end



%%  Legenda
% squeeze = diminui a dimencao do EEG.event
% struct2cell = Gera uma matriz com 3 linhas: L1 - eventos (sil, v2, v1, miss, ...)
%                                             L2 - latencia
%                                             L3 - ordem numérica em que o
%                                                  evento ocorre
% find = retorna a posicao do objeto procurado
% strcmp = compara sequencias