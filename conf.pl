%% Configuration file

%% Path to tartarus `platform.pl` file
path_to_tartarus('platform.pl').

%% Command to open new instance of swi prolog
%% This should be the format of the Command
%% Note: the terms in <> brackets will be replaced by the setup script
swipl_command('gnome-terminal --command "swipl -s init.pl -g <command>"').

%% Base port (base portno to start from)
%% Base port = 7000 => platforms will be 7001, 7002, ... so on
base_port(40000).

%% File server base port.
%% 2000 + platform base_port.
file_server_base(F_base):-
	base_port(B),
	F_base is B + 2000.


%% Size of grid (rowsxcolumns)
grid_size(10,10).

%% Insructor node(s) ?
instructor(1,5).

%% Set of TA node(s) :P
%% Note: leave atleast the null entry if none
assistant(null,null).


%% Static agent related Configuration
base_static_port(50000).
%% Peer -> peer location
%% Dest -> peer static agent location
static_addr(Peer, Dest) :- Peer=(Host,PPort), base_port(BPort), N is PPort-BPort, base_static_port(BSPort), SPort is BSPort+N, Dest=(Host,SPort).
static_agent_name(statica).
static_agent_handler(static_handler).