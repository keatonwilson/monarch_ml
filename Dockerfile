## Dockerfile for Monarch ML Project

## start with the Docker 'R-base' Debian-based image
FROM rocker/r-base:latest

## maintainer
MAINTAINER Keaton Wilson <keatonwilson@me.com>

## Remain current
RUN apt-get update -qq \
&& apt-get dist-upgrade -y

## additional build dependencies
RUN apt-get install -y --no-install-recommends -t unstable \
            bwidget \
      ca-certificates \
      curl \
      gdal-bin \
      git \
      gsl-bin \
      libcurl4-openssl-dev \
      libgdal-dev \
      libgeos-dev \
      libgeos++-dev \
      libproj-dev \
      libspatialite-dev \
      libssl-dev \
      libudunits2-dev \
      libv8-dev \
      libxml2-dev \
      netcdf-bin \
      pandoc pandoc-citeproc \
      qpdf \
      r-cran-rgl \
      r-cran-tkrplot \
      xauth \
      xfonts-base \
      xvfb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/apt/lists
  
## install devtools
RUN install2.r devtools remotes

#Adding project files to new directory
RUN mkdir /projects

ADD . /projects

#R Packages
RUN xvfb-run -a install.r \
      tidyverse \
      caret \
      geoR \
      ggmap \
      ggvis \
      gstat \
      mapdata \
      maps \
      maptools \
      plotKML \
      RandomFields \
      rgdal \
      rgeos \
      sf \
      shapefiles \
      sp \
      spatstat \
      raster \
      rasterVis \
      rts \
      synthpop \
&& installGithub.r s-u/fastshp \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds
