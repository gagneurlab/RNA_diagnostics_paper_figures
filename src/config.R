suppressPackageStartupMessages({
  library(cowplot)
  library(data.table)
  library(ggplot2)
  library(ggthemes)
  library(ggforce)
  library(ggsci)
  library(ggpubr)
  library(ggrepel)
  library(magrittr)
})

color_spl_outlier <- '#451970'  # dark purple
color_spl <- c("gray80", color_spl_outlier)

color_under_exp <- "#8E0152"
color_over_exp <- "#276419"
color_non_outlier <- 'gray80'
color_exp <- c(color_under_exp, color_non_outlier, color_over_exp)