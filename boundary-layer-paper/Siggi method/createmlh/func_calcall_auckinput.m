%func func_calcall_auckinput

%--------------------------------------------------------------------------
%calculate the mixed layer heights and the cloud layer height with the
%innsbruck algorithm for the Auckland R*.mat files (for the running averages)

%Siggi 14.6.2013
% edited by Anna Spyker 12.2015, edited by Lena Weissert for PC use 4.2016
%--------------------------------------------------------------------------
% set directory
path = 'C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/code/Siggi method/createmlh/';
cd(path)

close all;
clear;

year = '13';
monthStart = 10;
monthEnd = 10;

for j = monthStart:monthEnd
   
    
    if (j < 10)
        month = ['0' num2str(j)];
    else
        month = num2str(j);
    end
    
    numdays = eomday(2015, j);
    
    
    for i = 1:numdays
        if (i < 10)
            fileinname = (['C' year month '0' num2str(i) '.mat'])
        else
            fileinname = (['C' year month num2str(i) '.mat']);
        end
        
        filestr = ['C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/data/Siggi/' year month '/clean/']
        filein = [filestr  fileinname]
        
        if exist(filein)
            
            angle_tilt = 13;
            h = 5;
            height_meter = (0:h:3850-h).*cos(deg2rad(angle_tilt));
            
            id = 16224;
            
            load(filein)
            datahex = profile_nonoise';
            data_complete = horzcat([NaN;height'],vertcat(time,profile_nonoise'));
            sdate = time;
            
            [a b] = size(datahex)
            [a1,b1] = size(data_complete);
            
            
            [data_mean,gradient_mean,gradient_meanneg,gradient2_mean,grad,deltah,deltat,...
                ind_ygrad,ind_xgrad,max_mlh,ind_gesamt,mlh_height,cld_height]=func_calcall(angle_tilt,height_meter,datahex,...
                id,h,data_complete, a,b,a1,b1,sdate);
            
            savefile = ['C:/Users/lwei999/Dropbox/Boundary layer analysis/Anna Spyker/data/Siggi/' year month '/mlh/']
            savename = [savefile fileinname(1:7) 'mlh.mat']
            save(savename,'mlh_height')
        end
        
    end
end
