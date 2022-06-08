-- not 100% sure of this one, need to check as giving negative hours (ML)

DROP TABLE IF EXISTS icustay_hourly; CREATE TABLE icustay_hourly AS 
-- This query generates a row for every hour the patient is in the ICU.
-- The hours are based on clock-hours (i.e. 02:00, 03:00).
-- The hour clock starts 24 hours before the first heart rate measurement.
-- Note that the time of the first heart rate measurement is ceilinged to the hour.

-- this query extracts the cohort and every possible hour they were in the ICU
-- this table can be to other tables on ICUSTAY_ID and (ENDTIME - 1 hour,ENDTIME]

-- get first/last measurement time
with all_hours as
(
select
  it.stay_id

  -- ceiling the intime to the nearest hour by adding 59 minutes then truncating
  -- note that we truncate by parsing as string, rather than using DATETIME_TRUNC
  -- this is done to enable compatibility with psql
  , (it.intime_hr + INTERVAL '59 MINUTE') AS endtime

  -- create integers for each charttime in hours from admission
  -- so 0 is admission time, 1 is one hour after admission, etc, up to ICU disch
  --  we allow 24 hours before ICU admission (to grab labs before admit)
  , ARRAY(SELECT * FROM generate_series(CAST(-24 as bigint), cast(ceiling(date_part('hour', it.outtime_hr - it.intime_hr))as bigint), cast(1 as bigint))) as hrs

  from mimic_derived.icustay_times it
)
SELECT stay_id
, CAST(hr AS bigint) as hr
, (endtime + interval '1 hour' * CAST(hr AS bigint)) as endtime
FROM all_hours
CROSS JOIN UNNEST(all_hours.hrs) AS hr;