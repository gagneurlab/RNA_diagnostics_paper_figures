# Script to make Fig 6, regarding the variants called in RNA-seq data
# author: vyepez

source('src/config.R')

# Read and plot panel A
RNA_prop_vars <- readRDS('Data/RNA_var_a.Rds')

g2 <- ggplot(RNA_prop_vars, aes(var_type, prop, fill = Called)) + geom_bar(stat = 'identity') + 
  theme_cowplot(font_size = 14) + theme(legend.position = 'top') + 
  scale_fill_manual(values = c("#A2A475", "#02401B", "#D8B70A")) +
  labs(x='Classes of variants ', y='Proportion of variants detected', fill = '') +
  scale_x_discrete(guide = guide_axis(n.dodge=2))

save_plot('figs/fig6_rna_var.png', g2, base_height = 9, base_width = 7)