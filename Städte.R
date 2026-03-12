library(FactoMineR)
library(factoextra)

filter(data, AffiliationTypeLabel=="Mitantragsteller") %>%
  count(KonsortiumLabel, StadtLabel) %>%
  group_by(KonsortiumLabel) %>%
  pivot_wider(
    names_from = KonsortiumLabel,
    values_from = n,
    values_fill = 0
  ) %>%
  mutate(StadtLabel = ifelse(is.na(StadtLabel), 'Unbekannt', StadtLabel)) %>%
  column_to_rownames(var='StadtLabel') %>%
  CA()%>%
  fviz_ca(title = 'Co-Apps nach Städten', repel=true)


filter(data, AffiliationTypeLabel=="Mitantragsteller" | AffiliationTypeLabel=="Beteiligter") %>%
  count(KonsortiumLabel, StadtLabel) %>%
  group_by(KonsortiumLabel) %>%
  pivot_wider(
    names_from = KonsortiumLabel,
    values_from = n,
    values_fill = 0
  ) %>%
  mutate(StadtLabel = ifelse(is.na(StadtLabel), 'Unbekannt', StadtLabel)) %>%
  column_to_rownames(var='StadtLabel', repel=true) %>%
  CA()


