library(tidyverse)
library(FactoMineR)
library(factoextra)
library(gt)

filter(data, AffiliationTypeLabel=="Hauptantragssteller" | AffiliationTypeLabel=="Mitantragsteller") |>
  count(KonsortiumLabel, BundeslandLabel) |>
  group_by(KonsortiumLabel) |>
  pivot_wider(
    names_from = KonsortiumLabel,
    values_from = n,
    values_fill = 0
  ) |>
  mutate(BundeslandLabel = ifelse(is.na(BundeslandLabel), 'Unbekannt', BundeslandLabel)) |>
  column_to_rownames(var='BundeslandLabel') |>
  CA() |>
  fviz_ca(title = 'Co-Apps nach Ländern', repel = TRUE)

filter(data, AffiliationTypeLabel=="Hauptantragssteller" | AffiliationTypeLabel=="Mitantragsteller") |>
  count(KonsortiumLabel, BundeslandLabel) |>
  group_by(KonsortiumLabel) |>
  pivot_wider(
    names_from = KonsortiumLabel,
    values_from = n,
    values_fill = 0
  ) |>
  mutate(BundeslandLabel = ifelse(is.na(BundeslandLabel), 'Unbekannt', BundeslandLabel)) |>
  column_to_rownames(var='BundeslandLabel') |>
  CA() |>
  fviz_ca(title = 'Co-Apps & Participants nach Ländern')

filter(data, AffiliationTypeLabel=="Hauptantragssteller" | AffiliationTypeLabel=="Mitantragsteller" | AffiliationTypeLabel=="Beteiligter") |>
  count(KonsortiumLabel, BundeslandLabel) |>
  group_by(KonsortiumLabel) |>
  pivot_wider(
    names_from = KonsortiumLabel,
    values_from = n,
    values_fill = 0
  ) |>
  mutate(BundeslandLabel = ifelse(is.na(BundeslandLabel), 'Unbekannt', BundeslandLabel)) |>
  column_to_rownames(var='BundeslandLabel') |>
  CA() |>
  fviz_ca(title = 'Co-Apps & Participants nach Ländern')
