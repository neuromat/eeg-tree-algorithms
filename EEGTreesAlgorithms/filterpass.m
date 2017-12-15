% data time_points x variable
% type ='high', 'low' or 'stop'
% is stop, cutoff_freq must be 1x2
function y = filterpass( data, cutoff_freq, sample_rate, type, order ) 
%                        EEG     1/30          250    high/low   4
if nargin < 5
    order = 2;
end

Wn = cutoff_freq / sample_rate * 2 ;
[b,a] = butter(order,Wn,type); % um tipo de filtro

y = filtfilt(b,a,data);

end