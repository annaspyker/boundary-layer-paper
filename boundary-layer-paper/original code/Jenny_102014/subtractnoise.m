%fuction subtractnoise

%subtract the noise profile from the 10-min mean profiles

clear all;

profile_nonoise = zeros(18,760);

%Path to the 10-min profiles
ceilpath = 'd:\Neuseeland\uni\matfiles\10min\';

%noise profile
noisefile = fullfile(ceilpath,'noiseprofile20_120.mat');
load(noisefile, 'meanprolow');
noiseprofile = meanprolow;
%Have to find 10-min data and read out profiles to be able to subtract
%noise profile
listfolder = dir([ceilpath 'AK*'])
n = length(listfolder);
for i = 1:n
    ceilmpath = [ceilpath listfolder(i).name '\'];
    listpath = dir([ceilmpath 'A*']);
    m = length(listpath);
    for j = 1:m
        
        ceilfile = fullfile([ceilmpath listpath(j).name]);
        load(ceilfile);
        profiles = data{1,1};
        time = data{1,2};
        height = data{1,3};
        [m,n] = size(profiles);
        
        
        %size(noiseprofile)
        profile_nonoise = zeros(m,n);
        for k = 1:m
            profile_nonoise(k,:) = profiles(k,:) - noiseprofile;
        end
        
        %negative values do not make sense in a physical way, set = 0
        ze = find(profile_nonoise < 0);
        profile_nonoise(ze) = 0;
        %Save nonoisefile in the same directory as the 10-min data, but with
        %another starting letter (C = clean)
        nonoisefile = fullfile(ceilmpath, ['D' listpath(j).name(2:end)]);
        save(nonoisefile,'profile_nonoise','time','height');
    end
end

