%% Predicates for static agents

%% Message sending and acknowledgement for updating neighbour information

:- dynamic static_handler/3.

static_handler(guid, (_IP, _Port), main) :- 
    writeln('Static agent initialized').

%% When a peer tries to connect
%% WARNING: Src port will be different from Peer platform port (due to static agent)
static_handler(guid, Src, on_connect(Peer)) :- 
    %% do a handshake and send ack
    %% check if peer is already connected
    get_platform_details(IP, Port),
    static_agent_name(SName),
    static_agent_handler(SHandler),
    ((current_predicate(link/1) -> link(Peer) ; fail) ->
         %% Conection alr exists
         %% send negative ack
         writeln('peer attempting to connect'),
         agent_post(platform, Src, [SHandler, SName, Src, connect_negative_ack((IP,Port))]),
         writeln('negative ack sent to peer')
    ; 
        %% Create link
        assert(link(Peer)),
        %% send positive ack
        agent_post(platform, Src, [SHandler, SName, Src, connect_positive_ack((IP,Port))]),
        writeln('positive ack sent to peer for connection')
    ).

%% Try to connect to a peer
%% Uses static_addr/2 from conf.pl to get peer
%% static agent location
%% Uses static_agent_port/1 from callee platform
static_handler(guid, (IP,Port), connect(Peer)) :- 
    static_agent_port(SPort), Src=(IP,SPort),
    static_addr(Peer, Dest),
    static_agent_name(SName),
    static_agent_handler(SHandler),
    agent_post(platform, Dest, [SHandler, SName, Src, on_connect((IP,Port))]),
    writeln('requesting peer for connection').

%% If peer accepts connection
static_handler(guid, (_IP,_Port), connect_positive_ack(Peer)) :- 
    writeln('recvd positive ack'),
    %% create link
    assert(link(Peer)),
    writeln('link created'),
    Peer=(_,PPort),
    create_linkg(PPort).

%% If peer rejects connection
static_handler(guid, (_IP,_Port), connect_negative_ack(_)) :- 
    writeln('Peer rejected connection').



%% Helper Predicates
%% Try to connect to peer
connect(Peer) :- 
    static_agent_name(Name),
    get_platform_details(IP,Port),
    static_handler(Name, (IP,Port), connect(Peer)). 