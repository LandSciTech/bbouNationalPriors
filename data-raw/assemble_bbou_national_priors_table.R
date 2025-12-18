wd_out <- getwd()
setwd("data-raw")

library(dplyr)

# run bbou_national_priors_table in sets of 100 to save intermediate results and
# prevent slowing down
shell.exec(file.path(getwd(),"make_table.sh"))
shell.exec(file.path(getwd(),"make_table2.sh"))

while(!file.exists("table52.csv")){
  #check every 10 mins
  Sys.sleep(60)
}

# once the tables are all saved as csvs compile it into one table and save it in the package.
tbls <- list.files(pattern = "table.*.csv") %>% lapply(read.csv)
bbou_national_priors_table <- do.call(rbind, tbls) |>
  arrange(fire_excl_anthro, Anthro) |>
  select(-any_of(c("X")))
usethis::use_data(bbou_national_priors_table, overwrite = TRUE)
usethis::use_data(bbou_national_priors_table, overwrite = TRUE, internal = TRUE)

# clean up intermediate csvs
list.files(pattern = "table.*.csv") %>% lapply(file.remove)
list.files(pattern = "nohup.*out") %>% lapply(file.remove)

setwd(wd_out)
