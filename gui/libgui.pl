%% Library for Tartarus Tracker GUI
%% written by Midhul Varma <midhul.v@gmail.com>
%% 2 June 2015

:- use_module(library(http/http_client)).

:- dynamic gui_status/1.

%% Configuration
server_url('http://localhost:8080/').
%% Toggle this to enable/disable gui
gui_status(on).
%% Delay during agent motion
%% in seconds
move_delay(2).

%% Note: every platform must have a unique `uid`

%% Platform start w/ GUI support
platform_startg(Uid, Host, Port) :- gui_status(on),
    assert(uid(Uid)),
    server_url(Url),
    platform_start(Host,Port),
    http_post(Url, form([action(create_node), uid(Uid), port(Port)]), Rep, []),
    writeln(Rep),!.

platform_startg(Uid,Host,Port) :- assert(uid(Uid)), platform_start(Host,Port).

%% Create link in the GUI
create_linkg(Port) :- gui_status(on),
    uid(Uid),
    server_url(Url),
    http_post(Url, form([action(create_link), uid(Uid), dest_port(Port)]), Rep, []),
    writeln(Rep),!.

create_linkg(_) :- true.

%% Spawn agent w/ GUI support
agent_createg(Guid, Handler, Color) :- gui_status(on),
    uid(Uid),
    server_url(Url),
    http_post(Url, form([action(spawn_agent), uid(Uid), guid(Guid), color(Color)]), Rep, []),
    writeln(Rep),
    get_platform_details(IP, Port),
    agent_create(Guid, (IP, Port), Handler),!.

agent_createg(Guid, Handler, _) :- 
    get_platform_details(IP, Port),
    agent_create(Guid, (IP, Port), Handler).

%% Move agent w/ GUI support
agent_moveg(Guid, (Host, Port)) :- gui_status(on),
    server_url(Url),
    move_delay(Delay),
    http_post(Url, form([action(move_agent), guid(Guid), dest_port(Port), duration(Delay)]), Rep, []),
    writeln(Rep),
    sleep(Delay),
    agent_move(Guid, (Host, Port)),!.

agent_moveg(Guid, Dest) :- agent_move(Guid, Dest).

%% Kill agent w/ GUI support
agent_killg(Guid) :- gui_status(on),
    server_url(Url),
    http_post(Url, form([action(kill_agent), guid(Guid)]), Rep, []),
    writeln(Rep),
    agent_kill(Guid),!.

agent_killg(Guid) :- agent_kill(Guid).

%% Set node color w/ GUI support
set_colorg(Color) :- gui_status(on),
    uid(Uid),
    server_url(Url),
    http_post(Url, form([action(set_color), uid(Uid), color(Color)]), Rep, []),
    writeln(Rep),!.

set_colorg(_) :- true.