#!/bin/bash

echo "===== Rapport système - $(date) ====="
echo ""

echo "📦 Utilisation disque :"
df -h /
echo ""

echo "🧠 Mémoire :"
free -h
echo ""

echo "⚙️ Processus les plus gourmands en CPU :"
ps -eo pid,comm,%cpu --sort=-%cpu | head -6
