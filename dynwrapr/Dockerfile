FROM rocker/tidyverse:3.5

MAINTAINER Robrecht Cannoodt "rcannood@gmail.com"

ARG GITHUB_PAT

# install hdf5 and ssh
RUN apt-get update && apt-get install -y --no-install-recommends libhdf5-dev libssh-dev && \
	rm -rf /var/lib/apt/lists/*

# set default repo to cran.rstudio.com, not MRAN
RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"));utils::setRepositories(ind=1:4)' >> /usr/local/lib/R/etc/Rprofile.site

# install common packages and dynwrap/dyncli
RUN R -e 'install.packages(c("devtools", "remotes"))' && \
	R -e 'install.packages(c("Rcpp", "RcppEigen", "RSpectra", "RcppArmadillo"), repos = "https://cloud.r-project.org/", verbose = TRUE, quiet = TRUE)' && \
	R -e 'remotes::install_bioc("S4Vectors", "SingleCellExperiment")' && \
	R -e 'remotes::install_github("dynverse/dyntoy")' && \
	R -e 'remotes::install_github(c("dynverse/dynwrap", "dynverse/dyncli", "dynverse/dyndimred"), dependencies = TRUE)' && \
	rm -rf /tmp/* # clean up temp files

# set several env variables so that
# rstan and similar packages will not misbehave
ENV OPENBLAS_NUM_THREADS=1
ENV NUMEXPR_NUM_THREADS=1
ENV MKL_NUM_THREADS=1
ENV OMP_NUM_THREADS=1

ENTRYPOINT ["/code/run.sh"]

CMD ["-h"]
