% Le pr�dicat lire/2 lit une cha�ne de caract�res Chaine entre apostrophes
% et termin�e par un point.
% Resultat correspond � la liste des mots contenus dans la phrase.
% Les signes de ponctuation ne sont pas g�r�s.
lire(Chaine,Resultat):- write('Entrer votre question (entre apostrophes, en minuscule, sans ponctuation) : '), read(Chaine),
        name(Chaine, Temp), chaine_liste(Temp, Resultat),!.

% Pr�dicat de transformation de cha�ne en liste
chaine_liste([],[]).
chaine_liste(Liste,[Mot|Reste]):- separer(Liste,32,A,B), name(Mot,A),
        chaine_liste(B,Reste).

% S�pare une liste par rapport � un �l�ment
separer([],_,[],[]):-!.
separer([X|R],X,[],R):-!.
separer([A|R],X,[A|Av],Ap):- X\==A, !, separer(R,X,Av,Ap).

% Permet de lancer l'application
lancer() :-
        lire(_, Liste),
        question(Q, Liste, []),
        reponse(Q, _).

% Base d'informations
cout(qu�bec, montr�al, '50 $').
cout(qu�bec, newyork, '200 $').
trajet(qu�bec, montr�al, '16h00', '21h30').
trajet(qu�bec, newyork, '0h00', '12h30').
trajet(detroit, newyork, '0h00', '12h30').
trajet(qu�bec, detroit, '19h00', '23h00').
trajet(montr�al, detroit, '12h00', '20h00').
temps(qu�bec, montr�al, '5h30').
temps(qu�bec, newyork, '12h30').
pauses(qu�bec, montr�al, 0).
pauses(qu�bec, newyork, 2).

% Analyse s�mantique
question( SEM ) --> mq, gv(ACT, _), prep, ville(NOM1), conj, ville(NOM2), { SEM = [ACT, NOM1, NOM2, _] }.
question( SEM ) --> prep, mq, nc(_), gv(_, ACT), prep, ville(NOM1), prep, ville(NOM2), { SEM = [ACT, NOM1, NOM2, _, _] }.
question( SEM ) --> mq, prep, nc(ACT), gv(_, _), prep, ville(NOM1), conj, ville(NOM2), { SEM = [ACT, NOM1, NOM2, _] }.
question( SEM ) --> mq, v( sont ), gn(AGNT), pro,v( partent ), prep, ville(NOM), { SEM = [AGNT, NOM]}.
question( SEM ) --> mq, prep, nc(_), gn(_), v(_), prep, nc(ACT), prep, gn(_), prep, ville(NOM1), conj, ville(NOM2), { SEM = [ACT, NOM1, NOM2, _] }.
question( SEM ) --> mq, v( sont ), gn(_), prep, nc(AGNT), pro, v(_), prep, ville(DEST), { SEM = [AGNT, DEST]}.

mq( _ ) --> art, nc(_).
gv( ACT,OBJ ) --> v(ACT), gn(OBJ).
gn( AGNT ) --> art, nc(AGNT).
gn( AGNT ) --> art, adj, nc(AGNT).

% Questions
mq --> [combien].
mq --> [quelle].
mq --> [quel].
mq --> [quelles].

pro --> [qui].

v( cout ) --> [co�te].
v( part ) --> [est].
v( dure ) --> [dure].
v( prendra ) --> [prendra].
v( sont ) --> [sont].
v( partent ) --> [partent].
v( m�nent ) --> [m�nent].


art --> [un].
art --> [le].
art --> [les].

nc( trajet ) --> [trajet].
nc( trajet ) --> [trajets].
nc( heure ) --> [heure].
nc( temps ) --> [temps].
nc( fois ) --> [fois].
nc( chauffeur ) --> [chauffeur].
nc( pauses ) --> [pauses].
nc( trajet ) --> [d�part].
nc( villes ) --> [villes].

prep --> [entre].
prep --> [�].
prep --> [de].
prep --> [pour].

adj --> [prochain].

ville( qu�bec ) --> [qu�bec].
ville( montr�al ) --> [montr�al].
ville( newyork ) --> [newyork].
ville( detroit ) --> [detroit].



conj --> [et].

% R�ponse aux questions
reponse([ACT, NOM1, NOM2, REPONSE], REPONSE) :- call(ACT, NOM1, NOM2, REPONSE), !, write('La r�ponse est : '), write(REPONSE).
reponse([ACT, NOM1, NOM2, X, Y], REPONSE) :- call(ACT, NOM1, NOM2, X, Y), !, atom_concat(X, ' - ', Z), atom_concat(Z, Y, REPONSE), write('La r�ponse est : '), write(REPONSE).
reponse([AGNT, NOM], REPONSE) :- findall(DEST,call(AGNT, NOM, DEST , _, _),REPONSE), !, atomic_list_concat(REPONSE, ', ', REPONSE1) , write('La r�ponse est : '), write(REPONSE1).
reponse([AGNT, DEST], REPONSE) :- findall(DEP,call(AGNT, DEP, DEST , _, _),REPONSE), !, atomic_list_concat(REPONSE, ', ', REPONSE1) , write('La r�ponse est : '), write(REPONSE1).
