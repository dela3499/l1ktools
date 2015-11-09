function [qnorm_ds, inf_ds] = level2_to_level3(varargin)
% LEVEL2_TO_LEVEL3 - Given a the name of a plate and the path
% to its location, run L1000 invariant set scaling (LISS) and
% quantile normalization (QNORM). Then run inference (INF) on
% the resulting QNORM matrix. Returns the QNORM and INF 
% (level 3) matrices.
% Assumes GEX (level 2) dataset(s) exist under plate_path/plate/dpeak.
%
% Arguments:
% 
%	Parameter	Value
%	plate 		the name of the directory of LXB files
% 	plate_path	the path to the directory containing plate
%	
% 
% Example:
% [qnorm_ds, inf_ds] = level2_to_level3('plate', 'LJP009_A375_24H_X1_B20', 'plate_path', '.')

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
% norm_ds = l1kt_liss(gex_ds, )

% and QNORM
qnorm_ds = l1kt_qnorm(norm_ds, fullfile(arg.plate_path, arg.plate), 'plate', arg.plate);

% run inference
inf_ds = l1kt_infer(qnorm_ds, fullfile(arg.plate_path, arg.plate), varargin{:});

end
