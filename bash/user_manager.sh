#!/bin/bash
# =============================================
# Script de Gestion des Utilisateurs (Projet LIU-2026)
# Usage : ./user_manager.sh nom_utilisateur
# =============================================

LOG_FILE="user_actions.log"
PASSWORD_DEFAULT="LIU@2026"

# Fonction pour écrire dans le log
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 1. Vérifier si l'utilisateur a fourni un nom
if [ -z "$1" ]; then
    echo "Usage : $0 nom_utilisateur"
    exit 1
fi

USERNAME="$1"

# 2. Vérifier si l'utilisateur existe déjà
if id "$USERNAME" &>/dev/null; then
    echo "L'utilisateur '$USERNAME' existe déjà."
    log_action "Tentative échouée : l'utilisateur $USERNAME existe déjà."
    exit 1
fi

# 3. Créer l'utilisateur avec son dossier home
sudo useradd -m -s /bin/bash "$USERNAME"
if [ $? -ne 0 ]; then
    echo "Erreur lors de la création de l'utilisateur."
    log_action "Erreur création utilisateur $USERNAME."
    exit 1
fi

# 4. Définir un mot de passe par défaut
echo "$USERNAME:$PASSWORD_DEFAULT" | sudo chpasswd
if [ $? -eq 0 ]; then
    echo "Utilisateur '$USERNAME' créé avec succès."
    echo "Mot de passe par défaut : $PASSWORD_DEFAULT"
    log_action "Utilisateur $USERNAME créé avec mot de passe par défaut."
else
    echo "Utilisateur créé mais échec de l'attribution du mot de passe."
    log_action "Échec mot de passe pour $USERNAME."
    exit 1
fi

# 5. Forcer le changement de mot de passe à la première connexion (optionnel)
sudo chage -d 0 "$USERNAME"
echo "Le mot de passe devra être changé à la première connexion."
log_action "Expiration immédiate du mot de passe pour $USERNAME."
