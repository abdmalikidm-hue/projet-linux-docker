#!/bin/bash
# =============================================
# Script de Monitoring Système (Projet LIU-2026)
# Auteur : TonNom
# Description : Génère un rapport matériel complet
# =============================================

# Définir le fichier de log
LOG_FILE="system_report.log"

# Fonction pour écrire à la fois sur l'écran et dans le log
ecrire() {
    echo "$1" | tee -a "$LOG_FILE"
}

# Séparateur visuel
ecrire "============================================="
ecrire "RAPPORT SYSTÈME - $(date '+%d/%m/%Y %H:%M:%S')"
ecrire "============================================="

# 1. Informations CPU
ecrire ""
ecrire ">> CHARGE CPU :"
uptime | tee -a "$LOG_FILE"

# 2. Informations Mémoire
ecrire ""
ecrire ">> MÉMOIRE VIVE (RAM) :"
free -h | tee -a "$LOG_FILE"

# 3. Informations Disque
ecrire ""
ecrire ">> ESPACE DISQUE :"
df -h / | tee -a "$LOG_FILE"

# 4. Informations Réseau
ecrire ""
ecrire ">> ADRESSE IP :"
hostname -I | tee -a "$LOG_FILE"

ecrire ""
ecrire "============================================="
ecrire "FIN DU RAPPORT"
ecrire "============================================="
