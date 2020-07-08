#!/usr/bin/env Rscript

# generate dataset with certain seed
set.seed(1)
data <- dyntoy::generate_dataset(
  id = "specific_example/tester",
  num_cells = 300,
  num_features = 250,
  model = "cyclic"
)

# add method specific args (if needed)
data$params <- list()

# write example dataset to file
file <- commandArgs(trailingOnly = TRUE)[[1]]
dynutils::write_h5(data, file)
