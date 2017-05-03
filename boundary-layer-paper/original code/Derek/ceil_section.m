% ceil_section isolates a particular section of ceilometer data
%
% DATA_OUT = ceil_section(ALL_DATA,START,FINISH,FORMAT,RES...
%    ,ALT1,ALT2,ALT_RES)
%
%   this function creates a new four-element ceilometer data cell, DATA_OUT, containing
%   a portion of the data found in the input ceilometer data, ALL_DATA
%
%   The first argument must be a four-element cell of the proper format
%   created by the function CeilRead.
%
%   DATA_OUT contains the data acquired within the
%   time frame stipulated by the START and FINISH at a sampling period 
%   stipulated by RES.
%
%   These two variables can either be positive integers, julian serial
%   dates or a date string of a format recognized by matlab.
%
%   FORMAT stipulates which format is being used for START
%   and FINISH
%
%   FORMAT = 0-18: date string using a matlab format (see table in
%   the 'datestr' manual entry)
%   FORMAT = -1: index numbers
%   FORMAT = -2: julian number with 0000-JAN 01:00:00 being the pivot date
%
%   if either the START is more than the last date or the FINISH is less than
%   the first date of input data array then every layer of the outputed array is equal to
%   -999.
%
%   if the START is less than the first date or FINISH is after the
%   last date of the input data, then the edges of the data are taken
%
%   ALT1 and ALT2 stipulate the lower and upper limit, respectively, of the 
%   section of altitude which is taken from the original data. ALT_RES
%   gives altitude resolution.
%
%   Default Values:
%
%       START = 1
%       FINISH = length(ALL_DATA{2}) 
%       FORMAT = -1
%       RES = 1
%       ALT1 = ALL_DATA{3}(1)
%       ALT2 = ALL_DATA{3}(end)
%       ALT_RES = 1
%
% Current Version created by Derek van der Kamp on April 21, 2009.
% email: derek.vanderkamp@alumni.ubc.ca
%-------------------------------------------------------------------------

function [data_out] = ceil_section(all_data,start,finish,format,res...
    ,alt1,alt2,alt_res)




% Check to see if data is the proper format
if ~isCeilometerData(all_data) 
    error('Inputed Ceilometer Data not properly formatted'); 
end
    
% Read in layers of All_data
time_in = all_data{2};
alt = all_data{3};
data = all_data{1};

if (nargin < 8 | isempty(alt_res)),alt_res = 1;end
if (nargin < 7 | isempty(alt2)),alt2 = alt(end);end
if (nargin < 6 | isempty(alt1)),alt1 = alt(1);end
if (nargin < 5 | isempty(res)),res = 1;end
if (nargin < 4 | isempty(format)),format = -1;end
if (nargin < 3 | isempty(finish)),finish = length(time_in);end
if (nargin < 2 | isempty(start)),start = 1;end



% Determine Altitude Index of Lower and Upper Altitude range
if alt1<5, alt1=5;, end
alt1_i = fix(alt1/5);
alt2_i = fix(alt2/5);
%if alt2_i > length(alt)
%    alt2_i = length(alt);
%end


% Check for proper Altitude range index
if (alt1_i > alt2_i)
    error('Improper altitude range inputed'); 
end

bad_limits = 0;

% check for a date string format
if format >= 0

    %convert date string to julian date
    start_date = datenum(start,format);
    end_date = datenum(finish,format);

    % check whether input time limits are outside data limits
    if ((start_date > time_in(end)) || (end_date < time_in(1)) || ...
            start_date > end_date)
        bad_limits = 1;

    else

        if start_date < time_in(1)
            start_date = time_in(1);
        end

        if (end_date > time_in(end))
            end_date = time_in(end);
        end

        % find closest profile date to input dates
        [A start_I] = min(abs(time_in - start_date));
        [B end_I] = min(abs(time_in - end_date));
        % start_date = time_in(start_I);
        % end_date = time_in(end_I);

    end


% this section used if inputs are interger index values
elseif format==-1

    % check whether input time limits are outside data limits
    if (start> length(time_in) || start> finish)

        bad_limits = 1;

    else

        if finish > length(time_in)
            finish = length(time_in);
        end;
        
        start_I = round(start);
        end_I = round(finish);

    end

% this section used if iputs are julian dates
elseif format ==-2

    % check whether input time limits are outside data limits
    if ((start > time_in(end)) || (finish < time_in(1)) || start > finish)
        bad_limits = 1;

    else
        % Reset Start or End Time, if either of them are outside the range
        if (start < time_in(1))
            start = time_in(1);
        end
        if (finish > time_in(end))
            finish = time_in(end);
        end
        
        % find closest profile date to input dates
        [A start_I] = min(abs(time_in - start));
        [B end_I] = min(abs(time_in - finish));


    end

else
  % if the inputed format integer is an incorrect number, exit function
  error('Input variable FORMAT must be between -2 and 18');
end




% if the input dates were out of data range, ouput error and exit function
if bad_limits
    error('Improper temporal range inputed')
else

    % return section of data stipulated by 'start' and 'finish'
    data_out{1} = data(start_I:res:end_I,alt1_i:alt2_i);
    data_out{2} = time_in(start_I:res:end_I);
    time = time_in(start_I:res:end_I);
    data_out{3} = alt(alt1_i:alt2_i);

end
