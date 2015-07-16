:- dynamic distributor_handler/3.


distributor_handler(guid,(IP,Port),main):-
	distribute(guid,F),
	distributor_handler(guid,(IP,Port),file(F)).


distributor_handler(guid,(IP,Port),file(F)):-
	(visited -> writeln('already visited'),agent_kill(guid) ;assert(visited), forall(link(Port),distributor_handler(guid,(IP,Port),spawn_to(X)))),
	assert(distribute(guid,F)),
	add_payload(guid,[(distribute,2)]),
	writeln('Distributor agent').

distributor_handler(guid,(IP,Port),spawn_to(X)):-
	agent_clone(guid,(IP,Port),NewAgent),
	agent_move(NewAgent,(localhost,X)).

