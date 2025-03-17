/*travail réalisé par UBUNTO avec windows 10
 Auteur: Aymen IMAD
 Date: 10/12/2023
 
 compilation avec la commande : gcc -W -Wall -ansi -pedantic  mandel.c colors.c -o mandel -lm
   exécution avec les commandes : ./mandel full_bw_alt.mdb
                                ./mandel full_rgb.mdb
								./mandel figure2_gs.mdb
								./mandel figure2_rgb.mdb
								./mandel  265 -1.142817421949293,-0.21198254168631775,0.0055,0.0055
								./mandel 200 -0.75,0,2.48,2.48
								

    Ce programme permet la génèreration et la visualisation de l'ensemble de Mandelbrot sous divers angles en utilisant les paramètres spécifiés retournant une image d'un fractal, puis sauvegarde l'image résultante dans un fichier PPM.
    ---------------------------------------------------------------------------
 -On apprend que l'acquisition des compétences pour créer un fichier respectant un format donné implique de suivre les règles spécifiées pour l'organisation des données.
 -On apprend que changer la représentation ou le format des données pour assurer la compatibilité signifie effectuer la conversion entre différents types de données.
 -On apprend que la manipulation de pointeurs offre la possibilité d'accéder directement à la mémoire, une aptitude avancée dans le domaine de la programmation.
 -On apprend qu'allouer dynamiquement de la mémoire consiste à réserver de l'espace au moment de l'exécution, une pratique utile pour gérer efficacement la mémoire en fonction des besoins du programme.
	
	remarque:
    En augmentant la hauteur et la largeur que: la résolution de l'image augmente,ce qui permet d'obtenir une image plus détaillée
mais cette augmentation entraine aussi un temps de calcul plus long.


.
*/

/*
    Estimation de ma note : 19/20
 */



/*bibliothéques*/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "colors.h"

/*constantes*/

#define STRMAX 256
#define GREY_ST 2
#define GREY_SM 3
#define RGB 4
#define BW 0
#define BW_ALTERN 1
#define DEFAULT_WIDTH 1000
#define DEFAULT_HEIGHT 1000

/*structure pixdiv*/

struct pixdiv {
	int iter;
	double x,y;
};

/*structure camera*/

struct camera {
    double x, y;            /*coordonnées du point à observer*/
    double width, height;    /*dimensions de l'image*/
};

/*structure render*/

struct render {
    double xmin, xmax, ymin, ymax;   /*zone du plan complexe*/
    int width, height;  /* largeur, hauteur*/
    int max_iter;       /*nombre maximal d'iterations*/
    double radius;      /*rayon*/
    struct pixdiv *img;      /*tableau pour stocker les paramétres de l'image*/
    char basename[STRMAX]; /*nom du fichier*/
    struct camera pov;    /*paramétres de la camera*/     
    int type;            /*type de rendu: couleur dans notre cas*/
};

/*fonctions prédéfinis*/

double map(int v, int imin, int imax, double omin, double omax);
void cam2rect(struct render *set, struct camera *pov);
void render_init(struct render *set, int argc, char *argv[]);
int m2v(struct render *set, int x, int y);
void render_image(struct render *set);
void get_pixel_color(struct render *set, int Px, int Py, int *r, int *g, int *b);
void save_image(struct render *set);
void set_defaults(struct render *set);
int load_config(struct render *set, char *config_file);

/*fonction main*/

int main(int argc, char *argv[]) {
    struct render set;
    render_init(&set, argc, argv);          /*afin de générer l'image*/
    cam2rect(&set, &set.pov);               /* convertir du 2D au 1D*/
    render_image(&set);                      /*création de l'ensemble de mandelbrot*/
    save_image(&set);                       /*sauvegarder en fichier ppm*/
    free(set.img);                          /*libérer la mémoire*/
    return 0;
}


double map(int v, int imin, int imax, double omin, double omax) {      /*convertir un point d'une plage à une autre*/
    return omin + (omax - omin) * (v - imin) / (imax - imin);
}

void cam2rect(struct render *set, struct camera *pov) {        /*afin de convertir vers la zone de visualisation*/
    set->xmin = pov->x - pov->width / 2.0;
    set->xmax = pov->x + pov->width / 2.0;
    set->ymin = pov->y - pov->height / 2.0;
    set->ymax = pov->y + pov->height / 2.0;
}

void render_init(struct render *set, int argc, char *argv[]) {        /*initialiser les paramétres de la variable de type struct render*/
    int i=0;
    set->radius = 2.0;      /*rayon=2*/
    set->type =RGB ;        /*type par défaut rgb*/
   

   /*tester les arguments*/
    if (argc > 1) {
        /*Chargement du fichier de configuration*/
        if (sscanf(argv[1], "%d", &set->max_iter) != 1){
			if (load_config(set, argv[1]) == 0) {
            /*Si le chargement échoue, positionnez les valeurs par défaut*/
                set_defaults(set);
			    i=1;
                printf("Chargement du fichier de configuration échoué. Utilisation des valeurs par défaut.\n");
            }
		    if (load_config(set, argv[1]) == 1){
			    i=1;
			}
		}
    }else {
		if(i==0){    /*i=0 signifie qu'aucun nom de fichier n'a été fourni par l'utilisateur dans la ligne de commande*/
		    set->max_iter = 100;       /*si aucune condition n'a été déclarée la valeur du max_iter=100*/
		}
	}
    if (argc > 2) {
        if (sscanf(argv[2],"%lf,%lf,%lf,%lf", &set->pov.x, &set->pov.y, &set->pov.width, &set->pov.height) != 4) {
            printf("Erreur .\n");
            exit(1);  /*execution des valeur de x y width et height*/
        }
    } else if(i==0){
        set->pov.x = -0.76;
        set->pov.y = 0;
        set->pov.width = 2.48;
        set->pov.height = 2.48;
    }

    if (argc > 3) {
        if (sscanf(argv[3], "%dx%d", &set->width, &set->height) != 2) {
            printf("Erreur . \n");
            exit(1);    /*execution des valeurs relatifs à la hauteur et largeur de l'image*/
        }

        if (set->width <= 0 || set->height <= 0) {
            printf("Erreur. \n");
            exit(1);
        }
    } else if(i==0) {
        set->width = DEFAULT_WIDTH;
        set->height = DEFAULT_HEIGHT;
    }
	set->img = malloc((set->width * set->height) * sizeof(struct pixdiv)); /* allouer un espace mémoire suffisant pour acceuillir les paramétres set.img*/
    if (set->img == NULL) {       /*si l'image est nulle retourne un message d'erreur d'allocation mémoire*/ 
        printf("Erreur d'allocation mémoire !\n");
        exit(1);
	}

    if (argc > 4) {
        int i = 0;
        int j = 0;
        int taille = strlen(argv[4]);
        char *nom_fichier = malloc(taille * sizeof(char));

        while (i < taille && argv[4][i] == ' ') {
            i++;
        }

        for (; i < taille; i++) {
            if (argv[4][i] != ' ') {
                nom_fichier[j] = argv[4][i];
                j++;
            } else if (j == 0 || nom_fichier[j - 1] != '_') {
                nom_fichier[j] = '_';
                j++;
            }
        }

        strncpy(set->basename, nom_fichier, STRMAX - 5);  /*nom du fichier*/

        free(nom_fichier);
    } else if (i==0){
        strncpy(set->basename, "mandel", STRMAX);
    }
}

/* Fonction pour convertir les coordonnées 2D en indice de tableau 1D */

int m2v(struct render *set, int x, int y) {
    if (x < 0 || x >= set->width || y < 0 || y >= set->height) {
        fprintf(stderr, "Erreur : Coordonnées hors limites\n");
        exit(1);
    }
    return y * set->width + x;
}

/* Fonction pour générer l'image de la fractale de Mandelbrot */

void render_image(struct render *set) {
    int row, col;
	int i=0;
	int j;
	
    for (row = 0; row < set->height; row++) {
        for (col = 0; col < set->width; col++) {
            double x0 = map(col, 0, set->width, set->xmin, set->xmax);
            double y0 = map(row, 0, set->height, set->ymin, set->ymax);
            double x = 0.0, y = 0.0;
            int iteration = 0;
			/*Calcul de la fractale*/
            while (x * x + y * y < set->radius * set->radius && iteration < set->max_iter) {
                double xtemp = x * x - y * y + x0;
                y = 2 * x * y + y0;
                x = xtemp;
                iteration++;
            }
			for (j = 0; j < 4; j++) {
                double xt = x;
                x = xt * xt - y * y + x0;
                y = 2 * xt * y + y0;
            }
			set->img[m2v(set, col, row)].iter = i;
            set->img[m2v(set, col, row)].x = x;
            set->img[m2v(set, col, row)].y = y;
            set->img[m2v(set,col,row)].iter = iteration;
        }
    }
}

/* Fonction pour obtenir la couleur d'un pixel en fonction du nombre d'itérations */

void get_pixel_color(struct render *set, int Px, int Py, int *r, int *g, int *b) {
    int indice = m2v(set, Px, Py);
	int i=0;
    int iteration = set->img[indice].iter;
	double grey;
	double x,y;
	int n_it;
	struct color hsv,rgb;

    if (iteration == set->max_iter) {
        *r = *g = *b = 0;
	}
    else{
		switch(set->type){
			case BW :
			    *r = *g = *b = 255;   /* Pixel blanc pour les points en dehors de l'ensemble */
				break;
			case BW_ALTERN :
			    if (iteration % 2 == (set->max_iter) % 2) { /*blanc et noir alterné pour les points hors l'ensemble selon leurs parité*/
                *r = *g = *b = 0;
                } else {
                    *r = *g = *b = 255;
                }
				break;
			case GREY_ST :
			    i = (int)(255.0 * iteration / set->max_iter);
                *r = *g = *b = i;                             /* gris dégradé en dehors de l'ensemble*/
				break;
			case GREY_SM:                                     /* gris plus dégradé (lisse)*/
			    x = set->img[indice].x;
                y = set->img[indice].y;
                n_it =set->img[indice].iter;

                grey = 5.0 + n_it - log(log(x * x + y * y) / log(2.0)) / log(2.0);
                grey = floor(512.0 * grey / set->max_iter);

                if (grey > 255.0) {
                    grey = 255.0;
                }

                *r = *g = *b = (int)grey;
				break;
			case RGB:                               /*couleurs*/
			    x = set->img[indice].x;
                y = set->img[indice].y;
                n_it =set->img[indice].iter;

                grey = 5.0 + n_it - log(log(x * x + y * y) / log(2.0)) / log(2.0);
                grey = floor(512.0 * grey / set->max_iter);
		        hsv.c1=(int)(360.0 * grey/set->max_iter);
		        hsv.c2=1;
		        hsv.c3=1;
		        hsv2rgb(&rgb,&hsv);
		        *r=rgb.c1;
		        *g=rgb.c2;
		        *b=rgb.c3;
			    break;
		}
			
	}
	
}

/*savegarder le fichier PPM*/

void save_image(struct render *set) {
    FILE *fout;
    int i, j;
    int r, g, b;

    strcpy(set->basename,"mandel");    /*Création du nom de fichier en utilisant le nom de base avec l'extension ppm*/
    strcat(set->basename, ".ppm");

    fout = fopen(set->basename, "w");

    if (fout == NULL) {
        perror("Erreur lors de l'ouverture du fichier");
        exit(1);
    }

    fprintf(fout, "P3\n%d %d\n255\n", set->width, set->height);                  /*entête du fichier ppm*/
    fprintf(fout, "# Nombre d'itérations max : %d\n", set->max_iter);
    fprintf(fout, "# Zone dans le plan complexe visualisée : x dans [%g; %g], y dans [%g; %g]\n", set->xmin, set->xmax, set->ymin, set->ymax);

    for (i = 0; i < set->height; i++) {
        for (j = 0; j < set->width; j++) {
            get_pixel_color(set, j, i, &r, &g, &b);
            fprintf(fout, "%d %d %d ", r, g, b);
        }
        fprintf(fout, "\n");
    }

    fclose(fout);
}

void set_defaults(struct render *set) {
	/*Initialisation des paramètres par défaut de la caméra*/
    set->pov.x = -0.76;
    set->pov.y = 0;
    set->pov.width = 2.48;
    set->pov.height = 2.48;
    /*valeurs par défauts de la figure de mandelbrot*/
    set->max_iter = 100;
    set->radius = 2.0;
    set->width = DEFAULT_WIDTH;
    set->height = DEFAULT_HEIGHT;
    /*paramétrer le nom du fichier ainsi que le type de rendu*/
    strncpy(set->basename, "mandel", STRMAX);
    set->type = RGB;
}

/*fonction permettant de charger les paramétres de l'image à partir du fichier de config*/

int load_config(struct render *set, char *config_file){
	FILE *file = fopen(config_file,"r"); /*ouverture du fichier en lecture*/
	char line[STRMAX];
	if(file==NULL){
		printf("erreur d'ouverture du fichier");
		return 0;
	}
	/*lire le nom du fichier*/
	if (fgets(line, sizeof(line), file) != NULL) {
        if (sscanf(line, "%s", set->basename) != 1) {
            printf("Erreur de lecture du nom de base dans la ligne : %s", line);
            fclose(file);
            return 0;
        }
    }
    /*lire les paramétres de l'image*/
    if (fgets(line, sizeof(line), file) != NULL) {
        if (sscanf(line,"%dx%d", &set->width, &set->height) != 2) {
            printf("Erreur de lecture des dimensions dans la ligne : %s", line);
            fclose(file);
            return 0;
        }
    }
	/*lire le type de rendu*/
	if (fgets(line, sizeof(line), file) != NULL) {
        if (strcmp(line, "rgb\n") == 0) {
            set->type = RGB;
        } else if (strcmp(line, "b&w\n") == 0) {
            set->type = BW;
        } else if (strcmp(line, "b&w_alt\n") == 0) {
            set->type = BW_ALTERN;
        } else if (strcmp(line, "grey_stepped\n") == 0) {
            set->type = GREY_ST;
        } else if (strcmp(line, "grey_smoothed\n") == 0) {
            set->type = GREY_SM;
        } else {
            printf("Type de rendu non reconnu dans la ligne : %s", line);
            fclose(file);
            return 0;
        }
    }
	/*lire les paramétres de la camera*/
	if (fgets(line, sizeof(line), file) != NULL){
		if (sscanf(line,"%lf,%lf,%lf,%lf",&set->pov.x,&set->pov.y,&set->pov.width,&set->pov.height) != 4){
			printf("Erreur de lecture des paramétres de la camera dans la ligne : %s", line);
            fclose(file);
            return 0;
        }
	}
	/*lire le nombre d'itérations maximal*/
	if (fgets(line, sizeof(line), file) != NULL){
		if (sscanf(line,"%d",&set->max_iter) != 1){
			printf("Erreur de lecture de l'itération maximale dans la ligne : %s", line);
            fclose(file);
            return 0;
        }
	}
	/*lire la valeur du rayon*/
	if (fgets(line, sizeof(line), file) != NULL){
		if (sscanf(line,"%lf",&set->radius) != 1){
			printf("Erreur de lecture de l'itération maximale dans la ligne : %s", line);
            fclose(file);
            return 0;
        }
	}
	fclose(file); /*fermeture du ficher*/
	return 1;
}
