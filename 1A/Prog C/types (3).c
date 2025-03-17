#include <stdio.h>

int main(void)
{
	int i ;
	double d ;
	short s;
	float f;
	long l;
	char C[10];
    printf("l'entier court stocké à l'adresse %p vaut %d et occupe %lu octet(s) en mémoire\n",
            (void *)&s, s, sizeof(s)) ;
    printf("l'entier stocké à l'adresse %p vaut %d et occupe %lu octet(s) en mémoire\n",
            (void *)&i, i, sizeof(i)) ;
    printf("l'entier long stocké à l'adresse %p vaut %ld et occupe %lu octet(s) en mémoire\n",
            (void *)&l, l, sizeof(l)) ;
    printf("le nombre flottant simple précision stocké à l'adresse %p vaut %f et occupe %lu octet(s) en mémoire\n",
            (void *)&f, f, sizeof(f)) ;
    printf("le nombre flottant double précision stocké à l'adresse %p vaut %f et occupe %lu octet(s) en mémoire\n",
            (void *)&d, d, sizeof(d)) ;
    printf("la chaine de caractères stockée à l'adresse %p contient \"%s\"et occupe %lu octet(s) en mémoire\n",
            (void *)C, C, sizeof(C)) ;

    return 0 ;
}
/*on remarque que les valeurs different pour remédier cela il faut donner une valeur initiale aux variables*/