# Script to make Fig 8, regarding the expressed genes across GTEx tissues
# author: vyepez

source('src/config.R')

# Read and plot panel A
EXP_DT <- readRDS('Data/gtex_a.Rds')
g1 <- ggplot(EXP_DT ,aes(aux, Tissue_specific, fill = exp_cat,  col = CAT)) + geom_tile(size = .5) + 
  scale_fill_manual(values = c('#ffffe0', '#cae4c9', '#97c8b3', '#68ab9e', '#3a8e8b', '#0e707a')) + 
  scale_color_manual(values = c("firebrick"), guide = F) +
  theme_cowplot(font_size = 14) + theme(axis.text.x = element_text(angle = 90)) +
  labs(x = 'Gene category', y = 'Tissue', fill = 'Proportion of \nexpressed genes') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 13), 
        axis.title = element_blank(), axis.text.y = element_text(size=10),
        legend.position = 'top', legend.spacing.x = unit(.15,"cm"),  
        legend.text = element_text(size = 12), legend.title = element_text(size = 12))

# Read and plot panel B
ACC_DT <- readRDS('Data/gtex_b.Rds')
g2 <- ggplot(ACC_DT, aes(Tissue, expressed, color = DISEASE, group = DISEASE)) + geom_point() + geom_line() + 
  theme_cowplot(font_size = 14) + theme(legend.position = c(.7,.3)) + background_grid() +
  labs(color = "", y = 'Proportion of \nexpressed genes', x = 'Cinically accessible tissue') + 
  scale_y_continuous(labels=scales::percent, limits = c(0,1)) +
  scale_color_manual(values = c("black", "gray70", "#729E93", "#D9682B", "#699CB6", "#485178", "#A47443", "#985A71", "darkolivegreen3")) + 
  scale_x_discrete(guide = guide_axis(n.dodge=2))

g_gtex <- plot_grid(g1, g2, labels = LETTERS, axis = 'tb', align = 'h', rel_widths = c(1.1, 1))
save_plot('figs/fig8_gtex.png', g_gtex, base_height = 9, base_width = 14)
