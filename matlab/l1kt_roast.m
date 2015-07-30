function [roasted_plate] = l1kt_roast(varargin)
% L1KT_ROAST script to take a directory of LXB files
% through the standard L1000 processing pipeline
%
% inputs:
% directory of N uniquely named lxb files
% map of annotations as tab-delimited text
%
% methods run:
% dpeak
% flip adjustment
% liss
% qnorm
% inference
% z-scoring (pc + vc)
%
% outputs (as matrices):
% GEX
% QNORM
% INF
% ZSPC/VC


% get passed arguments
pnames = {'plate', 'plate_path', 'map_path', 'raw_path'};
dflts = {'LJP009_A375_24H_X1_B20', './', '../data/maps', '../data/lxb'};
args = parse_args(pnames, dflts, varargin{:});

% make output directory if needed
outpath = fullfile(args.plate_path, args.plate);
if exist(outpath, 'file') == 0
    mkdir(outpath)
end

% start messaging
fprintf('##[ %s ]## Start\n', 'l1kt_roast');
fprintf('arguments:\n');
disp(args);

% get list of lxb files in the raw directory
lxb_path = fullfile(args.raw_path, args.plate);
lxb_files = dir(lxb_path);

% detect peaks for each lxb file
fprintf('Detecting peaks...\n');
for i=1:5
    lxbfile = fullfile(args.raw_path, args.plate, lxb_files(i).name);
    [~, ~, ext] = fileparts(lxbfile);
    if strcmp(ext, '.lxb')
        [pkstats, raw] = l1kt_dpeak(lxbfile, 'out', outpath, 'showfig', false);
    end
end % end peak detection

end % end script
