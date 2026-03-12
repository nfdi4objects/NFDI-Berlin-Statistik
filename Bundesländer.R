library(tidyverse)
library(FactoMineR)
library(factoextra)

filter(data, AffiliationTypeLabel=="Mitantragsteller") %>%
  count(KonsortiumLabel, BundeslandLabel) %>%
  group_by(KonsortiumLabel) %>%
  pivot_wider(
    names_from = KonsortiumLabel,
    values_from = n,
    values_fill = 0
  ) %>%
  mutate(BundeslandLabel = ifelse(is.na(BundeslandLabel), 'Unbekannt', BundeslandLabel)) %>%
  column_to_rownames(var='BundeslandLabel') %>%
  CA() %>%
  fviz_ca(title = 'Co-Apps nach Ländern', repel=true)

filter(data, AffiliationTypeLabel=="Mitantragsteller" | AffiliationTypeLabel=="Beteiligter") %>%
  count(KonsortiumLabel, BundeslandLabel) %>%
  group_by(KonsortiumLabel) %>%
  pivot_wider(
    names_from = KonsortiumLabel,
    values_from = n,
    values_fill = 0
  ) %>%
  mutate(BundeslandLabel = ifelse(is.na(BundeslandLabel), 'Unbekannt', BundeslandLabel)) %>%
  column_to_rownames(var='BundeslandLabel') %>%
  CA() %>%
  fviz_ca(title = 'Co-Apps & Participants nach Ländern')
