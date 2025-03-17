#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void aff_tab(double[], int);
double aleatoire(double,double);
int main()
{
	double T[100];
	int i=0;
	srand((unsigned)time(NULL));
	while(i<100){
		T[i]=aleatoire(-1.0,1.0);
		i++;
	}
	aff_tab(T,100);
	return 0 ;
}
 
double aleatoire(double a,double b){
	double c ;
	if(b<a){
		c=a;
		a=b;
		b=c;
	}
    return a+(b-a)*((double)rand()/(double)RAND_MAX) ;
}
void aff_tab(double T[],int n){
	int i=0;
	while(i<n){
		if(i%5>0){
			printf(" %.2f ", T[i]);
		}
		else{
			printf("\n");
			printf(" %.2f ",T[i]);
		}
		i++;
	}
	printf("\n");
}