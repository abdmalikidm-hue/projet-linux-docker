#!/bin/bash
# =============================================
# Script de Sauvegarde Automatique (Projet LIU-2026)
# Usage : ./backup.sh /chemin/du/dossier
# =============================================

# Vérifier si l'utilisateur a donné un dossier
if [ -z "$1" ]; then
    echo "Erreur : Veuillez spécifier le dossier à sauvegarder."
    echo "Usage : $0 /chemin/du/dossier"
    exit 1
fi

SOURCE="$1"
DEST_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE="$DEST_DIR/sauvegarde_$DATE.tar.gz"

# Vérifier que le dossier source existe
if [ ! -d "$SOURCE" ]; then
    echo "Erreur : Le dossier '$SOURCE' n'existe pas."
    exit 1
fi

# Créer le dossier de destination si nécessaire
mkdir -p "$DEST_DIR"

echo "Sauvegarde de '$SOURCE' vers '$ARCHIVE'..."
tar -czf "$ARCHIVE" "$SOURCE"

if [ $? -eq 0 ]; then
    echo "✅ Sauvegarde réussie !"
else
    echo "❌ Échec de la sauvegarde."
    exit 1
fi

# Nettoyage : garder seulement les 3 dernières sauvegardes
cd "$DEST_DIR"
ls -t sauvegarde_*.tar.gz | tail -n +4 | xargs -r rm
echo "Rotation effectuée (3 dernières conservées)."
