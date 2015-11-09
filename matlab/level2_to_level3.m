function qnorm_ds = level2_to_level3(varargin)
% LEVEL2_TO_LEVEL3 - Given a directory of LXB files (level 1 data), perform
% peak deconvolution flip adjustment.
% Return to the workspace a gene expression (GEX, level 2 data)
% dataset and also save as a .gct file.
%
% Arguments:
% 
%	Parameter	Value
%	plate 		the name of the directory of LXB files
% 	raw_path	the path to the directory containing plate
% 	map_path 	the path to the directory containing the a file with sample annotations
% 
% Example:
% gex_ds = level1_to_level2('plate', 'LJP009_A375_24H_X1_B20', ...
% 'raw_path', '../data/lxb_test', 'map_path', '../data/maps');

toolname = mfilename;
fprintf('-[ %s ]- Start\n', upper(toolname));
% startup_defaults;
pnames = {'plate', 'overwrite', 'plate_path', 'precision'}; %, ...
    % 'flipcorrect', 'parallel', 'randomize',...
    % 'use_smdesc', 'lxbhist_analyte', 'lxbhist_well',...
    % 'detect_param', 'setrnd', 'rndseed', ...
    % 'incomplete_map'};
dflts = { '', false, '.' 1}; %, ...
    % true, true, true, ...
    % false, '25,182,286,373,463', 'A05,N13,G17',...
    % fullfile(mortarpath,'resources', 'detect_params.txt'), true, '', ...
    % false};
arg = parse_args(pnames, dflts, varargin{:});

% run LISS
norm_ds = liss_pipe(varargin{:});

% and QNORM
qnorm_ds = qnorm(norm_ds);

% save the dataset
mkgct(fullfile(arg.plate_path, sprintf('%s_QNORM.gct',...
    arg.plate)), qnorm_ds, 'precision', arg.precision);

end
