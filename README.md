# birth_control_egypt

This repository extracts a table from the 1997 DHS survey conducted in Egypt that measures the use of birth control. The table that is extracted is cleaned and converted into several wide and long csv format. The report looks at the results that are shown by the data, and discusses ethical concerns with birth control, as well as the option for male birth control and the recent change in public opinion around the subject.

## Reproducability

In order to reproduce the results, run the `scripts/process_egypt_dhs1997.R` file to extract the data from the Egypt 1997 DHS survey. Then knit `report.Rmd` to generate the report. The project uses an RProject so that everything is reproducible. The DHS survey can be found in inputs, but there is also a link to the original version in the script.
