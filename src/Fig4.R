# Script to make Fig 4, regarding Aberrant Splicing
# author: vyepez


source('src/config.R')
source('src/functions/gene_enrichment_plots.R')


# Read and plot panel A
splN <- readRDS('Data/AS_a.Rds')

p1 <- ggplot(splN, aes(variable, value+1)) + geom_boxplot(aes(color = type)) + 
  scale_y_continuous(trans = "log10", labels = c('0', '3', '10', '30'), breaks = c(1, 4, 11, 31)) +
  labs(y = 'Splicing outliers \nper sample', x = '') + theme_cowplot() + guides(color = F) +
  grids(axis = 'y', color = 'gray82') + scale_color_manual(values = c(color_spl_outlier))


# Read and plot panel B
gf <- readRDS('Data/AS_b.Rds')

p2 <- ggplot(gf, aes(rare_var_type, prop, fill = outlier_class)) + 
  geom_bar(stat= 'identity', position = 'dodge') + 
  geom_errorbar(aes(ymin = ci_l, ymax = ci_h), position = position_dodge(.9), width = .3) + 
  scale_fill_manual(values = color_spl) +
  scale_y_continuous(labels = scales::percent) +
  theme_cowplot(font_size = 14) + theme(legend.position=c(.25,.9)) +
  labs(x = '', y = 'Proportion of genes per \nsample with a WES rare variant', fill = '') +
  ggforce::facet_row(vars(group), scales = 'free', space = 'free') +
  background_grid(major = 'y', minor = 'y')


# Read and plot panel C
rf <- readRDS('Data/AS_c.Rds')
p4 <- plot_gene_log_reg(rf, '', group = 'out_class', colors = color_spl_outlier) + 
  theme(legend.position = 'none') + 
  background_grid(major = 'y') + annotation_logticks(side = 'l')

# Read and plot panel D
dt <- readRDS('Data/AS_volcano.Rds')
type <- 'psi5'
g <- 'TWNK'
main <- bquote(paste(italic(.(g)), ", first acceptor site"))

g3 <- ggplot(dt, aes(x = deltaPsi, y = -log10(pval), color = aberrant, label = featureID)) + 
  geom_point(aes(alpha = ifelse(aberrant == TRUE, 1, 0.8))) + 
  xlab(as.expression(bquote(paste(Delta, .(FRASER:::ggplotLabelPsi(type)[[1]]))))) + 
  ylab(expression(paste(-log[10], "(P value)"))) + theme_cowplot(font_size = 14) + background_grid() +
  theme(legend.position = "none", plot.title = element_text(face = 'plain', size = rel(1))) + ggtitle("Sample R36605") + 
  scale_color_manual(values = c("gray40", "firebrick")) +
  geom_text_repel(data = subset(dt, featureID %in% g), fontface = 'bold', hjust = -.3, vjust = -.3)

# Read and plot panel E
dtk <- readRDS('Data/AS_KN.Rds')

g4 <- ggplot(dtk, aes(x = n, y = k, color = aberrant, label = sampleID)) + 
  geom_point(alpha = ifelse(as.character(dtk$aberrant) == "TRUE", 1, 0.7)) + 
  scale_x_log10() + scale_y_log10() + annotation_logticks(sides = 'bl') +
  theme_cowplot(font_size = 14) + background_grid() + 
  theme(legend.position = "none", plot.title = element_text(face = 'plain', size = rel(1))) + 
  xlab("Total junction coverage (N)") + ylab("Junction count (K)") + 
  ggtitle(main) + scale_colour_manual(values = c("gray70", "firebrick")) +
  geom_text_repel(data = subset(dtk, sampleID %in% 'R36605'), aes(col = aberrant),
                  fontface = 'bold', hjust = -.2, vjust = -.2)

# Create the panels and full plot
plot_top <- plot_grid(p1, p2, nrow = 1, labels = 'AUTO', rel_widths = c(1, 3))
plot_bottom <- plot_grid(p4, g4, g3, NULL, nrow = 1, labels = c('C', 'D', 'E', 'F'), rel_widths = c(1, .8, .8, 1.25))
plot_full <- plot_grid(plot_top, plot_bottom, ncol = 1)
plot_full
save_plot('figs/fig4_AS.png', plot_full, base_height = 7, base_width = 15)

