FROM rocker/tidyverse:3.6.1

MAINTAINER Robrecht Cannoodt "rcannood@gmail.com"

ARG GITHUB_PAT

# install hdf5 and ssh
RUN apt-get update && apt-get install -y --no-install-recommends libhdf5-dev libssh-dev && \
	rm -rf /var/lib/apt/lists/*

# set several env variables so that
# rstan and similar packages will not misbehave
ENV OPENBLAS_NUM_THREADS=1
ENV NUMEXPR_NUM_THREADS=1
ENV MKL_NUM_THREADS=1
ENV OMP_NUM_THREADS=1

# set default repo to cran.rstudio.com, not MRAN
RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"));utils::setRepositories(ind=1:4)' >> /usr/local/lib/R/etc/Rprofile.site

# install common packages and dynwrap/dyncli
RUN R -e 'install.packages("tidyverse")' && \
	R -e 'install.packages(c("Rcpp", "RcppEigen", "RSpectra", "RcppArmadillo"), verbose = TRUE, quiet = TRUE)' && \
    R -e 'install.packages("BiocManager");BiocManager::install()' && \
	R -e 'BiocManager::valid()' && \
	R -e 'BiocManager::install(c("BiocGenerics", "S4Vectors", "SummarizedExperiment", "SingleCellExperiment"))' && \
	rm -rf /tmp/* # clean up temp files

ENTRYPOINT ["/code/run.sh"]

CMD ["-h"]
