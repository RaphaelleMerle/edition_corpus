library(readxl)
library(dplyr)


###########################################
# création de la base de données générale #
###########################################
dossiers <- list.files(path = "images")
metadonnees_corpus <- data.frame()
# boucle qui lit toutes les bases de données réparties dans les classeurs excels disséminés dans le corpus
# et les empile dans une unique base de données unique. 
for (i in dossiers){
  # i <- "1719_Lucas_t3"
  print(i)
  # création du chemin d'accès à chaque sous dossier.
  chemin_sous_dossiers <- paste0(chemin_corpus,"/images","/",i)
  print(chemin_sous_dossiers)
  # lecture et concaténation du fichier contenant les métadonnées
  fichier_metadata <- Sys.glob(paste0(chemin_sous_dossiers,"/*.xlsx"))
  if (identical(fichier_metadata, character(0))) next
    metadonnees_corpus_temp <- read_xlsx(fichier_metadata,skip = 1)
    # pour chaque fichier de métadonnées, ajout d'une colonne avec le chemin d'accès
    metadonnees_corpus_temp$path <- chemin_sous_dossiers
    metadonnees_corpus <- rbind(metadonnees_corpus,metadonnees_corpus_temp)
}

#############################################
# nettoyage de la base de données générale. #
#############################################
# on retire les colonnes vides et on renomme les colonnes avec des noms plus courts
metadonnees_corpus <- metadonnees_corpus %>% select(-starts_with("X_"))
names(metadonnees_corpus) <- c("chronologie","voyageur","recueil","lieu_edition","editeur","annee_edition","volume_cm","num_volume","nb_page","N_contenant_N","source","nb_retenu","nom_image","identifiant_corpus","titre","description","support","technique","dim","dimension_feuillet","unite_feuillet","dimension_cadre","unite_cadre","commentaire_general","auteur","date","sous_cote","photographe","region","toponyme_contemporain","toponyme_moderne","toponyme antique","monument","type","sous_type","path")

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
metadonnees_corpus <- metadonnees_corpus %>% mutate_all(funs('remplaceur'))

##########################################################
# sauvegarde de la base de données sur le disque#
##########################################################
# save.image(metadonnees_corpus,file = "metadonnees_corpus.RData")
