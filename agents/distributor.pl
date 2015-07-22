:- dynamic distributor_handler/3.	%% Handler for distribution.
:- dynamic distribute_file/2.		%% Payload carrying name of file being distributed.
:- dynamic agent_from/2.			%% payload carrying IP and Port information of the agent.
:- dynamic visited/2.				%% Predicate stating the file names that have been sent to a platform.

%% Initialize distributor agent.
%% Done on instructors platfrom.

init_distributor(X,F):-
	get_platform_details(IP,Port),
	agent_createg(X,distributor_handler,blue),
	add_token(X,[9595]),
	assert(distribute_file(guid,F)),
	assert(agent_from(guid,a,b)),
	add_payload(X,[(distribute_file,2),(agent_from,3)]),
	assert(visited(nik,F)),
	agent_execute(nik,(IP,Port),distributor_handler,morph).



%% Note: main handler is executed,
%% (i)After the transfer.
%%(ii)And after cloning.

%% If the agent belongs to the same platform exit execution.
%% To prevent the execution of agents after cloning.
distributor_handler(guid,(IP,Port),main):-
	writeln('exiting execution...'),
	agent_from(guid,From_IP,From_Port),
	write('From_Port ':From_Port),writeln('Port':Port),
	From_IP = IP,
	From_Port = Port,!.

%% If some agent carrying F has already arrived on this platform kill commit suicide.
distributor_handler(guid,(IP,Port),main):-
	assert(visited(guid,F)),					%% Mark the file F as visited on this platform.	
	distribute_file(guid,File),					%% Extract file name from payload.
	visited(Someother_agent,File),
	Someother_agent \= guid,
	write('File: ':File),writeln(' has already arrived on this platfrom'),
	agent_killg(guid),!.

%% Else (i)  Pull the file into current platform.
%%		(ii) Morph the agent's parent info.
%%		(iii)spawn clones of the morphed form. 
distributor_handler(guid,(IP,Port),main):-
	write('not visited': F),
	sleep(2),
	distribute_file(guid,F),						%% Extract file name from payload.
	agent_from(guid,From_IP,From_Port),				%% Extract Parent platform IP and Port from payload.
	From_server_port is From_Port + 2000,
	writeln('File: ' ),
	get(From_IP,From_server_port ,F),				%% Pull file from the parent platform.
	distributor_handler(guid,(IP,Port),morph).		%% Morph the agent by updating its parent to present platform.



%% Morph the agent payload
%% Note: This can be used to selectively spawn a set of files when agents carry more that one files
distributor_handler(guid,(IP,Port),morph):-
	remove_payload(guid,[(agent_from,3)]),			%% Remove parent platform information from the agent.
	assert(agent_from(guid,IP,Port)),				%% Assert new payload.
	add_payload(guid,[(agent_from,3)]),				%% add new payload to the agent.
	write('agent' : guid),writeln(' morphed successfully'),
	%% Extract all the links X to the platform and spawn agents to each of them.
	forall(link((_,X)),distributor_handler(guid,(IP,Port),spawn_to(X))),
	writeln('All agents spawned successfully').


%% Clone the morphed agent and send it to the specified link.
distributor_handler(guid,(IP,Port),spawn_to(X)):-
	agent_cloneg(guid,NewAgent,blue),					%% Clone agent with parent platform as present platform
														%% and distributed file name.
	writeln('agent cloned successfully!'),
	agent_moveg(NewAgent,(localhost,X)),				%% Move agent to link prescribed
	writeln('agent moved successfully!').

