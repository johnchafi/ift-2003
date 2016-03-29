:- op( 800, fx, si ),
	op( 700, xfx, alors ),
	op( 300, xfy, ou ),
	op( 200, xfy, et ).
:- dynamic fait/1.

ch_arriere(X):- est_vrai(X).
est_vrai(X):- fait(X).
est_vrai(X):- si COND alors X, est_vrai(COND).
est_vrai( C1 et C2 ):- est_vrai(C1), est_vrai(C2).
est_vrai( C1 ou C2 ):- est_vrai(C1) ; est_vrai(C2).

ch_avant:-
	si COND alors X,
	not(fait(X)),
	condition_vraie(COND),
	!,
	write('nouveau fait : '), write(X),nl,
	asserta(fait(X)),
	ch_avant.
ch_avant:- write(' La BC est satur�e'), nl.

/* condition_vraie/1 : m�me chose que le pr�dicat est_vrai/1, mais sans remonter dans les r�gles � partir des buts */
condition_vraie(C):- fait(C).
condition_vraie(C1 et C2):- condition_vraie(C1), condition_vraie(C2).
condition_vraie(C1 ou C2):- condition_vraie(C1) ; condition_vraie(C2).

%voyage
si distance(petite) alors deplacement(pied).
si distance(moyenne) et possede_auto(vrai) alors deplacement(auto).
si distance(moyenne) et possede_auto(faux) alors deplacement(train).
si distance(grande) alors deplacement(avion).
si distance(avion) alors billet(acheter).
si billet(acheter) et possede_telephone(vrai) alors agence(telephoner).
si billet(acheter) et possede_telephone(faux) alors agence(aller).
si duree(longue) alors logement(vrai).
si duree(courte) alors logement(faux).
si logement(vrai) et voyageur(riche) alors reservation(hotel).
si logement(vrai) et voyageur(pauvre) alors reservation(motel).
si logement(faux) alors reservation(nulle).

fait( distance(petite) ).