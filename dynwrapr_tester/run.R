#!/usr/local/bin/Rscript

library(dplyr, warn.conflicts = FALSE)
library(readr, warn.conflicts = FALSE)
library(dynwrap, warn.conflicts = FALSE)
library(dyncli, warn.conflicts = FALSE)

#####################################
###           LOAD DATA           ###
#####################################
task <- dyncli::main()
params <- task$parameters
expression <- task$expression
start_id <- task$priors$start_id

#####################################
###        INFER TRAJECTORY       ###
#####################################
# do PCA
dimred <- prcomp(expression)$x

# extract the component and use it as pseudotimes
pseudotime <- dimred[, params$component]
pseudotime <- (pseudotime - min(pseudotime)) / (max(pseudotime) - min(pseudotime))

# flip pseudotimes using start_id
if (!is.null(start_id)) {
  if (mean(pseudotime[start_id]) > 0.5) {
    pseudotime <- 1 - pseudotime
  }
}

#####################################
###     SAVE OUTPUT TRAJECTORY    ###
#####################################
output <-
  wrap_data(
    cell_ids = rownames(expression)
  ) %>%
  add_cyclic_trajectory(
    pseudotime = pseudotime,
    do_scale_minmax = FALSE
  ) %>% 
  add_dimred(
    dimred = dimred
  )

dyncli::write_output(output, task$output)
