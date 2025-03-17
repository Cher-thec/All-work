-- TP : tp3.sql
-- Date : le 8 Décembre 2023
-- Auteurs : Aymen IMAD et saief eddine jouini




set AUTOCOMMIT on;
--Q1: création d'une table:

CREATE TABLE myecrivain AS
SELECT * FROM sys.ecrivain;

--Q2: Vérifiez si la table myecrivain a des clés primaires ou étrangères.
SELECT CASE WHEN COUNT(*) > 0 THEN 'La clé primaire existe' ELSE 'Pas de clé primaire' END AS result
FROM user_constraints
WHERE table_name = 'MYECRIVAIN' AND constraint_type = 'P';


SELECT CASE WHEN COUNT(*) > 0 THEN 'Clés étrangères existent' ELSE 'Pas de clés étrangères' END AS result
FROM user_constraints
WHERE table_name = 'MYECRIVAIN' AND constraint_type = 'R';

--Q3:
-- Ajouter une clé primaire sur IDECR

ALTER TABLE myecrivain
ADD CONSTRAINT pk_myecrivain PRIMARY KEY (IDECR);

-- Ajouter une clé étrangère sur CHEF_DE_FILE
ALTER TABLE myecrivain
ADD CONSTRAINT fk_myecrivain_chef_def_file
FOREIGN KEY (CHEF_DE_FILE) REFERENCES myecrivain(IDECR);

--Q4:Supprimer la colonne genre_id de la table myecrivain
ALTER TABLE myecrivain
DROP COLUMN genre_id;
--Q5
select* 
from myecrivain;
SELECT constraint_name,constraint_type
FROM user_constraints 
WHERE table_name = 'MYECRIVAIN';

--Q6:

DELETE FROM myecrivain
WHERE ENOM = 'de Balzac'; --Cette requete donne des erreur on procédera differament--

-- Désactiver la contrainte de clé étrangère
ALTER TABLE myecrivain
DISABLE CONSTRAINT FK_MYECRIVAIN_CHEF_DEF_FILE;

-- Effectuer la suppression
DELETE FROM myecrivain
WHERE ENOM = 'de Balzac';

-- Réactiver la contrainte de clé étrangère
ALTER TABLE myecrivain
ENABLE CONSTRAINT FK_MYECRIVAIN_CHEF_DEF_FILE;

-- Désactiver temporairement la contrainte
ALTER TABLE myecrivain
DISABLE CONSTRAINT FK_MYECRIVAIN_CHEF_DE_FILE;

--Q7:insertion d'un nouvel ecrivain:

-- Effectuer l'insertion
INSERT INTO myecrivain (IDECR, ENOM, PNOM, SEXE, DATE_N, PAYS_N, CHEF_DE_FILE, LIVRES_VENDUS, VALEUR)
VALUES (6900, 'Hugo', 'Victor', 'M',TO_DATE('1802-02-26', 'YYYY-MM-DD'), 'France', 7500, 45000, 15);

-- Réactiver la contrainte
ALTER TABLE myecrivain
ENABLE CONSTRAINT FK_MYECRIVAIN_CHEF_DE_FILE;


--Q9: création d'une table oeuvre:

CREATE TABLE OEUVRE (
    IDOEUVRE NUMBER PRIMARY KEY,
    TITRE VARCHAR2(100),
    GENRE VARCHAR2(50),
    ANNEE_PUBLICATION NUMBER,
    IDECR NUMBER,
    FOREIGN KEY (IDECR) REFERENCES MYECRIVAIN(IDECR)
);

--Q10: création d'une table personnage:

CREATE TABLE PERSONNAGE (
    IDPERSONNAGE NUMBER PRIMARY KEY,
    NOM VARCHAR2(100),
    DESCRIPTION VARCHAR2(500),
    IDECR NUMBER,
    IDOEUVRE NUMBER,
    FOREIGN KEY (IDECR) REFERENCES MYECRIVAIN(IDECR),
    FOREIGN KEY (IDOEUVRE) REFERENCES OEUVRE(IDOEUVRE)
);

--Q11: insertion d'un nouvel enregistrement dans PERSONNAGE et OEUVRE:

-- Insérer une œuvre
INSERT INTO OEUVRE (IDOEUVRE, TITRE, GENRE, ANNEE_PUBLICATION, IDECR)
VALUES (1, 'Antigone', 'Tragédie', 1603, 8127);

-- Insérer un personnage
INSERT INTO PERSONNAGE (IDPERSONNAGE, NOM, DESCRIPTION, IDECR, IDOEUVRE)
VALUES (1, 'cher', 'Prince du Danemark', 8127, 1);

--Q12:

INSERT INTO PERSONNAGE (IDPERSONNAGE, NOM, DESCRIPTION, IDECR, IDOEUVRE)
VALUES (1, 'asterix', 'roi du norvége', 1, 1);       --erreur clé non trouvée--

--Q13:essai d'ajout d'une nouvelle valeur:
-- Suppression l'œuvre
DELETE FROM OEUVRE
WHERE IDOEUVRE = 1;       --interpretation erreur: problème de violation de contraintes--

--Q14:nombre des personnages saisis
SELECT
    E.IDECR,
    E.ENOM,
    E.PNOM,
    COUNT(P.IDPERSONNAGE) AS NOMBRE_DE_PERSONNAGES
FROM
    myecrivain E
LEFT JOIN
    PERSONNAGE P ON E.IDECR = P.IDECR
GROUP BY
    E.IDECR, E.ENOM, E.PNOM;

--Q15:nombre d'engegistrment pour une valeur nulle
SELECT COUNT(*) AS NOMBRE_D_ENREGISTREMENTS_SANS_VALEUR
FROM myecrivain
WHERE VALEUR IS NULL OR VALEUR = 0;

--Q16:

SET AUTOCOMMIT OFF;

-- verification de la table
SELECT * FROM myecrivain
order by 1;

-- Effectuez vos mises à jour ici
UPDATE myecrivain SET VALEUR = 42 WHERE IDECR=7902;

-- Vérifiez si la mise à jour est correcte
-- Si correcte, faites COMMIT pour valider la transaction
COMMIT;

-- Si la mise à jour n'est pas correcte, faites ROLLBACK pour annuler la transaction
ROLLBACK;

--Q17: mise à jour valeur

UPDATE myecrivain SET VALEUR = 0 WHERE VALEUR is NULL;

--Q18: mise a jour du nbre de livres vendus

UPDATE myecrivain set LIVRES_VENDUS=LIVRES_VENDUS*1.25;

---Q19: mise à jour de valeur

UPDATE myecrivain SET VALEUR = VALEUR + (SELECT COUNT(*) FROM PERSONNAGE);






