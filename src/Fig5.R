# Script to make Fig 5, regarding MAE
# author: vyepez

source('src/config.R')
source('src/functions/gene_enrichment_plots.R')

# Read and plot panel A
cascade_dt <- readRDS('Data/MAE_a.Rds')
p1 <- ggplot(cascade_dt, aes(variable, value+1)) + geom_boxplot() +
  labs(y = 'Heterozygous SNVs \n per sample', x = '') +
  annotation_logticks(sides = "l") + 
  scale_x_discrete(guide = guide_axis(n.dodge=2)) +
  scale_y_continuous(trans = "log10", labels = c('0', '10', '100', '1000', '10000'), breaks = c(1, 11, 101, 1001, 10001)) +
  theme_cowplot(font_size = 14) + background_grid(major = 'y', minor = 'y')

# Read and plot panel B
rv <- readRDS('Data/MAE_b.Rds')

p4 <- plot_gene_log_reg(rv, group = 'out_class', colors = 'black') +
  theme(legend.position = 'none', plot.title = element_blank()) +
  background_grid(major = 'y') + labs(x = 'Gene category')


# Read and plot panel C
ma_data <- readRDS('Data/MAE_c.Rds')
p5 <- ggplot(ma_data, aes(totalCount, altRatio, label = var)) + geom_point(aes(col = class), size = 1, alpha = .7) +
  geom_text_repel(hjust = -.2, vjust = -.2, fontface = 'bold') +
  theme_cowplot(font_size = 14) + background_grid() +
  annotation_logticks(sides = 'b') + scale_x_log10() + #scale_y_log10() +
  theme(legend.title = element_blank(), legend.position = c(0.7, 0.85)) +
  scale_color_manual(values = c("chocolate1", "firebrick", "gray61")) +
  labs(x = 'RNA Coverage per heterozygous SNV', 
       y = 'Alternative allele ratio')


# Create the panels and full plot
plot_top <- plot_grid(p1, p4, nrow = 1, labels = 'AUTO', rel_widths = c(1, .75))
plot_bottom <- plot_grid(p5, NULL, NULL, nrow = 1, 
                         labels = c('C', '', 'D'), rel_widths = c(.95, .05, .75)) # Leave a small space between C and D
plot_full <- plot_grid(plot_top, plot_bottom, ncol = 1)

save_plot('figs/fig5_MAE.png', plot_full, base_height = 7, base_width = 9)