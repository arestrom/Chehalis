#=============================================================
# ShinyDashboardPlus header function
#=============================================================

dash_header = dashboardHeader(
  fixed = TRUE,
  title = tagList(
    span(class = "logo-lg", "Chehalis Basin data"),
    img(src = "ShinyDashboardPlus.svg"))
)

