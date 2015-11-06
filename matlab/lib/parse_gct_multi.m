function ds = parse_gct_multi(fn, varargin)
pnames = {'version'};
dflts = {'1'};
arg = parse_args(pnames, dflts, varargin{:});

dsfile = parse_filename(fn, 'wc', '*.gct');
nds = length(dsfile);

for ii=1:nds
    fprintf('%d/%d\n', ii, nds);
    switch arg.version
        case '1'
            ds(ii) = parse_gct0(mapdir(dsfile{ii}), varargin{:});
        case '2'
            ds(ii) = parse_gct(mapdir(dsfile{ii}), varargin{:});
        case 'dev'
            ds(ii) = parse_gct_dev(mapdir(dsfile{ii}), varargin{:});
    end
end
