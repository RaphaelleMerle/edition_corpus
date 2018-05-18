
# Création du code latex permettant de charger les images et d'écrire les didascalies.
pour_latex <- metadonnees_utiles %>%
  transmute(
    path = gsub(chemin_corpus,"../..",path),
    chemin_image =paste0(path,"/",nom_image,".png"),
    identifiant_corpus = gsub("_","-",identifiant_corpus),
    
    reference = paste0("\\textbf{",identifiant_corpus,"} : "),
    titre = ifelse(titre=="","",paste0("\\textit{",titre,"}")),
    didascalie = paste(" ",description,support,"Dimension (H x L) :",dimension_feuillet,unite_feuillet,commentaire_general,auteur),
    fin_didascalie = paste(sous_cote,"\\\\",photographe))
  # hauteur_source = read_exif(chemin_image)$ImageHeight,
  # largeur_source = read_exif(chemin_image)$ImageHeight,
  # hauteur_latex = ifelse((hauteur_source/largeur_source > 1), h_max,l_max*hauteur_source/largeur_source),
  # largeur_latex = ifelse((lergeur_source/hauteur_source > 1), l_max,h_max*largeur_source/hauteur_source)) %>%
  
  
  # ultime étape qui écrit le code latex dans une table qui ne contient qu'une seule colonne
  code_latex <- pour_latex %>%
  transmute(
    res = paste0("\\newpage
                  \\clearpage
                 \\begin{figure}
                 \\center 
                 \\includegraphics[width=15cm,height=20cm,keepaspectratio]{",
                 chemin_image,
                 "}
                 \\caption{",
                 reference,
                 titre,
                 didascalie,
                 "\\\\",
                 fin_didascalie,
                 "}
                 \\end{figure}"))

write.table(code_latex[,"res"],"output/latex/corpus.tex",sep = "\n",row.names = FALSE,col.names = FALSE,quote = FALSE,fileEncoding = "UTF-8")


