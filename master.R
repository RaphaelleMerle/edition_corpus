rm(list = ls())

# Programme permettant d'écrire un programme latex qui édite le corpus de la thèse 
# Le dossier corpus comprend 3 sous dossiers : 
# - 1 dossier images. Ce dossier contient autant de sous dossiers qu'il y a d'ouvrages. 
#   Chaque sous-dossier contient les images associées. 
#   Attention : un dossier correspondant à un ouvrage ne doit pas contenir de sous dossier.
# - 1 dossier code : ce dossier contient ce script ainsi que les autres scripts de code R
# - 1 dossier output : ce dossier contient les résultats, à savoir : 
      # - la base de données consolidée, 
      # - le code latex
      # - le corpus au format PDF

# definition du chemin du dossier corpus
chemin_corpus <- "/Users/Raphaelle/Desktop/CORPUS FINAL"
setwd(chemin_corpus)
#####################################################
# ETAPE 1 : Création de la base de données générale #
#####################################################
# Cette base de données contient les métadonnées de l'ensemble des illustrations du corpus. 

# exécution du script qui compile toutes les bases de données en une seule base de données
source("code/creation_database.R")

####################################
# ETAPE 2 : application de filtres #
####################################
# On restreint ici la base de données à certaines illustrations seulement
# On crée donc une seconde base de données (metadonnees_utiles) qui contient uniquement les metadonnées
# des images retenues en appliquant les filtres
metadonnees_utiles <- metadonnees_corpus %>%
  filter()

#####################################
# ETAPE 3 : ecriture du code Latex. # 
#####################################
source("code/ecriture_latex.R")
