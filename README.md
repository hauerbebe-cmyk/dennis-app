# 🏃 Dennis-App

Persönliche Fitness-App: Halbmarathon-Plan (21KÖLN, 9.5.2027), Gewicht, Kalorien, Erholung aus Garmin und Termine aus Google-Kalender/TimeTree. Läuft als Web-App auf dem Homescreen.

## Einrichtung

### 1. Datenbank (Supabase)
1. Supabase → Projekt `dennis-app` → links **SQL Editor** → Inhalt von `schema.sql` reinkopieren → **Run**.
2. **Authentication → Users → Add user → Create new user**: E-Mail + Passwort, Haken bei *Auto Confirm User*.
3. **Authentication → Sign In / Providers**: *Allow new users to sign up* **ausschalten**.

### 2. App veröffentlichen (GitHub Pages)
Repo **Settings → Pages** → Branch `main`, Ordner `/ (root)` → Save. Nach 1–2 Min. läuft die App unter `https://hauerbebe-cmyk.github.io/dennis-app/`.

### 3. Aufs iPhone
Link in **Safari** öffnen → Teilen → **Zum Home-Bildschirm** → einloggen.

## Woher die Daten kommen
- Garmin, Termine und Trainingsplan schreibt die GitHub Action im privaten Repo `garmin-dashboard` mehrmals täglich in die Datenbank.
- Claude schreibt jeden Vormittag die Coach-Notiz und passt Trainingstage an Termine an.
- Essen, Gewicht und „erledigt“-Haken trägst du in der App ein.

## Gut zu wissen
- Der Key in `config.js` darf öffentlich sein: Ohne Login sieht man nichts.
- Produktdaten für Barcode und Suche kommen von Open Food Facts.
- Kostenloses Supabase-Projekt pausiert nach ~1 Woche ohne Nutzung – bei täglicher Nutzung kein Thema.
