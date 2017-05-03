% CeilRemoveBackgroundNoise removes the wave-type background profile from
% the ceilometer data
%
% [NewCeilData] = CeilRemoveBackgroundNoise(CeilData,NoiseFilename)
%
% Reads in the Noise profile from the file NOISEFILENAME and removes it
% from the input ceilomter data, CEILDATA. 
%
% The NOISEFILENAME input is optional, the default value is 
% '/<<<Current Matlab Directory>>>/NoiseProfiles/NoiseProfile.mat'
%
% This profile was developed using ceilomter data from  July 5 to Sept. 15,
% 2007. The procedure used is detailed in:
%
% Current version created by Derek van der Kamp, June 26, 2009.
% email: derek.vanderkamp@alumni.ubc.ca
%-------------------------------------------------------------------------


function [NewCeilData] = ...
    CeilRemoveBackgroundNoise(CeilData,NoiseFilename)

if (nargin <2),NoiseFilename = ...
    'NoiseProfiles/NoiseProfile.mat'; end

% Check to see if data is the proper format
if ~isCeilometerData(CeilData)
    error('Inputed Ceilometer Data not properly formatted');
end

% Read in Profile
SmoothBackGroundProfileFile = open(NoiseFilename);
SmoothBackGroundProfile = ...
    SmoothBackGroundProfileFile.NoiseProf2percJuly5toSept14;

MaxAltIndex = min([700 length(CeilData{3})]);

% Remove profile from data
NewCeilData = ceil_section(CeilData,[],[],[],[],5,MaxAltIndex*5,1);

NewCeilData = ...
    ceil_subtractSignal(NewCeilData,...
        SmoothBackGroundProfile(1:length(NewCeilData{3}))...
    );









