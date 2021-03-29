# Script to make Fig 3, regarding Aberrant Expression
# author: vyepez


source('src/config.R')
source('src/functions/gene_enrichment_plots.R')


# Read and plot panel A
outN <- readRDS('Data/AE_a.Rds')

p1 <- ggplot(outN[outlier_class != 'Combined'], aes(variable, value + 1)) + geom_boxplot(aes(color = outlier_class)) + 
  scale_y_continuous(trans = "log10", labels = c('0', '3', '10', '30'), breaks = c(1, 4, 11, 31)) +
  labs(y = 'Expression outliers \n outliers per sample', x = '', fill = '') + theme_cowplot() +  
  grids(axis = 'y', color = 'gray82') + scale_color_manual(values = c(color_under_exp, color_over_exp)) +
  guides(color = F) + facet_grid(~outlier_class)

# Read and plot panel B
gf <- readRDS('Data/AE_b.Rds')

p2 <- ggplot(gf, aes(rare_var_type, prop, fill = outlier_class)) + 
  geom_bar(stat= 'identity', position = 'dodge') + 
  geom_errorbar(aes(ymin = ci_l, ymax = ci_h), position = position_dodge(.9), width = .3) + 
  scale_fill_manual(values = color_exp) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1L)) + 
  theme_cowplot(font_size = 14) + theme(legend.position=c(.8,.8)) +
  labs(x = '', y = 'Proportion of genes per \nsample with a rare WES variant', fill = '') +
  ggforce::facet_row(vars(group), scales = 'free', space = 'free') +
  background_grid(major = 'y', minor = 'y')


# Read and plot panel C
rb <- readRDS('Data/AE_c.Rds')
p4 <- plot_gene_log_reg(rb, group = 'out_class', colors = c(color_under_exp, color_over_exp)) + 
  theme(legend.position = 'none') + 
  background_grid(major = 'y') + annotation_logticks(side = 'l') 

# Read and plot panel D
dt <- readRDS('Data/AE_volcano.Rds')

g1 <- ggplot(dt, aes(zScore, -log10(pValue), color = aberrant, label = GENE_ID)) + geom_point() + 
  theme_cowplot(font_size = 14) + xlab("Z-score") + background_grid() +
  ylab(expression(paste(-log[10], "(", italic(P), "-value)"))) + 
  ggtitle('Sample R20754') + scale_color_manual(values = c('gray', 'firebrick')) + 
  theme(legend.position = "none", plot.title = element_text(face = 'plain', size = rel(1))) +
  geom_text_repel(data = subset(dt, GENE_ID %in% 'UFM1'), 
                  fontface = 'bold', hjust = -.2, vjust = -.2)

# Read and plot panel E
dt <- readRDS('Data/AE_counts.Rds')

g2 <- ggplot(data = dt, aes(x = norm_rank, y = counts, label = sampleID)) + 
  geom_point(size = 2, aes(col = aberrant)) +
  labs(title = main, x = "Sample rank", y = "Normalized Counts") + 
  theme_cowplot(font_size = 14) + background_grid() + scale_y_log10() + annotation_logticks(sides = 'l')  + 
  scale_color_manual(values = c("gray", "firebrick")) + 
  theme(legend.position = "none", plot.title = element_text(face = 'plain', size = rel(1))) +
  geom_text_repel(data = subset(dt, sampleID %in% 'R20754'), aes(col = aberrant),
                  fontface = 'bold', hjust = -.2, vjust = -.2)

# Create the panels and full plot
# Ensemble plot
plot_top <- plot_grid(p1, p2, nrow = 1, labels = 'AUTO', rel_widths = c(1, 3))
plot_bottom <- plot_grid(p4, g1, g2, NULL, nrow = 1, labels = c('C', 'D', 'E', 'F'), rel_widths = c(.8, .7, .7, 1))
plot_full <- plot_grid(plot_top, plot_bottom, ncol = 1)
plot_full
save_plot('figs/fig3_AE.png', plot_full, base_height = 7, base_width = 15)

