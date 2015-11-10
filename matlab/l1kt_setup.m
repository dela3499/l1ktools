% get path to this script
this_path = strrep(which(mfilename), sprintf('%s%s.m',filesep, mfilename), '');  

% add appropriate paths to matlab environment
% these directories contain the .m files
addpath(genpath(fullfile(this_path, 'lib')));
addpath(genpath(fullfile(this_path, 'data_pipeline')));
addpath(genpath(fullfile(this_path, 'demos_and_examples')));

% add java utils for parsing lxbs
javaaddpath('lib/lxb-util.jar')

% set up path for mortar
% global MORTARPATH;
MORTARPATH = '.';