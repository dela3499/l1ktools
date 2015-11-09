this_path = strrep(which(mfilename), sprintf('%s%s.m', filesep, mfilename), '');    

% add appropriate paths to matlab environment
addpath(genpath(fullfile(this_path, '../data'))) 
addpath(genpath(fullfile(this_path, 'resources'))) 
addpath(genpath(fullfile(this_path, 'lib')))
addpath(genpath(fullfile(this_path, 'data_pipeline')))

% add java utils for parsing lxbs
javaaddpath(fullfile(this_path, 'lib/lxb-util.jar'))

% set up path for mortar
% global MORTARPATH;
MORTARPATH = this_path;