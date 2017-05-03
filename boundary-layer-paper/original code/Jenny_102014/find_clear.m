%find negative values and set them to 0
%find clear sky cases

clear all;

%thresholds for noise profile
bs = 500;
bs1 = 500;
mbs = 1000;

month = '05';
year = '13';

ceilpath = 'd:\Neuseeland\uni\matfiles\singleprofiles\';
listfolder = dir([ceilpath 'AK' year month '*']);

n = length(listfolder);
%timelow = zeros(717,n*247);         %bei 10 Min anstatt 717 muss 18 stehen
%profilelow = zeros(717,n*247,760);
k = 0;
timelownew = [];
profilelownew = [];
timemlhlownew = [];
mlhnew = [];

for i = 1:n
    ceilmpath = [ceilpath listfolder(i).name '\'];
    listpath = dir([ceilmpath 'R*.mat']);
    m = length(listpath);
    for j = 1:m
        k = k+1;
        ceilfile = fullfile([ceilmpath listpath(j).name]);
        load(ceilfile);
        data = profile_nonoise;
        ze = find(data < 0);
        data(ze) = 0;
        l = length(sum(data,2));
        
        %load mlh
        mlhfile = fullfile(['d:\Neuseeland\uni\matfiles\inns_format\AK' year month '\' listpath(j).name(1:8) 'mlh.mat']);
        load(mlhfile);
        
        
        
        
        %next line for single profiles only
        if l ~=717
%         if l ~= 15
            heightsum(:,k) = zeros(717,1);
            heightsum1500(:,k) = zeros(717,1);
            heightsum100(:,k) = zeros(717,1);
            heightmean(:,k) = zeros(717,1);
            heightmean1500(:,k) = zeros(717,1);
            ceilfile
        else
            %size(sum(data{1,1},2))
            heightsum(:,k) = sum(data(:,10:end),2);
            if ~isempty(find(sum(data(:,10:end),2)<100000, 1)) 
                heightsumlow(:,k) = sum(data(:,10:end),2);
            else
                heightsumlow(:,k) = zeros(l,1);
            end

            heightsum1500(:,k) = sum(data(:,10:250),2);
            heightsum100(:,k) = sum(data(:,10:20),2);
            heightmean(:,k) = mean(data(:,10:end),2);
            heightmean1500(:,k) = mean(data(:,10:250),2);
            
            %adjust thresholds for "clean profiles"
            
            l20 = find(heightmean(10:end,k)<mbs);
            ll20 = find(data(l20,10:end)>bs);
            if isempty(ll20)
                timelow(l20,k) = time(1,l20)';
                timelownew = [timelownew;timelow(l20,k)];
                
                si = size(data(l20,10:end));
                profilelownew = [profilelownew;data(l20,10:end)];
                
                %[tf, loc] = ismember(timelow(l20,k), mlh_height(1,:));
                timemlhlow(l20,k) = mlh_height(1,l20)';
                timemlhlownew = [timemlhlownew;timemlhlow(l20,k)];
                
                mlhnew = [mlhnew; mlh_height(2:5,l20)'];

            end
                
            if ~isempty(find(mean(data(:,10:end),2)<mbs, 1)) && isempty(find(data(:,10:end)>bs, 1))
                heightmeanlow(:,k) = mean(data(:,10:end),2);    
            else
                heightmeanlow(:,k) = zeros(l,1);
            end

%             heightmean1500(:,k) = mean(data{1,1}(:,1:250),2);
            
            
        end
    end
end
sihi = size(heightsum);

non0height = nonzeros(heightsum);
non0heightlow = nonzeros(heightsumlow);
non0height1500 = nonzeros(heightsum1500);
non0height100 = nonzeros(heightsum100);
non0heightm = nonzeros(heightmean);
non0heightml = nonzeros(heightmeanlow);
non0height1500m = nonzeros(heightmean1500);

sin0 = size(non0height)


sipro = size(profilelownew)

%calculate mean profile, which is considered noise. It is saved as a mat-file.
%This profile is subtracted from all 10-min means.

meanprolow = mean(profilelownew);



%save('D:\Neuseeland\uni\matfiles\datestr_lowbackscatter.txt',datestr(timelownew),'-ascii');
%--------------------------------------------------------------------------
%find out, when the mlh in clear conditions can be calculated and when it
%is not possible.

tf = isnan(mlhnew);
mlh1 = find(tf(:,1) == 0);
mlh2 = find(tf(:,2) == 0);
mlh3 = find(tf(:,3) == 0);
mlh4 = find(tf(:,4) == 0);


percentclear = (length(timelownew)/length(non0height))*100
percentmlhclear = (length(mlh1)/length(timelownew))*100

%think about if == 1 or ==0 makes more sense and how to find/specify the
%times

%--------------------------------------------------------------------------
gap = find(diff(timelownew)>0.0004);
gl = length(gap);


clf;

figure2 = figure(2);
 
axes2 = axes('Parent',figure2,'Layer','top',...
    'XTickLabel',{datestr(fix(timelownew(1)):1:fix(timelownew(end)),'dd')},...
    'XTick',(fix(timelownew(1)):1:fix(timelownew(end))),...
    'FontWeight','demi',...
    'FontSize',16,...
    'CLim',[15 500]);
% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes2,[fix(timelownew(1)) fix(timelownew(end))+1]);
 %datetick('x',19)
% Uncomment the following line to preserve the Y-limits of the axes
 ylim(axes2,[42.5 3802.5]);
box(axes2,'on');
hold(axes2,'all');

% Create image
image(timelownew(1:gap(1)),flipdim(height(10:end),2),flipdim((profilelownew(1:gap(1),:))',1),'Parent',axes2,'CDataMapping','scaled');
plot(timemlhlownew(1:gap(1)),mlhnew(1:gap(1),:),'m.','markersize',3)
for i = 1:gl-1
    image(timelownew(gap(i)+1:gap(i+1)),flipdim(height(10:end),2),flipdim((profilelownew(gap(i)+1:gap(i+1),:))',1),'Parent',axes2,'CDataMapping','scaled');
    plot(timemlhlownew(gap(i)+1:gap(i+1)),mlhnew(gap(i)+1:gap(i+1),:),'m.','markersize',3)
end

% Create xlabel
xlabel(['Day in ' datestr(timelownew(1),'mmm yyyy')],'FontWeight','demi','FontSize',16);

% Create ylabel
ylabel('Height above ground (m)','FontWeight','demi','FontSize',16);
title(['Time-height sections for clear cases in ' datestr(timelownew(1),'mmm yyyy')])

% Create colorbar
colorbar('peer',axes2,'FontSize',16, 'FontWeight', 'demi');

% figure4 = figure(4);
% axes4 = axes('Parent',figure4,'FontWeight','demi','FontSize',16);
% hold on
% plot(timelownew, max(profilelownew(:,10:end,2)),'c+')
% %plot(timelownew, mean(dataR(:,10:20),2),'b','LineWidth',2)
% %plot(timelownew, mean(dataR(:,10:750),2),'m','LineWidth',2)
% %ylim ([50 4000])
% datetick('x',20)
% xlabel('dd/mm/yy','FontWeight','demi','FontSize',16)
% ylabel('maximum backscatter for each profile','FontWeight','demi','FontSize',16)
% %title(['Time series of backscatter on ' date(4:5) '.' date(2:3) '.201' date(1)],'FontWeight','demi','FontSize',16)
% %legend('Sum of backscatter from 50 to 100 m','Mean backscatter from 50 to 100 m','Mean backscatter from 50 to 1500 m')
% hold off
% % 
% figure5 = figure(5);
% axes5 = axes('Parent',figure5,'FontWeight','demi','FontSize',16);
% hold on
% %plot(dataA,altA,'r','LineWidth',2)
% plot(profilelownew,height,'b','LineWidth',2)
% ylim ([50 4000])
% %legend('original','noise corrected')
% xlabel('backscatter','FontWeight','demi','FontSize',16)
% ylabel('height [m]','FontWeight','demi','FontSize',16)
% %title(['Selected single profiles on ' date(4:5) '.' date(2:3) '.201' date(1)],'FontWeight','demi','FontSize',16)
% %legend(lentry)
% hold off


% figure(1)
% hist(non0height,100)
% title('frequency dist of sum of whole backscatter profile for single files (August-March)')
% xlabel('Backscatter')
% ylabel('number of ocurrences')
% figure(2)
% hist(non0heightlow,10)
% title('frequency dist of sum of whole backscatter profile for single files, only low profiles (August-March)')
% xlabel('Backscatter')
% ylabel('number of ocurrences')
% figure(3)
% hist(non0height1500,100)
% title('frequency dist of sum of first 1500 m of backscatter for for single files (August-March)')
% xlabel('Backscatter')
% ylabel('number of ocurrences')
% figure(4)
% hist(non0height100,100)
% title('frequency dist of sum of first 100 m of backscatter for single files (August-March)')
% xlabel('Backscatter')
% ylabel('number of ocurrences')
% figure(5)
% hist(non0heightm,100)
% title('frequency dist of mean of whole backscatter profile for single files (August-March)')
% xlabel('Backscatter')
% ylabel('number of ocurrences')
% figure(6)
% hist(non0heightml,10)
% title('frequency dist of mean of whole low backscatter profile for single files (August-March)')
% xlabel('Backscatter')
% ylabel('number of ocurrences')
% % figure(6)
% % hist(non0height1500m,100)
% % title('frequency dist of mean of first 1500 m of backscatter for 10-min means (August-March)')
% % xlabel('Backscatter')
% % ylabel('number of ocurrences')
% figure(7)
% hold on
% plot(profilelownew,height)
% plot(meanprolow,height,'linewidth',3,'color','m')
% xlabel('backscatter')
% ylabel('height [m]')
% ylim ([50 4000])
% hold off