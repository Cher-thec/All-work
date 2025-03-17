-- TP : tp4.sql
-- Date : le 14 Décembre 2023
-- Auteurs : Aymen IMAD et saief eddine jouini


--Q1: Cette instruction permet de surprimer la table arbre
DROP TABLE ARBRE;

--Q4: ajouter la clé primaire sur l'attribut IDBASE
DELETE FROM arbre 
WHERE IDBASE IN (SELECT IDBASE FROM arbre GROUP BY IDBASE HAVING COUNT(*)>1);

ALTER TABLE arbre
ADD CONSTRAINT pk_arbre PRIMARY KEY (IDBASE);

--Q5:verification des coordonnées géographiques de type chaine de caractères
DESC arbre; --oui on pourra voir que le type de GEO_POINT_2D est VARCHAR2--

--Q6:verification de l'utilité de chaque colonne
-- Supprimer la colonne TYPE_EMPLACEMENT
ALTER TABLE arbre
DROP COLUMN TYPE_EMPLACEMENT;

-- Supprimer la colonne NUMERO
ALTER TABLE arbre
DROP COLUMN NUMERO;

--Q7:supprimer la colonne IDEMPLACEMENT
ALTER TABLE arbre
DROP COLUMN IDEMPLACEMENT;

--Q2.1 faire connaissance avec cette table
DESC SYS.ARRONDISSEMENT;
--Q2.2 ajouter une clé etrangère à la colonne arrondissement de table arbre
ALTER TABLE arbre
ADD CONSTRAINT fk_arbre
FOREIGN KEY (ARRONDISSEMENT)
REFERENCES SYS.ARRONDISSEMENT(NOM_ARR);

--Q3.1 creation de la table denomination_table
CREATE TABLE DENOMINATION_ARBRE (
  LIBELLE VARCHAR2(128) NOT NULL,
  GENRE VARCHAR2(26) NOT NULL,
  ESPECE VARCHAR2(26) NOT NULL,
  BESOIN_ELAGAGE VARCHAR2(128) DEFAULT NULL,
  AGE_LIMIT NUMBER(38) DEFAULT NULL,
  FEUILLES_TOMBANTES VARCHAR2(26) DEFAULT NULL,
  CONSTRAINT pk_denomination_arbre PRIMARY KEY (LIBELLE, GENRE, ESPECE)
);

--Q3.2 afficher une seule fois toutes dominations des arbres de la table ARBRE
SELECT DISTINCT LIBELLE_FRANCAIS, GENRE, ESPECE
FROM arbre;

--Q3.3 remplissage de la table denomination

INSERT INTO DENOMINATION_ARBRE (LIBELLE, GENRE, ESPECE)
SELECT DISTINCT LIBELLE_FRANCAIS, GENRE, ESPECE
FROM arbre;

--Q3.4 correction des valeurs nulles
INSERT INTO DENOMINATION_ARBRE (LIBELLE, GENRE, ESPECE, VARIETE_OUCULTIVAR, CIRCONFERENCE, HAUTEUR, STADE_DE_DEVELOPPEMENT, REMARQUABLE)
SELECT
  LIBELLE_FRANCAIS,
  GENRE,
  ESPECE,
  NVL(VARIETE_OUCULTIVAR, '1') AS VARIETE_OUCULTIVAR,
  NVL(CIRCONFERENCE, 0) AS CIRCONFERENCE,
  NVL(HAUTEUR, 0) AS HAUTEUR,
  NVL(STADE_DE_DEVELOPPEMENT, '') AS STADE_DE_DEVELOPPEMENT,
  NVL(REMARQUABLE, '') AS REMARQUABLE
FROM ARBRE;

--Q3.5 ajouter des clés étrangères sur libelle, espace, espece de la table arbre
ALTER TABLE DENOMINATION_ARBRE
ADD CONSTRAINT fk_denomination_arbre
FOREIGN KEY (LIBELLE_FRANCAIS, GENRE, ESPECE)
REFERENCES DENOMINATION_ARBRE (LIBELLE, GENRE, ESPECE);

--Q4.1 afficher les valeurs extrèmes des attributs CIRCONFERENCE et HAUTEUR de la table arbre
SELECT
  MIN(CIRCONFERENCE) AS MIN_CIRCONFERENCE,
  MAX(CIRCONFERENCE) AS MAX_CIRCONFERENCE,
  MIN(HAUTEUR) AS MIN_HAUTEUR,
  MAX(HAUTEUR) AS MAX_HAUTEUR
FROM arbre;

--Q4.2 est-ce que les valeurs vous semblent raisonnables?
--les valaurs de min max de sont pas raisonables et semble illogiques (min=0 , max=56000 ???!)--

--Q4.3 effacer tous les arbres de hauteur 0
DELETE FROM ARBE
WHERE HAUTEUR = 0;

--Q4.4 meme calcul pour la circonférence
DELETE FROM ARBE
WHERE CIRCONFERENCE = 0;

--Q4.5 que faire des valeurs maximales de ces attributs?
--on pourra choisir une valeur maximale limite et une valeur limite  minimale--