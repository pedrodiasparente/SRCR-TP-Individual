:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- dynamic goal/1.

:- set_prolog_flag(toplevel_print_options,
    [quoted(true), portrayed(true), max_depth(0)]).
:- consult('base_de_conhecimento.pl').


:- multifile (-)/1.

calcula_trajeto(Origem,Dest,Caminho):-
            profundidade(Origem,Dest,[Origem],Caminho).

profundidade(Dest, Dest, H, C):- inverso(H,C).

profundidade(Origem, Dest, His, C):-
            adjacente(paragem(Origem,_,_,_,_,_,_,Carr1,_,_,_),paragem(Prox,_,_,_,_,_,_,Carr2,_,_,_)),
            \+ member(Prox, His),
            profundidade(Prox,Dest,[Prox|His],C).

%---------------------------------------

calcula_melhor_trajeto(Origem,Dest,CarrD,Caminho):-
            paragem(Origem,_,_,_,_,_,_,CarrO,_,_,_),
            paragem(Dest,_,_,_,_,_,_,CarrD,_,_,_),
            CarrO = CarrD,
            profundidade_melhor(Origem,Dest,[Origem],Caminho).

profundidade_melhor(Dest, Dest, H, C):- inverso(H,C).

profundidade_melhor(Origem, Dest, His, C):-
            adjacente(paragem(Origem,_,_,_,_,_,_,Carr1,_,_,_),paragem(Prox,_,_,_,_,_,_,Carr2,_,_,_)),
            \+ member(Prox, His),
            profundidade_melhor(Prox,Dest,[Prox|His],C).

calcula_melhor_trajeto(Origem,Dest,CarrD,Caminho):-
            paragem(Origem,_,_,_,_,_,_,CarrO,_,_,_),
            paragem(Dest,_,_,_,_,_,_,CarrD,_,_,_),
            CarrO \= CarrD,
            profundidade_melhor_carr(Origem,Dest,[Origem],Caminho).

profundidade_melhor_carr(Dest, Dest, H, C):- inverso(H,C).

profundidade_melhor_carr(Origem, Dest, His, C):-
            adjacente(paragem(Origem,_,_,_,_,_,_,Carr1,_,_,_),paragem(Prox,_,_,_,_,_,_,Carr2,_,_,_)),
            paragem(Dest,_,_,_,_,_,_,CarrD,_,_,_),
            paragem(Prox,_,_,_,_,_,_,CarrD,_,_,_),
            \+ member(Prox,His),
            profundidade_melhor_carr(Prox,Dest,[Prox|His],C).

profundidade_melhor_carr(Origem, Dest, His, C):-
            adjacente(paragem(Origem,_,_,_,_,_,_,Carr1,_,_,_),paragem(Prox,_,_,_,_,_,_,Carr2,_,_,_)),
            paragem(Dest,_,_,_,_,_,_,CarrD,_,_,_),
            paragem(Prox,_,_,_,_,_,_,CarrP,_,_,_),
            CarrP \= CarrD,
            profundidade_melhor_carr(Prox,Dest,[Prox|His],C).

%--------------------------------------------

calcula_trajeto_operadora(Origem,Dest,O,Caminho):-
            paragem(Origem,_,_,_,_,_,Op1,_,_,_,_),
            member(Op1,O),
            paragem(Dest,_,_,_,_,_,Op2,_,_,_,_),
            member(Op2,O),
            profundidade_operadora(Origem,Dest,O,[(Origem,Op1)],Caminho).

profundidade_operadora(Dest, Dest,O, H, C):- inverso(H,C).

profundidade_operadora(Origem, Dest, O, His, C):-
            adjacente(paragem(Origem,_,_,_,_,_,Op1,_,_,_,_),paragem(Prox,_,_,_,_,_,Op2,_,_,_,_)),
            member(Op1,O),
            member(Op2,O),
            \+ member((Prox,Op2), His),
            profundidade_operadora(Prox,Dest,O,[(Prox,Op2)|His],C).


%---------------------------

calcula_trajeto_sem_operadora(Origem,Dest,O,Caminho):-
            paragem(Origem,_,_,_,_,_,Op,_,_,_,_),
            \+ member(Op,O),
            profundidade_sem_operadora(Origem,Dest,O,[(Origem,Op)],Caminho).

profundidade_sem_operadora(Dest, Dest,O, H, C):- inverso(H,C).

profundidade_sem_operadora(Origem, Dest, O, His, C):-
            adjacente(paragem(Origem,_,_,_,_,_,Op1,_,_,_,_),paragem(Prox,_,_,_,_,_,Op2,_,_,_,_)),
            \+ member(Op1,O),
            \+ member(Op2,O),
            \+ member((Prox,Op2), His),
            profundidade_sem_operadora(Prox,Dest,O,[(Prox,Op2)|His],C).

%---------------------------

calcula_maior_carreiras(Origem,Dest,L):-
            numero_paragens(Origem,Len),
            profundidade_maior_carreiras(Origem,Dest,[(Origem,Len)],Lista),
            quick_sort(Lista,L).

profundidade_maior_carreiras(Dest, Dest, H, L):- inverso(H,L).

profundidade_maior_carreiras(Origem, Dest, His, L):-
            adjacente(paragem(Origem,_,_,_,_,_,_,Carr1,_,_,_),paragem(Prox,_,_,_,_,_,_,Carr2,_,_,_)),
            numero_paragens(Prox,Len),
            \+ member((Prox,Len),His),
            profundidade_maior_carreiras(Prox,Dest,[(Prox,Len)|His],L).


numero_paragens(Num,Len):-
            findall(Num, paragem(Num,_,_,_,_,_,_,_,_,_,_), Lista),
            length(Lista,Len).

%-----------------------------------------------

quick_sort(List,Sorted):-q_sort(List,[],Sorted).
q_sort([],Acc,Acc).
q_sort([H|T],Acc,Sorted):-
	pivoting(H,T,L1,L2),
	q_sort(L1,Acc,Sorted1),q_sort(L2,[H|Sorted1],Sorted).

pivoting((N,H),[],[],[]).
pivoting((N,H),[(Y,X)|T],[(Y,X)|L],G):-X=<H,pivoting((N,H),T,L,G).
pivoting((N,H),[(Y,X)|T],L,[(Y,X)|G]):-X>H,pivoting((N,H),T,L,G).


%--------------------------------------------

calcula_trajeto_publicidade(Origem,Dest,Caminho):-
            paragem(Origem,_,_,_,_,Pub1,_,_,_,_,_),
            Pub1 = 'Yes',
            paragem(Dest,_,_,_,_,Pub2,_,_,_,_,_),
            Pub2 = 'Yes',
            profundidade_publicidade(Origem,Dest,[Origem],Caminho).

profundidade_publicidade(Dest, Dest, H, C):- inverso(H,C).

profundidade_publicidade(Origem, Dest, His, C):-
            adjacente(paragem(Origem,_,_,_,_,P1,_,_,_,_,_),paragem(Prox,_,_,_,_,P2,_,_,_,_,_)),
            P2 = 'Yes',
            \+ member(Prox, His),
            profundidade_publicidade(Prox,Dest,[Prox|His],C).

%--------------------------------------------

calcula_trajeto_abrigados(Origem,Dest,Caminho):-
            paragem(Origem,_,_,_,Abrig1,_,_,_,_,_,_),
            Abrig1 \= 'Sem Abrigo',
            paragem(Dest,_,_,_,Abrig2,_,_,_,_,_,_),
            Abrig2 \= 'Sem Abrigo',
            profundidade_abrigados(Origem,Dest,[Origem],Caminho).

profundidade_abrigados(Dest, Dest, H, C):- inverso(H,C).

profundidade_abrigados(Origem, Dest, His, C):-
            adjacente(paragem(Origem,_,_,_,Abrig1,_,_,_,_,_,_),paragem(Prox,_,_,_,Abrig2,_,_,_,_,_,_)),
            Abrig2 \= 'Sem Abrigo',
            \+ member(Prox, His),
            profundidade_abrigados(Prox,Dest,[Prox|His],C).

%------------------------------------------

calcula_trajeto_intermedios(Origem,Dest,L,Caminho):-
            profundidade_intermedios(Origem,Dest,L,[Origem],Caminho),
            are_members(L,Caminho).

profundidade_intermedios(Dest, Dest,L, H, C):-
            inverso(H,C).

profundidade_intermedios(Origem, Dest,L, His, C):-
            adjacente(paragem(Origem,_,_,_,_,_,_,Carr,_,_,_),paragem(Prox,_,_,_,_,_,_,Carr,_,_,_)),
            \+ member(Prox, His),
            profundidade_intermedios(Prox,Dest,L,[Prox|His],C).

are_members([],L2).

are_members([H],L2):-member(H,L2).

are_members([H|T],L2):-
            member(H,L2),
            are_members(T,L2).

%--------------------------------------------

resolve_informado_distancia(Origem, Dest,Caminho/Custo) :-
            assert(goal(Dest)),
            paragem(Origem,LatO,LonO,_,_,_,_,_,_,_,_),
            paragem(Dest,LatD,LonD,_,_,_,_,_,_,_,_),
            dist(LatO,LonO,LatD,LonD, Dist),
            informado_distancia([[Origem]/0/Dist], Dest, InvCaminho/Custo/_),
            retract(goal(Dest)),
            inverso(InvCaminho, Caminho).

informado_distancia(Caminhos, Dest, Caminho) :-
            obtem_melhor_distancia(Caminhos, Caminho),
            Caminho = [Nodo|_]/_/_,goal(Nodo).

informado_distancia(Caminhos, Dest, SolucaoCaminho) :-
            obtem_melhor_distancia(Caminhos, MelhorCaminho),
            seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
            expande_informado_distancia(MelhorCaminho, Dest, ExpCaminhos),
            append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
            informado_distancia(NovoCaminhos, Dest, SolucaoCaminho).

obtem_melhor_distancia([Caminho], Caminho) :- !.

obtem_melhor_distancia([Caminho1/Custo1/Dist1,_/Custo2/Dist2|Caminhos], MelhorCaminho) :-
            Dist1 =< Dist2, !,
            obtem_melhor_distancia([Caminho1/Custo1/Dist1|Caminhos], MelhorCaminho).

obtem_melhor_distancia([_|Caminhos], MelhorCaminho) :-
            obtem_melhor_distancia(Caminhos, MelhorCaminho).

expande_informado_distancia(Caminho, Dest, ExpCaminhos) :-
            findall(NovoCaminho, proximoDist(Caminho, Dest, NovoCaminho), ExpCaminhos).

proximoDist([Nodo|Caminho]/Custo/_, Dest, [ProxNodo,Nodo|Caminho]/NovoCusto/Dist) :-
            adjacente(paragem(Nodo,LatO,LonO,_,_,_,_,_,_,_,_),paragem(ProxNodo,Lat,Lon,_,_,_,_,_,_,_,_)),
            paragem(Dest,LatF,LonF,_,_,_,_,_,_,_,_),
            \+ member(ProxNodo, Caminho),
            dist(LatO,LonO,Lat,Lon,D),
            NovoCusto is Custo + D,
            dist(Lat,Lon,LatF,LonF,Dist).

dist(LatO,LonO,LatD,LonD,Dist):-
            Sqrt is (LatD-LatO)^2 + (LonD-LonO)^2,
            Dist is sqrt(Sqrt).

%--------------------------------------------------

resolve_informado_paragens(Origem, Dest,Caminho/Custo) :-
            assert(goal(Dest)),
            informado_paragens([[Origem]/0], Dest, InvCaminho/Custo),
            retract(goal(Dest)),
            inverso(InvCaminho, Caminho).

informado_paragens(Caminhos, Dest, Caminho) :-
            obtem_melhor_paragens(Caminhos, Caminho),
            Caminho = [Nodo|_]/_,goal(Nodo).

informado_paragens(Caminhos, Dest, SolucaoCaminho) :-
            obtem_melhor_paragens(Caminhos, MelhorCaminho),
            seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
            expande_informado_paragens(MelhorCaminho, Dest, ExpCaminhos),
            append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
            informado_paragens(NovoCaminhos, Dest, SolucaoCaminho).

obtem_melhor_paragens([Caminho], Caminho) :- !.

obtem_melhor_paragens([Caminho1/Custo1,_/Custo2|Caminhos], MelhorCaminho) :-
            Custo1 =< Custo2, !,
            obtem_melhor_paragens([Caminho1/Custo1|Caminhos], MelhorCaminho).

obtem_melhor_paragens([_|Caminhos], MelhorCaminho) :-
            obtem_melhor_paragens(Caminhos, MelhorCaminho).

expande_informado_paragens(Caminho, Dest, ExpCaminhos) :-
            findall(NovoCaminho, proximoParagem(Caminho, Dest, NovoCaminho), ExpCaminhos).

proximoParagem([Nodo|Caminho]/Custo, Dest, [ProxNodo,Nodo|Caminho]/NovoCusto) :-
            adjacente(paragem(Nodo,_,_,_,_,_,_,_,_,_,_),paragem(ProxNodo,_,_,_,_,_,_,_,_,_,_)),
            paragem(Dest,_,_,_,_,_,_,_,_,_,_),
            \+ member(ProxNodo, Caminho),
            NovoCusto is Custo + 1.

%--------------------------------------------------

inverso(Xs, Ys):-
	inverso(Xs, [], Ys).

inverso([], Xs, Xs).
inverso([X|Xs],Ys, Zs):-
	inverso(Xs, [X|Ys], Zs).

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).
