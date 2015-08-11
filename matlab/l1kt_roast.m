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
% outputs (as gct matrices):
% GEX
% QNORM
% INF
% ZSPC/VC
%
% requires appropriate paths be added to the matlab workspace, ie:
% addpath(genpath('l1ktools/data')) 
% addpath(genpath('l1ktools/matlab'))
% addpath(genpath('l1ktools/matlab/lib'))


% get passed arguments
pnames = {'plate', 'plate_path', 'map_path', 'raw_path'};
dflts = {'LJP009_A375_24H_X1_B20', './', '../data/maps', '../data/lxb'};
args = parse_args(pnames, dflts, varargin{:});

% create struct to manage plate params
plateinfo = struct('raw_path', fullfile(args.raw_path, args.plate), ...
    'map_path', fullfile(args.map_path, strcat(args.plate, '.map')))

% parse inputs
chip = parse_tbl('L1000_EPSILON.R2.chip');
platemap = parse_tbl(plateinfo.map_path);

% make output directory if needed
outpath = fullfile(args.plate_path, args.plate);
if exist(outpath, 'file') == 0
    mkdir(outpath)
end

% start messaging
fprintf('##[ %s ]## Start\n', 'l1kt_roast');
fprintf('arguments:\n');
disp(args);

% detect peaks for each lxb file
% get list of lxb files in the raw directory
lxb_files = dir(plateinfo.raw_path);
fprintf('Detecting peaks...\n');
% background correction
d = dir(fullfile(plateinfo.raw_path, '*.lxb'));
wn = unique(get_wellinfo({d.name}'));
%estimate bkg by sampling 10 random wells
bgwells = wn(randsample(1:length(wn), 10));
[bkg, bkg_correct] = estimate_bkg(plateinfo.raw_path, bgwells);
for i=1:5 % change this to use all lxbs in final version
    lxbfile = fullfile(args.raw_path, args.plate, lxb_files(i).name);
    [~, ~, ext] = fileparts(lxbfile);
    if strcmp(ext, '.lxb')
        [pkstats, raw] = l1kt_dpeak(lxbfile, 'showfig', false);
        % assign the peaks to genes
        assign = assign_lxb_peaks(pkstats);

        end
    end
end % end peak detection

end % end script
