%function plot10mindata

clear all;

date = '21101';
hour = '15';

plotlistA = dir(['d:\Neuseeland\uni\matfiles\singleprofiles\AK1' date(1:3) '\A' date '*.mat'])
plotlistR = dir(['d:\Neuseeland\uni\matfiles\singleprofiles\AK1' date(1:3) '\R' date '*.mat'])

n = length(plotlistR);
for i = 1:n

    load(['d:\Neuseeland\uni\matfiles\10min\AK1' date(1:3) '\A' date hour '.mat']);

    load(['d:\Neuseeland\uni\matfiles\10min\AK1' date(1:3) '\D' date hour '.mat']);

    timeA = data{2};
    altA = data{3};
    dataA = data{1};

    timeD = time;
    altD = height;
    dataD = profile_nonoise;
end
grad_data = gradient(mean(dataD(1:18,:)))
clf;
figure1 = figure(1);
axes1 = axes('Parent',figure1,'FontWeight','demi','FontSize',16);
hold on
plot(mean(dataD(1:18,:)),altD,'b','LineWidth',2)
plot(mean(dataA),altA,'r','LineWidth',2)
ylim ([50 4000])
legend('noise corrected', 'original')
xlabel('backscatter','FontWeight','demi','FontSize',16)
ylabel('height [m]','FontWeight','demi','FontSize',16)
title(['3-hour mean profile on ' date(4:5) '.' date(2:3) '.201' date(1) ', ' hour ' NZST'],'FontWeight','demi','FontSize',16)
hold off

figure2 = figure(2);
% plot the 2-d matrix using the 'image' function
% plot the data
image(timeA,flipdim(altA,2),flipdim((dataA)',1),'CDataMapping', 'scaled');
% label axes, with certain fonts and sizes
set(gca,'FontSize', 16);
set(gca,'FontWeight','demi');
%caxis([15 200])
caxis ([15 200])
COLORH = colorbar;
%set(COLORH,'FontName', 'Times New Roman');
set(COLORH,'FontSize', 16);
ylabel('Height above ground (m)')
xlabel('Time of Day (NZST)')
    
% Set the x-axis labels to nice intervals
datetick('x','HH:MM')
xlim([timeA(1) timeA(end)]);

figure3 = figure(3);
% plot the 2-d matrix using the 'image' function
% plot the data
image(timeD,flipdim(altD,2),flipdim((dataD)',1),'CDataMapping', 'scaled');
% label axes, with certain fonts and sizes
set(gca,'FontSize', 16);
set(gca,'FontWeight','demi');
%caxis([15 200])
caxis ([15 100])
COLORH = colorbar;
%set(COLORH,'FontName', 'Times New Roman');
set(COLORH,'FontSize', 16);
ylabel('Height above ground (m)')
xlabel('Time of Day (NZST)')
    
% Set the x-axis labels to nice intervals
datetick('x','HH:MM')
xlim([timeA(1) timeA(end)]);

figure4 = figure(4);
axes4 = axes('Parent',figure4,'FontWeight','demi','FontSize',16);
hold on
plot(grad_data,altD,'b','LineWidth',2)
%plot(mean(dataA),altA,'r','LineWidth',2)
ylim ([50 4000])
%legend('noise corrected', 'original')
xlabel('backscatter','FontWeight','demi','FontSize',16)
ylabel('height [m]','FontWeight','demi','FontSize',16)
title(['Gradient of 3-hour mean profile on ' date(4:5) '.' date(2:3) '.201' date(1) ', ' hour ' NZST'],'FontWeight','demi','FontSize',16)
hold off


