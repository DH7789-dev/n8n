# Structure Google Sheets pour le Monitoring

## 📋 Feuille 1 : "URLs"
Cette feuille contient la liste des URLs à monitorer.

### Structure des colonnes :
| Colonne | Nom | Type | Description | Exemple |
|---------|-----|------|-------------|---------|
| A | url | URL | URL complète à tester | https://api.example.com/health |
| B | name | Texte | Nom explicite du service | API Principal |
| C | category | Texte | Catégorie du service | Production |
| D | active | Booléen | Activer/Désactiver le monitoring | true |
| E | timeout | Nombre | Timeout en secondes (optionnel) | 30 |

### Exemple de contenu :
```
url                                    | name              | category    | active | timeout
https://api.example.com/health        | API Principal     | Production  | true   | 30
https://www.example.com               | Site Web          | Production  | true   | 15
https://blog.example.com              | Blog              | Marketing   | true   | 20
https://staging.example.com           | Environnement Test| Staging     | false  | 10
```

## 📊 Feuille 2 : "Logs"
Cette feuille stocke les logs d'incidents (sites en panne uniquement).

### Structure des colonnes :
| Colonne | Nom | Type | Description |
|---------|-----|------|-------------|
| A | id | Texte | ID unique du log |
| B | url | URL | URL testée |
| C | name | Texte | Nom du service |
| D | category | Texte | Catégorie |
| E | status | Texte | Status (UP/DOWN) |
| F | status_code | Nombre | Code HTTP |
| G | response_time | Nombre | Temps de réponse (ms) |
| H | error_message | Texte | Message d'erreur |
| I | timestamp | Date/Heure | Date/heure du check |
| J | check_date | Date | Date du jour |

## 📈 Feuille 3 : "Daily_KPIs"
Cette feuille stocke les KPIs quotidiens globaux.

### Structure des colonnes :
| Colonne | Nom | Type | Description |
|---------|-----|------|-------------|
| A | date | Date | Date du rapport |
| B | total_checks | Nombre | Nombre total de vérifications |
| C | total_downtime | Nombre | Nombre total de pannes |
| D | global_uptime_percentage | Nombre | Pourcentage uptime global |
| E | global_avg_response_time | Nombre | Temps de réponse moyen |
| F | worst_url | Texte | Pire URL du jour (JSON) |
| G | unique_urls_monitored | Nombre | Nombre d'URLs monitorées |
| H | timestamp | Date/Heure | Date/heure de génération |

## 🎯 Feuille 4 : "URL_KPIs"
Cette feuille stocke les KPIs par URL.

### Structure des colonnes :
| Colonne | Nom | Type | Description |
|---------|-----|------|-------------|
| A | url | URL | URL monitorée |
| B | name | Texte | Nom du service |
| C | category | Texte | Catégorie |
| D | date | Date | Date du rapport |
| E | total_checks | Nombre | Nombre de vérifications |
| F | downtime_count | Nombre | Nombre de pannes |
| G | uptime_percentage | Nombre | Pourcentage uptime |
| H | avg_response_time | Nombre | Temps de réponse moyen |
| I | timestamp | Date/Heure | Date/heure de génération |

## 📅 Feuille 5 : "Weekly_Reports"
Cette feuille stocke les rapports hebdomadaires.

### Structure des colonnes :
| Colonne | Nom | Type | Description |
|---------|-----|------|-------------|
| A | period | Texte | Période du rapport |
| B | total_checks | Nombre | Nombre total de vérifications |
| C | avg_uptime | Nombre | Uptime moyen |
| D | avg_response_time | Nombre | Temps de réponse moyen |
| E | total_incidents | Nombre | Nombre total d'incidents |
| F | worst_day | Date | Pire jour de la semaine |
| G | problematic_urls | Nombre | Nombre d'URLs problématiques |
| H | timestamp | Date/Heure | Date/heure de génération |

## 🔧 Configuration des Permissions
1. Partager la feuille avec le compte Google utilisé dans n8n
2. Donner les permissions "Éditeur" pour permettre l'écriture
3. Copier l'ID du Google Sheet (visible dans l'URL)

## 💡 Conseils d'utilisation
- Utilisez des formats de validation de données pour les colonnes booléennes
- Ajoutez des graphiques sur une feuille séparée pour visualiser les tendances
- Activez l'historique des versions pour suivre les modifications
- Créez des alertes Google Sheets pour être notifié des changements importants