% CEILREADRAWFILE retrieves data from an individual cl-view .dat file
%
% FINAL_OUTPUT = CeilReadRawFile(FILENAME,MAXALT)
%
% This Script Reads in Original .dat file supplied by CL-View
% and converts it into a 2d data matrix The altitude range of the data 
% is determined by the input MAXALT
%
% The output is a 4-element cell. The first element is the 2-D data matrix
% of backscatter values, the 2nd element is the time vector, the 3rd
% element is the altitude vector, and the fourth element is an information
% string. THIS 4-ELEMENT CELL FORMAT IS REQUIRED BY ALL OTHER CEILOMETER
% SCRIPTS.
%
% Because the timing information was provided by the field laptop, which 
% switched to daylight savings time in both 2007, 2008 and 2009, The timing 
% information had to be converted to the Pacific Standard Time by this
% function when applicable
%
% This function is called by CeilRead.
%   
% The function CeilRead checks for the existence of the file before it
% calls CeilReadRawFile. Therefore this function does not check for the
% existence of the file itself. 
%
% Current Version Created by Derek van der Kamp June 1, 2009.
% email: derek.vanderkamp@alumni.ubc.ca
% -----------------------------------------------------------------------
function [final_output] = ...
    CeilReadRawFile(filename,MaxAlt)



[fid1 message] = fopen(filename); %Opens File 'filename'

% Initialize loop variables
i=1;
ProfileString = '';
MoreLines = 1;
FirstLine = 1;

% vvvvvvvvvvvvvvvvv Data Read Loop vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
% Continue loop until the file's final line is reached
while MoreLines
    
    % read in Empty lines and header lines
    EmptyLine = fgetl(fid1);
    EmptyLine2 = fgetl(fid1);
    DateLine = fgetl(fid1) ;
    HeaderLine1 = fgetl(fid1);
    HeaderLine2 = fgetl(fid1);
    HeaderLine3 = fgetl(fid1);
    % Read in one more header line if it's included i.e., its message Type
    % 1, not message type 2
    if length(HeaderLine3) <47
        HeaderLine3 = fgetl(fid1);
    end
    
    % Check to see if we're not at the end of the file, i.e, the
    % date line has the phrase: '-File Closed:' If we are, no data is read
    % and the MoreLines flag is set to False, ending the while loop
    if isempty(findstr(DateLine,'Closed'))
        % if we're in the first message of a file, establish the resolution 
        % and initialie the data array 
        if FirstLine

            resolution = sscanf(HeaderLine3,'%*6c%02d%*39c');
            N_alt = int32(MaxAlt/resolution);
            alt = resolution:resolution:MaxAlt;
            final_data = ones(1,N_alt)*0;
            
            FirstLine = 0;
            
        end
        
        % read in profile as a string in hexidecimal form
        ProfileString = fgetl(fid1); 
            
        % convert hexidecimal string to a vector of integers
        final_data(i,1:N_alt) = ...
            hex2dec(reshape(ProfileString(1:N_alt*5)',5,N_alt)');
        
        % Find the values which are out of range and set them to negative
        % values
        TooBigIndex = find(final_data(i,1:N_alt) > 2^19) ;
        final_data(i,TooBigIndex) = -(2^20-final_data(i,TooBigIndex));

        % Append the new date value onto the Date String cell
        date_c{i} = DateLine;
    else 
        MoreLines = 0;
    end
    i=i+1;
end
% ^^^^^^^^^^^^^^^^^^^^^^ Data read loop end ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

% Convert Strings to julian dates (Days after Jan 1, 0000)
time = datenum(date_c,'-yyyy-mm-dd HH:MM:SS');

% Convert any Daylight savings times to Standard Time
% if time(1) <=datenum('2007-10-29','yyyy-mm-dd') | ...
%         ( time(1) > datenum('2008-04-05 02:00:00','yyyy-mm-dd HH:MM:SS') & ...
%         time(1) < datenum('2008-11-02 02:00:00','yyyy-mm-dd HH:MM:SS')  ) | ...
%         time(1) > datenum('2009-03-08 02:00:00','yyyy-mm-dd HH:MM:SS')
% 
%     time(find(time <= datenum('2007-10-28 01:59:53','yyyy-mm-dd HH:MM:SS')...
%         | (time > datenum('2008-04-06 02:00:00','yyyy-mm-dd HH:MM:SS') & ...
%         time < datenum('2008-11-02 01:59:53','yyyy-mm-dd HH:MM:SS')  ) |...
%         time > datenum('2009-03-08 02:00:00','yyyy-mm-dd HH:MM:SS')  ))...
%         = ...
%     time(find(time <= datenum('2007-10-28 01:59:53','yyyy-mm-dd HH:MM:SS')...
%         | (time > datenum('2008-04-06 02:00:00','yyyy-mm-dd HH:MM:SS') & ...
%         time < datenum('2008-11-02 01:59:53','yyyy-mm-dd HH:MM:SS')  ) |...
%         time > datenum('2009-03-08 02:00:00','yyyy-mm-dd HH:MM:SS')  ))...
%         -1/24;
%     [time UniqueTimeI]  = unique(time);
%     final_data = final_data(UniqueTimeI,:);
%     disp('Correcting Time...')
% end

time = time';

% vvvvvvvvvvv stores data and axes info into 4-element cell 'final_output'
final_output{1} = final_data;
final_output{2} = time;
final_output{3} = alt;
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

fclose(fid1); % Close file 'filename'


