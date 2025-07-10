-- Schéma de base de données Supabase pour le monitoring

-- Table principale des logs de monitoring
CREATE TABLE monitoring_logs (
                                 id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
                                 url TEXT NOT NULL,
                                 name TEXT NOT NULL,
                                 category TEXT DEFAULT 'General',
                                 status TEXT NOT NULL CHECK (status IN ('UP', 'DOWN')),
                                 status_code INTEGER,
                                 response_time INTEGER, -- en millisecondes
                                 error_message TEXT,
                                 timestamp TIMESTAMPTZ DEFAULT NOW(),
                                 check_date DATE DEFAULT CURRENT_DATE,
                                 created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour optimiser les requêtes
CREATE INDEX idx_monitoring_logs_url ON monitoring_logs(url);
CREATE INDEX idx_monitoring_logs_check_date ON monitoring_logs(check_date);
CREATE INDEX idx_monitoring_logs_status ON monitoring_logs(status);
CREATE INDEX idx_monitoring_logs_timestamp ON monitoring_logs(timestamp);

-- Table des KPIs quotidiens globaux
CREATE TABLE daily_kpis (
                            id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
                            date DATE NOT NULL UNIQUE,
                            total_checks INTEGER NOT NULL DEFAULT 0,
                            total_downtime INTEGER NOT NULL DEFAULT 0,
                            global_uptime_percentage DECIMAL(5,2) NOT NULL DEFAULT 0,
                            global_avg_response_time INTEGER NOT NULL DEFAULT 0,
                            worst_url JSONB, -- Stockage du pire URL du jour
                            unique_urls_monitored INTEGER NOT NULL DEFAULT 0,
                            timestamp TIMESTAMPTZ DEFAULT NOW(),
                            created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour les KPIs quotidiens
CREATE INDEX idx_daily_kpis_date ON daily_kpis(date);

-- Table des KPIs par URL
CREATE TABLE url_kpis (
                          id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
                          url TEXT NOT NULL,
                          name TEXT NOT NULL,
                          category TEXT DEFAULT 'General',
                          date DATE NOT NULL,
                          total_checks INTEGER NOT NULL DEFAULT 0,
                          downtime_count INTEGER NOT NULL DEFAULT 0,
                          uptime_percentage DECIMAL(5,2) NOT NULL DEFAULT 0,
                          avg_response_time INTEGER NOT NULL DEFAULT 0,
                          timestamp TIMESTAMPTZ DEFAULT NOW(),
                          created_at TIMESTAMPTZ DEFAULT NOW(),
                          UNIQUE(url, date)
);

-- Index pour les KPIs par URL
CREATE INDEX idx_url_kpis_url ON url_kpis(url);
CREATE INDEX idx_url_kpis_date ON url_kpis(date);
CREATE INDEX idx_url_kpis_url_date ON url_kpis(url, date);

-- Table des rapports hebdomadaires
CREATE TABLE weekly_reports (
                                id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
                                period TEXT NOT NULL, -- Format: "2024-01-01 to 2024-01-07"
                                total_checks INTEGER NOT NULL DEFAULT 0,
                                avg_uptime DECIMAL(5,2) NOT NULL DEFAULT 0,
                                avg_response_time INTEGER NOT NULL DEFAULT 0,
                                total_incidents INTEGER NOT NULL DEFAULT 0,
                                worst_day DATE,
                                problematic_urls INTEGER NOT NULL DEFAULT 0,
                                timestamp TIMESTAMPTZ DEFAULT NOW(),
                                created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour les rapports hebdomadaires
CREATE INDEX idx_weekly_reports_period ON weekly_reports(period);

-- Vues pour faciliter les requêtes analytiques

-- Vue pour les statistiques en temps réel
CREATE VIEW current_status AS
SELECT
    url,
    name,
    category,
    status,
    status_code,
    response_time,
    error_message,
        timestamp,
        ROW_NUMBER() OVER (PARTITION BY url ORDER BY timestamp DESC) as rn
        FROM monitoring_logs
        WHERE timestamp >= NOW() - INTERVAL '1 hour';

-- Vue pour les métriques des dernières 24h
CREATE VIEW last_24h_metrics AS
SELECT
    url,
    name,
    category,
    COUNT(*) as total_checks,
    COUNT(CASE WHEN status = 'DOWN' THEN 1 END) as downtime_count,
    ROUND(
            (COUNT(CASE WHEN status = 'UP' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2
    ) as uptime_percentage,
    ROUND(AVG(response_time)::INTEGER) as avg_response_time,
    MAX(timestamp) as last_check
FROM monitoring_logs
WHERE timestamp >= NOW() - INTERVAL '24 hours'
        GROUP BY url, name, category;

-- Vue pour les tendances hebdomadaires
CREATE VIEW weekly_trends AS
SELECT
    url,
    name,
    date_trunc('week', check_date) as week,
    COUNT(*) as total_checks,
    COUNT(CASE WHEN status = 'DOWN' THEN 1 END) as downtime_count,
    ROUND(
            (COUNT(CASE WHEN status = 'UP' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2
    ) as uptime_percentage,
    ROUND(AVG(response_time)::INTEGER) as avg_response_time
FROM monitoring_logs
WHERE check_date >= CURRENT_DATE - INTERVAL '4 weeks'
        GROUP BY url, name, date_trunc('week', check_date)
        ORDER BY week DESC, uptime_percentage ASC;

-- Politique de sécurité RLS (Row Level Security)
ALTER TABLE monitoring_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_kpis ENABLE ROW LEVEL SECURITY;
ALTER TABLE url_kpis ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_reports ENABLE ROW LEVEL SECURITY;

-- Politique pour permettre la lecture/écriture avec la clé API
CREATE POLICY "Enable all operations for service role" ON monitoring_logs
    FOR ALL USING (true);

CREATE POLICY "Enable all operations for service role" ON daily_kpis
    FOR ALL USING (true);

CREATE POLICY "Enable all operations for service role" ON url_kpis
    FOR ALL USING (true);

CREATE POLICY "Enable all operations for service role" ON weekly_reports
    FOR ALL USING (true);

-- Fonction pour nettoyer les vieux logs (optionnel)
CREATE OR REPLACE FUNCTION cleanup_old_logs()
RETURNS void AS $$
BEGIN
    -- Garder seulement les 90 derniers jours de logs détaillés
DELETE FROM monitoring_logs
WHERE timestamp < NOW() - INTERVAL '90 days';

-- Garder seulement les 365 derniers jours de KPIs
DELETE FROM daily_kpis
WHERE date < CURRENT_DATE - INTERVAL '365 days';

DELETE FROM url_kpis
WHERE date < CURRENT_DATE - INTERVAL '365 days';
END;
$$ LANGUAGE plpgsql;

-- Créer un trigger pour nettoyer automatiquement (optionnel)
-- SELECT cron.schedule('cleanup-old-logs', '0 2 * * *', 'SELECT cleanup_old_logs();');