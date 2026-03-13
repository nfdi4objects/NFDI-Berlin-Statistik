library(gt)

apply_n4o_styles <- function(gt_obj) {
  gt_obj %>%
    tab_style(
      style = list(
        cell_fill(color = "#EEEAE0"),
        cell_text(style = "oblique",
                  color = "#13294B",
                  font = c(google_font(name = "PT Sans"), default_fonts()))
      ),
      locations = cells_body()
    ) %>%
    tab_style(
      style = list(cell_fill(color = "#EEEAE0")),
      locations = cells_stubhead()
    ) %>%
    tab_style(
      style = list(
        cell_fill(color = "#EEEAE0"),
        cell_text(style = "oblique",
                  color = "#13294B",
                  font = c(google_font(name = "PT Sans"), default_fonts()))
      ),
      locations = cells_column_labels()
    ) %>%
    tab_style(
      style = list(
        cell_text(style = "normal",
                  color = "#13294B",
                  font = c(google_font(name = "PT Sans"), default_fonts()))
      ),
      locations = cells_stub()
    ) %>%
    tab_style(
      style = list(
        cell_text(style = "normal",
                  color = "#13294B",
                  font = c(google_font(name = "PT Sans"), default_fonts()))
      ),
      locations = cells_title()
    )
}
