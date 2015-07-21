:- use_module(library(http/http_open)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_server_files)).

:- use_module(library(http/http_path)).

:- multifile user:file_search_path/2.

user:file_search_path(pwd, Cwd) :- working_directory(Cwd, Cwd).
user:file_search_path(files, pwd(files)).

http:location(files, root(files), []).

get :- 
    http_open('http://localhost:8000/files/test.txt', In, []),
    open('files/nik', write, Fd, [type(binary)]),
    copy_stream_data(In, Fd),
    close(In), close(Fd).

get(Host,Port,File):- 
	atom_concat('http://',Host,X1),
	atom_concat(X1,':',X2),
	atom_concat(X2,Port,X3),
	atom_concat(X3,'/files/',X4),
	atom_concat(X4,File,Y),
    http_open(Y, In, []),
    string_concat('files/',okay,X),
    open(X, write, Fd, [type(binary)]),
    copy_stream_data(In, Fd),
    close(In), close(Fd).



serve(Port) :- 
    http_server(http_dispatch, [port(Port)]),
    http_handler(files(.), serve_files_in_directory(files), [prefix]).
