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
    assert(stack(guid, [])),
    add_payload(attt, [(timestamp, 3), (att_register,2), (stack,2)]).

att_handler(guid, (IP, Port), main) :-

    %% update timestamp information of present node
    (retract(timestamp(guid, (IP,Port), _)) -> true ; true),
    get_time(X),
    assert(timestamp(guid, (IP, Port), X)),

    %% check if node has been marked
    (current_predicate(present/0) -> set_colorg('#FF6600') ;
        %% add node to payload list
        uid(Uid),
        retract(att_register(guid, L)),
        assert(att_register(guid, [(Uid, (IP,Port))|L])),
        set_colorg('#99FF66'),
        assert(present),
        %% add unvisited neighbours to stack
        (findall(Neigh, (link(Neigh), \+ timestamp(guid,Neigh,_)), Lun) ->
        forall((link(Ppl), \+ timestamp(guid,Ppl,_)), assert(timestamp(guid,Ppl,0))),
        retract(stack(guid, Stk)),
        append(Lun,Stk,NStk),
        assert(stack(guid, NStk)) ; true)

    ),
    
    %% move to next node
    %% Check the stack
    (retract(stack(guid, [Top|Remaining])) ->
         %%Pop top from stack
         assert(stack(guid,Remaining)),
         writeln(Top),
         agent_moveg(guid, Top)
    ;
         writeln('done') 
    ).
    