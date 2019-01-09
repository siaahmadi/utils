function ps = phasestruct(varargin)
%PHASESTRUCT Make a unified struct for storing a singleton LFP phase
%
% ps = PHASESTRUCT(['parameter', 'value']);
%
% parameter:
%      - theta
%      - lgamma
%      - mgamma
%      - hgamma

args = parseInput(varargin{:});

ps.theta = args.theta;
ps.lgamma = args.lgamma;
ps.mgamma = args.mgamma;
ps.hgamma = args.hgamma;


function args = parseInput(varargin)

p = inputParser();
p.addParameter('theta', NaN, @validphase)
p.addParameter('lgamma', NaN, @validphase)
p.addParameter('mgamma', NaN, @validphase)
p.addParameter('hgamma', NaN, @validphase)

p.parse(varargin{:});
args = p.Results;

function validphase(x)
validateattributes(x, {'numeric'}, {'scalar'});