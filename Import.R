library(tidyverse)
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

# Print the result
print(data)