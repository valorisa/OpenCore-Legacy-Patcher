#!/bin/bash

# 1. Vérification de l'activation du venv
if [ -z "\$VIRTUAL_ENV" ]; then
  echo "Erreur : Veuillez d'abord activer votre environnement virtuel (venv) avant de lancer ce script."
  exit 1
fi

# 2. Correction du fichier .spec pour cibler x86_64
echo "Modification de OpenCore-Patcher-GUI.spec..."
sed -i.bak 's/target_arch="universal2"/target_arch="x86_64"/g' OpenCore-Patcher-GUI.spec

# 3. Réinstallation du module problématique en x86_64
echo "Recompilation de charset-normalizer pour x86_64..."
arch -x86_64 pip install --force-reinstall --no-binary :all: charset-normalizer

# 4. Vérification de l'architecture des binaires natifs
echo "Vérification de l'architecture de charset_normalizer..."
find \$VIRTUAL_ENV/lib/python*/site-packages/charset_normalizer -name "*.so" -exec file {} \; | grep "x86_64"

# 5. Lancement de la compilation
echo "Lancement de la compilation..."
chmod +x Build-Project.command
./Build-Project.command 2>&1 | tee build.log

