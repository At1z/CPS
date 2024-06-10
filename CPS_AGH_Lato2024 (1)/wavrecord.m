function x = wavrecord( Nx, fs, chan)
% wavrecord (OLD) via audiorecorder (NEW)

recorder = audiorecorder(fs,8,chan);  % create the recorder
recordblocking( recorder, Nx/fs );    % record Nx/fs seconds of data
x = getaudiodata( recorder );         % get the samples   
