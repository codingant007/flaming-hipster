%% Tested on 11/07/2015
%% status: PASS

%% Test of static agent connect handshake mechanism
%% Turn GUI off while testing

%% init peer with given port
init(Port, SPort) :- 
    consult('../platform.pl'),
    consult('../agents/static.pl'),
    consult('../conf.pl'),
    assert(static_agent_port(SPort)),
    platform_start(localhost, Port),
    static_agent_name(Name),
    static_agent_handler(Handler),
    create_static_agent(Name, (localhost, SPort), Handler),
    agent_execute(Name, (localhost, SPort), Handler).

%% Try to connect to peer
connect(Peer) :- 
    static_agent_name(Name),
    get_platform_details(IP,Port),
    static_handler(Name, (IP,Port), connect(Peer)). 