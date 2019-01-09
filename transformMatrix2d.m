function mat = transformMatrix2d(tType, param, reference)

switch tType
	case 'rotation'
		x = 0; y = 0; z = 0;
		if exist('reference', 'var')
			x = reference(1);
			y = reference(2);
			if numel(reference) > 2
				z = referece(3);
			end
		end
		
		mat = makehgtform('translate', [x y z])*makehgtform('zrotate', param)*makehgtform('translate', -[x y z]);
	otherwise
		error('Operation not defined yet');
end