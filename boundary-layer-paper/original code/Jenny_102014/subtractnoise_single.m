%fuction subtractnoise_single

%subtract the noise profile from the single running averages

clear all;

%profile_nonoise = zeros(18,760);

%Path to the 10-min profiles
%ceilpath = 'f:\NewZealand\V_CL31\AK1303\';
ceilpath = 'd:\Neuseeland\uni\matfiles\singleprofiles\AK1310\';

%noise profile
noisefile = fullfile('d:\Neuseeland\uni\matfiles\singleprofiles\','noiseprofile_r_16_65.mat');
load(noisefile, 'meanprolow');
noiseprofile = meanprolow;
%Have to find data to read profile and to be able to subtract noise profile
listpath = dir([ceilpath 'R31031*.mat']);
m = length(listpath);
for j = 1:m
        
    ceilfile = fullfile([ceilpath listpath(j).name])
    load(ceilfile)
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
    nonoisefile = fullfile('d:\Neuseeland\uni\matfiles\singleprofiles\' , 'AK1310\', [listpath(j).name]);
    exi = exist(nonoisefile);
    %if exi ~= 2
        save(nonoisefile,'profile_nonoise','time','height');
    %end
end

