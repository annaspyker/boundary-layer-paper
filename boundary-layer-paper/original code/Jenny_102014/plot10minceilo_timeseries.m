%function plot10minceilo_timeseries

clear all;

ceilpath = 'd:\Neuseeland\uni\matfiles\10min\';
listfolder = dir([ceilpath 'AK*']);

n = length(listfolder);

orgsum_all = [];
orgsum_1500= [];
orgsum_500 = [];
orgsum_100 = [];
orgtime = [];
corsum_all = [];
corsum_1500= [];
corsum_500 = [];
corsum_100 = [];
cortime = [];

hourtime = [];
hourdata = [];
hourdata1500 = [];
hourdata500 = [];
hourdata100 = [];

hourtimec = [];
hourdatac = [];
hourdatac1500 = [];
hourdatac500 = [];
hourdatac100 = [];

%--------------------------------------------------------------------------
%as a first try, find all times with relative humidity < 62% 
%(according to Münkel et al., 2004)

relhumpath = 'd:\Neuseeland\uni\data\Metdata\';
humfiles = dir([relhumpath 'screen*']);
l = length(humfiles);
station_id = zeros(1,l);
humtime = zeros(937,l);
relhum = zeros(937,l);
for h = 1:l
    humfile = [relhumpath humfiles(h).name];
    fid=fopen(humfile,'r');
    humfield = textscan(fid,'%d %13c %*f %*s %*s %*d %f %*f %*s %*s', 'headerlines', 9);
    fclose(fid);
    station_id(1,h) = humfield{1,1}(1,1);
    humdatenum = datenum(humfield{1,2},'yyyymmdd:HHMM');
    hum = humfield{1,3};
    u62 = find(hum<45);
    humind = length(hum(u62));
    %size(datenum(windfield{1,2},'yyyymmdd:HHMM'));
    humtime(1:humind,h) = humdatenum(u62);
    relhum(1:humind,h) = hum(u62);
    
    
    
end


%--------------------------------------------------------------------------
for i = 1:n
    ceilmpath = [ceilpath listfolder(i).name '\']
    listpath = dir([ceilmpath 'A*']);
    m = length(listpath);
    for j = 1:m
        ceilfile = fullfile([ceilmpath listpath(j).name]);
        load(ceilfile);
        ze = find(data{1,1} < 0);
        data{1,1}(ze) = 0;
        
        orgtimevec = datevec(data{1,2});
        uni = unique(orgtimevec(:,4));
        for u = 1:length(uni)
            induni = find(orgtimevec(:,4) == uni(u));
            hourtime = [hourtime; datenum(orgtimevec(induni(end),:))];
            hourmean = mean(data{1,1}(induni,:));
            hourdata = [hourdata; sum(hourmean(11:end))];
            hourdata1500 = [hourdata1500;sum(hourmean(11:300),2)];
            hourdata500 = [hourdata500;sum(hourmean(11:100),2)];
            hourdata100 = [hourdata100;sum(hourmean(11:20),2)];
        end
        
        orgsum = sum(data{1,1}(:,11:end),2);
        orgsum_all = [orgsum_all;orgsum];
        orgsum_1500= [orgsum_1500;sum(data{1,1}(:,11:300),2)];
        orgsum_500 = [orgsum_500;sum(data{1,1}(:,11:100),2)];
        orgsum_100 = [orgsum_100;sum(data{1,1}(:,11:20),2)];
        orgtime = [orgtime,data{1,2}];
        %create hourly mean profile
        
    end
    listpathc = dir([ceilmpath 'C*']);
    m = length(listpathc);
    for j = 1:m
        ceilfilec = fullfile([ceilmpath listpathc(j).name]);
        cdata = load(ceilfilec);
        
        cortimevec = datevec(cdata.time);
        unic = unique(cortimevec(:,4));
        for u = 1:length(unic)
            indunic = find(cortimevec(:,4) == unic(u));
            hourtimec = [hourtimec; datenum(cortimevec(indunic(end),:))];
            hourmeanc = mean(cdata.profile_nonoise(indunic,:));
            hourdatac = [hourdatac; sum(hourmeanc(11:end))];
            hourdatac1500 = [hourdatac1500;sum(hourmeanc(11:300))];
            hourdatac500 = [hourdatac500;sum(hourmeanc(11:100))];
            hourdatac100 = [hourdatac100;sum(hourmeanc(11:20))];
        end
        
        corsum_all = [corsum_all;sum(cdata.profile_nonoise(:,11:end),2)];
        corsum_1500= [corsum_1500;sum(cdata.profile_nonoise(:,11:300),2)];
        corsum_500 = [corsum_500;sum(cdata.profile_nonoise(:,11:100),2)];
        corsum_100 = [corsum_100;sum(cdata.profile_nonoise(:,11:20),2)];
        cortime = [cortime,cdata.time];
    end
end

% u62 = find(relhum <62);
% relhum = relhum(u62);
% humtime = humtime(u62);

[m,n] = size(humtime)
% loc = zeros(m,n);
 sametime = zeros(m,n);
 samehum100 = zeros(m,n);
 samehum500 = zeros(m,n);
 samehum1500 = zeros(m,n);
 samehumc100 = zeros(m,n);
 samehumc500 = zeros(m,n);
 samehumc1500 = zeros(m,n);
 for h = 1:n
    hround = round((hourtime - floor(hourtime)).*24);
    hourtimeh = floor(hourtime)+hround/24;
    [tf,loc] = ismember(nonzeros(humtime(:,h)), hourtimeh);
   %size(loc(:,h))
    sametime(1:length(nonzeros(loc)),h) = hourtimeh(nonzeros(loc));
    samehum100(1:length(nonzeros(loc)),h) = hourdata100(nonzeros(loc));
    samehum500(1:length(nonzeros(loc)),h) = hourdata500(nonzeros(loc));
    samehum1500(1:length(nonzeros(loc)),h) = hourdata1500(nonzeros(loc));
    samehumc100(1:length(nonzeros(loc)),h) = hourdatac100(nonzeros(loc));
    samehumc500(1:length(nonzeros(loc)),h) = hourdatac500(nonzeros(loc));
    samehumc1500(1:length(nonzeros(loc)),h) = hourdatac1500(nonzeros(loc));
 end
 
%--------------------------------------------------------------------------
%find out correct time of pm measurements for correlation with ceilometer
%data
pmdir = 'd:\Neuseeland\uni\data\';
pmfile = fullfile(pmdir, 'PM1hr_2012wo9999.txt');
fid=fopen(pmfile,'r');
pmfield = textscan(fid,'%10c %5c %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d', 'headerlines', 3);
fclose(fid);

date = pmfield{1,1};
time = pmfield{1,2};
plottime = datenum([date,time],'dd.mm.yyyyHH:MM');
    
pm10_Henderson = pmfield{1,3};
pm10_Penrose = pmfield{1,4};
pm25_Penrose = pmfield{1,5};
pm10_Takapuna = pmfield{1,6};
pm25_Takapuna = pmfield{1,7};
pm10_Patumahoe = pmfield{1,8};
pm10_Pakuranga = pmfield{1,9};
pm10_Botany = pmfield{1,10};
pm10_GlenEden = pmfield{1,11};
pm10_Orewa = pmfield{1,12};
pm25_Patumahoe = pmfield{1,13};
pm10_Whangaparaoa = pmfield{1,14};
pm25_Whangaparaoa = pmfield{1,15};
pm10_MobilePOAL = pmfield{1,16};
pm25_MobilePOAL = pmfield{1,17};
pm10_KhyberPass = pmfield{1,18};
pm10_Kumeu = pmfield{1,19};

nzsamet = nonzeros(sametime(:,4));
[tfpm,locpm] = ismember(nzsamet, plottime);
timepm = plottime(nonzeros(locpm));
pm25_Taka = pm10_Henderson(nonzeros(locpm));
indpm = find(tfpm ~=0);
sametimepm = nzsamet(indpm);
same500pm = samehumc1500(indpm);
 
size(timepm)
size(sametimepm)

clf;
figure(1)
hold on
%plot(orgtime,orgsum_all,'r*')
plot(orgtime,orgsum_1500,'r+')
plot(orgtime,orgsum_500,'rx')
%plot(cortime,corsum_all,'b*')
plot(cortime,corsum_1500,'b+')
plot(cortime,corsum_500,'bx')
datetick('x',20)
%legend('original: 50-3600m', 'original: 50-1500m','original: 50-500m','corrected: 50-3600m','corrected: 50-1500m','corrected: 50-500m')
legend('original: 50-1500m','original: 50-500m','corrected: 50-1500m','corrected: 50-500m')
xlabel('day/month/year')
ylabel('vertical sum of backscatter')
title('Time series of various sums of backscatter profile')
hold off

figure(2)
hold on
%plot(orgtime,orgsum_all,'r*')
plot(hourtime,hourdata1500,'r+')
plot(hourtime,hourdata500,'rx')
%plot(cortime,corsum_all,'b*')
plot(hourtimec,hourdatac1500,'b+')
plot(hourtimec,hourdatac500,'bx')
datetick('x',20)
%legend('original: 50-3600m', 'original: 50-1500m','original: 50-500m','corrected: 50-3600m','corrected: 50-1500m','corrected: 50-500m')
legend('original: 50-1500m','original: 50-500m','corrected: 50-1500m','corrected: 50-500m')
xlabel('day/month/year')
ylabel('vertical sum of backscatter')
title('Time series of hourly mean sums of backscatter profile')
hold off

figure(3)
hold on
plot(humtime,relhum,'.')
datetick('x',20)
xlim([735140 735355])
ylim([0 105])
hold off

figure(4)
hold on
plot(sametime(:,3),samehumc500(:,3)./1000,'b+')
%plot(sametime(:,3),samehumc1500(:,3),'cx')
plot(timepm,pm25_Taka,'m*')
datetick('x',20)
xlim([735140 735355])

hold off

figure(5)
hold on
plot(same500pm,pm25_Taka,'.')
hold off

corrcoef(same500pm,double(pm25_Taka))