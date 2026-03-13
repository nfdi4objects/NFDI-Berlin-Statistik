library(tidyverse)
library(gt)
library(httr2)
library(dplyr)
library(purrr)

endpoint <- "https://query.wikidata.org/sparql"

# Define your SPARQL query
query <- "
SELECT DISTINCT ?Bundesland ?BundeslandLabel ?Stadt ?StadtLabel ?Institution ?InstitutionLabel ?AffiliationTypeLabel ?Konsortium ?KonsortiumLabel ?Rechtsform ?RechtsformLabel WHERE {
{
SELECT DISTINCT ?Bundesland ?Stadt ?Institution ?AffiliationType ?Konsortium ?Rechtsform WHERE {
  {
   ?Institution wdt:P463 wd:Q61658497 .
  } UNION {
    ?Konsortium wdt:P31 wd:Q98270496 .
    ?Konsortium p:P1416 ?statement .
    ?statement ps:P1416 ?Institution .
    OPTIONAL { ?statement pq:P3831 ?AffiliationType .}
  }
  OPTIONAL { ?Institution wdt:P31 ?Rechtsform .} 
  OPTIONAL {
    ?Institution wdt:P131+ ?Stadt .
    {?Stadt  wdt:P31/wdt:P279* wd:Q515} UNION {?Stadt  wdt:P31/wdt:P279* wd:Q116457956 } 
    OPTIONAL {
      ?Stadt wdt:P131* ?Bundesland .
      ?Bundesland  wdt:P31 wd:Q1221156 .
     }
   }
  OPTIONAL {
    ?Institution wdt:P159/wdt:P131* ?Stadt . 
    ?Stadt  wdt:P31/wdt:P279* wd:Q515 . 
    OPTIONAL {
      ?Stadt wdt:P131* ?Bundesland .
      ?Bundesland  wdt:P31 wd:Q1221156 .
     }    
   }
  FILTER NOT EXISTS {?Institution  wdt:P31 wd:Q98270496 }  
}
  }
  BIND(IF(! Bound(?AffiliationType), 'NFDI-Vereinsmitglied', ?AffiliationTypeLabel) AS ?AffiliationTypeLabel)
  SERVICE wikibase:label { bd:serviceParam wikibase:language 'de,en' . }
} ORDER BY ASC(?BundeslandLabel) ASC(?StadtLabel) ASC(?AffiliationTypeLabel) ASC(?InstitutionLabel)
"

# Send the query
res <- request(endpoint) %>%
  req_url_query(query = query) %>%
  req_headers("Accept" = "application/sparql-results+json") %>%
  req_perform()

# Parse the JSON
raw <- res %>% resp_body_json()

# Flatten into a tibble
bindings <- raw$results$bindings
data <- map_dfr(bindings, function(row) {
  tibble(!!!setNames(lapply(row, function(v) v$value), names(row)))
})

# Define the target combinations, adding a flag column
target_combinations <- data.frame(
  KonsortiumLabel = c(
    "BERD@NFDI", "DAPHNE4NFDI", "DataPLANT", "FAIRagro", "FAIRmat", "GHGA",
    "KonsortSWD", "MaRDI", "NFDI-MatWerk", "NFDI4Biodiversity", "NFDI4BIOIMAGE",
    "NFDI4Cat", "NFDI4Chem", "NFDI4Culture", "NFDI4DataScience", "NFDI4Earth",
    "NFDI4Energy", "NFDI4Health", "NFDI4Immuno", "NFDI4ING", "NFDI4Memory",
    "NFDI4Microbiota", "NFDI4Objects", "NFDIxCS", "PUNCH4NFDI", "Text+"
  ),
  InstitutionLabel = c(
    "Universität Mannheim", "Deutsches Elektronen-Synchrotron",
    "Albert-Ludwigs-Universität Freiburg", "ZALF",
    "Humboldt-Universität zu Berlin", "Deutsches Krebsforschungszentrum",
    "GESIS – Leibniz-Institut für Sozialwissenschaften",
    "Weierstraß-Institut für Angewandte Analysis und Stochastik",
    "Fraunhofer-Gesellschaft", "Universität Bremen",
    "Heinrich-Heine-Universität Düsseldorf", "DECHEMA",
    "Friedrich-Schiller-Universität Jena",
    "Akademie der Wissenschaften und der Literatur Mainz",
    "Fraunhofer-Gesellschaft", "Technische Universität Dresden",
    "Carl von Ossietzky Universität Oldenburg",
    "Leibniz-Institut für Präventionsforschung und Epidemiologie",
    "Deutsches Krebsforschungszentrum", "Technische Universität Darmstadt",
    "Leibniz-Institut für Europäische Geschichte",
    "ZB MED – Informationszentrum Lebenswissenschaften",
    "Deutsches Archäologisches Institut", "Universität Duisburg-Essen",
    "Deutsches Elektronen-Synchrotron", "Leibniz-Institut für Deutsche Sprache"
  ),
  is_target = TRUE,  # Add a flag column
  stringsAsFactors = FALSE
)

# Update AffiliationTypeLabel
data <- data %>%
  left_join(target_combinations, by = c("KonsortiumLabel", "InstitutionLabel")) %>%
  mutate(
    AffiliationTypeLabel = case_when(
      AffiliationTypeLabel %in% c("Mitantragsteller", "Bewerber") & is_target ~ "Hauptantragssteller",
      TRUE ~ AffiliationTypeLabel  # Keep original value otherwise
    )
  ) %>%
  select(-is_target)  # Remove the flag column

print(data)
