# Plots logistic regression results
# for gene enrichment

plot_gene_log_reg <- function(DT, title = '', group = NULL, colors = NULL){
  if(is.null(group)){
    g <- ggplot(DT, aes(reorder(category, OR), OR))
    if(!is.null(colors))
      g <- g
  } else { 
    g <- ggplot(DT, aes(reorder(category, OR), OR, group = get(group), color = get(group))) + 
      labs(color = '')
  }
  g <- g + geom_point(position = position_dodge(width = .5)) + 
    geom_hline(yintercept = 1) + labs(x = 'Gene category', y = 'Odds Ratio', title = title) + 
    geom_errorbar(aes(ymin = ci_l, ymax = ci_h), position = position_dodge(.5), width = .2) +
    scale_y_log10() + annotation_logticks(side = 'l') +
    theme_cowplot() + theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = 'top')
  if(!is.null(colors))
    g <- g + scale_color_manual(values = colors)
  
  return(g)
}
