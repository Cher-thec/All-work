Attribute VB_Name = "Module1"

' OPTIMISATION DE PORTEFEUILLE AVEC SEUIL MINIMUM PAR RECUIT SIMULE
' Etude de cas n°3
' Axe Aide à la Décision en Contexte Industriel

' Déclaration de constantes
Const FeuilleRecuit As String = "Recuit simulé"
Const FeuilleLog As String = "Fichier log"
Const Log As Boolean = True
Const NbActions As Integer = 40

' Recupération des paramètres du recuit et des données du problème
Sub InitialiseDonnees(ByRef It As Integer, ByRef T As Double, ByRef Alpha As Double, ByRef L As Integer, ByRef Min As Double, ByRef Max As Double, ByRef rend() As Double)

    With ThisWorkbook.Worksheets(FeuilleRecuit)
        It = .Cells(2, 3)
        T = .Cells(3, 3)
        Alpha = .Cells(4, 3)
        L = .Cells(5, 3)
        Min = .Cells(8, 3)
        Max = .Cells(9, 3)
        For j = 1 To NbActions
            rend(j) = .Cells(10, 2 + j)
        Next j
        .Cells(13, 3) = ""
        For j = 1 To NbActions
            .Cells(14, 2 + j) = ""
        Next j
        .Cells(15, 3) = "En cours"
    End With

End Sub
'Lecture des coefficents de correlations entre les actions et des variances de chacunes d'entre elles pour calcul matrice covariance
Sub Lecture_donnees(ByRef variance() As Double, ByRef rho() As Double)
        With ThisWorkbook.Worksheets("Corrélations rho")
        For i = 1 To NbActions
            For j = 1 To NbActions
                rho(j, i) = .Cells(4 + i, 1 + j) 'on récupère le coeff de correlation sur chaque ligne et on avance sur les colonnes
            Next j
        Next i
    End With
    
    With ThisWorkbook.Worksheets("Paramètres mu-sigma")
        For i = 1 To NbActions
            variance(i) = .Cells(3 + i, 4) 'on récupère la variance de chaque entreprise
        Next i
    End With

End Sub
' Calcul des coefficients de la matrice de covariance
Function Matrice_Covariance(ByRef variance() As Double, ByRef rho() As Double, ByRef Matrice_cov() As Double)
    For i = 1 To NbActions
        For j = 1 To NbActions
            Matrice_cov(i, j) = rho(i, j) * variance(i) * variance(j)
        Next j
    Next i

End Function
' Calcul de la variance d'une solution
Function variance_solution(ByRef Matrice_cov() As Double, ByRef Solution() As Double)
    Dim produit_xomega(NbActions) As Double
    Dim s As Integer
    
    For i = 1 To NbActions
        produit_xomega(i) = 0
        For j = 1 To NbActions
            produit_xomega(i) = produit_xomega(i) + Solution(j) * Matrice_cov(j, i) 'on somme sur chaque colonne
        Next j
    Next i
    
    variance_finale = 0
    For i = 1 To NbActions
        variance_finale = variance_finale + produit_xomega(i) * Solution(i)
    Next i
    
    variance_solution = variance_finale

End Function
'Calcul du risque
Function Risque(ByRef variance_solution As Double)
Risque = 0

r = Sqr(variance_solution)

Risque = r
End Function

Sub Pareto(ByVal NbIteration As Integer)
    Dim ws As Worksheet
    Dim i As Long
    Dim j As Long
    Dim IsPareto As Boolean
    Dim CurrentReturn() As Double, CurrentRisk() As Double
    Dim CompareReturn As Double, CompareRisk As Double

    ' Référence vers la feuille de calcul
    Set ws = ThisWorkbook.Worksheets("Fichier log")
    ws.Activate

    ' Initialisation des tableaux pour stocker les valeurs
    ReDim CurrentReturn(1 To NbIteration)
    ReDim CurrentRisk(1 To NbIteration)

    ' Remplissage des valeurs de rendement et risque
    For i = 1 To NbIteration
        CurrentReturn(i) = ws.Cells(i + 1, 43).Value ' Colonne du rendement
        CurrentRisk(i) = ws.Cells(i + 1, 47).Value   ' Colonne du risque
    Next i

    ' Calcul du front de Pareto
    For i = 1 To NbIteration
        IsPareto = True

        ' Comparaison avec tous les autres portefeuilles
        For j = 1 To NbIteration
            If j <> i Then
                CompareReturn = CurrentReturn(j)
                CompareRisk = CurrentRisk(j)

                ' Détermine si le portefeuille (j) domine (i)
                If (CompareReturn >= CurrentReturn(i) And CompareRisk <= CurrentRisk(i)) Then
                    IsPareto = False
                    Exit For
                End If
            End If
        Next j

        ' Mise à jour des résultats
        If IsPareto Then
            ws.Cells(i + 1, NbActions + 9).Value = "Pareto"
        Else
            ws.Cells(i + 1, NbActions + 9).Value = "Non Pareto"
        End If
    Next i
End Sub




' Affichage de la meilleure solution trouvée par le recuit simulé
Sub SolutionProposee(ByVal Val As Double, ByRef Sol() As Double, ByVal Temps As Integer)
    
    With ThisWorkbook.Worksheets(FeuilleRecuit)
        .Cells(13, 3) = Val
        For j = 1 To NbActions
            .Cells(14, 2 + j) = Sol(j)
        Next j
        .Cells(15, 3) = Temps
    End With

End Sub

' Calcul de l'espérance de rendement d'une solution
Function Rendement(ByRef Solution() As Double, ByRef Coef() As Double)

    Rendement = Application.WorksheetFunction.SumProduct(Solution, Coef)  '


End Function

' Sélection aléatoire d'une solution dans le voisinage de la solution courante
Sub Voisin(ByRef Solution() As Double, ByRef NewSol() As Double, ByVal SeuilInf As Double, ByVal SeuilSup As Double)
    
    Dim Actif1, Actif2, Cpt As Integer
    Dim Transaction, ComplementMax As Double
    
    Cpt = 0
        
    ' Sélection d'une action pouvant être vendue et de la quantité vendue
    Actif1 = Int(NbActions * Rnd + 1)
    While Solution(Actif1) = 0
        Actif1 = Int(NbActions * Rnd + 1)
    Wend
    If Solution(Actif1) = SeuilInf Then
        Transaction = Solution(Actif1)
    Else
        Transaction = Solution(Actif1) * Rnd
        If Transaction < SeuilInf Then
            ComplementMax = 0
            For j = 1 To NbActions
                If (Solution(j) >= SeuilInf) And (j <> Actif1) Then
                    ComplementMax = Application.WorksheetFunction.Max(ComplementMax, SeuilSup - Solution(j))
                End If
            Next j
            If (Transaction > ComplementMax) And (Transaction > 0.5 * SeuilInf) And (Solution(Actif1) >= SeuilInf * 2) Then
                Transaction = SeuilInf
            Else
                Transaction = Application.WorksheetFunction.Min(ComplementMax, Solution(Actif1) - SeuilInf, Transaction)
            End If
        Else
            If Transaction > Solution(Actif1) - SeuilInf Then
                If (Transaction > Solution(Actif1) - 0.5 * SeuilInf) Then
                    Transaction = Solution(Actif1)
                Else
                    Transaction = Solution(Actif1) - SeuilInf
                End If
            End If
        End If
    End If
    
    ' Sélection d'une autre action pour réinvestir l'argent
    If Transaction <= 0.000000000001 Then ' Gestion des imprécisions numériques
        Actif2 = Actif1
        Transaction = 0
    Else
        Actif2 = Int(NbActions * Rnd + 1)
        While ((Actif1 = Actif2) Or (Solution(Actif2) + Transaction < SeuilInf) Or (Solution(Actif2) + Transaction > SeuilSup)) And Cpt <= 1000
            Actif2 = Int(NbActions * Rnd + 1)
            Cpt = Cpt + 1
        Wend
    End If
    If Cpt > 1000 Then
        Actif2 = Actif1
        Transaction = 0
    End If
    
    ' Mise à jour du portefeuille avec le transfert de l'action Actif1 vers l'action Actif2
    NewSol(Actif1) = Solution(Actif1) - Transaction
    NewSol(Actif2) = Solution(Actif2) + Transaction
    For j = 1 To NbActions
        If (j <> Actif1) And (j <> Actif2) Then
            NewSol(j) = Solution(j)
        End If
    Next j

End Sub

' Construction gloutonne d'un portefeuille initial
Sub InitSol(ByRef Solution() As Double, ByVal SeuilInf As Double, ByVal SeuilSup As Double)

    Dim Tirage As Integer
        
    For j = 1 To NbActions
        Solution(j) = 0
    Next j
    
    For j = 1 To Int(1 / SeuilInf)
        Tirage = Int(NbActions * Rnd + 1)
        While (Solution(Tirage) + SeuilInf > SeuilSup)
            Tirage = Int(NbActions * Rnd + 1)
        Wend
        Solution(Tirage) = Solution(Tirage) + SeuilInf
    Next j
        
    Tirage = Int(NbActions * Rnd + 1)
    While (Solution(Tirage) = 0) Or (Solution(Tirage) + (1 - SeuilInf * Int(1 / SeuilInf)) > SeuilSup) ' assure la somme totale des élément =1 (valeur résiduelle)
        Tirage = Int(NbActions * Rnd + 1)
    Wend
    Solution(Tirage) = Solution(Tirage) + (1 - SeuilInf * Int(1 / SeuilInf))
    
End Sub

' Affichage d'une solution dans le fichier de log
Static Sub AfficheSolution(ByVal Etiquette As String, ByRef Solution() As Double, ByRef Taux() As Double, Meilleure As Double, Choix As String, Temp As Double, ByRef Matrice_cov() As Double)

    Static Line As Integer ' Variable static nécessaire pour l'affichage ligne par ligne
       
    If Log Then
        With ThisWorkbook.Worksheets(FeuilleLog)

            If (Line = 0) Then ' Affichage de la ligne de titre au premier lancement
                .Cells.ClearContents
                .Cells(1 + Line, 1) = "Iteration"
                For j = 1 To NbActions
                    .Cells(1 + Line, j + 1) = "Action " & j
                Next j
                .Cells(1 + Line, NbActions + 2) = ""
                .Cells(1 + Line, NbActions + 3) = "Rendement"
                .Cells(1 + Line, NbActions + 4) = "Meilleure valeur"
                .Cells(1 + Line, NbActions + 5) = "Choix"
                .Cells(1 + Line, NbActions + 6) = "Température"
                
                .Cells(1 + Line, NbActions + 7) = "Variance"
                .Cells(1 + Line, NbActions + 8) = "Risque"
                .Cells(1 + Line, NbActions + 9) = "Frontiere de Pareto"

                Line = Line + 1
            End If
                
            .Cells(1 + Line, 1) = Etiquette
            
            For j = 1 To NbActions
                .Cells(1 + Line, j + 1) = Solution(j)
            Next j
            .Cells(1 + Line, NbActions + 2) = "->"
            .Cells(1 + Line, NbActions + 3) = Rendement(Solution, Taux)
            If Meilleure < 0 Then
                .Cells(1 + Line, NbActions + 4) = ""
            Else
                .Cells(1 + Line, NbActions + 4) = Meilleure
            End If
            .Cells(1 + Line, NbActions + 5) = Choix
            If Temp < 0 Then
                .Cells(1 + Line, NbActions + 6) = ""
            Else
                .Cells(1 + Line, NbActions + 6) = Temp
            End If
            
            If variance_finale < 0 Then
                .Cells(1 + Line, NbActions + 7) = ""
                .Cells(1 + Line, NbActions + 8) = ""
            Else
                .Cells(1 + Line, NbActions + 7) = variance_solution(Matrice_cov, Solution()) 'on rentre les valeurs des variances de chaque solution
                .Cells(1 + Line, NbActions + 8) = Risque(variance_solution(Matrice_cov, Solution())) 'on rentre la valeur des risques
            
            End If
            
          
           
            
        End With
    
        Line = Line + 1
        
    End If
    
End Sub


Function ValueAtRisk(Rendement As Double, Risque As Double, Quantile As Double)

 
    ValueAtRisk = Rendement - Risque * Application.NormSInv(Quantile)
End Function

Sub AjouterValeursPareto()
    Dim wsLog As Worksheet
    Dim wsPareto As Worksheet
    Dim DerniereLigne As Long
    Dim LignePareto As Long
    Dim Rendement As Double
    Dim Risque As Double
    Dim Pareto As String
    Dim Var99 As Double
    Dim Var95 As Double
   
    ' Définir les feuilles
    Set wsLog = ThisWorkbook.Sheets("Fichier log")
    On Error Resume Next
    Set wsPareto = ThisWorkbook.Sheets("pareto-optimaux")
    If wsPareto Is Nothing Then
        Set wsPareto = ThisWorkbook.Sheets.Add
        wsPareto.Name = "Pareto"
    Else
        wsPareto.Cells.Clear
    End If
    On Error GoTo 0
   
    ' Ajouter les titres à la feuille Pareto
    With wsPareto
        .Cells(1, 1).Value = "Pareto"
        .Cells(1, 2).Value = "Rendement"
        .Cells(1, 3).Value = "Risque"
        .Cells(1, 4).Value = "VaR 99%"
        .Cells(1, 5).Value = "VaR 95%"
        .Cells(1, 6).Value = "VaR 80%"
        .Cells(1, 7).Value = "VaR 70%"
        
    End With
   
    LignePareto = 2 ' Première ligne pour les données
   
    ' Trouver la dernière ligne dans la feuille Log
    DerniereLigne = wsLog.Cells(wsLog.Rows.Count, "AW").End(xlUp).Row
   
    ' Parcourir les données et calculer les VaR
    For i = 2 To DerniereLigne ' Supposons que les titres sont sur la première ligne
        Pareto = wsLog.Cells(i, "AW").Value
        Rendement = wsLog.Cells(i, "AQ").Value
        Risque = wsLog.Cells(i, "AV").Value
       
        ' Vérifier si la ligne appartient au Pareto
        If Pareto <> "Non Pareto" And Pareto <> "" Then
            ' Calcul des VaR (à partir de la fonction existante)
            Var99 = ValueAtRisk(Rendement, Risque, 0.99) ' Appel de la fonction pour le quantile 99%
            Var95 = ValueAtRisk(Rendement, Risque, 0.95) ' Appel de la fonction pour le quantile 95%
            Var80 = ValueAtRisk(Rendement, Risque, 0.8)  ' Appel de la fonction pour le quantile 99%
            Var70 = ValueAtRisk(Rendement, Risque, 0.7)  ' Appel de la fonction pour le quantile 95%
           
            ' Ajouter les données à la feuille Pareto
            With wsPareto
                .Cells(LignePareto, 1).Value = Pareto
                .Cells(LignePareto, 2).Value = Rendement
                .Cells(LignePareto, 3).Value = Risque
                .Cells(LignePareto, 4).Value = Var99
                .Cells(LignePareto, 5).Value = Var95
                .Cells(LignePareto, 6).Value = Var80
                .Cells(LignePareto, 7).Value = Var70
            End With
           
            LignePareto = LignePareto + 1
        End If
    Next i
    DerniereLigne = LignePareto
   
   
   
    MsgBox "Calcul des VaR pour les solutions de Pareto terminé. Résultats enregistrés dans la feuille 'Pareto'."
End Sub
Sub GraphiqueParetoCouleur1()
    Dim ws As Worksheet
    Dim ChartObj As ChartObject
    Dim Chart As Chart
    Dim DerniereLigne As Long
    Dim i As Long
    
    ' Sélection de la feuille de log
    Set ws = ThisWorkbook.Worksheets("Fichier log")
    
    ' Trouver la dernière ligne avec des données
    DerniereLigne = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    ' Ajouter un objet graphique
    Set ChartObj = ws.ChartObjects.Add(Left:=500, Width:=400, Top:=50, Height:=300)
    Set Chart = ChartObj.Chart
    
    ' Ajouter les séries pour les points non-Pareto
    With Chart
        .ChartType = xlXYScatter ' Nuage de points avec courbe lissée
        ' Ajout des points non Pareto
        .SeriesCollection.NewSeries
        .SeriesCollection(1).Name = "non pareto"
        .SeriesCollection(1).XValues = ws.Range("AV2:AV" & DerniereLigne)
        .SeriesCollection(1).Values = ws.Range("AQ2:AQ" & DerniereLigne)
        
    
        
        ' Parcourir la plage de données et ajouter les points "Pareto" en rouge
        For i = 2 To DerniereLigne
            If ws.Cells(i, "AW").Value = "Pareto" Then
                .SeriesCollection.NewSeries
                With .SeriesCollection(.SeriesCollection.Count)
                    .XValues = ws.Cells(i, "AV").Value ' Risque
                    .Values = ws.Cells(i, "AQ").Value  ' Rendement
                    .MarkerStyle = xlMarkerStyleCircle
                    .MarkerSize = 8
                    .MarkerForegroundColor = RGB(255, 0, 0) ' Rouge
                    .MarkerBackgroundColor = RGB(255, 0, 0) ' Rouge
                End With
            End If
        Next i
        
        ' Mise en forme du graphique
        .HasTitle = True
        .ChartTitle.Text = "Frontière de Pareto - Risque vs Rendement"
        .Axes(xlCategory).HasTitle = True
        .Axes(xlCategory).AxisTitle.Text = "Risque"
        .Axes(xlValue).HasTitle = True
        .Axes(xlValue).AxisTitle.Text = "Rendement"
    End With
End Sub



' Procédure principale du recuit simulé
Sub SimulatedAnnealing()

    Dim Matrice_cov(NbActions, NbActions) As Double
    Dim variance(NbActions) As Double
    Dim rho(NbActions, NbActions) As Double
    
    ' Constantes pour le recuit simulé
    Dim NbIteration As Integer
    Dim Temperature As Double
    Dim AlphaTemp As Double
    Dim Palier As Integer

    ' Constantes du problème
    Dim SeuilMin As Double
    Dim SeuilMax As Double
    Dim Taux(NbActions) As Double

    ' Variables
    Dim Actuelle(NbActions) As Double
    Dim Nouvelle(NbActions) As Double
    Dim BestSol(NbActions) As Double
    Dim BestVal As Double
    Dim depart
    Dim arrivee
     
    depart = Now
    Randomize ' Pour initialiser la suite aléatoire pour Rnd
    
    
    Call InitialiseDonnees(NbIteration, Temperature, AlphaTemp, Palier, SeuilMin, SeuilMax, Taux)
    Call Lecture_donnees(variance, rho)
    Call Matrice_Covariance(variance, rho, Matrice_cov)
    
        
    ' Calcul et affichage d'une solution initiale
    Call InitSol(Actuelle, SeuilMin, SeuilMax)
    For j = 1 To NbActions
        BestSol(j) = Actuelle(j)
    Next j
    BestVal = Rendement(BestSol, Taux)
    Call AfficheSolution("Solution initiale", Actuelle, Taux, BestVal, "", -1, Matrice_cov)

    ' Boucle principale du recuit jusqu'à critère d'arrêt (nombre d'itérations)
    For Iteration = 1 To NbIteration
        Call Voisin(Actuelle, Nouvelle, SeuilMin, SeuilMax)
        ' Mise à jour de la meilleure solution connue
        If Rendement(Nouvelle, Taux) > BestVal Then
            For j = 1 To NbActions
                BestSol(j) = Nouvelle(j)
            Next j
            BestVal = Rendement(BestSol, Taux)
        End If
        ' Mise à jour de la solution courante
        If (Rendement(Nouvelle, Taux) >= Rendement(Actuelle, Taux)) Or (Rnd <= Exp((Rendement(Nouvelle, Taux) - Rendement(Actuelle, Taux)) / Temperature)) Then
            For j = 1 To NbActions
                Actuelle(j) = Nouvelle(j)
            Next j
            Call AfficheSolution("Iteration " & Iteration, Nouvelle, Taux, BestVal, "Acceptée", Temperature, Matrice_cov)
        Else
            Call AfficheSolution("Iteration " & Iteration, Nouvelle, Taux, BestVal, "Rejetée", Temperature, Matrice_cov)
        End If
        ' Mise à jour de la température
        If Iteration Mod Palier = 0 Then
            Temperature = Temperature * AlphaTemp
        End If
    Next Iteration

    ' Affichage de la meilleure solution trouvée
    Call AfficheSolution("Solution finale ", BestSol, Taux, -1, "", -1, Matrice_cov)
    arrivee = Now
    Call SolutionProposee(BestVal, BestSol, Int((arrivee - depart) * 3600 * 24))
    Call Pareto(NbIteration)
    
    Sheets("Recuit simulé").Activate
    Call GraphiqueParetoCouleur1
    Call AjouterValeursPareto
    
        
    End ' Nécessaire pour réinitialiser les variables statiques
    
End Sub

