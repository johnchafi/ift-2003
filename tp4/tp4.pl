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
trajet(qu�bec, montr�al, '16h00', '21h30').

% Analyse s�mantique
question( SEM ) --> mq, gv(ACT, _), prep, ville(NOM1), conj, ville(NOM2), { SEM = [ACT, NOM1, NOM2, _] }.
question( SEM ) --> prep, mq, nc(_), gv(_, ACT), prep, ville(NOM1), prep, ville(NOM2), { SEM = [ACT, NOM1, NOM2, _, _] }.
mq( _ ) --> art, nc(_).
gv( ACT,OBJ ) --> v(ACT), gn(OBJ).
gn( AGNT ) --> art, nc(AGNT).
gn( AGNT ) --> art, adj, nc(AGNT).

% Questions
mq --> [combien].
mq --> [quelle].

v( cout ) --> [co�te].
v( part ) --> [est].

art --> [un].
art --> [le].

nc( trajet ) --> [trajet].
nc( heure ) --> [heure].

prep --> [entre].
prep --> [�].
prep --> [de].

adj --> [prochain].

ville( qu�bec ) --> [qu�bec].
ville( montr�al ) --> [montr�al].

conj --> [et].

% R�ponse aux questions
reponse([ACT, NOM1, NOM2, REPONSE], REPONSE) :- call(ACT, NOM1, NOM2, REPONSE), !, write('La r�ponse est : '), write(REPONSE).
reponse([ACT, NOM1, NOM2, X, Y], REPONSE) :- call(ACT, NOM1, NOM2, X, Y), !, atom_concat(X, ' - ', Z), atom_concat(Z, Y, REPONSE), write('La r�ponse est : '), write(REPONSE).
