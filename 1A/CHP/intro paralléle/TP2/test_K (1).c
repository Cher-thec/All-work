#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

/*Fonction qui trouve la valeur de l'élément à l'indice k dans un tableau trié*/
int ValeurIndice(int *a, int n, int k) {
       /* Trier les k premiers éléments du tableau en ordre croissant*/
    /* Complexité théorique du tri sélection : O(k^2)*/
    int i,j;
	int index[n];
	int temp,idx;
    #pragma omp parallel for shared(a) private(i,j,idx,temp) /*Partager le tableau entre les threads*/
    for ( i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            if (a[j] < a[i]) {
                idx++;
            }
        }
        /* Utilisation d'une section critique pour garantir une synchronisation*/
        #pragma omp critical
        index[i]=idx+1;
    }
    #pragma omp parallel for
	for (i=0;i<n;i++){
		if (index[i]==k){
		    temp=a[i];
		}

    /* L'élément à l'indice k est maintenant à la position k-1 dans le tableau trié*/
    return temp;
}

int main() {
    int n = 5; // Taille du tableau
    int *a;
	int k;
    a = malloc(n * sizeof(int));

    /* Vérification de l'allocation mémoire*/
    if (a == NULL) {
        fprintf(stderr, "Erreur, impossible d'allouer la mémoire.\n");
        exit(1);
    }

    /* Génération du tableau d'entiers aléatoires entre 0 et RAND_MAX*/
    #pragma omp parallel for
    for (int i = 0; i < n; i++) {
        a[i] = rand();
    }

    /*Affichage du tableau initial*/
    printf("Tableau initial : ");
    for (int i = 0; i < n; i++) {
        printf("%d ", a[i]);
    }
    printf("\n");

    /* Demande de l'indice k , les indices commencent  de 1 */
    int k;
    printf("Veuillez saisir l'indice k : ");
    scanf("%d", &k);

    /* Calcul de la valeur de l'élément à l'indice k dans le tableau trié*/
    printf("La valeur de l'élément à l'indice %d dans le tableau trié est : %d\n", k - 1, ValeurIndice(a, n, k));

    /*Libération de la mémoire allouée pour le tableau*/
    free(a);

    return 0;
}
