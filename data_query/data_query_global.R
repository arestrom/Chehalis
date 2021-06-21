
# Get all creel sites
get_scale_streams = function(pool, start_scale_date, end_scale_date) {
  qry = glue("select distinct wb.waterbody_id, ",
             "wb.waterbody_display_name || ': ' || wb.latitude_longitude_id as scale_stream ",
             "from spawning_ground.survey as s ",
             "inner join spawning_ground.survey_event as se on s.survey_id = se.survey_id ",
             "inner join spawning_ground.fish_encounter as fe on se.survey_event_id = fe.survey_event_id ",
             "inner join spawning_ground.individual_fish as indf on fe.fish_encounter_id = indf.fish_encounter_id ",
             "inner join spawning_ground.location as locu on s.upper_end_point_id = locu.location_id ",
             "inner join spawning_ground.location as locl on s.lower_end_point_id = locl.location_id ",
             "inner join spawning_ground.waterbody_lut as wb on locl.waterbody_id = wb.waterbody_id ",
             "inner join spawning_ground.wria_lut as wr on locl.wria_id = wr.wria_id ",
             "where wr.wria_code in ('22', '23') ",
             "and indf.scale_sample_card_number is not null ",
             "and date(s.survey_datetime::timestamp at time zone 'America/Los_Angeles') >= '{start_scale_date}' ",
             "and date(s.survey_datetime::timestamp at time zone 'America/Los_Angeles') <= '{end_scale_date}' ",
             "order by scale_stream")
  con = poolCheckout(pool)
  scale_stream_list = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  return(scale_stream_list)
}

# Get all creel sites for selected years and catch areas
get_scale_query_data = function(pool, start_scale_date, end_scale_date, sc_stream_ids) {
  qry = glue("select s.survey_id, s.survey_datetime as survey_date, ",
             "wb.waterbody_display_name || ': ' || wb.latitude_longitude_id as scale_stream, ",
             "locu.river_mile_measure as upper_rm, ",
             "locl.river_mile_measure as lower_rm, ",
             "s.survey_start_datetime as start_time, ",
             "s.survey_end_datetime as end_time, ",
             "s.observer_last_name as observer, ",
             "sp.common_name as species, ",
             "fs.fish_status_description as fish_status, ",
             "sx.sex_description as sex, ",
             "mat.maturity_short_description as maturity, ",
             "ori.origin_description as origin, ",
             "cwtd.detection_status_description as cwt_status, ",
             "ad.adipose_clip_status_description as clip, ",
             "indf.scale_sample_card_number, ",
             "indf.scale_sample_position_number, ",
             "indf.genetic_sample_number as genetic_number, ",
             "indf.otolith_sample_number as otolith_number, ",
             "age.european_age_code, ",
             "age.gilbert_rich_age_code, ",
             "age.fresh_water_annuli, ",
             "age.maiden_salt_water_annuli, ",
             "age.total_salt_water_annuli, ",
             "age.age_at_spawning, ",
             "age.prior_spawn_event_count, ",
             "s.created_datetime as created_date, ",
             "s.created_by, s.modified_datetime as modified_date, ",
             "s.modified_by ",
             "from spawning_ground.survey as s ",
             "inner join spawning_ground.location as locu on s.upper_end_point_id = locu.location_id ",
             "inner join spawning_ground.location as locl on s.lower_end_point_id = locl.location_id ",
             "inner join spawning_ground.waterbody_lut as wb on locl.waterbody_id = wb.waterbody_id ",
             "inner join spawning_ground.survey_event as se on s.survey_id = se.survey_id ",
             "inner join spawning_ground.species_lut as sp on se.species_id = sp.species_id ",
             "inner join spawning_ground.fish_encounter as fe on se.survey_event_id = fe.survey_event_id ",
             "inner join spawning_ground.fish_status_lut as fs on fe.fish_status_id = fs.fish_status_id ",
             "inner join spawning_ground.sex_lut as sx on fe.sex_id = sx.sex_id ",
             "inner join spawning_ground.maturity_lut as mat on fe.maturity_id = mat.maturity_id ",
             "inner join spawning_ground.origin_lut as ori on fe.origin_id = ori.origin_id ",
             "inner join spawning_ground.cwt_detection_status_lut as cwtd on fe.cwt_detection_status_id = cwtd.cwt_detection_status_id ",
             "inner join spawning_ground.adipose_clip_status_lut as ad on fe.adipose_clip_status_id = ad.adipose_clip_status_id ",
             "inner join spawning_ground.individual_fish as indf on fe.fish_encounter_id = indf.fish_encounter_id ",
             "left join spawning_ground.age_code_lut as age on indf.age_code_id = age.age_code_id ",
             "where date(s.survey_datetime::timestamp at time zone 'America/Los_Angeles') >= '{start_scale_date}' ",
             "and date(s.survey_datetime::timestamp at time zone 'America/Los_Angeles') <= '{end_scale_date}' ",
             "and (locu.waterbody_id in ({sc_stream_ids}) or locl.waterbody_id in ({sc_stream_ids})) ",
             "and indf.scale_sample_card_number is not null")
  con = poolCheckout(pool)
  scale_data = DBI::dbGetQuery(con, qry)
  poolReturn(con)
  scale_data = scale_data %>%
    mutate(survey_date = with_tz(survey_date, tzone = "America/Los_Angeles")) %>%
    mutate(survey_date_dt = format(survey_date, "%m/%d/%Y")) %>%
    mutate(start_time = with_tz(start_time, tzone = "America/Los_Angeles")) %>%
    mutate(start_time_dt = format(start_time, "%H:%M")) %>%
    mutate(end_time = with_tz(end_time, tzone = "America/Los_Angeles")) %>%
    mutate(end_time_dt = format(end_time, "%H:%M")) %>%
    mutate(created_date = with_tz(created_date, tzone = "America/Los_Angeles")) %>%
    mutate(created_dt = format(created_date, "%m/%d/%Y %H:%M")) %>%
    mutate(modified_date = with_tz(modified_date, tzone = "America/Los_Angeles")) %>%
    mutate(modified_dt = format(modified_date, "%m/%d/%Y %H:%M")) %>%
    mutate(survey_date = as.Date(survey_date)) %>%
    select(survey_id, survey_date, survey_date_dt, scale_stream,
           upper_rm, lower_rm, start_time, start_time_dt, end_time, end_time_dt,
           observer, species, fish_status, sex, maturity, origin, cwt_status,
           clip, scale_sample_card_number, scale_sample_position_number,
           european_age_code, gilbert_rich_age_code, fresh_water_annuli,
           maiden_salt_water_annuli, total_salt_water_annuli,
           age_at_spawning, prior_spawn_event_count, genetic_number,
           otolith_number, created_date, created_dt, created_by,
           modified_date, modified_dt, modified_by) %>%
    arrange(survey_date, start_time, end_time, created_date)
  return(scale_data)
}
