FROM rocker/tidyverse:3.5

MAINTAINER Robrecht Cannoodt "rcannood@gmail.com"

# install hdf5
RUN apt-get update && apt-get install -y libhdf5-dev libssh-dev

# install common packages
RUN echo 'utils::setRepositories(ind=1:4)' > ~/.Rprofile
RUN R -e 'install.packages(c("Rcpp", "RcppEigen", "RSpectra", "RcppArmadillo"), repos = "https://cloud.r-project.org/", quiet = TRUE)' && \
  R -e 'devtools::install_github("dynverse/dyndimred", dependencies = TRUE)' && \
  R -e 'devtools::install_github("dynverse/dynwrap", dependencies = TRUE)' && \
  rm -rf /tmp/*

# set several env variables so that
# rstan and similar packages will not misbehave
ENV OPENBLAS_NUM_THREADS=1
ENV NUMEXPR_NUM_THREADS=1
ENV MKL_NUM_THREADS=1
ENV OMP_NUM_THREADS=1

# set default command
CMD ["R", "--no-save"]
