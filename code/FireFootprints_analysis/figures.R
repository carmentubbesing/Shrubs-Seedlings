fir_summary <- MyData_summary_simple
pine_summary <- MyData_summary_simple

brown <- "#5b3d07"

figure_summary <- ggplot()+
  labs(title = "Seedling volumetric growth")+
  ylab("relative growth rate (RGR)")+
  xlab("shrub cover 0-2 m from seedling")+
  geom_line(data = fir_summary, aes(y = pred_simple, x =(Cov1.2/800)*100), col = "#1b3f4c", size= 1.2)+
  geom_line(data = pine_summary, aes(y = pred_simple, x =(Cov1.2/800)*100), col = color, size = 1.2)+
  theme_bw()+
  xlim(c(0,130))+
  theme(plot.background = element_rect(fill = '#e9ebe8', colour = '#e9ebe8'),
        panel.background = element_rect(fill="#e9ebe8"),
        text = element_text(size=20, colour = brown),
        axis.text.x = element_text(colour=brown), 
        axis.text.y = element_text(colour=brown),
        panel.border = element_rect(colour = brown)
  )
  #scale_y_continuous(limits = c(0.3,0.8))
figure_summary

setwd("C:/Users/Carmen/Documents/Shrubs-Seedlings/results/figures")
pdf("fir_pine_RGR.pdf", width = 6, height = 7.25, pointsize = 30,useDingbats = F)
figure_summary
dev.off()
