%% Initialization of platforms

:- use_module(library(random)).

getxy(N, Cols, X, Y) :- X is ceiling(N/Cols), Y is mod(N, Cols), Y>0.
getxy(N, Cols, X, Y) :- X is ceiling(N/Cols), Rem is mod(N,Cols), Rem=0, Y is Cols.

init(N) :- 
    consult('conf.pl'),
    consult('gui/libgui.pl'),
    path_to_tartarus(Path), consult(Path),
    base_port(Base), Port is Base + N,
    platform_startg(N, localhost, Port),
    set_token(9595),
    %% Get X,Y coords
    grid_size(_, Cols),
    getxy(N, Cols, X, Y),
    writeln(X), writeln(Y),
    

    %% Wait for others to initialize
    sleep(15),
    %% Randomly create links
    %% build a list of neighbours
    L = [], 
    (Left is Y-1, Left > 0 -> Np is N-1, L1 = [Np|L] ; L1=L),
    (Bot is X-1, Bot > 0 -> Npp is (X-2)*Cols+Y, L2=[Npp|L1] ; L2=L1),
    (Cornx is Y-1, Corny is X-1, Cornx > 0, Corny > 0 -> Nppp is (X-2)*Cols+Y-1, L3=[Nppp|L2] ; L3 = L2),
    (Dornx is X-1, Dorny is Y+1, Dornx > 0, Dorny =< Cols -> Npppp is (X-2)*Cols+Y+1, L4=[Npppp|L3] ; L4=L3),
    
    %% Randomly select links
    (L3\=[] ->
        writeln('non empty'),
        select_random(L4,L4)  
     ; true).    



    %% If instructor

    %% If TA
    
select_random(L,[]) :- (current_predicate(link/1) -> true ; select_random(L,L)).
select_random(L, [H|T]) :- random_between(0,1,R), writeln('making selection':R), (R=1 -> create_link(H) ; true), select_random(L,T).

%% predicate to create link
create_link(I) :- base_port(Base), Port is Base + I, assert(link(Port)), create_linkg(Port).