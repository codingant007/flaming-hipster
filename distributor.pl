:- dynamic distributor_handler/3.


distributor_handler(guid,(IP,Port),main):-
	distribute(guid,F),
	from(guid,From_IP,From_Port),
	get(From_IP,From_Port + 1000 ,F),
	remove_payload(guid,[(from,3)]),
	distributor_handler(guid,(IP,Port),file(F)).


distributor_handler(guid,(IP,Port),file(F)):-
	serve(Port + 1000),
	assert(distribute(guid,F)),
	assert(from(guid,IP,Port)),
	add_payload(guid,[(distribute,2),(from,3)]),
	(visited(F) -> writeln('already visited'),agent_kill(guid) ;assert(visited(F)), forall(link(Port),distributor_handler(guid,(IP,Port),spawn_to(X)))),
	writeln('Distributor agent').

distributor_handler(guid,(IP,Port),spawn_to(X)):-
	agent_clone(guid,(IP,Port),NewAgent),
	agent_move(NewAgent,(localhost,X)).

