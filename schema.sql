-- Dennis-App: komplett in den Supabase SQL Editor kopieren und auf "Run" tippen.

-- Tageswerte aus Garmin (kommen jeden Morgen automatisch)
create table garmin_daily (
  date date primary key,
  data jsonb not null,
  updated_at timestamptz default now()
);

-- Aktivitäten aus Garmin
create table garmin_activities (
  id text primary key,
  date date not null,
  data jsonb not null,
  updated_at timestamptz default now()
);

-- Gewicht und Bauchumfang (aus der App oder aus Garmin)
create table weights (
  date date primary key,
  kg numeric(5,1),
  waist_cm numeric(5,1),
  source text default 'app',
  updated_at timestamptz default now()
);

-- Essen
create table foods (
  id uuid primary key default gen_random_uuid(),
  day date not null default current_date,
  meal text,                      -- Frühstück, Mittag, Abend, Snack, Getränk
  name text not null,
  kcal int not null,
  protein numeric(5,1) default 0,
  grams numeric(6,1),
  barcode text,
  is_beer boolean default false,
  created_at timestamptz default now()
);
create index on foods(day);

-- Favoriten fürs schnelle Eintragen
create table favorites (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  meal text,
  kcal int not null,
  protein numeric(5,1) default 0,
  is_beer boolean default false,
  sort int default 100,
  created_at timestamptz default now()
);

-- Trainingsplan (wird automatisch erzeugt, Claude passt ihn an Termine an)
create table plan (
  date date primary key,
  week int,
  phase text,
  kind text,                      -- kraft_a, kraft_b, run_quality, run_easy, long, rest, free, race, walk
  title text,
  details text,
  km numeric(4,1),
  moved_note text,                -- falls die Einheit wegen eines Termins verschoben wurde
  slot text,                      -- vorgeschlagenes Zeitfenster, z. B. 17:30–18:15
  done boolean default false,
  done_at timestamptz,
  updated_at timestamptz default now()
);

-- Termine aus Google-Kalender und TimeTree
create table events (
  uid text primary key,
  source text,
  title text,
  starts_at timestamptz,
  ends_at timestamptz,
  all_day boolean default false,
  updated_at timestamptz default now()
);
create index on events(starts_at);

-- Tägliche Coach-Notiz von Claude
create table coach (
  date date primary key,
  ampel text,                     -- gruen, gelb, rot
  headline text,
  message text,
  today text,
  insights jsonb,
  updated_at timestamptz default now()
);

-- Nur eingeloggte Nutzer (also nur du) dürfen lesen und schreiben
do $$
declare t text;
begin
  foreach t in array array['garmin_daily','garmin_activities','weights','foods','favorites','plan','events','coach'] loop
    execute format('alter table %I enable row level security', t);
    execute format('create policy "nur ich" on %I for all to authenticated using (true) with check (true)', t);
  end loop;
end $$;

-- Startwert
insert into weights(date, kg, source) values ('2026-11-05', 95.0, 'start');


-- Öffentlicher Speicher nur für das Trainingsplan-Kalender-Abo (enthält nur den Plan, keine Gesundheitsdaten)
insert into storage.buckets (id, name, public) values ('kalender', 'kalender', true)
on conflict (id) do nothing;
