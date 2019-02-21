function str = num2words(num,opts,varargin)
% Convert a number to a string with the English name of the number value (GB/IN/US).
%
% (c) 2017 Stephen Cobeldick
%
% Convert a numeric scalar into a string giving the number in English words,
% e.g. 1024 -> 'one thousand and twenty-four', exactly as it would be spoken
% by a person. Very handy for converting to text or computer-generated voice!
%
%%% Syntax:
%  str = num2words(num)
%  str = num2words(num,opts)
%  str = num2words(num,<name-value pairs>)
%
% The number format is based on: http://www.blackwasp.co.uk/NumberToWords.aspx
% Options control the number scale, number type, number precision, the
% string's character case, commas, hyphens, trailing zeros, and more.
%
% See also WORDS2NUM NUM2SIP NUM2BIP NUM2ORDINAL INT2STR NUM2STR NATSORT ARRAYFUN TTS
%
%% Options %%
%
% The options may be supplied either
% 1) in a scalar structure, or
% 2) as a comma-separated list of name-value pairs.
%
% Field names and string values are case-insensitive. The following field
% names and values are permitted as options (*=default value):
%
% Field  | Permitted  |
% Name:  | Values:    | Description (example):
% =======|============|====================================================
% type   |'decimal'  *| Number words are cardinal/decimal (21->'twenty-one')
%        |'ordinal'   | Last number word is an ordinal    (21->'twenty-first')
%        |'highest'   | Uses the highest suitable multiplier, with decimal
%        |            | digits if required  (1.2e9->'one point two billion')
%        |'cheque'    | (1->'one dollar only', 0.1->'zero dollars and ten cents')
%        |'money'     | (1->'one dollar',      0.1->'ten cents')
% -------|------------|----------------------------------------------------
% scale  |'short'    *| Short scale, modern English   (1e9->'one billion')
%        |'long'      | Long scale, B.E. until 1970's (1e9->'one thousand million')
%        |'peletier'  | Most other European languages (1e9->'one milliard')
%        |'rowlett'   | Russ Rowlett's Greek-based    (1e9->'one gillion')
%        |'indian'    | Indian with Lakh and Crore    (1e9->'one hundred crore')
%        |'knuth'     | Donald Knuth's logarithmic    (1e9->'ten myllion')
% -------|------------|----------------------------------------------------
% case   |'lower'    *| Lowercase string  ('one thousand and twenty-four')
%        |'upper'     | Uppercase string  ('ONE THOUSAND AND TWENTY-FOUR')
%        |'title'     | Titlecase string  ('One Thousand and Twenty-Four')
%        |'sentence'  | Sentence string   ('One thousand and twenty-four')
% -------|------------|----------------------------------------------------
% hyphen | true      *| With hyphen between tens and ones ('twenty-four')
%        | false      | No hyphen between tens and ones   ('twenty four')
% -------|------------|----------------------------------------------------
% comma  | true      *| With comma separator ('one billion, two hundred million')
%        | false      | No comma separator   ('one billion two hundred million')
% -------|------------|----------------------------------------------------
% and    | true      *| With 'and' before tens/ones ('one thousand and twenty-four')
%        | false      | No 'and' before tens/ones   ('one thousand twenty-four')
% -------|------------|----------------------------------------------------
% trz    | true       | With trailing zeros  ('one point zero')
%        | false     *| No trailing zeros    ('one')
% -------|------------|----------------------------------------------------
% pos    | true       | With positive prefix ('positive one thousand and twenty-four')
%        | false     *| No positive prefix   ('one thousand and twenty-four')
% -------|------------|----------------------------------------------------
% One of the following two field names may be used, with a scalar value N:
% -------|------------|----------------------------------------------------
% order  | N        0*| Round <num> to the nearest 10^N.       See Note 1.
% sigfig | N          | Round <num> to N significant figures.  See Note 2.
% -------|------------|----------------------------------------------------
% Only for types 'money' and 'cheque' (see the section "Money" below):
% -------|------------|----------------------------------------------------
% unit   | string     | The currency unit name   (*'Dollar|')  See "Money"
% subunit| string     | The currency subunit name  (*'Cent|')  See "Money"
% -------|------------|----------------------------------------------------
%
% Note 1: For <type> 'cheque' and 'money' the default order is that of the
%  smallest subunit (i.e. -2). For all other <type> the default order is zero.
% Note 2: To provide the least-unexpected output, significant figures for numeric
%  classes single and double are internally limited to 6 and 15 digits respectively.
% Note 3: The <scale> 'knuth' ignores the options <comma> and <and>.
% Note 4: The <scale> 'indian' defaults to 'short' scale for values >= 10^21.
%
%% Money %%
%
% This function supports a unit/subunit ratio of 1/100.
%
% Type:  | Description:
% =======|=================================================================
% cheque | Leading zeros. Suffix 'Only' if subunit==0 and <trz>==false.
% -------|-----------------------------------------------------------------
% money  | No leading zeros, even if <num> is zero.
% -------|-----------------------------------------------------------------
%
% Currency unit and subunit names can be defined depending on the plural form:
% Plural:   | Input String Convention:   | Examples:
% ==========|============================|=================================
% invariant | 'InvariantName'            | 'Rand', 'Baht', 'Satang', 'Euro'
% ----------|----------------------------|---------------------------------
% regular   | 'SingularName|'            | 'Pound|', 'Rupee|', 'Kopek|'
% ----------|----------------------------|---------------------------------
% irregular | 'SingularName|PluralName'  | 'Penny|Pence', 'Krone|Kroner'
% ----------|----------------------------|---------------------------------
%
%% Examples %%
%
% num2words(0)
%  ans = 'zero'
%
% num2words(1024)
%  ans = 'one thousand and twenty-four'
% num2words(-1024)
%  ans = 'negative one thousand and twenty-four'
% num2words(1024, 'pos',true, 'case','title', 'hyphen',false)
%  ans = 'Positive One Thousand and Twenty Four'
% num2words(1024, struct('type','ordinal', 'case','sentence'))
%  ans = 'One thousand and twenty-fourth'
% num2words(1024, 'and',false, 'order',1) % round to the tens.
%  ans = 'one thousand twenty'
%
% num2words(pi, 'order',-10) % round to tenth decimal digit
%  ans = 'three point one four one five nine two six five three six'
%
% num2words(intmax('uint64'), 'sigfig',3, 'comma',false)
%  ans = 'eighteen quintillion four hundred quadrillion'
% num2words(intmax('uint64'), 'sigfig',3, 'type','highest')
%  ans = 'eighteen point four quintillion'
% num2words(intmax('uint64'), 'sigfig',3, 'scale','long')
%  ans = 'eighteen trillion, four hundred thousand billion'
% num2words(intmax('uint64'), 'sigfig',3, 'case','title', 'scale','indian')
%  ans = 'One Lakh, Eighty-Four Thousand Crore Crore'
% num2words(intmax('uint64'), 'order',17, 'case','upper', 'scale','knuth')
%  ans = 'EIGHTEEN HUNDRED FORTY BYLLION'
%
% num2words(1234.56, 'type','cheque', 'unit','Euro')
%  ans = 'one thousand, two hundred and thirty-four euro and fifty-six cents'
% num2words(1234.56, 'type','cheque', 'unit','Pound|', 'subunit','Penny|Pence')
%  ans = 'one thousand, two hundred and thirty-four pounds and fifty-six pence'
%
% num2words(101, 'type','money', 'unit','Dalmatian|', 'case','title')
% num2words(1001, 'type','money', 'unit','Night|', 'case','title')
% [num2words(2e4, 'type','money', 'unit','League|', 'case','title'), ' Under the Sea']
%
%% Input and Output Arguments %%
%
%%% Inputs:
%  num  = Numeric Scalar (float, int, or uint), the value to convert to words.
%  opts = Structure Scalar, with optional fields and values as per 'Options' above.
%  OR
%  <name-value pairs> = a comma separated list of field names and associated values.
%
%%% Output:
%  str = Char Vector, a string with the value of <num> in words of the chosen number
%        type and dialect, rounded to the requested order or significant figures.
%
% str = num2words(num,*opts)
% str = num2words(num,*<name-value pairs>)

%% Input Wrangling %%
%
assert(isnumeric(num)&&isscalar(num),'First input <num> must be a numeric scalar.')
assert(isreal(num),'First input <num> cannot be a complex value: %g%+gi',num,imag(num))
%
% Default option values:
dfar = struct('case','lower', 'type','decimal', 'scale','short',...
	'comma',true, 'hyphen',true, 'and',true, 'pos',false, 'trz',false,...
	'white',' ', 'order',0, 'sigfig',0,... % In cells, as per post-parsing:
	'subunit',{{'Cent','Cents'}}, 'unit',{{'Dollar','Dollars'}});
%
% Check any supplied option fields and values:
switch nargin
	case 1 % no options
		dfar.iso = true;
		dfar.mny = false;
	case 2 % options in a struct
		assert(isstruct(opts)&&isscalar(opts),'Second input <opts> can be a scalar struct.')
		dfar = n2wOptions(dfar,opts);
	otherwise % options as <name-value> pairs
		opts = struct(opts,varargin{:});
		assert(isscalar(opts),'Invalid <name-value> pairs: cell array values are not permitted.')
		dfar = n2wOptions(dfar,opts);
end
%
tmp = {dfar.white,'-'};
dfar.hyp = tmp{1+dfar.hyphen};
%
%% Order & Significant Figures %%
%
if isfinite(num)
	%
	if num==0
		mag = -1;
	elseif isfloat(num)
		mag = floor(log10(abs(num)));
	else % integer
		mag = numel(sprintf('%lu',abs(num)))-1;
	end
	%
	if dfar.iso % order
		odr = dfar.order;
		sgf = mag + 1 - odr;
	else % sigfig
		sgf = dfar.sigfig;
		odr = mag + 1 - sgf;
	end
	%
else % Inf or NaN
	%
	sgf = 0;
	odr = 0;
	%
end
%
%% Convert Numeric to String %%
%
if sgf<1 % round one digit to a particular order
	%
	raw = sprintf('%+.0f',num/10^odr);
	%
	if strcmp(raw(2:end),'Inf')
		str = 'Infinity';
		frc = [];
	elseif strcmp(raw,'NaN')
		str = sprintf('Not%sa%sNumber',dfar.hyp,dfar.hyp);
		frc = [];
		dfar.pos = false;
	else % one digit
		pwr = odr;
		[str,frc] = n2wParse(dfar,pwr,sgf,mag,raw(2:end)-'0');
	end
	%
elseif isfloat(num)
	%
	tmp = min(sgf,6+9*isa(num,'double'));
	raw = sprintf('%#+.*e',tmp-1,num);
	%
	ide = strfind(raw,'e');
	pwr = sscanf(raw(ide:end),'e%d');
	[str,frc] = n2wParse(dfar,pwr,sgf,mag,raw([2,4:ide-1])-'0');
	%
else % integer
	%
	cls = class(num);
	bit = sscanf(cls, '%*[ui]nt%u');
	pfx = {[],[],'%h','%h','%','%l'}; % {2,4,8,16,32,64} bit
	%
	tmp = max(0,odr);
	raw = sprintf([pfx{log2(bit)},cls(1)], num/10^tmp);
	%
	isn = num<0;
	pwr = numel(raw)-1-isn-(mag<0)+tmp;
	[str,frc] = n2wParse(dfar,pwr,sgf,mag,raw(1+isn:min(sgf+isn,end))-'0');
	%
end
%
%% Money or Ordinal %%
%
if dfar.mny
	odr = odr + (~dfar.iso && pwr>mag && ~strcmp(str,'Zero'));
	% Singular/plural form of unit/subunit currency name:
	fun = @(s,c)sprintf('%s%s%s',s,dfar.white,c{2-strcmp(s,'One')});
else
	% Convert fractional digits into words:
	str = [str,n2wFract(dfar,frc)];
end
%
switch dfar.type
	case 'cheque'
		if odr>=0 || ~(dfar.trz || any(frc)) % Suffix with 'Only':
			str = sprintf('%s%sOnly', fun(str,dfar.unit),dfar.white);
		else % Always include leading units, even if they are zero:
			str = sprintf('%s%sand%s%s', fun(str,dfar.unit),dfar.white,...
				dfar.white,fun(n2wCents(dfar,frc),dfar.subunit));
		end
	case 'money'
		if odr>=0 || ~(dfar.trz || any(frc)) % Only the units:
			str = fun(str,dfar.unit);
		elseif strcmp(str,'Zero') % Only the subunits:
			str = fun(n2wCents(dfar,frc),dfar.subunit);
		else % Mixed units and subunits:
			str = sprintf('%s%sand%s%s', fun(str,dfar.unit),dfar.white,...
				dfar.white,fun(n2wCents(dfar,frc),dfar.subunit));
		end
	case 'ordinal'
		expr = {'(r|x|n|d|ro|re|h)$','One$','Two$','ree$','ve$','ht$','ne$','ty$'};
		repstr = {'$1th','First','Second','ird','fth','hth','nth','tieth'};
		str = regexprep(str,expr,repstr,'once');
end
%
%% Sign and Case %%
%
if strncmp('-',raw,1)
	str = sprintf('Negative%s%s',dfar.white,str);
elseif dfar.pos
	str = sprintf('Positive%s%s',dfar.white,str);
end
%
switch dfar.case
	case 'lower'
		str = lower(str);
	case 'upper'
		str = upper(str);
	case 'sentence'
		str(2:end) = lower(str(2:end));
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%num2words
function dfar = n2wOptions(dfar,opts)
% Options check: only supported fieldnames with suitable option values.
%
cFld = fieldnames(opts);
idx = ~cellfun(@(f)any(strcmpi(f,fieldnames(dfar))),cFld);
if any(idx)
	error('Unsupported field name/s:%s\b',sprintf(' <%s>,',cFld{idx})) %#ok<SPERR>
end
%
% Logical options:
dfar = n2wLgc(dfar,opts,cFld,'and');
dfar = n2wLgc(dfar,opts,cFld,'comma');
dfar = n2wLgc(dfar,opts,cFld,'hyphen');
dfar = n2wLgc(dfar,opts,cFld,'pos');
dfar = n2wLgc(dfar,opts,cFld,'trz');
%
% String options:
dfar = n2wStr(dfar,opts,cFld,'case','lower','upper','title','sentence');
dfar = n2wStr(dfar,opts,cFld,'type','decimal','ordinal','highest','cheque','money');
dfar = n2wStr(dfar,opts,cFld,'scale','long','short','peletier','rowlett','indian','knuth');
dfar = n2wStr(dfar,opts,cFld,'white','_','+','-','.','~',char(32),char(9));
%
% Currency Names:
dfar.mny = any(strcmpi(dfar.type,{'cheque','money'}));
dfar.order = -2*dfar.mny;
dfar = n2wUni(dfar,opts,cFld,'subunit');
dfar = n2wUni(dfar,opts,cFld,'unit');
%
% Precision:
dfar.iso = [];
dfar = n2wDgt(dfar,opts,cFld,'order');
dfar = n2wDgt(dfar,opts,cFld,'sigfig');
dfar.iso = isempty(dfar.iso)||dfar.iso;
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wOptions
function idx = n2wCmpi(cFld,sFld)
% Options check: throw an error if more than one fieldname match.
idx = strcmpi(cFld,sFld);
if nnz(idx)>1
	error('Duplicate field names:%s\b.',sprintf(' <%s>,',cFld{idx})); %#ok<SPERR>
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wCmpi
function dfar = n2wLgc(dfar,opts,cFld,sFld)
% Options check: logical scalar.
idx = n2wCmpi(cFld,sFld);
if any(idx)
	tmp = opts.(cFld{idx});
	assert(islogical(tmp)&&isscalar(tmp),'The <%s> value must be a scalar logical.',sFld)
	dfar.(sFld) = tmp;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wLgc
function dfar = n2wStr(dfar,opts,cFld,sFld,varargin)
% Options check: string.
idx = n2wCmpi(cFld,sFld);
if any(idx)
	tmp = opts.(cFld{idx});
	if ~ischar(tmp)||~isrow(tmp)||~any(strcmpi(tmp,varargin))
		error('The <%s> value must be one of:%s\b.',sFld,sprintf(' ''%s'',',varargin{:}));
	end
	dfar.(sFld) = lower(tmp);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wStr
function dfar = n2wDgt(dfar,opts,cFld,sFld)
% Options check: numeric scalar (order or significant figures).
idx = n2wCmpi(cFld,sFld);
if any(idx)
	assert(isempty(dfar.iso),'Only one of <order> or <sigfig> may be specified.')
	dfar.iso = strcmp(sFld,'order');
	tmp = opts.(cFld{idx});
	assert(isnumeric(tmp)&&isscalar(tmp),'The <%s> value must be a scalar numeric.',sFld)
	assert(isreal(tmp),'The <%s> value cannot be complex: %g%+gi',sFld,tmp,imag(tmp))
	assert(isfinite(tmp),'The <%s> value must be finite: %g',sFld,tmp)
	assert(fix(tmp)==tmp,'The <%s> value must be a whole number: %g',sFld,tmp)
	assert(dfar.iso||(tmp>=1),'The <%s> value must be positive: %g',sFld,tmp)
	dfar.(sFld) = double(tmp);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wDgt
function dfar = n2wUni(dfar,opts,cFld,sFld)
% Options check: currency unit or subunit name.
idx = n2wCmpi(cFld,sFld);
if any(idx) && dfar.mny
	tmp = opts.(cFld{idx});
	assert(ischar(tmp)&&isrow(tmp),'The <%s> value must be a 1xN char (currency name).',sFld)
	spl = regexp(tmp,'\|','split');
	assert(~isempty(spl{1}),'The <%s> value does not define a currency name.',sFld)
	assert(numel(spl)<3,'The <%s> value may contain up to one ''|'' character.',sFld)
	if isscalar(spl) % invariant
		dfar.(sFld) = spl([1,1]);
	elseif isempty(spl{2}) % regular
		dfar.(sFld) = strcat(spl(1),{'','s'});
	else % irregular
		dfar.(sFld) = spl;
	end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wUni
function str = n2wCents(dfar,frc)
% Create the currency subunit string (defined as 1/100 of currency unit).
%
str = [n2wWhole(dfar,1,frc(1:min(end,2))),n2wFract(dfar,frc(3:end))];
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wCents
function [str,frc] = n2wParse(dfar,pwr,sgf,mag,dgt)
% Split digits vector into whole and fractional parts, convert whole part into words.
%
sgf = sgf + (dfar.iso && pwr>mag || dgt(1)==0 && pwr==0);
% Pad with zeros or remove zeros from digits:
if dfar.trz % pad
	vec = [zeros(1,0-pwr),dgt,zeros(1,sgf-numel(dgt))];
elseif any(dgt) % remove
	vec = [zeros(1,0-pwr),dgt(1:find(dgt,1,'last'))];
else % remove
	vec = [];
end
pwr = max(0,pwr);
%
% Split into whole and fractional digits:
if isempty(vec) || pwr>0 && strcmp(dfar.type,'highest')
	frc = [];
else % decimal, ordinal, cheque, money
	idf = (pwr-(0:numel(vec)-1))<0;
	frc = vec(idf);
	vec = vec(~idf);
end
%
% Convert whole digits into words:
str = n2wWhole(dfar,pwr,vec);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wParse
function str = n2wFract(dfar,frc)
% Convert a digits vector into decimal fraction string, preceded with 'point'.
%
if isempty(frc)
	str = '';
else
	cZer = {'Zero','One','Two','Three','Four','Five','Six','Seven','Eight','Nine'};
	str = [dfar.white,'Point',sprintf([dfar.white,'%s'],cZer{1+frc})];
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wFract
function [mat,grp] = n2wShape(pwr,vec,N)
% Reshape input <vec> into a matrix with <N> rows, according to magnitude of order.
%
grp = mod(pwr-(0:numel(vec)-1),N);
mat = reshape([zeros(1,N-1-grp(1)),vec(:)',zeros(1,grp(end))],N,[]);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wShape
function [idy,frc] = n2wSplit(dfar,mat,grp,N)
% Split fractional parts from <mat>, index of (non-zero) columns to keep.
%
if strcmp(dfar.type,'highest')
	idy = true;
	frc = mat(N+1:end-grp(end));
else
	idy = any(mat,1);
	frc = [];
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wSplit
function mat = n2wTeens(mat,N)
% Convert teens to ones within <mat>. N is tens row, N+1 is ones row.
%
idx = mat(N,:)==1;
mat(N+1,idx) = mat(N+1,idx) + 10;
mat(N+0,idx) = 0;
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wTeens
function str = n2wWhole(dfar,pwr,vec)
% Convert a numeric vector of digits to a string with English number words.
%
cTen = {[],'Twenty','Thirty','Forty','Fifty','Sixty','Seventy','Eighty','Ninety'};
cOne = {'One','Two','Three','Four','Five','Six','Seven','Eight','Nine','Ten','Eleven','Twelve','Thirteen','Fourteen','Fifteen','Sixteen','Seventeen','Eighteen','Nineteen'};
%
if isempty(vec) || all(vec==0)
	str = 'Zero';
	return
elseif strcmp(dfar.scale,'knuth')
	str = n2wKnuth(dfar,pwr,vec,cTen,cOne);
	return
elseif strcmp(dfar.scale,'indian') && pwr<21
	str = n2wIndian(dfar,pwr,vec,cTen,cOne);
	return
elseif strcmp(dfar.scale,'rowlett') % Derived from the work of Russ Rowlett and Sbiis Saibian.
	cPfx = {'M','G','Tetr','Pent','Hex','Hept','Okt','Enn','Dek','Hendek','Dodek','Trisdek','Tetradek','Pentadek','Hexadek','Heptadek','Oktadek','Enneadek','Icos','Icosihen','Icosid','Icositr','Icositetr','Icosipent','Icosihex','Icosihept','Icosiokt','Icosienn','Triacont','Triacontahen','Triacontad','Triacontatr','Triacontatetr','Triacontapent','Triacontahex','Triacontahept','Triacontaokt','Triacontaenn','Tetracont','Tetracontahen','Tetracontad','Tetracontatr','Tetracontatetr','Tetracontapent','Tetracontahex','Tetracontahept','Tetracontaokt','Tetracontaenn','Pentacont','Pentacontahen','Pentacontad','Pentacontatr','Pentacontatetr','Pentacontapent','Pentacontahex','Pentacontahept','Pentacontaokt','Pentacontaenn','Hexacont','Hexacontahen','Hexacontad','Hexacontatr','Hexacontatetr','Hexacontapent','Hexacontahex','Hexacontahept','Hexacontaokt','Hexacontaenn','Heptacont','Heptacontahen','Heptacontad','Heptacontatr','Heptacontatetr','Heptacontapent','Heptacontahex','Heptacontahept','Heptacontaokt','Heptacontaenn','Oktacont','Oktacontahen','Oktacontad','Oktacontatr','Oktacontatetr','Oktacontapent','Oktacontahex','Oktacontahept','Oktacontaokt','Oktacontaenn','Enneacont','Enneacontahen','Enneacontad','Enneacontatr','Enneacontatetr','Enneacontapent','Enneacontahex','Enneacontahept','Enneacontaokt','Enneacontaenn','Hect','Hectahen','Hectad'};
else % Derived from the work of John Conway, Allan Wechsler, Richard Guy, and Olivier Miakinen.
	cPfx = {'M','B','Tr','Quadr','Quint','Sext','Sept','Oct','Non','Dec','Undec','Duodec','Tredec','Quattuordec','Quindec','Sedec','Septendec','Octodec','Novendec','Vigint','Unvigint','Duovigint','Tresvigint','Quattuorvigint','Quinvigint','Sesvigint','Septemvigint','Octovigint','Novemvigint','Trigint','Untrigint','Duotrigint','Trestrigint','Quattuortrigint','Quintrigint','Sestrigint','Septentrigint','Octotrigint','Noventrigint','Quadragint','Unquadragint','Duoquadragint','Tresquadragint','Quattuorquadragint','Quinquadragint','Sesquadragint','Septenquadragint','Octoquadragint','Novenquadragint','Quinquagint','Unquinquagint','Duoquinquagint','Tresquinquagint','Quattuorquinquagint','Quinquinquagint','Sesquinquagint','Septenquinquagint','Octoquinquagint','Novenquinquagint','Sexagint','Unsexagint','Duosexagint','Tresexagint','Quattuorsexagint','Quinsexagint','Sesexagint','Septensexagint','Octosexagint','Novensexagint','Septuagint','Unseptuagint','Duoseptuagint','Treseptuagint','Quattuorseptuagint','Quinseptuagint','Seseptuagint','Septenseptuagint','Octoseptuagint','Novenseptuagint','Octogint','Unoctogint','Duooctogint','Tresoctogint','Quattuoroctogint','Quinoctogint','Sexoctogint','Septemoctogint','Octooctogint','Novemoctogint','Nonagint','Unnonagint','Duononagint','Trenonagint','Quattuornonagint','Quinnonagint','Senonagint','Septenonagint','Octononagint','Novenonagint','Cent','Uncent'};
end
%
% Reshape into 3xM matrix [Hundreds;Tens;Ones]:
row = 3;
[mat,grp] = n2wShape(pwr,vec,row);
% Split fractional part:
[idy,frc] = n2wSplit(dfar,mat,grp,row);
% Move teens into ones:
mat = n2wTeens(mat(:,idy),row-1);
%
mlt = floor(pwr/row)-(0:numel(idy));
mlt = mlt(idy);
% Indices for digits and punctuation:
iHun = mat(1,:)>0; % hundreds
iTen = mat(2,:)>0; % tens
iOne = mat(3,:)>0; % ones
iCom = iHun | mlt>0 | nnz(idy)==1; % commas
iAnd = iHun&(iTen|iOne) | ~iCom; % ands
%
% Indices for multipliers:
iPel = false;  % illiards
iTho = mlt==1; % thousands
switch dfar.scale
	case 'peletier'
		idx  = rem(mlt,2);
		iIon = 0==idx & mlt>1;
		iPel = 1==idx & mlt>1;
		mlt  = 1+floor(mlt/2);
	case 'long'
		iIon = mlt>=2;
		iTho = 1==rem(mlt,2);
		mlt  = 1+floor(mlt/2);
		iDif = ~diff(mlt);
		iIon(iDif) = false;
		iDif = [false,iDif]&~iHun;
		iAnd = iAnd | iDif;
		iCom = iCom & ~iDif;
	otherwise % short, rowlett
		iIon = mlt>=2; % illions
end
%
% Allocate all digits, multipliers and punctuation:
out = cell(15,size(mat,2));
out(:) = {''}; % faster concatenation
out(1,iCom&dfar.comma) = {','};
out(2,iCom) = {dfar.white};
out(3,iHun) = cOne(mat(1,iHun));
out(4,iHun) = {[dfar.white,'Hundred']};
out(5,iAnd) = {dfar.white};
out(6,iAnd&dfar.and) = {['and',dfar.white]};
out(7,iTen) = cTen(mat(2,iTen));
out(8,iOne&iTen) = {dfar.hyp};
out(9,iOne) = cOne(mat(3,iOne));
out{10,1} = n2wFract(dfar,frc);
out(11,iTho) = {dfar.white};
out(12,iTho) = {'Thousand'};
out(13,iIon|iPel) = {dfar.white};
out(15,iIon) = {'illion'};
out(15,iPel) = {'illiard'};
if any(iIon|iPel)
	out(14,iIon|iPel) = cPfx(mlt(iIon|iPel)-1);
end
%
str = [out{3:end}];
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wWhole
function str = n2wKnuth(dfar,pwr,vec,cTen,cOne)
% Donald Knuth's logarithmic scale (aka "-Yllion").
%
cMyr = {'Hundred','Myriad','Myllion','Byllion','Tryllion','Quadryllion','Quintyllion','Sextyllion'};
cMyr = strcat({dfar.white},cMyr);
%
% Reshape into 2xM matrix [Tens;Ones]:
row = 2;
[mat,grp] = n2wShape(pwr,vec,row);
% Split fractional part:
[idy,frc] = n2wSplit(dfar,mat,grp,row);
% Move teens into ones:
mat = n2wTeens(mat(:,idy),row-1);
%
mlt = floor(pwr/row)-(0:numel(idy));
mlt = [2*mlt(idy),NaN];
%
% Identify the multipliers for each group:
idm = floor(log2(mlt));
M = 1+max(0,idm(1));
idm(M,end) = 0;
for m = 2:M
	mlt = mlt - pow2(idm(m-1,:));
	idm(m,:) = floor(log2(mlt));
end
idm(~isfinite(idm)) = 0;
idx = 0>diff(idm,1,2);
idx(end:-1:1,:) = 0<(cumsum(idx,1)&idm(:,1:end-1));
idm(end:-1:1,:) = idm;
%
% Indices for digits:
iTen = mat(1,:)>0; % tens
iOne = mat(2,:)>0; % ones
%
% Allocate all digits, multipliers and punctuation:
N = nnz(idy);
out = cell(5+M,N);
out(:) = {''};
out([false(5,N);idx]) = cMyr(idm(idx));
out{5,end} = n2wFract(dfar,frc);
out(4,iOne) = cOne(mat(2,iOne));
out(3,iOne&iTen) = {dfar.hyp};
out(2,iTen) = cTen(mat(1,iTen));
out(1,:) = {dfar.white};
%
% Concatentate the strings together:
str = [out{2:end}];
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wKnuth
function str = n2wIndian(dfar,pwr,vec,cTen,cOne)
% Indian numbering using Lakh and Crore.
%
% Reshape into 9xN matrix [NaN;TenLakhs;Lakhs;NaN;TenThousands;Thousands;Hundreds;Tens;Ones]:
row = 7;
[mat([2:3,5:9],:),grp] = n2wShape(pwr,vec,row);
mat([1,4],:) = NaN;
% Reshape into 3xM matrix [Hundreds,Tens,Ones]:
idx = grp>4;
grp = grp+idx;
mat = mat(row+2-grp(1):end-grp(end));
pwr = pwr+2*floor(pwr/row)+idx(1);
row = 3;
[mat,grp] = n2wShape(pwr,mat,row);
% Split fractional part:
[idy,frc] = n2wSplit(dfar,mat,grp,row);
% Move teens into ones:
mat = n2wTeens(mat(:,idy),row-1);
%
mlt = floor(pwr/row)-(0:numel(idy));
mlt = mlt(idy);
grp = floor(mlt/row);
% Indices for digits:
iHun = mat(1,:)>0; % hundreds
iTen = mat(2,:)>0; % tens
iOne = mat(3,:)>0; % ones
%
% Indices for multipliers:
iLak = 2==mod(mlt,row); % lakhs
iTho = 1==mod(mlt,row); % thousands
iZer = 0==mod(mlt,row); % nones
iCro = [diff(grp)<0,grp(end)>0]; % crores
%
% Indices for punctuation:
iNaN = isnan(mat(1,:));
[~,~,iUni] = unique(grp(:));
iAnd = accumarray(iUni,~iNaN&any(mat(2:3,:),1),[],@any); % ands
iAnd = iAnd & accumarray(iUni,iNaN|mat(1,:)>0,[],@any);
iAnd = iZer & (~iNaN & iAnd(iUni).' | mlt==0 & nnz(idy)>1);
iCom = iHun | ~iAnd; % commas
%
% Allocate all digits, multipliers and punctuation:
out = cell(13,size(mat,2));
out(:) = {''};
out(1,iCom&dfar.comma) = {','};
out(2,iCom) = {dfar.white};
out(3,iHun) = cOne(mat(1,iHun));
out(4,iHun) = {[dfar.white,'Hundred']};
out(5,iAnd) = {dfar.white};
out(6,iAnd&dfar.and) = {['and',dfar.white]};
out(7,iTen) = cTen(mat(2,iTen));
out(8,iOne&iTen) = {dfar.hyp};
out(9,iOne) = cOne(mat(3,iOne));
out{10,1} = n2wFract(dfar,frc(~isnan(frc)));
out(11,iTho|iLak) = {dfar.white};
out(12,iTho) = {'Thousand'};
out(12,iLak) = {'Lakh'};
if any(iCro)
	out(13,iCro) = arrayfun(@(n)repmat([dfar.white,'Crore'],1,n),grp(iCro),'UniformOutput',false);
end
%
str = [out{3:end}];
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n2wIndian