FROM n8nio/n8n:latest

# Crée un répertoire pour les données n8n
ENV N8N_USER_FOLDER=/home/node/.n8n

# Copie tes fichiers de workflow/credentials/env si besoin
COPY workflows /home/node/.n8n/workflows
COPY .env /home/node/.n8n/

# Définir l'utilisateur node
USER node
