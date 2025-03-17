/*TP OpenMP TB2 Calcul hautes performances
probléme 1: évaluation d'un polynôme en un point
Windows UTF-8
réalisé par: Aymen IMAD et Charaf-eddine EL-KIHAL
04/04/2024*/


#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

/*fonction maximum*/
float maximun(int T[], int n){
	int i;
	int j=0;
	int max;
	int est_max[n];
	#pragma omp parallel for
	for (i=0;i<n;i++){    /*remplissage du tableau est_max par 1*/
		est_max[i]=1;
	}
	#pragma omp parallel for
	for(i=0;i<n;i++){
		#pragma omp parallel for
		for(j=0;j<n;j++){
			if (T[i]<T[j]){             /*si pas maximum cad existence d'un élément plus grand remplie la case par 0*/
				est_max[i]=0;
			}
		}
	}
	#pragma omp parallel for
	for (i=0;i<n;i++){
		if (est_max[i]==1){
			max=T[i];
		}
	}
	return max;      /*retourne max*/
}


float puissance(float x, int n, int k) {   /*x le point, n la taille du tableau, k la puissance*/ 
    float b = 1;
    int i;

    /* Calcul des puissances*/
    #pragma omp parallel for reduction(*:b)     /*réduction du produit*/
    for(i = 0; i < k; i++) {
        b *= x;
    }

    return b ;
}


float evaluation_poly(float x, float y, float c[], int px[], int py[], int n) {    /*c tablde des coeficient, x et y les coordonnées du point */
    float result = 0.0f; /* Initialiser le résultat à zéro*/                       /*px et py les puissances de x et y et n la taille du tableau*/

    /* Calculer chaque terme du polynôme et les ajouter au résultat*/
    #pragma omp parallel for reduction(+:result)               
    for (int i = 0; i < n; i++) {
        float term = c[i] * puissance(x, n, px[i]) * puissance(y, n, py[i]);    /*calcul d'un terme*/
        result += term;
    }

    return result;
}


	
int main(int argc, char* argv[])
{
	int n; // nb de termes du polynome
    float *c; // le coefficient d'un terme
	int *px ; // la puisance en X
	int *py; // la puissance en Y
    int i,j; // des indices
	int k; // nb de points
	float x, y; //un point du R
	float val; 
	
	/* -- Saisie de mon polynome -- */
	printf(" saisie -> nb de termes du polynome :");
	scanf("%d", &n);
	
	c = malloc(n * sizeof(float));
	px = malloc(n * sizeof(int));
	py = malloc(n * sizeof(int));
	
	printf(" Saisissez les termes un à un et pour chacun indiquez le coeeficient (réel), la puissance de X et puis la puissance de Y\n");
	for(i = 0; i < n; i++)
	{ 
		printf(" terme :");
		scanf("%f%d%d", &c[i], &px[i], &py[i]);
	}
	
	/* -- Affichage polynome -- */
	for(i = 0; i < n; i++)
	{
		printf("%f ", c[i]);
		if (px[i] != 0)
			printf("X^%d ", px[i]);
		if (py[i] != 0)
			printf("Y^%d ", py[i]);
		if (i <n-1)
			printf(" +  ");
		else
			printf("\n");
		
	}
	
	/* un pretraiement, peut-etre ?*/
	
	/* -- Saisie des points (x,y) un à un -- */
	/* suivie du traitement qui va bien */
	printf(" Saisie -> nb de points pour calculer la valeur :");
	scanf("%d", &k);
	for (j = 0; j < k; j++)
	{
		printf(" Saisie ->  un point  :");
		scanf("%f%f", &x, &y);
		
		
		
		val=evaluation_poly(x,y,c,px,py,n);      /*évaluation du polynôme*/
		
		printf(" La valeur du polynome en (%f, %f) est %f\n", x, y, val);
	}

}


