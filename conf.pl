%% Configuration file

%% Path to tartarus `platform.pl` file
path_to_tartarus('../platform.pl').

%% Command to open new instance of swi prolog
%% This should be the format of the Command
%% Note: the terms in <> brackets will be replaced by the setup script
swipl_command('gnome-terminal --command "swipl -s init.pl -g <command>"').

%% Base port (base portno to start from)
%% Base port = 7000 => platforms will be 7001, 7002, ... so on
base_port(7000).

%% Size of grid (rowsxcolumns)
grid_size(10,10).

%% Insructor node(s) ?
instructor(1,3).

%% Set of TA node(s) :P
%% Note: leave atleast the null entry if none
assistant(null,null).
