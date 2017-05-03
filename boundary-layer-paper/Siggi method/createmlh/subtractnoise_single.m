%fuction subtractnoise_single

%subtracts the noise profile from the single running averages

%Anna Spyker 12.2015, edited by Lena Weissert for PC use 4.2016
% set directory
path = 'C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Siggi method/createmlh/';
cd(path)

clear all;

monthStart = 10;
monthEnd = 10;

for j = monthStart:monthEnd
    % which year you would like to analyse
    stryear = '12'
    
    if (j < 10)
        strmonth = ['0' num2str(j)];
    else 
        strmonth = num2str(j);
    end
    
    month = j;
    year = str2num(stryear(2:2));
    numdays = eomday(2015, j);
    
    %Path to the 10-min profiles
    ceilpath = ['S:/env/Share/V_CL31/AK' stryear strmonth '/']
    
    %noise profile
    noisefile = fullfile('C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/data/noise profiles','noiseprofile_r_17_65.mat')
    load(noisefile, 'meanprolow');
    noiseprofile = meanprolow;
    %Have to find data to read profile and to be able to subtract noise profile
    listpath = dir([ceilpath 'A*.DAT'])
    m = length(listpath)
    
    for i = 1:numdays
        disp(i)
        CeilData = CeilRead(year, month, i, 0, year, month, i, 23, 1, 3800, ceilpath);
        [DataOut] = ceil_run_avg(CeilData,25,25);
        profiles = DataOut{1,1};
        time = DataOut{1,2};
        height = DataOut{1,3};
        
        [m,n] = size(profiles);
        
        %size(noiseprofile)
        profile_nonoise = zeros(m,n);
        
        for k = 1:m
            profile_nonoise(k,:) = profiles(k,:) - noiseprofile;
        end
        
        %nagavite values do not make sense in a physical way, set = 0
        ze = find(profile_nonoise < 0);
        profile_nonoise(ze) = 0;
        %Save nonoisefile in the same directory as the 10-min data, but with
        %another starting letter (C = clean)
        if (i < 10)
            strday = (['0' num2str(i)]);
        else
            strday = num2str(i);
        end
        
        nonoisefile = (['C' stryear strmonth strday '.mat']);
        cddir = ['C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/data/Siggi/' stryear strmonth '/clean/']
        cd(cddir)
        save(nonoisefile,'profile_nonoise','time','height', '-mat');
        cd('C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Siggi method/createmlh')
    end
    
    clear all;
end

