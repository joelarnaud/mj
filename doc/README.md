Description
===========

Documentation qui décrit l'infrastructure et son utilisation

Utilisation
-----------

Cette documentation est construite à chaque modification du
dépot. Elle utilise la solution [Sphinx](http://www.sphinx-doc.org).

Sphinx utilise la syntaxe reStructuredText. Une référence rapide
à cette syntaxe est disponible [ici](https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html). 

Instructions pour constuction locale (testing)
---------------------------------------------
    Linux

    * Avoir pip et python3 d'installer
    * pip install -U sphinx
    * pip install sphinx_rtd_theme
    * make html

    Le contenu généré sera dans le dossier _build/html    


Gestion des diagrammes draw.io
------------------------------

Pour modifier un digramme en png généré à partir de draw.io,
il faut ouvrir son fichier source (présent dans le même répertoire que l'image) à partir du site [draw.io](https://draw.io).