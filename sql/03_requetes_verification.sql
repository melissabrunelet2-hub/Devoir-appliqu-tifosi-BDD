/* ============================================================
   03_requetes_verification.sql
   - Requêtes de vérification
   ============================================================ */

USE tifosi;

-- 1) Afficher la liste des noms des focaccias par ordre alphabétique croissant
SELECT nom_focaccia
FROM focaccia
ORDER BY nom_focaccia ASC;
-- Résultat attendu : liste triée A->Z
-- Résultat obtenu : 6 focaccias (ex : Campagnola, Classica, Hawaienne, Raclaccia, Vegetariana, Venezia)
-- Commentaire : conforme

-- 2) Afficher le nombre total d’ingrédients
SELECT COUNT(*) AS nb_ingredients
FROM ingredient;
-- Résultat attendu : nombre d’ingrédients dans ingredient
-- Résultat obtenu : 23
-- Commentaire : conforme

-- 3) Afficher le prix moyen des focaccias
SELECT AVG(prix) AS prix_moyen
FROM focaccia;
-- Résultat attendu : moyenne des prix
-- Résultat obtenu : environ 9.50 €
-- Commentaire : conforme

-- 4) Afficher la liste des boissons avec leur marque, triée par nom de boisson
SELECT b.nom_boisson, m.nom_marque
FROM boisson b
JOIN marque m ON m.id_marque = b.id_marque
ORDER BY b.nom_boisson ASC;
-- Résultat attendu : chaque boisson avec sa marque
-- Résultat obtenu : 12 lignes (ex : Capri-sun / Coca-Cola, Eau de source / Cristalline, Pepsi / PepsiCo)
-- Commentaire : conforme

-- 5) Afficher la liste des ingrédients pour une Raclaccia
SELECT f.nom_focaccia, i.nom_ingredient, fi.quantite
FROM focaccia f
JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
JOIN ingredient i ON i.id_ingredient = fi.id_ingredient
WHERE f.nom_focaccia = 'Raclaccia'
ORDER BY i.nom_ingredient ASC;
-- Résultat attendu : ingrédients et quantités de la Raclaccia
-- Résultat obtenu : plusieurs ingrédients (ex : Fromage, Raclette, Crème, Pomme de terre)
-- Commentaire : conforme

-- 6) Afficher le nom et le nombre d’ingrédients pour chaque focaccia
SELECT f.nom_focaccia, COUNT(*) AS nb_ingredients
FROM focaccia f
JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom_focaccia
ORDER BY f.nom_focaccia ASC;
-- Résultat attendu : 1 ligne par focaccia avec le nombre d’ingrédients
-- Résultat obtenu : 6 lignes avec un nombre variable d’ingrédients
-- Commentaire : conforme

-- 7) Afficher le nom de la focaccia qui a le plus d’ingrédients
SELECT f.nom_focaccia
FROM focaccia f
JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom_focaccia
ORDER BY COUNT(*) DESC, f.nom_focaccia ASC
LIMIT 1;
-- Résultat attendu : focaccia ayant le plus d’ingrédients
-- Résultat obtenu : Raclaccia
-- Commentaire : conforme

-- 8) Afficher la liste des focaccia qui contiennent de l’ail
SELECT DISTINCT f.nom_focaccia
FROM focaccia f
JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
JOIN ingredient i ON i.id_ingredient = fi.id_ingredient
WHERE i.nom_ingredient = 'Ail'
ORDER BY f.nom_focaccia ASC;
-- Résultat attendu : focaccias contenant de l’ail
-- Résultat obtenu : 3 focaccias
-- Commentaire : conforme

-- 9) Afficher la liste des ingrédients inutilisés
SELECT i.nom_ingredient
FROM ingredient i
LEFT JOIN focaccia_ingredient fi ON fi.id_ingredient = i.id_ingredient
WHERE fi.id_ingredient IS NULL
ORDER BY i.nom_ingredient ASC;
-- Résultat attendu : ingrédients jamais utilisés
-- Résultat obtenu : plusieurs ingrédients (ex : Anchois, Thon)
-- Commentaire : conforme

-- 10) Afficher la liste des focaccia qui n’ont pas de champignons
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
-- Résultat attendu : focaccia sans champignons
-- Résultat obtenu : 2 focaccias
-- Commentaire : conforme
