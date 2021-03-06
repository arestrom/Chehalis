#========================================================
# Get Initial WRIA
#========================================================

# wria_select
output$wria_select = renderUI({
  req(valid_connection == TRUE)
  wria_list = get_wrias(pool)
  selectizeInput("wria_select",
                 label = "Select WRIA",
                 choices = wria_list,
                 selected = "23 Upper Chehalis",
                 width = "100%")
})

#========================================================
# Get initial set of streams for selected wria
#========================================================

# Get streams in wria
wria_streams = reactive({
  req(valid_connection == TRUE)
  req(input$wria_select)
  chosen_wria = substr(input$wria_select, 1, 2)
  streams = get_streams(pool, chosen_wria) %>%
    mutate(stream_label = if_else(is.na(stream_name) & !is.na(waterbody_name),
                                  waterbody_name, stream_name)) %>%
    mutate(stream_label = paste0(stream_name, ": ", llid)) %>%
    st_transform(4326) %>%
    select(waterbody_id, stream_id, stream_label, geometry)
  return(streams)
})

# Pull out stream_list from wria_streams
stream_list = reactive({
  stream_data = wria_streams() %>%
    st_drop_geometry() %>%
    select(stream_label) %>%
    arrange(stream_label) %>%
    distinct()
  return(stream_data$stream_label)
})

# stream_select
output$stream_select = renderUI({
  req(valid_connection == TRUE)
  selectizeInput(inputId = "stream_select",
                 label = "Select stream (or click on map)",
                 choices = stream_list(),
                 selected = stream_list()[1],
                 width = "100%")
})

#========================================================
# Get initial set of dates for selected stream
#========================================================

# Filter to selected stream
waterbody_id = eventReactive(input$stream_select, {
  req(valid_connection == TRUE)
  req(input$stream_select)
  stream_data = wria_streams() %>%
    st_drop_geometry() %>%
    filter(stream_label == input$stream_select) %>%
    select(waterbody_id) %>%
    distinct() %>%
    pull(waterbody_id)
  return(stream_data)
})

waterbody_survey_dates = eventReactive(input$stream_select, {
  req(valid_connection == TRUE)
  date_list = get_survey_dates(pool, waterbody_id())
  if (length(date_list) == 0 ) {
    date_list = NULL
  } else {
    date_list = date_list
  }
  return(date_list)
})

# Date range select
output$when_date_range = renderUI({
  req(waterbody_survey_dates())
  dateRangeInput(inputId = "when_date_range",
                 label = "Date range for surveys",
                 width = "100%",
                 start = waterbody_survey_dates()[1],
                 end = waterbody_survey_dates()[1],
                 format = "mm/dd/yyyy",
                 startview = "year")
})

#========================================================
# Get data for initial map
#========================================================

selected_wria = reactive({
  req(valid_connection == TRUE)
  req(input$wria_select)
  chosen_wria = substr(input$wria_select, 1, 2)
  zoom_wria = get_wria_centroid(pool, chosen_wria) %>%
    select(wria_name, lat, lon)
  return(zoom_wria)
})

# Output leaflet bidn map
output$stream_map <- renderLeaflet({
  req(valid_connection == TRUE)
  req(input$wria_select)
  m = leaflet() %>%
    setView(lng = selected_wria()$lon[1],
            lat = selected_wria()$lat[1],
            zoom = 10) %>%
    addProviderTiles("Esri.WorldImagery", group = "Esri World Imagery") %>%
    addProviderTiles("OpenTopoMap", group = "Open Topo Map") %>%
    addLayersControl(position = 'bottomleft',
                     baseGroups = c("Esri World Imagery", "Open Topo Map"),
                     options = layersControlOptions(collapsed = TRUE))
  m
})

# Update leaflet proxy map with all streams in selected wria
observe({
  input$wria_select
  stream_map_proxy = leafletProxy("stream_map") %>%
    clearShapes() %>%
    addPolylines(data = wria_streams(),
                 group = "Streams",
                 weight = 3,
                 color = "#0000e6",
                 label = ~stream_label,
                 layerId = ~stream_id,
                 labelOptions = labelOptions(noHide = FALSE)) %>%
    addLayersControl(position = 'bottomleft',
                     baseGroups = c("Esri World Imagery", "Open Topo Map"),
                     overlayGroups = c("Streams"),
                     options = layersControlOptions(collapsed = TRUE))
})

# Focus map on selected stream
observe({
  input$stream_select
  stream_map_proxy = leafletProxy("stream_map") %>%
    fitBounds(lng1 = selected_stream_bounds()$min_lon,
              lat1 = selected_stream_bounds()$min_lat,
              lng2 = selected_stream_bounds()$max_lon,
              lat2 = selected_stream_bounds()$max_lat)
})

#========================================================
# Update stream select if map is clicked
#========================================================

# Reactive to record stream_id of stream_clicked
selected_map_stream_id = reactive({
  req(input$stream_map_shape_click$id)
  selected_map_stream_id = input$stream_map_shape_click$id
  return(selected_map_stream_id)
})

# Reactive to record stream_label of stream_clicked
selected_map_stream = reactive({
  req(input$stream_map_shape_click)
  stream_names = wria_streams() %>%
    st_drop_geometry() %>%
    select(stream_id, stream_label) %>%
    distinct()
  selected_map_stream_id = selected_map_stream_id()
  selected_map_stream_label = stream_names %>%
    filter(stream_id == selected_map_stream_id) %>%
    pull(stream_label)
  return(selected_map_stream_label)
})

# Update Stream input if stream on map is clicked
observeEvent(input$stream_map_shape_click, {
  clicked_stream = selected_map_stream()
  # Update
  updateSelectizeInput(session, "stream_select",
                       choices = stream_list(),
                       selected = clicked_stream)
})

# Get list of river mile end_points for waterbody_id
rm_list = reactive({
  req(valid_connection == TRUE)
  wb_id = waterbody_id()
  stream_rms = get_end_points(pool, waterbody_id())
  return(stream_rms)
})

#========================================================
# Get centroid of selected stream for fish_map & redd_map
#========================================================

# Get centroid of stream for setting view of fish_map
selected_stream_centroid = reactive({
  req(valid_connection == TRUE)
  req(input$stream_select)
  stream_centroid_coords = get_stream_centroid(pool, waterbody_id())
  return(stream_centroid_coords)
})

#========================================================
# Get bounds of selected stream for fish_map & redd_map
#========================================================

# Get centroid of stream for setting view of fish_map
selected_stream_bounds = reactive({
  req(valid_connection == TRUE)
  req(input$stream_select)
  stream_bounds = get_stream_bounds(pool, waterbody_id())
  return(stream_bounds)
})

#========================================================
# Get wria for location insert, redds and fish
#========================================================

# Reactive to pull out wria_id
wria_id = reactive({
  req(valid_connection == TRUE)
  req(input$wria_select)
  chosen_wria = substr(input$wria_select, 1, 2)
  get_streams(pool, chosen_wria) %>%
    st_drop_geometry() %>%
    mutate(wria_id = tolower(wria_id)) %>%
    select(wria_id) %>%
    distinct() %>%
    pull(wria_id)
})

