%function plotsingleprofiledata1

clear all;

% timeA = [];
% altA = [];
% dataA = [];

timeR = [];
%altR = [];
dataR = [];

time_mlh = [];
mlh = [];

date = '31023';
plotpath = ['d:\Neuseeland\uni\matfiles\singleprofiles\AK1' date(1:3) '\']
%plotpathA = ['d:\Neuseeland\uni\matfiles\10min\AK1' date(1:3) '\']
plotpath_mlh = ['d:\Neuseeland\uni\matfiles\inns_format\AK1' date(1:3) '\']
%hour = '18';

%plotlistA = dir([plotpathA 'A' date '*.mat']);
plotlistR = dir([plotpath 'R' date '*.mat'])
plotlist_mlh = dir([plotpath_mlh 'r' date '*mlh.mat'])

n = length(plotlistR);
for i = 1:n

%     load([plotpathA plotlistA(i).name])
%     timeA = [timeA,data{2}];
%     altA = data{3};
%     dataA = [dataA; data{1}];

    load([plotpath plotlistR(i).name]);
    timeR = [timeR, time];
    altR = height;
    dataR = [dataR; profile_nonoise];
    
    load([plotpath_mlh plotlist_mlh(i).name]);
    time_mlh = [time_mlh, mlh_height(1,:)];
    mlh = [mlh, mlh_height(2:5,:)];
end

clf;
% figure1 = figure(1);
% axes1 = axes('Parent',figure1,'FontWeight','demi','FontSize',16);
% hold on
% plot(mean(dataA),altA,'r','LineWidth',2)
% plot(mean(dataR),altR,'b','LineWidth',2)
% ylim ([50 4000])
% legend('original','noise corrected')
% xlabel('backscatter','FontWeight','demi','FontSize',16)
% ylabel('height [m]','FontWeight','demi','FontSize',16)
% title(['3-hour mean profile on ' date(4:5) '.' date(2:3) '.201' date(1)],'FontWeight','demi','FontSize',16)
% hold off

% figure2 = figure(2);
% axes2 = axes('Parent',figure2,...
%     'XTickLabel',{'00:00','03:00','06:00','09:00','12:00','15:00','18:00','21:00','24:00'},...
%     'XTick',[fix(timeA(1)) fix(timeA(1))+.125 fix(timeA(1))+.25 fix(timeA(1))+.375 fix(timeA(1))+.5 ...
%     fix(timeA(1))+.625 fix(timeA(1))+.75 fix(timeA(1))+.875 fix(timeA(1))+1],'Layer','top',...
%     'FontWeight','demi',...
%     'FontSize',16,...
%     'CLim',[15 200]);
% % Uncomment the following line to preserve the X-limits of the axes
%  xlim(axes2,[timeA(1) timeA(end)]);
% % Uncomment the following line to preserve the Y-limits of the axes
%  ylim(axes2,[42.5 3802.5]);
% box(axes2,'on');
% hold(axes2,'all');
% 
% % Create image
% image(timeA,flipdim(altA,2),flipdim((dataA)',1),'Parent',axes2,'CDataMapping','scaled');
% 
% % Create xlabel
% xlabel('Time of Day (NZST)','FontWeight','demi','FontSize',16);
% 
% % Create ylabel
% ylabel('Height above ground (m)','FontWeight','demi','FontSize',16);
% 
% % Create colorbar
% colorbar('peer',axes2,'FontSize',16);

figure3 = figure(3);
axes3 = axes('Parent',figure3,...
    'XTickLabel',{'00:00','03:00','06:00','09:00','12:00','15:00','18:00','21:00','24:00'},...
    'XTick',[fix(timeR(1)) fix(timeR(1))+.125 fix(timeR(1))+.25 fix(timeR(1))+.375 fix(timeR(1))+.5 ...
    fix(timeR(1))+.625 fix(timeR(1))+.75 fix(timeR(1))+.875 fix(timeR(1))+1],'Layer','top',...
    'FontWeight','demi',...
    'FontSize',16,...
    'CLim',[15 500]);
% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes3,[timeR(1) timeR(end)]);
% Uncomment the following line to preserve the Y-limits of the axes
 ylim(axes3,[42.5 3802.5]);
 title([date(4:5) '.' date(2:3) '.2013'])
box(axes3,'on');
hold(axes3,'all');

% Create image
image(timeR,flipdim(altR,2),flipdim((dataR)',1),'Parent',axes3,'CDataMapping','scaled');
plot(time_mlh,mlh,'m+')
% Create xlabel
xlabel('Time of Day (NZST)','FontWeight','demi','FontSize',16);

% Create ylabel
ylabel('Height above ground (m)','FontWeight','demi','FontSize',16);

% Create colorbar
colorbar('peer',axes3,'FontSize',16);

figure4 = figure(4);
axes4 = axes('Parent',figure4,...
    'XTickLabel',{'00:00','03:00','06:00','09:00','12:00','15:00','18:00','21:00','24:00'},...
    'XTick',[fix(timeR(1)) fix(timeR(1))+.125 fix(timeR(1))+.25 fix(timeR(1))+.375 fix(timeR(1))+.5 ...
    fix(timeR(1))+.625 fix(timeR(1))+.75 fix(timeR(1))+.875 fix(timeR(1))+1],...
    'FontWeight','demi','FontSize',16);
hold on
%plot(dataA,altA,'r','LineWidth',2)
plot(timeR, sum(dataR(:,10:20),2),'c','LineWidth',2)
plot(timeR, mean(dataR(:,10:20),2),'b','LineWidth',2)
plot(timeR, mean(dataR(:,10:750),2),'m','LineWidth',2)
%ylim ([50 4000])
%legend('original','noise corrected')
xlabel('Time of Day (NZST)','FontWeight','demi','FontSize',16)
ylabel('Mean backscatter between 50 and 100 m','FontWeight','demi','FontSize',16)
title(['Time series of backscatter on ' date(4:5) '.' date(2:3) '.201' date(1)],'FontWeight','demi','FontSize',16)
legend('Sum of backscatter from 50 to 100 m','Mean backscatter from 50 to 100 m','Mean backscatter from 50 to 1500 m')
hold off

t_anfang = datenum(['201' date '1500'],'yyyymmddHHMM');
[tmina,tmininda] = min(abs(timeR-t_anfang));
t_ende = datenum(['201' date '2350'],'yyyymmddHHMM');
[tmine,tmininde] = min(abs(timeR-t_ende));
lentry = datestr(timeR(tmininda:240:tmininde),'HH:MM');


figure5 = figure(5);
axes5 = axes('Parent',figure5,'FontWeight','demi','FontSize',16);
hold on
%plot(dataA,altA,'r','LineWidth',2)
plot(dataR(tmininda:240:tmininde,:),altR,'b','LineWidth',2)
ylim ([50 4000])
%legend('original','noise corrected')
xlabel('backscatter','FontWeight','demi','FontSize',16)
ylabel('height [m]','FontWeight','demi','FontSize',16)
title(['Selected single profiles on ' date(4:5) '.' date(2:3) '.201' date(1)],'FontWeight','demi','FontSize',16)
legend(lentry)
hold off


