
# All sites select
output$scale_streams_select = renderUI({
  req(valid_connection == TRUE)
  req(input$scale_survey_date_range)
  start_scale_date = input$scale_survey_date_range[1]
  end_scale_date = input$scale_survey_date_range[2]
  scale_stream_list = get_scale_streams(pool, start_scale_date, end_scale_date)$scale_stream
  pickerInput("scale_streams_select",
              label = "Stream(s) with scale data in date range",
              multiple = TRUE,
              choices = scale_stream_list,
              selected = scale_stream_list[1],
              width = "325px",
              options = pickerOptions(
                actionsBox = TRUE
              )
  )
})

# Primary DT datatable for samplers
output$scale_cards_query = renderDT({
  req(valid_connection == TRUE)
  req(input$scale_survey_date_range)
  req(input$scale_streams_select)
  start_scale_date = input$scale_survey_date_range[1]
  end_scale_date = input$scale_survey_date_range[2]
  selected_scale_streams = input$scale_streams_select
  scale_stream_ids = get_scale_streams(pool, start_scale_date, end_scale_date) %>%
    filter(scale_stream %in% selected_scale_streams) %>%
    distinct() %>%
    pull(waterbody_id)
  req(!length(scale_stream_ids) < 1L)
  sc_stream_ids = paste0(paste0("'", scale_stream_ids, "'"), collapse = ", ")
  scale_query_title = glue("All surveys with scale data for selected dates and streams")
  scale_query_data = get_scale_query_data(pool, start_scale_date, end_scale_date, sc_stream_ids)  %>%
    select(survey_date_dt, scale_stream, upper_rm, lower_rm, start_time_dt, end_time_dt,
           observer, species, fish_status, sex, maturity, origin, cwt_status, clip,
           scale_sample_card_number, scale_sample_position_number,
           european_age_code, gilbert_rich_age_code, fresh_water_annuli,
           maiden_salt_water_annuli, total_salt_water_annuli,
           age_at_spawning, prior_spawn_event_count, genetic_number,
           otolith_number, created_dt, created_by, modified_dt, modified_by)

  # Generate table
  datatable(scale_query_data,
            colnames = c("Survey Date", "Stream", "Upper RM", "Lower RM", "Start",
                         "End", "Observer", "Species", "Live-Dead", "Sex", "Maturity",
                         "Origin", "CWT Detection", "Clip Status", "Card Number",
                         "Pos Number", "European", "Gilbert Rich", "FW Annuli",
                         "SW Annuli", "Total SW", "Spawn Age", "Prior Spawn Count",
                         "Genetic Number", "Otolith Number", "Create DT", "Create By",
                         "Mod DT", "Mod By"),
            selection = list(mode = 'single'),
            extensions = 'Buttons',
            options = list(dom = 'Blftp',
                           pageLength = 20,
                           lengthMenu = c(20, 50, 100, 500, 2000),
                           scrollX = T,
                           buttons = c('excel', 'print'),
                           initComplete = JS(
                             "function(settings, json) {",
                             "$(this.api().table().header()).css({'background-color': '#9eb3d6'});",
                             "}")),
            caption = htmltools::tags$caption(
              style = 'caption-side: top; text-align: left; color: black; width: auto;',
              htmltools::em(htmltools::strong(scale_query_title))))
})

# Create surveys DT proxy object
scale_cards_query_dt_proxy = dataTableProxy(outputId = "scale_cards_query")
