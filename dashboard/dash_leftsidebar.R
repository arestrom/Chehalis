#==========================================================================
# ShinyDashboardPlus left sidebar
#==========================================================================

dash_leftsidebar = dashboardSidebar(
  width = 175,
  sidebarMenu(
    id = "tabs",
    menuItem("Where and when", tabName = "wria_stream", icon = icon("globe")),
    menuItem("Data entry", tabName = "data_entry", icon = icon("database")),
    menuItem("Add reach point", tabName = "reach_point", icon = icon("map-pin")),
    menuItem("Add stream", tabName = "add_stream", icon = icon("map-marked-alt")),
    menuItem("Import from mobile", tabName = "mobile_import", icon = icon("sync-alt")),
    menuItem("Import from file", tabName = "file_import", icon = icon("file-upload")),
    menuItem("Scale query", tabName = "data_query", icon = icon("share-square")),
    menuItem("Reports", tabName = "reports", icon = icon("pencil-alt")),
    menuItem("Connect", tabName = "connect", icon = icon("user-lock")),
    menuItem("About", tabName = "about", icon = icon("info-circle"))
  )
)
