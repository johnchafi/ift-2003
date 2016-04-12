% Auteur:
% Date: 12/04/2016

% Le prédicat lire/2 lit une chaîne de caractères Chaine entre apostrophes
% et terminée par un point.
% Resultat correspond à la liste des mots contenus dans la phrase.
% Les signes de ponctuation ne sont pas gérés.
lire(Chaine,Resultat):- write('Entrer votre question (entre apostrophes, en minuscule, sans ponctuation) : '), read(Chaine),
        name(Chaine, Temp), chaine_liste(Temp, Resultat),!.

% Prédicat de transformation de chaîne en liste
chaine_liste([],[]).
chaine_liste(Liste,[Mot|Reste]):- separer(Liste,32,A,B), name(Mot,A),
        chaine_liste(B,Reste).

% Sépare une liste par rapport à un élément
separer([],_,[],[]):-!.
separer([X|R],X,[],R):-!.
separer([A|R],X,[A|Av],Ap):- X\==A, !, separer(R,X,Av,Ap).

% Permet de lancer l'application
lancer() :-
        lire(_, Liste),
        question(Q, Liste, []),
        reponse(Q, _).

% Base d'informations
cout(québec, montréal, '50 $').
cout(québec, newyork, '200 $').
trajet(québec, montréal, '16h00', '21h30').
trajet(québec, newyork, '0h00', '12h30').
trajet(québec, detroit, '19h00', '23h00').
temps(québec, montréal, '5h30').
temps(québec, newyork, '12h30').
arrets(québec, montréal, 0).
arrets(québec, newyork, 2).

% Analyse sémantique
question( SEM ) --> mq, gv(ACT, _), prep, ville(NOM1), conj, ville(NOM2), { SEM = [ACT, NOM1, NOM2, _] }.
question( SEM ) --> prep, mq, nc(_), gv(_, ACT), prep, ville(NOM1), prep, ville(NOM2), { SEM = [ACT, NOM1, NOM2, _, _] }.
question( SEM ) --> mq, prep, nc(ACT), gv(_, _), prep, ville(NOM1), conj, ville(NOM2), { SEM = [ACT, NOM1, NOM2, _] }.
question( SEM ) --> mq, v( sont ), gn(AGNT), v( partent ), prep, ville(NOM), { SEM = [AGNT, NOM]}.
%question( SEM ) --> mq, prep, nc(_), art, nc(_), v(_), prep, nc(_), prep, ville(NOM1), prep, ville(NOM2), { SEM = [ACT, NOM1, NOM2, _, _] }. % "Combien de fois le chauffeur prendra de pauses ?"
mq( _ ) --> art, nc(_).
gv( ACT,OBJ ) --> v(ACT), gn(OBJ).
gn( AGNT ) --> art, nc(AGNT).
gn( AGNT ) --> art, adj, nc(AGNT).

% Questions
mq --> [combien].
mq --> [quelle].
mq --> [quel].
mq --> [quelles].

v( cout ) --> [coûte].
v( part ) --> [est].
v( dure ) --> [dure].
v( prendra ) --> [prendra].
v( sont ) --> [sont].
v( partent ) --> [partent].

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

prep --> [entre].
prep --> [à].
prep --> [de].

adj --> [prochain].

ville( québec ) --> [québec].
ville( montréal ) --> [montréal].
ville( new-york ) --> [new-york].

conj --> [et].

% Réponse aux questions
reponse([ACT, NOM1, NOM2, REPONSE], REPONSE) :- call(ACT, NOM1, NOM2, REPONSE), !, write('La réponse est : '), write(REPONSE).
reponse([ACT, NOM1, NOM2, X, Y], REPONSE) :- call(ACT, NOM1, NOM2, X, Y), !, atom_concat(X, ' - ', Z), atom_concat(Z, Y, REPONSE), write('La réponse est : '), write(REPONSE).
reponse([AGNT, NOM], REPONSE) :- findall(DEST,call(AGNT, NOM, DEST , _, _),REPONSE), !, atomic_list_concat(REPONSE, ', ', REPONSE1) , write('La réponse est : '), write(REPONSE1).
