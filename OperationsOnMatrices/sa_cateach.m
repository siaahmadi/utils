function catarray = sa_cateach(aString, stringArray)

catarray = cell(length(stringArray), 1);
for i = 1:length(catarray)
	catarray{i} = [aString stringArray{i}];
end
