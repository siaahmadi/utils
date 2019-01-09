classdef queue < handle
	properties
	end
	properties(SetAccess=private)
		Items
		currInd = 0;
	end
	methods
		function obj = queue(Items)
			if isempty(Items)
				obj.Items = [];
				obj.currInd = 1;
			end
			if iscell(Items)
				obj.Items = Items;
			else
				obj.Items = num2cell(Items(:));
			end
		end
		function item = next(obj)
			if isempty(obj.Items)
				item = [];
				return
			end
			obj.currInd = obj.currInd + 1;
			if obj.currInd > length(obj.Items)
				fprintf(2, '%s!\0', 'Reached end');
				item = obj.Items{end};
				return
			end
			item = obj.Items{obj.currInd};
		end
		function rewind(obj)
			obj.currInd = 0;
		end
		function ef = eof(obj)
			ef = false;
			if obj.currInd >= length(obj.Items)
				ef = true;
			end
		end
		function n = numel(obj)
			n = numel(obj.Items);
		end
	end
end