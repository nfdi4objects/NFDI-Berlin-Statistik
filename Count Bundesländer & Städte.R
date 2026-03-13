filter(data, AffiliationTypeLabel=="Hauptantragssteller")[, c("BundeslandLabel", "KonsortiumLabel")] |>
  mutate(BundeslandLabel = ifelse(is.na(BundeslandLabel), 'Unbekannt', BundeslandLabel)) |>
  distinct(BundeslandLabel, KonsortiumLabel, .keep_all = TRUE) |>
  count(BundeslandLabel, sort = TRUE) -> MainAppCountLänder

gt(data=MainAppCountLänder, rowname_col = "BundeslandLabel") |>
   tab_header(title = "Anzahl NFDI-Konsortien mit Main-Apps nach Bundesländern",
              subtitle = "Stand vom 13.03.2026, erarbeitet durch NFDI4Objects") |>
   tab_source_note(source_note = 
                     md("Für die Datengrundlage und den Sourcecoude: [Link](https://github.com/nfdi4objects/NFDI-Berlin-Statistik)")) |>
  cols_label(
    n = "n / 27 Konsortien vertreten im jeweiligen Bundesland"
  ) |>
  apply_n4o_styles()

filter(data, AffiliationTypeLabel=="Hauptantragssteller" | AffiliationTypeLabel=="Mitantragsteller")[, c("BundeslandLabel", "KonsortiumLabel")] |>
  mutate(BundeslandLabel = ifelse(is.na(BundeslandLabel), 'Unbekannt', BundeslandLabel)) |>
  distinct(BundeslandLabel, KonsortiumLabel, .keep_all = TRUE) |>
  count(BundeslandLabel, sort = TRUE) -> MainAppCoAppCountLänder

gt(data=MainAppCoAppCountLänder, rowname_col = "BundeslandLabel") |>
  tab_header(title = "Anzahl NFDI-Konsortien mit Main-Apps & Co-Apps nach Bundesländern",
             subtitle = "Stand vom 13.03.2026, erarbeitet durch NFDI4Objects") |>
  tab_source_note(source_note = 
                    md("Für die Datengrundlage und den Sourcecoude: [Link](https://github.com/nfdi4objects/NFDI-Berlin-Statistik)")) |>
  cols_label(
    n = "n / 27 Konsortien vertreten im jeweiligen Bundesland"
  ) |>
  apply_n4o_styles()

filter(data, AffiliationTypeLabel=="Hauptantragssteller" | AffiliationTypeLabel=="Mitantragsteller" | AffiliationTypeLabel=="Beteiligter")[, c("BundeslandLabel", "KonsortiumLabel")] |>
  mutate(BundeslandLabel = ifelse(is.na(BundeslandLabel), 'Unbekannt', BundeslandLabel)) |>
  distinct(BundeslandLabel, KonsortiumLabel, .keep_all = TRUE) |>
  count(BundeslandLabel, sort = TRUE) -> MainAppCoAppPartCountLänder

gt(data=MainAppCoAppPartCountLänder, rowname_col = "BundeslandLabel") |>
  tab_header(title = "Anzahl NFDI-Konsortien mit Main-Apps, Co-Apps & Participants nach Bundesländern",
             subtitle = "Stand vom 13.03.2026, erarbeitet durch NFDI4Objects") |>
  tab_source_note(source_note = 
                    md("Für die Datengrundlage und den Sourcecoude: [Link](https://github.com/nfdi4objects/NFDI-Berlin-Statistik)")) |>
  cols_label(
    n = "n / 27 Konsortien vertreten im jeweiligen Bundesland"
  ) |>
  apply_n4o_styles()

filter(data, AffiliationTypeLabel=="Hauptantragssteller")[, c("StadtLabel", "KonsortiumLabel")] |>
  mutate(StadtLabel = ifelse(is.na(StadtLabel), 'Unbekannt', StadtLabel)) |>
  distinct(StadtLabel, KonsortiumLabel, .keep_all = TRUE) |>
  count(StadtLabel, sort = TRUE) -> MainAppCountStädte

gt(data=MainAppCountStädte, rowname_col = "StadtLabel") |>
  tab_header(title = "Anzahl NFDI-Konsortien mit Main-Apps nach Städten",
             subtitle = "Stand vom 13.03.2026, erarbeitet durch NFDI4Objects") |>
  tab_source_note(source_note = 
                    md("Für die Datengrundlage und den Sourcecoude: [Link](https://github.com/nfdi4objects/NFDI-Berlin-Statistik)")) |>
  cols_label(
    n = "n / 27 Konsortien vertreten in der jeweiligen Stadt"
  ) |>
  apply_n4o_styles()

filter(data, AffiliationTypeLabel=="Hauptantragssteller" | AffiliationTypeLabel=="Mitantragsteller")[, c("StadtLabel", "KonsortiumLabel")] |>
  mutate(StadtLabel = ifelse(is.na(StadtLabel), 'Unbekannt', StadtLabel)) |>
  distinct(StadtLabel, KonsortiumLabel, .keep_all = TRUE) |>
  count(StadtLabel, sort = TRUE) |>
  filter(n>=8) -> MainAppCoAppCountStädte

gt(data=MainAppCoAppCountStädte, rowname_col = "StadtLabel") |>
  tab_header(title = "Anzahl NFDI-Konsortien mit Main-Apps & Co-Apps nach Städten",
             subtitle = "Stand vom 13.03.2026, erarbeitet durch NFDI4Objects") |>
  tab_source_note(source_note = 
                    md("Für die Datengrundlage und den Sourcecoude: [Link](https://github.com/nfdi4objects/NFDI-Berlin-Statistik)")) |>
  cols_label(
    n = "n / 27 Konsortien vertreten in der jeweiligen Stadt"
  ) |>
  apply_n4o_styles()

filter(data, AffiliationTypeLabel=="Hauptantragssteller" | AffiliationTypeLabel=="Mitantragsteller"| AffiliationTypeLabel=="Beteiligter")[, c("StadtLabel", "KonsortiumLabel")] |>
  mutate(StadtLabel = ifelse(is.na(StadtLabel), 'Unbekannt', StadtLabel)) |>
  distinct(StadtLabel, KonsortiumLabel, .keep_all = TRUE) |>
  count(StadtLabel, sort = TRUE) |>
  filter(n>=10) -> MainAppCoAppPartCountStädte

gt(data=MainAppCoAppPartCountStädte, rowname_col = "StadtLabel") |>
  tab_header(title = "Anzahl NFDI-Konsortien mit Main-Apps, Co-Apps oder Participants nach Städten",
             subtitle = "Stand vom 13.03.2026, erarbeitet durch NFDI4Objects") |>
  tab_source_note(source_note = 
                    md("Für die Datengrundlage und den Sourcecoude: [Link](https://github.com/nfdi4objects/NFDI-Berlin-Statistik)")) |>
  cols_label(
    n = "n / 27 Konsortien vertreten in der jeweiligen Stadt"
  ) |>
  apply_n4o_styles()
