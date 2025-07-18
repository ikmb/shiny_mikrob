FROM rocker/r-ver:4.5.1

LABEL maintainer="olga.brovkina@ikmb.de"

# System dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libpng-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN install2.r --error \
    shiny \
    rmarkdown \
    ggplot2 \
    dplyr \
    tidyr \
    readr \
    stringr \
    phyloseq \
    vegan \
    png \
    cowplot \
    reshape2 \
    scales \
    jsonlite \
    rlang \
    htmltools \
    ggpubr \
    magrittr \
    data.table \
    RColorBrewer

# Set work directory
WORKDIR /mikrob

# Copy project files (modify as needed)
COPY . /mikrob

EXPOSE 3838

CMD ["R", "-e", "rmarkdown::run('shiny_mikrob.Rmd', shiny_args = list(host='0.0.0.0', port=3838))"]