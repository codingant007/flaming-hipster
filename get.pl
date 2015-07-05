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
    http_open('http://localhost:8000/test.zip', In, []),
    open('test.zip', write, Fd, [type(binary)]),
    copy_stream_data(In, Fd),
    close(In), close(Fd).

serve :- 
    http_server(http_dispatch, [port(8000)]),
    http_handler(files(.), serve_files_in_directory(files), [prefix]).
