#include <stdio.h>

void affiche_tableau(int[],int);
void tableau_init(int[],int,int);

int main()
{
	int entier[42];
	
	tableau_init(entier,42,0);

	affiche_tableau(entier,42);
	
	return 0 ;
}
void affiche_tableau(int T[], int sz)
{
    int i ;

    printf("[") ;
    for ( i = 0 ; i < sz - 1 ; i++ ) {
        printf("%d, ", T[i]) ;
    }
    printf("%d]\n", T[i]) ;
}
void tableau_init(int T[],int sz, int t0)
{	
    int i=1;
	T[0]=t0;
	while(i<sz){
		T[i]=2*T[i-1]+2 ;
		i++ ;
	}
}
	