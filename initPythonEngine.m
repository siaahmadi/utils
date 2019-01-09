function initPythonEngine(loadModule, modulePath)

if ~exist('modulePath', 'var') || isempty(modulePath)
	modulePath = 'Y:\Sia\scripts\py';
end
if ~exist('loadModule', 'var') || isempty(loadModule)
	loadModule = 'myutils';
end

[~, ~, ~] = pyversion; % force load Python
sys = py.importlib.import_module('sys');
sys.path.append(modulePath);
py.importlib.import_module(loadModule);