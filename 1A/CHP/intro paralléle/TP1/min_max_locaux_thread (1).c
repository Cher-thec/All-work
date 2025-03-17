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
#include <omp.h>

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
	int num_threads;
	int tid;
	int start;
	int end;
	
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
	
	num_threads = omp_get_num_threads();
		
	/*parallelisme avec num_threads  qui se séparent le tableau*/
	
	#pragma omp parallel num_threads(num_threads) default (shared) private(i,start,end)
	{
		tid = omp_get_thread_num();
		start = tid * taille / num_threads;
		end = (tid + 1) * taille / num_threads;

		/* Calcul des minima et maxima locaux sur la part du thread*/
		for (i=start+1;i<end-1;i++){
			if (T[i]<T[i-1] && T[i]<T[i+1]){
				min[j]=T[i];
				j++;
			}
			else if ((T[i]>T[i-1]) && (T[i]>T[i+1])){
				max[k]=T[i];
				k++;
			}
		}
	}
	
	/*affichage des min et max locaux*/
	//#pragma omg parallel for default (shared) private(i) // Mj ce n'est pas une bonne idée
	printf("minima locaux sont :\n");
	for (i=0;i<j;i++){
		printf("%d ",min[i]);
	}
	printf("\n");
	
	//#pragma omp barrier
	//#pragma omg parallel for default (shared) private(i)
	printf("maxima locaux sont \n");
	for (i=0;i<k;i++){
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