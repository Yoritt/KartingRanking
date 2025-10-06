/*
  # Karting Database Schema

  ## Overzicht
  Dit bestand maakt alle benodigde tabellen aan voor de karting ranking website.

  ## 1. Nieuwe Tabellen
  
  ### `notifications`
  - `id` (uuid, primary key) - Unieke identificatie
  - `message` (text) - Mededeling tekst
  - `active` (boolean) - Of de mededeling zichtbaar is
  - `created_at` (timestamp) - Aanmaakdatum
  
  ### `race_calendar`
  - `id` (uuid, primary key) - Unieke identificatie
  - `date` (date) - Datum van de race
  - `title` (text) - Titel van het evenement
  - `description` (text) - Beschrijving
  - `created_at` (timestamp) - Aanmaakdatum
  
  ### `race_results`
  - `id` (uuid, primary key) - Unieke identificatie
  - `year` (integer) - Jaar van de uitslagen
  - `file_url` (text) - URL naar Excel bestand
  - `created_at` (timestamp) - Aanmaakdatum
  
  ### `year_rankings`
  - `id` (uuid, primary key) - Unieke identificatie
  - `year` (integer) - Jaar van het klassement
  - `ranking_type` (text) - Type: 'fastest_lap' of 'best_average'
  - `position` (integer) - Positie in klassement
  - `driver_name` (text) - Naam van de rijder
  - `value` (text) - Waarde (tijd of gemiddelde)
  - `created_at` (timestamp) - Aanmaakdatum
  
  ### `media`
  - `id` (uuid, primary key) - Unieke identificatie
  - `type` (text) - Type: 'photo' of 'video'
  - `url` (text) - URL naar media bestand
  - `thumbnail_url` (text, optioneel) - Thumbnail voor video's
  - `date` (date) - Datum van de media
  - `description` (text, optioneel) - Beschrijving
  - `created_at` (timestamp) - Aanmaakdatum
  
  ### `rules`
  - `id` (uuid, primary key) - Unieke identificatie
  - `content` (text) - Reglement inhoud (HTML toegestaan)
  - `order_index` (integer) - Volgorde
  - `created_at` (timestamp) - Aanmaakdatum

  ## 2. Beveiliging
  - RLS is ingeschakeld op alle tabellen
  - Publieke read-only toegang voor alle tabellen (geen authenticatie vereist voor lezen)
  - Alleen geauthenticeerde gebruikers kunnen data toevoegen/wijzigen (voor toekomstig admin panel)
*/

-- Notifications tabel voor mededelingsbalk
CREATE TABLE IF NOT EXISTS notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  message text NOT NULL,
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Iedereen kan mededelingen lezen"
  ON notifications FOR SELECT
  TO anon
  USING (active = true);

CREATE POLICY "Authenticated users kunnen mededelingen beheren"
  ON notifications FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Race kalender tabel
CREATE TABLE IF NOT EXISTS race_calendar (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  date date NOT NULL,
  title text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE race_calendar ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Iedereen kan kalender bekijken"
  ON race_calendar FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Authenticated users kunnen kalender beheren"
  ON race_calendar FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Race uitslagen tabel
CREATE TABLE IF NOT EXISTS race_results (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  year integer NOT NULL,
  file_url text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE race_results ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Iedereen kan uitslagen bekijken"
  ON race_results FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Authenticated users kunnen uitslagen beheren"
  ON race_results FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Jaar klassementen tabel
CREATE TABLE IF NOT EXISTS year_rankings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  year integer NOT NULL,
  ranking_type text NOT NULL CHECK (ranking_type IN ('fastest_lap', 'best_average')),
  position integer NOT NULL,
  driver_name text NOT NULL,
  value text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE year_rankings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Iedereen kan klassementen bekijken"
  ON year_rankings FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Authenticated users kunnen klassementen beheren"
  ON year_rankings FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Media tabel
CREATE TABLE IF NOT EXISTS media (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type text NOT NULL CHECK (type IN ('photo', 'video')),
  url text NOT NULL,
  thumbnail_url text,
  date date NOT NULL,
  description text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE media ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Iedereen kan media bekijken"
  ON media FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Authenticated users kunnen media beheren"
  ON media FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Reglement tabel
CREATE TABLE IF NOT EXISTS rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content text NOT NULL,
  order_index integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE rules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Iedereen kan reglement bekijken"
  ON rules FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Authenticated users kunnen reglement beheren"
  ON rules FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Indexes voor betere performance
CREATE INDEX IF NOT EXISTS idx_notifications_active ON notifications(active);
CREATE INDEX IF NOT EXISTS idx_race_calendar_date ON race_calendar(date);
CREATE INDEX IF NOT EXISTS idx_race_results_year ON race_results(year);
CREATE INDEX IF NOT EXISTS idx_year_rankings_year ON year_rankings(year);
CREATE INDEX IF NOT EXISTS idx_media_date ON media(date);
CREATE INDEX IF NOT EXISTS idx_rules_order ON rules(order_index);
