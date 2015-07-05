:- use_module(library(http/http_open)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

      

get :- 
    http_open('http://localhost:8000/test.zip', In, []),
    open('test.zip', write, Fd, [type(binary)]),
    copy_stream_data(In, Fd),
    close(In), close(Fd).

serve :- 
    http_server(http_dispatch, [port(8000)]),
    http_handler('/test.zip', http_reply_file('test.zip', []), []).
