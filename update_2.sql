-- Update 2: Zeitfenster für Trainingseinheiten. Einmal im SQL Editor ausführen.
alter table plan add column if not exists slot text;
