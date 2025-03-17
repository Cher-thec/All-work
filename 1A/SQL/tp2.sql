-- TP : tp2.sql
-- Date : le 5 D�cembre 2023
-- Auteurs : Aymen IMAD et saief eddine jouini


--Q1: redescribtions des tables ecrivain,genre, localisation:

DESC ECRIVAIN
DESC GENRE
DESC LOCALISATION;

--Q2: SELECTIONNER LES ECRIVAINS DE GENRES HORREUR
SELECT ENOM,PNOM,DATE_N,PAYS_N
FROM ECRIVAIN JOIN GENRE ON ECRIVAIN.GENRE_ID = GENRE.IDGENRE
WHERE GENRE.GNOM = 'Horreur';

--Q3: Affichez les couples d��crivains qui ont le m�me pr�nom
SELECT E1.ENOM AS NOM1, E2.ENOM AS NOM2
FROM ECRIVAIN E1, ECRIVAIN E2
WHERE E1.PNOM = E2.PNOM and E1.ENOM != E2.ENOM

SELECT E1.ENOM AS NOM1,E1.PNOM AS PNOM1
FROM ECRIVAIN E1, ECRIVAIN E2
WHERE E1.ENOM != E2.ENOM and SUBSTR(E1.PNOM, 1,2)=SUBSTR(E2.PNOM, 1,2)

--Q4: �crivains qui n'ont pas de genre associ�
SELECT *
FROM ECRIVAIN 
WHERE GENRE_ID IS NULL

--Q5: Affichage pour chaque �crivain son genre litt�raire en toutes lettres
SELECT ECRIVAIN.ENOM,ECRIVAIN.PNOM,ECRIVAIN.DATE_N,ECRIVAIN.PAYS_N,GENRE.GNOM
FROM ECRIVAIN JOIN GENRE ON ECRIVAIN.GENRE_ID = GENRE.IDGENRE

--Q6: ECRIVAIN N�s en france
SELECT ECRIVAIN.ENOM,ECRIVAIN.PNOM,ECRIVAIN.DATE_N,ECRIVAIN.PAYS_N,GENRE.GNOM
FROM ECRIVAIN JOIN GENRE ON ECRIVAIN.GENRE_ID = GENRE.IDGENRE
WHERE PAYS_N= 'France';

--Q7:les localisations suivis des genres literraires
SELECT L.IDLOC, L.LNOM , G.GNOM
FROM GENRE G JOIN LOCALISATION L ON L.IDLOC=G.LOC_ID;

--Q8:une requ�te imbriqu�e les �crivains dont le genre litt�raire est situ� aux Am�riques (Nord ou Sud).
SELECT DISTINCT E.ENOM,E.PNOM
FROM ECRIVAIN E, GENRE G, LOCALISATION L
WHERE E.GENRE_ID IN (SELECT G.IDGENRE FROM GENRE G WHERE G.LOC_ID IN (SELECT L.IDLOC FROM LOCALISATION L WHERE L.LNOM='Am�rique Latine' or L.LNOM = 'Am�rique du nord'));

--Q9:m�me requ�te que pr�c�dente sans imbrications
SELECT E.ENOM,E.PNOM
FROM ECRIVAIN E JOIN GENRE G ON E.GENRE_ID = G.IDGENRE JOIN LOCALISATION L ON G.LOC_ID=L.IDLOC
WHERE L.LNOM='Am�rique Latine' or L.LNOM = 'Am�rique du nord';

--Q10:pour chaque pays de naissance le nombre d��crivains qui y sont n�s. liste obtenue en ordre d�croissant.
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

--pays de naissance qui apparaissent une seule fois dans la base avec les agr�gats

SELECT E.PAYS_N
FROM ECRIVAIN E
GROUP BY E.PAYS_N
HAVING COUNT(*) < 2;

--Q12: pour chaque localisation le nombre de genres litt�raires distincts, le nombre d��crivains qui y sont rattach�s et le nombre total de livres vendus.
SELECT L.LNOM, COUNT(DISTINCT G.GNOM) AS GNBR, COUNT(DISTINCT E.IDECR) AS NBRECD, SUM(E.LIVRES_VENDUS) AS TOTLIVR
FROM ECRIVAIN E JOIN GENRE G ON E.GENRE_ID = G.IDGENRE JOIN LOCALISATION L ON G.LOC_ID=L.IDLOC 
GROUP BY L.LNOM;

--Q13:les localisations, suivi du nom des genres litt�raires, le nombre d��crivains et le total des livres vendus, tenant compte des genres qui ne sont pas rattach�s � une localisation et aussi des �crivains qui n�ont pas de genre (syntaxe FULL OUTERJOIN).
SELECT COALESCE(L.LNOM, 'Non attribu�') AS Localisation,
       COALESCE(G.GNOM, 'Non attribu�') AS Genre,
       COUNT(E.ENOM) AS NombreEcrivains,
       SUM(E.LIVRES_VENDUS) AS TotalLivresVendus
FROM LOCALISATION L
FULL OUTER JOIN GENRE G ON L.IDLOC = G.LOC_ID
FULL OUTER JOIN ECRIVAIN E ON G.IDGENRE = E.GENRE_ID
GROUP BY COALESCE(L.LNOM, 'Non attribu�'), COALESCE(G.GNOM, 'Non attribu�')
ORDER BY Localisation, Genre;

--Q14: verification de nombre des �crivains
SELECT sum(NOMBREECRIVAINS)
FROM (SELECT COALESCE(L.LNOM, 'Non attribu�') AS Localisation,
       COALESCE(G.GNOM, 'Non attribu�') AS Genre,
       COUNT(E.ENOM) AS NombreEcrivains,
       SUM(E.LIVRES_VENDUS) AS TotalLivresVendus
FROM LOCALISATION L
FULL OUTER JOIN GENRE G ON L.IDLOC = G.LOC_ID
FULL OUTER JOIN ECRIVAIN E ON G.IDGENRE = E.GENRE_ID
GROUP BY COALESCE(L.LNOM, 'Non attribu�'), COALESCE(G.GNOM, 'Non attribu�')
ORDER BY Localisation, Genre);        
--oui



