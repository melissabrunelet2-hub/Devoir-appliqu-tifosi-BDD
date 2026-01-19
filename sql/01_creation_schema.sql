/* ============================================================
   01_creation_schema.sql
   - Création BDD tifosi
   - Création utilisateur tifosi + droits
   - Création du schéma (tables + contraintes)
   ============================================================ */

-- (Optionnel) sécurité : exécuter en admin MySQL
DROP DATABASE IF EXISTS tifosi;
CREATE DATABASE tifosi
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

-- Utilisateur + droits (adapté si besoin)
DROP USER IF EXISTS 'tifosi'@'localhost';
CREATE USER 'tifosi'@'localhost' IDENTIFIED BY 'Tifosi#2026!';

GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';
FLUSH PRIVILEGES;

USE tifosi;

-- =========================
-- TABLES "référentielles"
-- =========================

CREATE TABLE ingredient (
  id_ingredient INT NOT NULL,
  nom_ingredient VARCHAR(100) NOT NULL,
  CONSTRAINT pk_ingredient PRIMARY KEY (id_ingredient),
  CONSTRAINT uq_ingredient_nom UNIQUE (nom_ingredient),
  CONSTRAINT ck_ingredient_nom CHECK (CHAR_LENGTH(nom_ingredient) >= 1)
) ENGINE=InnoDB;

CREATE TABLE marque (
  id_marque INT NOT NULL,
  nom_marque VARCHAR(100) NOT NULL,
  CONSTRAINT pk_marque PRIMARY KEY (id_marque),
  CONSTRAINT uq_marque_nom UNIQUE (nom_marque),
  CONSTRAINT ck_marque_nom CHECK (CHAR_LENGTH(nom_marque) >= 1)
) ENGINE=InnoDB;

CREATE TABLE boisson (
  id_boisson INT NOT NULL,
  nom_boisson VARCHAR(120) NOT NULL,
  id_marque INT NOT NULL,
  CONSTRAINT pk_boisson PRIMARY KEY (id_boisson),
  CONSTRAINT uq_boisson_nom UNIQUE (nom_boisson),
  CONSTRAINT fk_boisson_marque FOREIGN KEY (id_marque)
    REFERENCES marque(id_marque)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE focaccia (
  id_focaccia INT NOT NULL AUTO_INCREMENT,
  nom_focaccia VARCHAR(120) NOT NULL,
  prix DECIMAL(6,2) NOT NULL,
  CONSTRAINT pk_focaccia PRIMARY KEY (id_focaccia),
  CONSTRAINT uq_focaccia_nom UNIQUE (nom_focaccia),
  CONSTRAINT ck_focaccia_prix CHECK (prix >= 0)
) ENGINE=InnoDB;

-- =========================
-- TABLES "métier" (MCD)
-- =========================

CREATE TABLE client (
  id_client INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL,
  code_postal VARCHAR(10) NOT NULL,
  CONSTRAINT pk_client PRIMARY KEY (id_client),
  CONSTRAINT uq_client_email UNIQUE (email),
  CONSTRAINT ck_client_email CHECK (email LIKE '%_@_%._%')
) ENGINE=InnoDB;

CREATE TABLE menu (
  id_menu INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(120) NOT NULL,
  prix DECIMAL(6,2) NOT NULL,
  CONSTRAINT pk_menu PRIMARY KEY (id_menu),
  CONSTRAINT uq_menu_nom UNIQUE (nom),
  CONSTRAINT ck_menu_prix CHECK (prix >= 0)
) ENGINE=InnoDB;

-- Association focaccia <-> ingredient (avec quantité)
CREATE TABLE focaccia_ingredient (
  id_focaccia INT NOT NULL,
  id_ingredient INT NOT NULL,
  quantite INT NOT NULL,
  CONSTRAINT pk_focaccia_ingredient PRIMARY KEY (id_focaccia, id_ingredient),
  CONSTRAINT fk_fi_focaccia FOREIGN KEY (id_focaccia)
    REFERENCES focaccia(id_focaccia)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_fi_ingredient FOREIGN KEY (id_ingredient)
    REFERENCES ingredient(id_ingredient)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT ck_fi_quantite CHECK (quantite > 0)
) ENGINE=InnoDB;

-- Menu "est constitué" de focaccia (un menu peut contenir plusieurs focaccia)
CREATE TABLE menu_focaccia (
  id_menu INT NOT NULL,
  id_focaccia INT NOT NULL,
  CONSTRAINT pk_menu_focaccia PRIMARY KEY (id_menu, id_focaccia),
  CONSTRAINT fk_mf_menu FOREIGN KEY (id_menu)
    REFERENCES menu(id_menu)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_mf_focaccia FOREIGN KEY (id_focaccia)
    REFERENCES focaccia(id_focaccia)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Menu "contient" des boissons
CREATE TABLE menu_boisson (
  id_menu INT NOT NULL,
  id_boisson INT NOT NULL,
  CONSTRAINT pk_menu_boisson PRIMARY KEY (id_menu, id_boisson),
  CONSTRAINT fk_mb_menu FOREIGN KEY (id_menu)
    REFERENCES menu(id_menu)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_mb_boisson FOREIGN KEY (id_boisson)
    REFERENCES boisson(id_boisson)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Achat : un client achète un menu à une date
CREATE TABLE achat (
  id_achat INT NOT NULL AUTO_INCREMENT,
  id_client INT NOT NULL,
  id_menu INT NOT NULL,
  date_achat DATETIME NOT NULL,
  CONSTRAINT pk_achat PRIMARY KEY (id_achat),
  CONSTRAINT fk_achat_client FOREIGN KEY (id_client)
    REFERENCES client(id_client)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_achat_menu FOREIGN KEY (id_menu)
    REFERENCES menu(id_menu)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;
