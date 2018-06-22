library(dplyr)

library(tidyr)

iris.wide <- iris %>%
  gather(key, value, -Species, -Flower) %>%
  separate(key, c("Part", "Measure"), "\\.") %>%
  spread(Measure, value)

library(ggplot2)

# Using ggplot is easy!

# the first argument is the data set you want to plot with
# ggplot(cars, ...
#
# next, you want to map variables to 'aesthetics' like the axes
# ggplot(cars, aes(x=speed, y=distance)) ...
#
# finally, add your geometry of choice to the plot. here we use a histogram.

ggplot(cars, aes(x=speed)) + geom_histogram()

# Density Plot

ggplot(cars, aes(x=speed)) + geom_density(alpha = .3)

# Overlayed density plots

# how we will divide the distribution
cars$far <- cars$dist > 36
cars$fast <- cars$speed > 15

# fill is used to group the overlay
ggplot(cars, aes(x = speed, fill=as.factor(cars$far)))
  # add an alpha channel so the overlays don't obscure each other
  + geom_density(alpha = .3)
  # rename legend title
  + guides(fill=guide_legend("dist > 36"))

# Other grammar includes facet, statistical, coordinate, and theme elements

# Faceted Histogram, with a title

ggplot(cars, aes(x=speed)) + geom_histogram() + facet_wrap(~far) + ggtitle("Speed Distribution by whether car went far")

# also 'geom_dotplot', 'geom_boxplot', 'geom_line', and 'geom_point'
# 'geom_jitter'

# Aesthetics

# x and y
# color, fill: factors / categorical variables
# size: continuous variables

# Boxplot
bp <- ggplot(cars, aes(x=far, y=speed)) + geom_boxplot()
bp

# use coord_flip to flip axis labels, if necessary
bp + coord_flip()

# theming options exist to rotate labels without flipping graph axes
bp + theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Scatterplot

sp <- ggplot(cars, aes(x=speed, y=dist)) + geom_point()
sp

# with overlayed contours

mtcars %>% ggplot(aes(x=hp, y=mpg)) +
  geom_point() +
  stat_density_2d(aes(alpha=..level.., fill=..level..), geom="polygon") +
  scale_fill_gradient(low = "white", high = "black", guide = FALSE) +
  scale_alpha(range = c(0.00, 0.4), guide = FALSE)

#  geom_density_2d(color="red") +
#  theme(panel.background = element_rect(fill="black", color="gray"),
#        plot.background = element_rect(fill="black", color="gray"),
#        panel.grid.major = element_line(color="black"),
#        panel.grid.minor = element_line(color="black"))

#  geom_smooth(method="lm", se=FALSE, formula="y ~ x", aes(group=1)) +
#  stat_smooth()

# Facet grids, with labelling

ggplot(cars, aes(x=speed)) + geom_density() + facet_grid(far ~ fast, labeller=label_both)

# to account for skew in a distribution:
#  - use log or sqrt for right-skewed distributions
#      scale_x_log10, scale_y_log10
#  - use power function for left-skewed distributions

# expand_limits()

# mutate, filter, group_by, factor, droplevels, sample_n

# proportional bar chart: geom_bar(position="fill")

# cluster, stratified, multistage samples
# use group_by and sample_n to do a stratified sample

# blocking is used to eliminate the effect of confounding variables
# members with different pre-treatment values are grouped into blocks

# Calculating a p-value

## With a normal distribution, two sided test

a <- 6.5
v <- 3.8
n <- 200
xbar <- 7
z <- (xbar-a) / sqrt(v/n)
2*pnorm(-abs(z))
# also with args
2*(1-pnorm(xbar, mean=a, sd=sqrt(v/n)))