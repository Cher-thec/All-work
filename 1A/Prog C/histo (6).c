/* Travail réalisé sur un UBUNTO  avec windows 11 */

/* Auteur : AYA EL MOUDDEN
   Date : 30/10/2023

   compilation avec la commande : gcc -W -Wall -ansi -pedantic histo.c -o histo -lm
   exécution avec la commande : ./histo

    Ce programme permet de génèrer des nombres aléatoires,de les stocker dans un histogramme, de calculer des statistiques sur ces nombres, d'afficher un histogramme et d'effectuer un test de qualité du générateur aléatoire.
    ---------------------------------------------------------------------------
    On apprend comment réaliser des calculs mathématiques par C
    On apprend que le fait d'utiliser la bibliotèque math il faut ajouter "-lm" dans la commande de compilation
	On apprend à utiliser le générateur de nombres aléatoires
	
	On constate que les valeurs de la moyenne,de khi2,et de la variance sont comformes avec les valeurs qu'on doit trouver

    IMPORTANT : il faut ajouter "-lm" dans la commande de compilation pour utiliser la bibliotèque mathématique


*/

/*
    Estimation de ma note : entre 16 /20 et 18/20
 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>


#define ALEA_MAX 80
#define T_MAX 10000

int VAL_AL();  /*Cette fonction permet de retourner une variable aléatoire entière entre 0 et 79*/
double khi2(int T[], int n, int v);
double variance(int T[], int sz);



int main(){
    int histo[ALEA_MAX]; /*Pour stocker combien de fois le nombre entre 0 et 79 est tiré */
    int i;   /*un compteur qui compte le nombre de fois du tirage qui arrive jusqu'à 1000*/
    int v;          /*Elle contient la valeur aléatoire entière générée entre 0 et 79*/
    int j;  /*Un compteur pour parcourir la liste histo*/
    int k;  /*Un compteur qui compte le nombre de ligne entre 1 et hmax*/
    int min;
    int max;
    int hmax=20;
    float moy;
    int Nbre_Diese[ALEA_MAX]; /*Tableau qui représente le nombre de dièses accordées à chaque nombre entre 0 et 79*/
    srand(time(NULL));
    for (j=0 ; j<ALEA_MAX ; j++){
        histo[j]=0;
    }
    for (i=0 ; i<T_MAX ; i++){
        v=VAL_AL();  
        histo[v]++ ;
    }

    
    /*calcul du min et du max de histo*/
    min=histo[0];  /*initialisation à la première valeur du tableau*/
    max=histo[0];
    moy=0;
    for (j=0 ; j<ALEA_MAX ; j++){   /*on modifie la boucle de l'affichage afin de trouver min et max et moy*/
        if (histo[j]>max){
            max=histo[j];
        }
        if (histo[j]<min){
            min=histo[j];
        }
        moy= moy+ (float)histo[j]/(float)(ALEA_MAX);

    }
    /* remplir le tableau Nbre_diez qui contient le nombre de dièses */
    for (j=0 ; j<ALEA_MAX ; j++){
        Nbre_Diese[j]=histo[j]*hmax/max ;     
    }

    /* affichage de l'histogramme*/
    for (k=hmax ; k>0 ; k--){     /*Boucle pour les lignes commenceant du haut vers le bas*/
        for (j=0 ; j<ALEA_MAX ; j++){   /*Boucle pour les colonnes*/
            if (Nbre_Diese[j]==k){
                printf("#");        /*Si le score d'un nombre est égale au niveau, on met un diez et retranche 1 du score*/
                Nbre_Diese[j]-- ;    
            }
            else {
                printf(" ");       
            }
        }
        printf("\n");

    }
    printf("min = %d \n",min);
    printf("max = %d \n",max);
    printf("moy = %f \n",moy);
    printf("Variance = %f \n",variance(histo, ALEA_MAX));
    printf("Lécart type = %f \n",sqrt(variance(histo, ALEA_MAX)));
    /*Pour voir si le générateur passe le test il faut que abs(χ2-v)<2v√ , puisque je ne posséde pas la valeur absolue dans C j'ai enlevé l'énégalité au carré:*/
    if ((khi2(histo, T_MAX, ALEA_MAX)-ALEA_MAX)*(khi2(histo, T_MAX, ALEA_MAX)-ALEA_MAX)<=4*ALEA_MAX){  
        printf("pass");
    }
    else {
        printf("fail");
    }



    return 0;
}

int VAL_AL(){
    float x;
    float y;
    x=rand()/(RAND_MAX+1.0);   /*j'obtiens une valeur aléatoire entre 0 et 1*/
    y=x*ALEA_MAX;            /*J'obtiens une valeur aléatoire flottente entre 0 et ALEA_MAX*/
    return (int) y;      /*je retourne la partie entière de y qui sera une variable aléatoire entière entre 0 et ALEA_MAX-1*/
}

/*Commentaires sur l'affichage du histogramme :
 - Plus on augmente la valeur de T_MAX, plus l'histogramme se remplie de façon que hmax reste constante*/
/*fonction permettant de calculer khi2*/
double khi2(int T[], int n, int v){
    long s=0;
    int j;
    for (j=0 ; j<v ; j++){
        s=s+T[j]*T[j];
    }
    return ((float)v/(float)n)*s-n;
}
/*fonction permettant de calculer la variance*/
double variance(int T[], int sz){
    double m=0;
    double m_perv;
    double s=0;
    int i=0;
    int v=T[0];
    for (j=0;j<sz;j++){
		v=T[j]
        m_perv=m;
        j++;
        m= m + (float)(T[j]-m)/j;
        s= s + (v-m)*(v-m_perv);
    }
    return s/(j-1);
}
