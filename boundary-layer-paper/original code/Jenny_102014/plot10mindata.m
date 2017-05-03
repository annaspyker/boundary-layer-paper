%function plot10mindata

clear all;

date = '21024';
hour = '15';

load(['d:\Neuseeland\uni\matfiles\10min\AK1' date(1:3) '\A' date hour '.mat']);

load(['d:\Neuseeland\uni\matfiles\10min\AK1' date(1:3) '\D' date hour '.mat']);

clf;
figure1 = figure(1);
axes1 = axes('Parent',figure1,'FontWeight','demi','FontSize',16);
hold on
plot(mean(profile_nonoise(1:18,:)),height,'b','LineWidth',2)
plot(mean(data{1,1}),data{1,3},'r','LineWidth',2)
ylim ([50 4000])
legend('noise corrected', 'original')
xlabel('backscatter','FontWeight','demi','FontSize',16)
ylabel('height [m]','FontWeight','demi','FontSize',16)
title(['3-hour mean profile on ' date(4:5) '.' date(2:3) '.201' date(1) ', ' hour ' NZST'],'FontWeight','demi','FontSize',16)
hold off