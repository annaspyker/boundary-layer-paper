function produce_running_avg

%produce 10-min mean ceilometer files for further data analysis
%Siggi 15.5.2013


%sdir = 's:\env\Share\V_CL31\';
%sdir = 'f:\NewZealand\V_CL31\';
sdir = 'd:\Neuseeland\uni\matfiles\singleprofiles\';
listing = dir([sdir '\AK1310*'])
n = length(listing);

for i = 1:n
    InitialFolder = [sdir listing(i).name '\']
    %Finalfolder = ['f:\NewZealand\V_CL31\' listing(i).name '\']
    Finalfolder = [sdir listing(i).name '\'];
        
    td = isdir(Finalfolder);
    if td ~= 1
        mkdir(Finalfolder);
    end
        
    nfinalfiles = length(dir(Finalfolder))
    %if nfinalfiles > 200

        filelist = dir([InitialFolder 'A310*.mat']);
        r = length(filelist);
        
        for j = 1:r
            SaveFilename = fullfile(Finalfolder,['R' filelist(j).name(2:end)]);
            exi = exist(SaveFilename);
            if exi ~= 2
                
                load([InitialFolder filelist(j).name]);
                [DataOut] = ceil_run_avg(data,25,25);
                
            
                SaveFilename
                save(SaveFilename,'DataOut');
            end
        end    
    %end
end