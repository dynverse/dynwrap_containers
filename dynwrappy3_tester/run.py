#!/usr/local/bin/python

import pandas as pd
import numpy as np
import sklearn.decomposition
import dynclipy

import time
checkpoints = {}

#####################################
###           LOAD DATA           ###
#####################################
task = dynclipy.main()

cell_ids = task["cell_ids"]
expression = task["expression"]
params = task["params"]

if "start_id" in task["priors"]:
  start_id = task["priors"]["start_id"]
else:
  start_id = None

checkpoints["method_afterpreproc"] = time.time()


#####################################
###        INFER TRAJECTORY       ###
#####################################
# do PCA
pca = sklearn.decomposition.PCA()
dimred = pca.fit_transform(expression)

# extract the component and use it as pseudotimes
pseudotime = dimred[:, params["component"]]
pseudotime = (pseudotime - pseudotime.min()) / (pseudotime.max() - pseudotime.min())

# flip pseudotimes using start_id
if start_id is not None:
  if pseudotime[start_id].mean():
    pseudotime = 1 - pseudotime

checkpoints["method_aftermethod"] = time.time()


#####################################
###     SAVE OUTPUT TRAJECTORY    ###
#####################################
output = dynclipy.wrap_data(cell_ids = cell_ids)
output.add_linear_trajectory(pseudotime = pd.Series(pseudotime, name = expression.index), do_scale_minmax = False)
output.add_dimred(dimred)
output.add_timings(checkpoints)

# save
dynclipy.write_output(
  output,
  task["output"]
)
