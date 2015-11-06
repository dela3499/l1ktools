% add appropriate paths to matlab environment
% assumes run from within l1ktools/matlab
addpath(genpath('../data')) 
% addpath(genpath('matlab'))
addpath(genpath('lib'))

% add java utils for parsing lxbs
javaaddpath('lib/lxb-util.jar')

% set up path for mortar
global mortarpath;
mortarpath = '.';