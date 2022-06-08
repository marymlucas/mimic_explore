-- THIS SCRIPT IS AUTOMATICALLY GENERATED. DO NOT EDIT IT DIRECTLY.
DROP TABLE IF EXISTS icustay_detail; CREATE TABLE icustay_detail AS 
SELECT ie.subject_id, ie.hadm_id, ie.stay_id

-- patient level factors
, pat.gender, pat.dod

-- hospital level factors
, adm.admittime, adm.dischtime
, date_part('day', adm.dischtime - adm.admittime) as los_hospital
, (EXTRACT(year from adm.admittime) - pat.anchor_year) + pat.anchor_age as admission_age
, adm.ethnicity
, adm.hospital_expire_flag
, DENSE_RANK() OVER (PARTITION BY adm.subject_id ORDER BY adm.admittime) AS hospstay_seq
, CASE
    WHEN DENSE_RANK() OVER (PARTITION BY adm.subject_id ORDER BY adm.admittime) = 1 THEN True
    ELSE False END AS first_hosp_stay

-- icu level factors
, ie.intime as icu_intime, ie.outtime as icu_outtime
, ROUND( CAST( date_part('hour', ie.outtime - ie.intime)/24.0 as numeric),2) as los_icu
, DENSE_RANK() OVER (PARTITION BY ie.hadm_id ORDER BY ie.intime) AS icustay_seq

-- first ICU stay *for the current hospitalization*
, CASE
    WHEN DENSE_RANK() OVER (PARTITION BY ie.hadm_id ORDER BY ie.intime) = 1 THEN True
    ELSE False END AS first_icu_stay

FROM mimic_icu.icustays ie
INNER JOIN mimic_core.admissions adm
    ON ie.hadm_id = adm.hadm_id
INNER JOIN mimic_core.patients pat
    ON ie.subject_id = pat.subject_id
