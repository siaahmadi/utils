function newpath = newserver(src)

newpath = regexprep(src, '^[XYZxyz]:\', 'V:\');
