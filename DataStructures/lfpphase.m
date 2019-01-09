classdef lfpphase < handle
	properties (SetObservable)
		theta = NaN;
		lgamma = NaN;
		mgamma = NaN;
		hgamma = NaN;
	end
	properties(Access=private)
		lhPre
		lhPost
		OldValues
	end
	events
		PreSet
	end
	methods
		function obj = lfpphase(varargin)
			%PHASESTRUCT Make a unified struct for storing a singleton LFP phase
			%
			% ps = PHASESTRUCT(['parameter', 'value']);
			%
			% parameter:
			%      - theta
			%      - lgamma
			%      - mgamma
			%      - hgamma

			args = obj.parseInput(varargin{:});

			Bands = properties('lfpphase');
			
			obj.lhPre = cellfun(@(band) addlistener(obj,band,'PreSet',@(src,evt) validphase(src,evt,args.caller)), Bands, 'un', 0);
			obj.lhPost = cellfun(@(band) addlistener(obj,band,'PostSet',@(src,evt) validphase(src,evt,args.caller)), Bands, 'un', 0);
			
			obj.theta = args.theta;
			obj.lgamma = args.lgamma;
			obj.mgamma = args.mgamma;
			obj.hgamma = args.hgamma;
			
			function validphase(src, evnt, caller)
				Bands = properties(obj);

				if strcmp(caller, 'lfpphase.lfpphase/validphase/RevertValues') % Me calling myself
					return;
				end
				switch evnt.EventName
					case 'PreSet'
						switch src.Name
							case Bands
								obj.OldValues = cellfun(@(band) obj.(band), Bands, 'un', 0);
						end
					case 'PostSet'
						switch src.Name
							case Bands
								NewValues = cellfun(@(band) obj.(band), Bands, 'un', 0);
								
								invalid = cellfun(@(nv) ~isnumeric(nv) | ~isscalar(nv), NewValues);
								if any(invalid)
									RevertValues(obj.OldValues);
% 									fprintf(2, 'Invalid phase value being set for %s. Ignoring...\n', Bands{invalid});
								end
								
								outofrange = cellfun(@(nv) isfinite(nv) & (nv < 0 | nv >= 2*pi), cellfun(@(band) obj.(band), Bands, 'un', 0));
								if any(outofrange)
									BringInRange();
								end
						end
				end
				function RevertValues(Values)
					for i = find(invalid)
						band = Bands{i};
						obj.(band) = Values{i};
					end
				end
				function BringInRange()
					for i = find(outofrange)
						band = Bands{i};
						obj.(band) = mod(2*pi+obj.(band), 2*pi);
					end
				end
			end
		end
	end

	methods (Access=private)
		function args = parseInput(~, varargin)
			p = inputParser();
			p.addParameter('theta', NaN)
			p.addParameter('lgamma', NaN)
			p.addParameter('mgamma', NaN)
			p.addParameter('hgamma', NaN)
			p.addParameter('caller', []);

			p.parse(varargin{:});
			args = p.Results;
		end
	end
end