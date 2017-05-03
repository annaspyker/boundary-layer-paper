%find negative values and set them to 0
%create noise profile

clear all;

%thresholds for noise profile
bs = 65;
bs1 = 500;
mbs = 17;

ceilpath = 'd:\Neuseeland\uni\matfiles\singleprofiles\';
listfolder = dir([ceilpath 'A*']);

n = length(listfolder);
%timelow = zeros(717,n*247);         %bei 10 Min anstatt 717 muss 18 stehen
%profilelow = zeros(717,n*247,760);
k = 0;
timelownew = [];
profilelownew = [];
for i = 1:n
    ceilmpath = ['f:\NewZealand\V_CL31\' listfolder(i).name '\'];
    listpath = dir([ceilmpath 'R*.mat']);
    m = length(listpath);
    for j = 1:m
        k = k+1;
        ceilfile = fullfile([ceilmpath listpath(j).name]);
        load(ceilfile);
        data = DataOut;
        ze = find(data{1,1} < 0);
        data{1,1}(ze) = 0;
        l = length(sum(data{1,1},2));
        %die nächste Zeile gilt für 10 Min Mittel!
        if l ~=717
%         if l ~= 18
            heightsum(:,k) = zeros(717,1);
            %heightsum1500(:,k) = zeros(18,1);
            heightmean(:,k) = zeros(717,1);
            %heightmean1500(:,k) = zeros(18,1);
            ceilfile
        else
            %size(sum(data{1,1},2))
            heightsum(:,k) = sum(data{1,1},2);
            if ~isempty(find(sum(data{1,1},2)<100000, 1)) 
                heightsumlow(:,k) = sum(data{1,1},2);
            else
                heightsumlow(:,k) = zeros(717,1);
            end

%             heightsum1500(:,k) = sum(data{1,1}(:,1:250),2);
            heightmean(:,k) = mean(data{1,1}(:,11:end),2);
            
            %Adjust thresholds for "clean profiles"
            %25 and 120 result in 102 profiles, which makes up 0.3% of all
            %10-min profiles.
            l20 = find(heightmean(11:end,k)<mbs);
            ll20 = find(data{1,1}(l20,11:end)>bs);
            if isempty(ll20)
                timelow(l20,k) = data{1,2}(1,l20)';
                timelownew = [timelownew;timelow(l20,k)];
               
                si = size(data{1,1}(l20,:));
                profilelownew = [profilelownew;data{1,1}(l20,:)];

            end
                
            if ~isempty(find(mean(data{1,1}(:,11:end),2)<mbs, 1)) && isempty(find(data{1,1}(:,11:end)>bs, 1))
                heightmeanlow(:,k) = mean(data{1,1},2);    
            else
                heightmeanlow(:,k) = zeros(717,1);
            end

%             heightmean1500(:,k) = mean(data{1,1}(:,1:250),2);
            
        end
    end
end
sihi = size(heightsum);

non0height = nonzeros(heightsum);
non0heightlow = nonzeros(heightsumlow);
% non0height1500 = nonzeros(heightsum1500);
non0heightm = nonzeros(heightmean);
non0heightml = nonzeros(heightmeanlow);
% non0height1500m = nonzeros(heightmean1500);
sin0 = size(non0height)

height = data{1,3};
sipro = size(profilelownew)

%calculate mean profile, which is considered noise. It is saved as a mat-file.
%This profile is subtracted from all 10-min means.

meanprolow = mean(profilelownew);

noisefile = fullfile([ceilpath 'noiseprofile_r_' num2str(mbs) '_' num2str(bs) '.mat']);
save(noisefile,'meanprolow','timelownew','height');

datestr(timelownew)
clf;

figure(1)
hist(non0height,100)
title('frequency dist of sum of whole backscatter profile for single files (August-March)')
xlabel('Backscatter')
ylabel('number of ocurrences')
figure(2)
hist(non0heightlow,10)
title('frequency dist of sum of whole backscatter profile for single files, only low profiles (August-March)')
xlabel('Backscatter')
ylabel('number of ocurrences')
% figure(3)
% hist(non0height1500,100)
% title('frequency dist of sum of first 1500 m of backscatter for 10-min means (August-March)')
% xlabel('Backscatter')
% ylabel('number of ocurrences')
figure(4)
hist(non0heightm,100)
title('frequency dist of mean of whole backscatter profile for single files (August-March)')
xlabel('Backscatter')
ylabel('number of ocurrences')
figure(5)
hist(non0heightml,10)
title('frequency dist of mean of whole low backscatter profile for single files (August-March)')
xlabel('Backscatter')
ylabel('number of ocurrences')
% figure(6)
% hist(non0height1500m,100)
% title('frequency dist of mean of first 1500 m of backscatter for 10-min means (August-March)')
% xlabel('Backscatter')
% ylabel('number of ocurrences')
figure(6)
hold on
plot(profilelownew,height)
plot(meanprolow,height,'linewidth',3,'color','m')
xlabel('backscatter')
ylabel('height [m]')
ylim ([50 4000])
hold off