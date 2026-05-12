#!/bin/bash
# سكريبت نسخ احتياطي بسيط
SOURCE="/home/user/documents"
DEST="/tmp/backup-$(date +%Y%m%d).tar.gz"

echo "Démarrez la sauvegarde"
tar -czf "$DEST" "$SOURCE" 2>/dev/null || echo "erreur de vérification du dossier:  $SOURCE"
echo " La sauvegarde est terminée.: $DEST"
