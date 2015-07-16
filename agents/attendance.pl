%% Attendance taking agent
%% lists uids of all connected students

:- dynamic att_handler/3.

%% payloads
%% att_register, timestamp. 
init_att :- 
    agent_createg(attt, att_handler, blue),
    add_token(attt, [9595]),
    %% add payloads
    assert(timestamp(guid, none, 0)),
    assert(att_register(guid, [])),
    add_payload(attt, [(timestamp, 3), (att_register,2)]).

att_handler(guid, (IP, Port), main) :- 
    %% check if node has been marked
    (current_predicate(present/0) -> set_colorg('#FF6600') ;
        %% add node to payload list
        uid(Uid),
        retract(att_register(guid, L)),
        assert(att_register(guid, [(Uid, (IP,Port))|L])),
        set_colorg('#99FF66'),
        assert(present)
    ),
    %% update timestamp information of present node
    (retract(timestamp(guid, (IP,Port), _)) -> true ; true),
    get_time(X),
    assert(timestamp(guid, (IP, Port), X)),
    %% move to next node
    %% Check for unvisited neighbours
    (link(Loc), \+ timestamp(guid, Loc, _) -> Dest=Loc ;
    %% else go to least recently visited
    writeln('reached else'),
    findall(Tim, (timestamp(guid, Place, Tim), link(Place)), Ln),
    writeln(Ln),
    min_list(Ln, Min),
    writeln(Min),
    timestamp(guid, Dest, Min)
    ),
    writeln(Dest),
    agent_moveg(guid, Dest).