## code to prepare `bbou_national_priors_table` dataset

# This script can be run using make_table.sh which saves a csv after every 100 runs
# This allows for any interruptions that might occur and seems to prevent the
# process slowing down too much over many reps.
# make_table2.sh runs the second half of the runs and can be run at the same time.

# once the tables are all saved as csvs you can run assemble_bbou_national_priors_table to
# compile it into one table and save it in the package.

print("in script")
stopifnot(requireNamespace("caribouMetrics", quietly = TRUE))
library(caribouMetrics)
library(dplyr)
dist_tbl <- expand.grid(Anthro = 0:100, fire_excl_anthro = 0:100) |>
  subset((Anthro + fire_excl_anthro) <= 100)

set <- commandArgs(trailingOnly = TRUE)[1] %>% as.numeric()

st <- set*100 - 99
en <- set*100
en <- min(en, nrow(dist_tbl))

dist_tbl <- slice(dist_tbl, st:en)

out <- lapply(1:nrow(dist_tbl), function(i){
  gc()
  message(i)
  if(i/10 == ceiling(i/10)) tictoc::tic()
  res <- bbouNationalPriors(dist_tbl$Anthro[i], dist_tbl$fire_excl_anthro[i])
  res <- unlist(res) |> as.data.frame() |> t()
  colnames(res) <- gsub(pattern = "\\.", replacement = "_", colnames(res))
  res <- as.data.frame(res, row.names = "")
  res$Anthro <- dist_tbl$Anthro[i]
  res$fire_excl_anthro <- dist_tbl$fire_excl_anthro[i]
  if(i/10 == ceiling(i/10)) tictoc::toc()
  res
})

bbou_national_priors_table <- do.call(rbind, out)

write.csv(bbou_national_priors_table, paste0("table", set, ".csv"))


