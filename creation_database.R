library(readxl)
library(dplyr)
library(openxlsx)


###########################################
# création de la base de données générale #
###########################################
dossiers <- list.files(path = "images")
corpus <- data.frame()
# boucle qui lit toutes les bases de données réparties dans les classeurs excels disséminés dans le corpus
# et les empile dans une unique base de données unique. 
for (i in dossiers){
  # i <- "1685_1697_Gravier_d'Ortieres_1"
  print(i)
  # création du chemin d'accès à chaque sous dossier.
  chemin_sous_dossiers <- paste0(chemin_corpus,"/images","/",i)
  print(chemin_sous_dossiers)
  # lecture et concaténation du fichier contenant les métadonnées
  fichier_metadata <- Sys.glob(paste0(chemin_sous_dossiers,"/*.xlsx"))
  if (identical(fichier_metadata, character(0))) next
    corpus_temp <- read_xlsx(fichier_metadata[1],skip = 1)
    # pour chaque fichier de métadonnées, ajout d'une colonne avec le chemin d'accès
    corpus_temp$path <- chemin_sous_dossiers
    corpus <- rbind(corpus,corpus_temp)
}

# sauvegarde de la base de données au format excel
write.xlsx(corpus, "corpus.xlsx",colWidths="auto", asTable = FALSE,sheetName = "Ensemble")

#############################################
# nettoyage de la base de données générale. #
#############################################

# certains caractères particuliers sont mal compris par le comilateur latex. Pour l'instant il s'agit de certaines espaces et des guillemets;
# cette fonction permet de les remplacer par des caractères mieux connus.
remplaceur <- function(X){
  X <- gsub("» »",'»',X) # remplacement da la guillemet fermante par la balise latex correspondante
  X <- gsub("«",'\\\\enquote{',X) # remplacement de la guillemet ouvrante par la balise Latex permettant d'ouvrir des guillements
  X <- gsub("»",'}',X) # remplacement da la guillemet fermante par la balise latex correspondante
  X <- gsub("[[:space:]]"," ",X) #remplacement de toutes les types d'espaces par une espace standard, que Latex sait reconnaître.
  X <- gsub("  "," ",X) # suppression des doubles espaces.
  X <- gsub("n°","\\\\no{}",X) # suppression des doubles espaces.
  X <- gsub("N°","\\\\No{}",X) # suppression des doubles espaces.
  # X <- gsub(NA,"",X) # suppression des doubles espaces.
  
  return(X)
}
corpus <- corpus %>% mutate_all(funs('remplaceur'))

# pour que la table soit plus facile à manipuler en R, 
# on retire les colonnes vides et on renomme les colonnes avec des noms plus courts
corpus_data <- corpus %>% select(-starts_with("X_"))
names(corpus_data) <- c("chronologie","voyageur","recueil","lieu_edition","editeur","annee_edition","volume_cm","num_volume","nb_page","N_contenant_N","source","nb_retenu","nom_image","identifiant_corpus","titre","description","support","technique","dim","dimension_feuillet","unite_feuillet","dimension_cadre","unite_cadre","commentaire_general","auteur","date","sous_cote","photographe","region","toponyme_contemporain","toponyme_moderne","toponyme_antique","monument","type","sous_type","path")

##########################################################
# sauvegarde de la base de données sur le disque#
##########################################################
# save.image(corpus_data,file = "output/data/corpus.RData")


