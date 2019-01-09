function lines = textreadlines(pathToTxtFile)
	fID = fopen(pathToTxtFile);
% 	fcontent = textscan(fID, '%s\n');
	if fID == -1
		error('Something wrong opening the file')
	end
	
	lines = cell(0, 1);
	buffer = 0;
	while ~isequal(buffer, -1)
		buffer = fgetl(fID);
		lines{end+1} = buffer;
	end
	lines(end) = [];
	lines = lines(:);
	
	fclose(fID);
end