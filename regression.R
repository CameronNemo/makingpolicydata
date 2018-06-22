library(dplyr)
library(lmtest)
library(sandwich)
library(ggplot2)

data %>% lm(formula="Age ~ Ideology", data=.) %>% coeftest(vcovHC)

data %>% na.omit %>% ggplot(aes(x=as.factor(Ideology), y=Age)) +
  geom_boxplot(fill="black", alpha=0.2) +
  geom_smooth(method="lm", se=FALSE, formula="y ~ x", aes(group=1)) +
  xlab("Ideology")

data %>% na.omit %>% ggplot(aes(x=Age, y=Ideology, color=PartyID)) + geom_point() + facet_wrap(~Race) + geom_smooth(method="lm", se=FALSE, formula="y ~ x", aes(group=1))

