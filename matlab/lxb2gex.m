% given a directory of lxb files, 
% convert to GEX matrix

%% lxb2gex: convert raw data (lxb) to gene expression (GEX)
function [pkstats, assign] = lxb2gex(plate_name, plate_path)
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
		'parallel', true);
	% and assign them
	assign = assign_lxb_peaks(pkstats);

end % end lxb2gex
