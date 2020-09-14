
get_wrias = function() {
  qry = glue("select distinct wr.wria_code || ' ' || wr.wria_description as wria_name ",
             "from spawning_ground.wria_lut as wr ",
             "where wr.wria_code in ('22', '23') ",
             "order by wria_name")
  con = poolCheckout(pool)
  wria_list = DBI::dbGetQuery(con, qry) %>%
    pull(wria_name)
  poolReturn(con)
  return(wria_list)
}

get_streams = function(chosen_wria) {
  qry = glue("select distinct wb.waterbody_id, wb.waterbody_name as stream_name, ",
             "wb.waterbody_name, wb.latitude_longitude_id as llid, ",
             "wb.stream_catalog_code as cat_code, wr.wria_id, st.stream_id, ",
             "wr.wria_code || ' ' || wr.wria_description as wria_name, st.geom as geometry ",
             "from spawning_ground.waterbody_lut as wb ",
             "inner join spawning_ground.stream as st on wb.waterbody_id = st.waterbody_id ",
             "inner join spawning_ground.wria_lut as wr on st_intersects(st.geom, wr.geom) ",
             "where wr.wria_code = '{chosen_wria}' ",
             "order by wb.waterbody_name")
  con = poolCheckout(pool)
  streams_st = sf::st_read(con, query = qry)
  poolReturn(con)
  return(streams_st)
}

get_data_years = function(waterbody_id) {
  qry = glue("select distinct date_part('year', s.survey_datetime) as data_year ",
             "from spawning_ground.survey as s ",
             "inner join spawning_ground.location as up_loc on s.upper_end_point_id = up_loc.location_id ",
             "inner join spawning_ground.location as lo_loc on s.lower_end_point_id = lo_loc.location_id ",
             "where up_loc.waterbody_id = '{waterbody_id}' ",
             "or lo_loc.waterbody_id = '{waterbody_id}' ",
             "order by data_year desc")
  con = poolCheckout(pool)
  year_list = DBI::dbGetQuery(con, qry) %>%
    mutate(data_year = as.character(data_year)) %>%
    pull(data_year)
  poolReturn(con)
  return(year_list)
}

get_end_points = function(waterbody_id) {
  qry = glue("select distinct loc.location_id, loc.river_mile_measure as river_mile, ",
             "loc.location_description as rm_desc ",
             "from spawning_ground.location as loc ",
             "inner join spawning_ground.location_type_lut as lt on loc.location_type_id = lt.location_type_id ",
             "where lt.location_type_description in ('Reach boundary point', 'Section break point') ",
             "and loc.waterbody_id = '{waterbody_id}'")
  con = poolCheckout(pool)
  end_points = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  end_points = end_points %>%
    arrange(river_mile) %>%
    mutate(rm_label = if_else(is.na(rm_desc), as.character(river_mile),
                              paste0(river_mile, " ", rm_desc))) %>%
    select(location_id, rm_label)
  return(end_points)
}

#==========================================================================
# Get centroid or bounds of waterbody to use in interactive maps
#==========================================================================

get_wria_centroid = function(chosen_wria) {
  qry = glue("select distinct wria_code || ' ' || wria_description as wria_name, ",
             "ST_Y(ST_Transform(ST_Centroid(geom), 4326)) as lat, ",
             "ST_X(ST_Transform(ST_Centroid(geom), 4326)) as lon ",
             "from spawning_ground.wria_lut ",
             "where wria_code = '{chosen_wria}'")
  con = poolCheckout(pool)
  wria_centroid = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  return(wria_centroid)
}

get_stream_centroid = function(waterbody_id) {
  qry = glue("select DISTINCT waterbody_id, ",
             "ST_X(ST_Transform(ST_Centroid(geom), 4326)) as center_lon, ",
             "ST_Y(ST_Transform(ST_Centroid(geom), 4326)) as center_lat ",
             "from spawning_ground.stream ",
             "where waterbody_id = '{waterbody_id}'")
  con = poolCheckout(pool)
  stream_centroid = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  return(stream_centroid)
}

# Stream bounds query
get_stream_bounds = function(waterbody_id) {
  qry = glue("select DISTINCT st.waterbody_id, ",
             "st.geom as geometry ",
             "from spawning_ground.stream as st ",
             "where st.waterbody_id = '{waterbody_id}'")
  con = poolCheckout(pool)
  stream_bounds = sf::st_read(con, query = qry, crs = 2927) %>%
    st_transform(., 4326) %>%
    st_cast(., "POINT", warn = FALSE) %>%
    mutate(lat = as.numeric(st_coordinates(geometry)[,2])) %>%
    mutate(lon = as.numeric(st_coordinates(geometry)[,1])) %>%
    st_drop_geometry() %>%
    mutate(min_lat = min(lat),
           min_lon = min(lon),
           max_lat = max(lat),
           max_lon = max(lon)) %>%
    select(waterbody_id, min_lat, min_lon, max_lat, max_lon) %>%
    distinct()
  poolReturn(con)
  return(stream_bounds)
}
