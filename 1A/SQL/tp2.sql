-- TP : tp2.sql
-- Date : le 5 Décembre 2023
-- Auteurs : Aymen IMAD et saief eddine jouini


--Q1: redescribtions des tables ecrivain,genre, localisation:

DESC ECRIVAIN
DESC GENRE
DESC LOCALISATION;

--Q2: SELECTIONNER LES ECRIVAINS DE GENRES HORREUR
SELECT ENOM,PNOM,DATE_N,PAYS_N
FROM ECRIVAIN JOIN GENRE ON ECRIVAIN.GENRE_ID = GENRE.IDGENRE
WHERE GENRE.GNOM = 'Horreur';

--Q3: Affichez les couples d’écrivains qui ont le même prénom
SELECT E1.ENOM AS NOM1, E2.ENOM AS NOM2
FROM ECRIVAIN E1, ECRIVAIN E2
WHERE E1.PNOM = E2.PNOM and E1.ENOM != E2.ENOM

SELECT E1.ENOM AS NOM1,E1.PNOM AS PNOM1
FROM ECRIVAIN E1, ECRIVAIN E2
WHERE E1.ENOM != E2.ENOM and SUBSTR(E1.PNOM, 1,2)=SUBSTR(E2.PNOM, 1,2)

--Q4: écrivains qui n'ont pas de genre associé
SELECT *
FROM ECRIVAIN 
WHERE GENRE_ID IS NULL

--Q5: Affichage pour chaque écrivain son genre littéraire en toutes lettres
SELECT ECRIVAIN.ENOM,ECRIVAIN.PNOM,ECRIVAIN.DATE_N,ECRIVAIN.PAYS_N,GENRE.GNOM
FROM ECRIVAIN JOIN GENRE ON ECRIVAIN.GENRE_ID = GENRE.IDGENRE

--Q6: ECRIVAIN Nés en france
SELECT ECRIVAIN.ENOM,ECRIVAIN.PNOM,ECRIVAIN.DATE_N,ECRIVAIN.PAYS_N,GENRE.GNOM
FROM ECRIVAIN JOIN GENRE ON ECRIVAIN.GENRE_ID = GENRE.IDGENRE
WHERE PAYS_N= 'France';

--Q7:les localisations suivis des genres literraires
SELECT L.IDLOC, L.LNOM , G.GNOM
FROM GENRE G JOIN LOCALISATION L ON L.IDLOC=G.LOC_ID;

--Q8:une requête imbriquée les écrivains dont le genre littéraire est situé aux Amériques (Nord ou Sud).
SELECT DISTINCT E.ENOM,E.PNOM
FROM ECRIVAIN E, GENRE G, LOCALISATION L
WHERE E.GENRE_ID IN (SELECT G.IDGENRE FROM GENRE G WHERE G.LOC_ID IN (SELECT L.IDLOC FROM LOCALISATION L WHERE L.LNOM='Amérique Latine' or L.LNOM = 'Amérique du nord'));

--Q9:même requête que précédente sans imbrications
SELECT E.ENOM,E.PNOM
FROM ECRIVAIN E JOIN GENRE G ON E.GENRE_ID = G.IDGENRE JOIN LOCALISATION L ON G.LOC_ID=L.IDLOC
WHERE L.LNOM='Amérique Latine' or L.LNOM = 'Amérique du nord';

--Q10:pour chaque pays de naissance le nombre d’écrivains qui y sont nés. liste obtenue en ordre décroissant.
SELECT PAYS_N,count(*) AS NBR
FROM ECRIVAIN
GROUP BY PAYS_N
ORDER BY NBR DESC;

--Q11:pays de naissance qui apparaissent une seule fois dans la base avec le syntaxe EXIST EXIST NOT
SELECT DISTINCT E.PAYS_N
FROM ECRIVAIN E
WHERE NOT EXISTS (
    SELECT 1
    FROM ECRIVAIN E2
    WHERE E.PAYS_N = E2.PAYS_N
      AND E.ENOM <> E2.ENOM        --
);

--pays de naissance qui apparaissent une seule fois dans la base avec les agrégats

SELECT E.PAYS_N
FROM ECRIVAIN E
GROUP BY E.PAYS_N
HAVING COUNT(*) < 2;

--Q12: pour chaque localisation le nombre de genres littéraires distincts, le nombre d’écrivains qui y sont rattachés et le nombre total de livres vendus.
SELECT L.LNOM, COUNT(DISTINCT G.GNOM) AS GNBR, COUNT(DISTINCT E.IDECR) AS NBRECD, SUM(E.LIVRES_VENDUS) AS TOTLIVR
FROM ECRIVAIN E JOIN GENRE G ON E.GENRE_ID = G.IDGENRE JOIN LOCALISATION L ON G.LOC_ID=L.IDLOC 
GROUP BY L.LNOM;

--Q13:les localisations, suivi du nom des genres littéraires, le nombre d’écrivains et le total des livres vendus, tenant compte des genres qui ne sont pas rattachés à une localisation et aussi des écrivains qui n’ont pas de genre (syntaxe FULL OUTERJOIN).
SELECT COALESCE(L.LNOM, 'Non attribué') AS Localisation,
       COALESCE(G.GNOM, 'Non attribué') AS Genre,
       COUNT(E.ENOM) AS NombreEcrivains,
       SUM(E.LIVRES_VENDUS) AS TotalLivresVendus
FROM LOCALISATION L
FULL OUTER JOIN GENRE G ON L.IDLOC = G.LOC_ID
FULL OUTER JOIN ECRIVAIN E ON G.IDGENRE = E.GENRE_ID
GROUP BY COALESCE(L.LNOM, 'Non attribué'), COALESCE(G.GNOM, 'Non attribué')
ORDER BY Localisation, Genre;

--Q14: verification de nombre des écrivains
SELECT sum(NOMBREECRIVAINS)
FROM (SELECT COALESCE(L.LNOM, 'Non attribué') AS Localisation,
       COALESCE(G.GNOM, 'Non attribué') AS Genre,
       COUNT(E.ENOM) AS NombreEcrivains,
       SUM(E.LIVRES_VENDUS) AS TotalLivresVendus
FROM LOCALISATION L
FULL OUTER JOIN GENRE G ON L.IDLOC = G.LOC_ID
FULL OUTER JOIN ECRIVAIN E ON G.IDGENRE = E.GENRE_ID
GROUP BY COALESCE(L.LNOM, 'Non attribué'), COALESCE(G.GNOM, 'Non attribué')
ORDER BY Localisation, Genre);        
--oui



