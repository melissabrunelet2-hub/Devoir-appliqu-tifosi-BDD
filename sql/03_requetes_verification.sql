/* ============================================================
   03_requetes_verification.sql
   - 10 requêtes de test + commentaires
   ============================================================ */

USE tifosi;

-- 1) Afficher la liste des noms des focaccias par ordre alphabétique croissant
-- SQL :
SELECT nom_focaccia
FROM focaccia
ORDER BY nom_focaccia ASC;
-- Résultat attendu : liste triée A->Z
-- Résultat obtenu : (à compléter après exécution)
-- Commentaire : (écarts éventuels)

-- 2) Afficher le nombre total d’ingrédients
-- SQL :
SELECT COUNT(*) AS nb_ingredients
FROM ingredient;
-- Résultat attendu : nombre d’ingrédients dans ingredient
-- Résultat obtenu : (à compléter)
-- Commentaire :

-- 3) Afficher le prix moyen des focaccias
-- SQL :
SELECT AVG(prix) AS prix_moyen
FROM focaccia;
-- Résultat attendu : moyenne des prix
-- Résultat obtenu :
-- Commentaire :

-- 4) Afficher la liste des boissons avec leur marque, triée par nom de boisson
-- SQL :
SELECT b.nom_boisson, m.nom_marque
FROM boisson b
JOIN marque m ON m.id_marque = b.id_marque
ORDER BY b.nom_boisson ASC;
-- Résultat attendu : chaque boisson + marque, tri A->Z sur boisson
-- Résultat obtenu :
-- Commentaire :

-- 5) Afficher la liste des ingrédients pour une Raclaccia
-- SQL :
SELECT f.nom_focaccia, i.nom_ingredient, fi.quantite
FROM focaccia f
JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
JOIN ingredient i ON i.id_ingredient = fi.id_ingredient
WHERE f.nom_focaccia = 'Raclaccia'
ORDER BY i.nom_ingredient ASC;
-- Résultat attendu : ingrédients + quantités pour "Raclaccia"
-- Résultat obtenu :
-- Commentaire :

-- 6) Afficher le nom et le nombre d’ingrédients pour chaque focaccia
-- SQL :
SELECT f.nom_focaccia, COUNT(*) AS nb_ingredients
FROM focaccia f
JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom_focaccia
ORDER BY f.nom_focaccia ASC;
-- Résultat attendu : 1 ligne par focaccia avec nb d’ingrédients
-- Résultat obtenu :
-- Commentaire :

-- 7) Afficher le nom de la focaccia qui a le plus d’ingrédients
-- SQL :
SELECT f.nom_focaccia
FROM focaccia f
JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom_focaccia
ORDER BY COUNT(*) DESC
LIMIT 1;
-- Résultat attendu : focaccia ayant le max d’ingrédients
-- Résultat obtenu :
-- Commentaire :

-- 8) Afficher la liste des focaccia qui contiennent de l’ail
-- SQL :
SELECT DISTINCT f.nom_focaccia
FROM focaccia f
JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
JOIN ingredient i ON i.id_ingredient = fi.id_ingredient
WHERE i.nom_ingredient = 'Ail'
ORDER BY f.nom_focaccia ASC;
-- Résultat attendu : focaccia contenant "Ail"
-- Résultat obtenu :
-- Commentaire :

-- 9) Afficher la liste des ingrédients inutilisés
-- (ingrédients qui n’apparaissent dans aucune focaccia)
-- SQL :
SELECT i.nom_ingredient
FROM ingredient i
LEFT JOIN focaccia_ingredient fi ON fi.id_ingredient = i.id_ingredient
WHERE fi.id_ingredient IS NULL
ORDER BY i.nom_ingredient ASC;
-- Résultat attendu : ingrédients jamais utilisés
-- Résultat obtenu :
-- Commentaire :

-- 10) Afficher la liste des focaccia qui n’ont pas de champignons
-- SQL :
SELECT f.nom_focaccia
FROM focaccia f
WHERE NOT EXISTS (
  SELECT 1
  FROM focaccia_ingredient fi
  JOIN ingredient i ON i.id_ingredient = fi.id_ingredient
  WHERE fi.id_focaccia = f.id_focaccia
    AND i.nom_ingredient = 'Champignon'
)
ORDER BY f.nom_focaccia ASC;
-- Résultat attendu : focaccia sans "Champignon"
-- Résultat obtenu :
-- Commentaire :
