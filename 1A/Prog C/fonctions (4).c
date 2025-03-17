#include <stdio.h>

void passe_valeur(int);
int retourne_valeur(int);
void passe_reference(int *);

int main()
{
	int j;
	j = 1 ;
    printf("\n\nLa variable stockée à l'adresse %p contient la valeur %d\n", (void*)&j, j) ;
    printf("\n") ;

    printf("Appel à passe_valeur() ...\n") ;
    passe_valeur(j) ;
    printf("nouvelle valeur de j : %d\n", j) ;
    printf("\n") ;

    printf("Appel à retourne_valeur() ...\n") ;
    j = retourne_valeur(j) ;
    printf("nouvelle valeur de j : %d\n", j) ;
    printf("\n") ;

    printf("Appel à passe_reference() ...\n") ;
    passe_reference(&j) ;
    printf("nouvelle valeur de j : %d\n", j) ;
    printf("\n") ;
}

void passe_valeur(int a)
{
	printf("l'adresse mémoire de %d est %p \n",a,(void*)&a);
	a=a+5;
}
int retourne_valeur(int a)
{
	printf("l'adresse mémoire de %d est %p \n",a,(void*)&a);
	a=a*7;
	return a;
}
void passe_reference(int * a)
{
	printf("l'adresse mémoire de %p est %p de valeur %d \n",(void*)a,(void*)&a,*a);
	*a=*a+11;
}