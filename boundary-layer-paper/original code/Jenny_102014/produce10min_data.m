function produce10min_data

%produce 10-min mean ceilometer files for further data analysis
%Siggi 3.5.2013


%sdir = 's:\env\Share\V_CL31\';
sdir = 'f:\NewZealand\V_CL31\';
listing = dir([sdir '\Ak*'])
n = length(listing);

for i = 1:n
    InitialFolder = [sdir listing(i).name '\']
    %Finalfolder = ['d:\Neuseeland\uni\matfiles\10min\' listing(i).name '\']
    Finalfolder = ['f:\NewZealand\V_CL31\' listing(i).name '\']
        
    td = isdir(Finalfolder);
    if td ~= 1
        mkdir(Finalfolder);
    end
        
    nfinalfiles = length(dir(Finalfolder))
    if nfinalfiles > 200

        filelist = dir([InitialFolder 'A*']);

        %In InitialFolder AK1209 are data from August, I don't want them in
        %the final folder, therefore this if-loop

        switch 1
            case strcmp(listing(i).name,'AK1209')        
                YearI = 2;
                MonthI = 9;
                DayI = 1;
                HourI = 0;
            case strcmp(listing(i).name,'AK1303')
                YearI = 3;
                MonthI = 3;
                DayI = 13;
                HourI = 09;         
            otherwise 
                YearI = str2num(filelist(1).name(2));
                MonthI = str2num(filelist(1).name(3:4));
                DayI = str2num(filelist(1).name(5:6));
                HourI = str2num(filelist(1).name(7:8));
        end

        Year2 = str2num(filelist(end).name(2));
        Month2 = str2num(filelist(end).name(3:4));
        Day2 = str2num(filelist(end).name(5:6));
        Hour2 = str2num(filelist(end).name(7:8));
        
        [final_data] = CeilRead(YearI,MonthI,DayI,HourI,Year2,Month2,Day2,Hour2,1,3800,InitialFolder);

        %ceilReadCreateMatFilestest(YearI,MonthI,DayI,HourI,Year2,Month2,Day2,Hour2,1,InitialFolder, Finalfolder)
        [DataOut] = ceil_run_avg(final_data,25,25);
        SaveFilename = sprintf('%s%s%01d%02d%02d%02d.mat',Finalfolder,'R',Year,month,day,hour);
        save(SaveFilename);
    end
end