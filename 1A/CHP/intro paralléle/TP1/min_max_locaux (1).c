/*TP Opend MP TB2 Calcul hautes performances
Minimum et maximums locaux avec grain fin 
Windows UTF-8
Aymeric Eyer
28/03/2024*/

/*En-têtes*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

#define a 0
#define b 100
#define taille 100


int main(){
	
	int * T;
	int i;
	double * x;
	int * n;
	int * min;
	int * max;
	int j;
	int k;
	
	j=0;
	k=0;
	
	/*Initialisation des tableaux*/
	T=malloc(taille*sizeof(int));
	x=malloc(taille*sizeof(double));
	n=malloc(taille*sizeof(int));
	min=malloc(taille*sizeof(int));
	max=malloc(taille*sizeof(int));

	/*Vérification d'erreurs d allocations mémoire*/
	if (T == NULL || x == NULL || n == NULL || min == NULL || max == NULL) {
        fprintf(stderr, "Erreur, impossible d'allouer la mémoire.\n");
        exit(1);
    }
	
	/*Initialisation du générateur de nombres pseudos-aléatoires*/
	srand(time(NULL));
	
	/*génération tableau d'entiers aléatoires entre a et b*/
	#pragma omp parallel for  default (shared) private(i) 
	for (i=0;i<taille;i++){
		n[i] = rand(); /*Génération d'un nombre aléatoire entre 0 et RAND_MAX*/
		x[i] = (double)n[i] / RAND_MAX; /*Conversion du nombre aléatoire en un nombre flottant entre 0 et 1*/
		x[i] = a + x[i] * (b - a); /*Interpolation entre a et b : on passe de x entre 0 et 1 à x entre a et b*/
		T[i]=floor(x[i]);
	}
	// J'affiche le tableau car rongée par la curiosité
	for (i=0;i<taille;i++) printf(" %d", T[i]);
	printf("\n");
	
	/*parallélisme grain fin*/
	#pragma omp parallel for  default (shared) private(i) 
	for (i = 1; i < taille - 1; i++) {
		if (T[i] < T[i - 1] && T[i] < T[i + 1]) {
			#pragma omp critical
			{
				min[j++] = T[i];
			}
		} else if (T[i] > T[i - 1] && T[i] > T[i + 1]) {
			#pragma omp critical
			{
				max[k++] = T[i];
			}
		}
	}
	
	/*affichage des min et max locaux*/
	#pragma omg parallel for default (shared) private(i)
	printf("minima locaux sont :\n");
	for (i=0;i<j+1;i++){
		printf(" %d",min[i]);
	}
	printf("\n");
	#pragma omp barrier
	printf("maxima locaux sont :\n");
	#pragma omg parallel for default (shared) private(i)
	for (i=0;i<k+1;i++){
		printf(" %d",max[i]);
	}
	printf("\n");
	
	free(T);
	free(x);
	free(n);
	free(min);
	free(max);
	
	return 0;
}/*TP Opend MP TB2 Calcul hautes performances
Minimum et maximums locaux avec grain fin 
Windows UTF-8
Aymeric Eyer
28/03/2024*/

/*En-têtes*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

#define a 0
#define b 100
#define taille 100


int main(){
	
	int * T;
	int i;
	double * x;
	int * n;
	int * min;
	int * max;
	int j;
	int k;
	
	j=0;
	k=0;
	
	/*Initialisation des tableaux*/
	T=malloc(taille*sizeof(int));
	x=malloc(taille*sizeof(double));
	n=malloc(taille*sizeof(int));
	min=malloc(taille*sizeof(int));
	max=malloc(taille*sizeof(int));

	/*Vérification d'erreurs d allocations mémoire*/
	if (T == NULL || x == NULL || n == NULL || min == NULL || max == NULL) {
        fprintf(stderr, "Erreur, impossible d'allouer la mémoire.\n");
        exit(1);
    }
	
	/*Initialisation du générateur de nombres pseudos-aléatoires*/
	srand(time(NULL));
	
	/*génération tableau d'entiers aléatoires entre a et b*/
	#pragma omp parallel for  default (shared) private(i) 
	for (i=0;i<taille;i++){
		n[i] = rand(); /*Génération d'un nombre aléatoire entre 0 et RAND_MAX*/
		x[i] = (double)n[i] / RAND_MAX; /*Conversion du nombre aléatoire en un nombre flottant entre 0 et 1*/
		x[i] = a + x[i] * (b - a); /*Interpolation entre a et b : on passe de x entre 0 et 1 à x entre a et b*/
		T[i]=floor(x[i]);
	}
	// J'affiche le tableau car rongée par la curiosité
	for (i=0;i<taille;i++) printf(" %d", T[i]);
	printf("\n");
	
	/*parallélisme grain fin*/
	#pragma omp parallel for  default (shared) private(i) 
	for (i = 1; i < taille - 1; i++) {
		if (T[i] < T[i - 1] && T[i] < T[i + 1]) {
			#pragma omp critical
			{
				min[j++] = T[i];
			}
		} else if (T[i] > T[i - 1] && T[i] > T[i + 1]) {
			#pragma omp critical
			{
				max[k++] = T[i];
			}
		}
	}
	
	/*affichage des min et max locaux*/
	#pragma omg parallel for default (shared) private(i)
	printf("minima locaux sont :\n");
	for (i=0;i<j+1;i++){
		printf(" %d",min[i]);
	}
	printf("\n");
	#pragma omp barrier
	printf("maxima locaux sont :\n");
	#pragma omg parallel for default (shared) private(i)
	for (i=0;i<k+1;i++){
		printf(" %d",max[i]);
	}
	printf("\n");
	
	free(T);
	free(x);
	free(n);
	free(min);
	free(max);
	
	return 0;
}