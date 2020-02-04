#Starting after Chunk 25, AKA mutate(DIFN = max(DIFN))

test <- df %>% filter(!is.na(HTLCB)) 
test <- df %>% filter(HTLCB>0)
test <- test %>% filter(Species %in% c("ABCO", "PIPO"))
ggplot(test, aes(x = Ht.cm, y = HTLCB, col = Species))+
  geom_point()+
  geom_smooth(method = "lm")+
  geom_abline(aes(intercept = 0, slope = .5))

lm <- lm(HTLCB ~ Ht.cm + Species + BasDia.cm, data = test)
