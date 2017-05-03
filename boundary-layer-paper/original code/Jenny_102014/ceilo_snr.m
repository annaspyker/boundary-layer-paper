%ceilo_snr
%calculate the ceilometers SNR according to Heese et al. 2010

clear all;

ceilofile = 'd:\Neuseeland\uni\matfiles\singleprofiles\AK1210\R2102415.mat';
load(ceilofile);

noisefile = fullfile('d:\Neuseeland\uni\matfiles\singleprofiles\','noiseprofile_r_16_65.mat');
load(noisefile, 'meanprolow');
noiseprofile = meanprolow;

[m,n]=size(profile_nonoise)
size(noiseprofile)
for i = 1:m
    phcor(i,:) = profile_nonoise(i,:).*height.^2;
    snr(i,:) = profile_nonoise(i,:)./sqrt(profile_nonoise(i,:) + 2*noiseprofile);
   
end
clf;
figure1 = figure(1);
plot(snr, height)

figure2 = figure(2);
plot(phcor,height)

figure3 = figure(3);
plot(profile_nonoise,height)