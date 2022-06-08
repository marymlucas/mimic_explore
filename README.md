# Exploring MIMIC Patient Data

A repo containing my initial explorations of the MIMIC patient databases

To learn more about this data and how to get access to it, please see [https://mimic.mit.edu/](https://mimic.mit.edu/). It is freely available but each user needs to go through a credentialing process before being granted access.  Details on that are on the [Getting Started](https://mimic.mit.edu/docs/gettingstarted/) page.


## Data 
Following and adapting the steps outlined in [https://github.com/MIT-LCP/mimic-code](https://github.com/MIT-LCP/mimic-code) I have loaded the MIMIC data into PostgreSQL databases running on my local machine.

### MIMIC-IV Concepts
I struggled to generate the MIMIC-IV concepts with the postgres code in the original repo, mostly due to datetime errors. I think the conversion from BigQuery may have left some artifacts, but I also couldn't figure out how to add my corrections to the conversion script, so I modified the affected SQL files and the concepts now load fine for me - see mimic-iv/concepts/postgres folder.