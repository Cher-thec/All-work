-- TP : tp5.sql
-- Date : le 19 Décembre 2023
-- Auteurs : Aymen IMAD 

--partie SQL:

--Q1: verification de la table arbre
select *
from SYS.ARBRE;  --on remarque des circonference et hauteurs à 0 on procéde donc à leurs surpression--

--Q2: determination du maximum d'hauteur et circonférence
SELECT MAX(HAUTEUR),MAX(CIRCONFERENCE)
FROM ARBRE;
-- les valeurs maximales peuvent ne pas être considérés comme aberrantes et l'unité est en cm à contrario les valeurs paraissent abérantes--

--Q3:Affichez le nombre d'arbres par arrondissement et domanialité
SELECT ARRONDISSEMENT,DOMANIALITE,COUNT(*) AS NBRE_ARBRES
FROM ARBRE
GROUP BY ARRONDISSEMENT,DOMANIALITE;
--pour un affichage en des bois--
SELECT ARRONDISSEMENT,DOMANIALITE,COUNT(*) AS NBRE_ARBRES
FROM ARBRE
GROUP BY ARRONDISSEMENT,DOMANIALITE
HAVING ARRONDISSEMENT LIKE 'BOIS%';

--Q4:Chois de TILIA comme genre et trouvons son arrondissement et sa domanialité :
SELECT arrondissement, domanialite
FROM sys.arbre
WHERE libelle = 'Tilleul';

--Q5:Comptez le nombre d'exemplaires de cet arbre en 'Alignement' et excluez les Bois :
SELECT count(*)as nombre_exemplaires
from (SELECT arrondissement, domanialite FROM sys.arbre WHERE libelle = 'Tilleul')
where arrondissement not like 'BOIS%'and domanialite='Alignement'or domanialite='Jardin';


--Q6:Sélectionnez les dénominations d'arbres en 'Jardin' et 'Alignement' avec au moins 30 exemplaires, excluant les Bois :
SELECT libelle
FROM sys.arbre
WHERE domanialite = 'Jardin'
  AND genre IN (
    SELECT libelle
    FROM sys.arbre
    WHERE domanialite = 'Alignement'
      AND arrondissement NOT LIKE 'Bois%'
    GROUP BY libelle
    HAVING COUNT(*) >= 30)
GROUP BY libelle
HAVING COUNT(*) >= 30;