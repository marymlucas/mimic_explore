# PostgreSQL concepts

This folder contains scripts to generate useful abstractions of raw MIMIC-IV data ("concepts"). The
scripts are intended to be run against the MIMIC-IV data in a PostgreSQL database.

**IMPORTANT NOTE**: This is the postgres version for generating the concepts but it differs from what is in the original MIMIC-IV repo (https://github.com/MIT-LCP/mimic-code/tree/main/mimic-iv/concepts). I ran into a lot of errors when setting things up in Windows so my workaround was to go script by script and make the necessary changes.

I have not tested running postgres-make-concepts.sql with my modified scripts from the psql command line as described in the original instructions (see below), so ymmv. I may test it on another setup if time allows.


*Original Instructions*
-----------------------

**Most of these scripts are automatically generated by a shell script in the parent folder.** If you would like to contribute a correction, please look at the conversion shell script to ensure you edit the right script!

To generate concepts, change to this directory and run `psql`. Then within psql, run:

```sql
-- NOTE: many scripts *require* you to use mimic_derived as the schema for outputting concepts
-- change the search path at your peril!
set search_path to mimic_derived, mimic_core, mimic_hosp, mimic_icu, mimic_ed;
\i postgres-functions.sql -- only needs to be run once
\i postgres-make-concepts.sql
```

... or, execute the SQL files in your GUI of choice.
