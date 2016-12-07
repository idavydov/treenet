#!/usr/bin/Rscript
set.seed(1)
N=1000
m0 <- data.frame(
  k=1+rexp(N,1),
  w=rexp(N,1),
  ncodons=sample(100:1000,N,replace=T),
  nseq=sample(8:15,N,replace=T),
  tlen=rgamma(N,2,1/2),
  row.names=sprintf('d%04d', 1:N)
)

write.table(m0, file='data/m0.txt', sep=',', quote = F)


m0.long <- reshape(m0, varying = names(m0),
                   v.names='value', timevar='variable', times=names(m0), direction = 'long')
library(ggplot2)


pdf('res/m0_dist.pdf', width=10, height=6)
ggplot(m0.long, aes(value)) +
  geom_histogram() +
  geom_histogram(data=subset(m0.long, variable=='nseq'), binwidth=1) +
  facet_wrap( ~ variable, scales="free_x") +
  theme_bw() + theme(panel.grid=element_blank())
dev.off()

