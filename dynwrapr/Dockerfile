FROM dynverse/dynbase:latest

MAINTAINER Robrecht Cannoodt "rcannood@gmail.com"

ARG GITHUB_PAT

# install common packages and dynwrap/dyncli
RUN R -e 'remotes::install_github("dynverse/dyntoy")' && \
	R -e 'remotes::install_github(c("dynverse/dynwrap", "dynverse/dyncli", "dynverse/dyndimred"), dependencies = TRUE)' && \
	rm -rf /tmp/* # clean up temp files
