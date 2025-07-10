# 🚀 Guide d'Installation - Système de Monitoring n8n

## 📋 Prérequis
- Instance n8n fonctionnelle
- Compte Supabase ou Google Sheets
- Compte Slack ou Discord (pour les alertes)
- Accès aux APIs nécessaires

## 🔧 Configuration Étape par Étape

### 1. Configuration Supabase

#### A. Créer le projet Supabase
1. Allez sur [supabase.com](https://supabase.com)
2. Créez un nouveau projet
3. Notez votre **URL du projet** et **clé API anon**

#### B. Créer les tables
1. Allez dans l'onglet "SQL Editor"
2. Copiez-collez le script SQL du schéma fourni
3. Exécutez le script pour créer toutes les tables

### 2. Configuration Google Sheets (Alternative)

#### A. Créer le Google Sheet
1. Créez un nouveau Google Sheet
2. Créez les 5 feuilles selon la structure fournie :
    - URLs
    - Logs
    - Daily_KPIs
    - URL_KPIs
    - Weekly_Reports

#### B. Remplir la feuille URLs
```
https://httpstat.us/200    | Test OK        | Test     | true  | 30
https://httpstat.us/500    | Test Erreur    | Test     | true  | 30
https://www.google.com     | Google         | External | true  | 15
```

#### C. Partager le Google Sheet
1. Cliquez sur "Partager"
2. Ajoutez l'email du compte Google connecté à n8n
3. Donnez les permissions "Éditeur"
4. Copiez l'ID du Sheet (depuis l'URL)

### 3. Configuration n8n

#### A. Connexions requises
1. **Google Sheets** (si utilisé)
    - Allez dans "Credentials"
    - Ajoutez "Google Sheets OAuth2 API"
    - Autorisez l'accès à vos sheets

2. **Slack** (pour les alertes)
    - Créez une app Slack
    - Générez un Bot Token
    - Ajoutez les permissions : `chat:write`, `channels:read`
    - Ajoutez le credential "Slack OAuth2 API"

3. **Supabase** (si utilisé)
    - Pas de credential spécifique nécessaire
    - Utilisez les HTTP Request avec headers

#### B. Importer les workflows
1. Copiez le JSON du workflow principal
2. Dans n8n, cliquez sur "+" puis "Import from URL or file"
3. Collez le JSON
4. Répétez pour les workflows KPIs et rapport hebdomadaire

### 4. Personnalisation des Workflows

#### A. Remplacer les variables
Dans chaque workflow, remplacez :
- `YOUR_GOOGLE_SHEET_ID` par l'ID de votre Google Sheet
- `YOUR_SUPABASE_URL` par l'URL de votre projet Supabase
- `YOUR_SUPABASE_ANON_KEY` par votre clé API Supabase

#### B. Configuration des canaux Slack
- Remplacez `monitoring-alerts` par votre canal d'alertes
- Remplacez `monitoring-reports` par votre canal de rapports

### 5. Test et Activation

#### A. Test du workflow principal
1. Ouvrez le workflow "Website Monitoring - Principal"
2. Cliquez sur "Execute Workflow" pour tester
3. Vérifiez que les données apparaissent dans Supabase ou Google Sheets

#### B. Test des alertes
1. Ajoutez une URL qui retourne une erreur (ex: `https://httpstat.us/500`)
2. Exécutez le workflow
3. Vérifiez que l'alerte arrive sur Slack

#### C. Activation des workflows
1. Activez les 3 workflows :
    - Monitoring principal (toutes les 5 minutes)
    - KPIs quotidiens (tous les jours à 00:00)
    - Rapport hebdomadaire (lundi à 9h00)

## 📊 Configuration Dashboard (Optionnel)

### Metabase
1. Connectez Metabase à votre base Supabase
2. Créez un dashboard avec :
    - Graphique de disponibilité par URL
    - Temps de réponse moyen
    - Nombre d'incidents par jour
    - Heatmap des pannes par heure

### Google Data Studio
1. Connectez Data Studio à votre Google Sheet
2. Créez des graphiques similaires
3. Configurez la mise à jour automatique

## 🔍 Monitoring et Maintenance

### Surveillance des Workflows
- Vérifiez régulièrement les logs d'exécution dans n8n
- Surveillez les erreurs de connexion aux APIs
- Vérifiez que les données sont bien stockées

### Nettoyage des Données
- Les logs sont automatiquement nettoyés après 90 jours (si fonction activée)
- Les KPIs sont gardés 365 jours
- Ajustez selon vos besoins de rétention

### Optimisation
- Ajustez la fréquence de monitoring selon vos besoins
- Optimisez les timeouts des requêtes HTTP
- Surveillez la consommation des quotas API

## 🚨 Dépannage

### Erreurs Communes
1. **Erreur Google Sheets** : Vérifiez les permissions de partage
2. **Erreur Supabase** : Vérifiez l'URL et la clé API
3. **Erreur Slack** : Vérifiez le token et les permissions du bot
4. **Timeout HTTP** : Ajustez les timeouts selon vos sites

### Logs Utiles
- Logs d'exécution n8n
- Logs des requêtes HTTP
- Logs Supabase (onglet Logs)
- Historique Google Sheets

## 📧 Support
Pour toute question ou problème :
1. Vérifiez les logs d'erreur
2. Consultez la documentation n8n
3. Testez les connexions individuellement
4. Vérifiez les permissions des APIs utilisées