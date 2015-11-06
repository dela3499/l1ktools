% given a directory of lxb files, 
% convert to GEX matrix

%% lxb2gex: convert raw data (lxb) to gene expression (GEX)
function [ds, pkstats, assign] = lxb2gex(plate_name, plate_path)
	% plate_name: the name of the plate to be processed
	% plate_path: path to directory containing plate
	
	fprintf('##[ %s ]## Start\n', upper(mfilename));
	% detect peaks for each lxb file
	% get list of lxb files in the raw directory
	lxb_files = dir(fullfile(plate_path, plate_name, '*.lxb'));
	fprintf('Detecting peaks...\n');
	% background correction
	% wn = unique(get_wellinfo({lxb_files.name}'));
	% %estimate bkg by sampling 10 random wells
	% bgwells = wn(randsample(1:length(wn), 10));
	% [bkg, bkg_correct] = estimate_bkg(plateinfo.raw_path, bgwells);
	% [nxlb, ~] = size(lxb_files);
	% for i=1:3 % nlxb % change this to use all lxbs in final version
	% 	lxbfile = fullfile(plate_path, plate_name, lxb_files(i).name);
	% 	[~, ~, ext] = fileparts(lxbfile);
	% 	if strcmp(ext, '.lxb')
	% 		[pkstats, raw] = l1kt_dpeak(lxbfile, 'showfig', false);
	% 		% assign the peaks to features
	% 		assign = assign_lxb_peaks(pkstats);
	% 	end
	% end % end peak detection
	% detect peaks for all LXBs
	[pkstats, fn] = detect_lxb_peaks_folder(fullfile(plate_path, plate_name), ...
		'parallel', false);
	
    [nanalyte, nwells] = size(pkstats);

    % bead counts
    mean_count = zeros(nwells, 1);
    cv_count = zeros(nwells, 1);
    for ii=1:size(pkstats, 2)
        cnt = [pkstats(11:end,ii).ngoodbead];
        mean_count(ii) = mean(cnt);
        cv_count(ii) = 100 * std(cnt) / mean_count(ii);
    end

    % dummy dataset to get annotated well info
    wells = get_wellinfo(fn);
    rid = gen_labels(nanalyte, 'prefix', 'Analyte ', 'zeropad', false);
    ds = mkgctstruct(zeros(nanalyte, nwells), 'rid', rid, 'cid', wells);
    % ds = annotate_wells(ds, plateinfo, varargin{:});
    % add bead count stats
    meta_hd = {'count_mean', 'count_cv'};
    meta = [num2cellstr(mean_count, 'precision', 0),...
        num2cellstr(cv_count, 'precision', 0)];
    ds = ds_add_meta(ds, 'column', meta_hd, meta);

    % and assign them
	assign = assign_lxb_peaks(pkstats);
	

end % end lxb2gex
