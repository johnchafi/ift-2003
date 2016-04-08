% Le pr�dicat lire/2 lit une cha�ne de caract�res Chaine entre apostrophes
% et termin�e par un point.
% Resultat correspond � la liste des mots contenus dans la phrase.
% Les signes de ponctuation ne sont pas g�r�s.
lire(Chaine,Resultat):- write('Entrer la phrase '), read(Chaine),
	name(Chaine, Temp), chaine_liste(Temp, Resultat),!.
	
% Pr�dicat de transformation de cha�ne en liste
chaine_liste([],[]).
chaine_liste(Liste,[Mot|Reste]):- separer(Liste,32,A,B), name(Mot,A),
	chaine_liste(B,Reste).
	
% S�pare une liste par rapport � un �l�ment
separer([],_,[],[]):-!.
separer([X|R],X,[],R):-!.
separer([A|R],X,[A|Av],Ap):- X\==A, !, separer(R,X,Av,Ap).








% Base de connaissance
cout(qu�bec, montr�al, 50).










% Analyse s�mantique
question( SEM ) --> mq, gv(ACT, OBJ), prep, ville(NOM1), conj, ville(NOM2), { SEM =.. [ACT, NOM1, NOM2] }.
mq( Q ) --> art, nc(AGNT).
gv( ACT,OBJ ) --> v(ACT), gn(OBJ).
gn( AGNT ) --> art, nc(AGNT).















% Questions
mq --> [combien].

v( cout ) --> [co�te].

art --> [un].

nc( trajet ) --> [trajet].

prep --> [entre].

ville( qu�bec ) --> [qu�bec].
ville( montr�al ) --> [montr�al].

conj --> [et].













reponse([],REPONSE):- REPONSE = "Je n'ai pas compris.".
                     
reponse(QUESTION, REPONSE) :- call(QUESTION, X), !, append("La r�ponse est :", X, REPONSE).

