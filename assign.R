
library("readxl")
library(ggplot2)
library(pastecs)
library(psych)
library(dplyr)
library(tseries)
library(knitr)
df <- read_excel("house.xlsx")

# Data description 
dim(df)
str(df)

# Dependent Variable
summary(df$price_of_unit_area)
res <- stat.desc(df$price_of_unit_area)
round(res, 2)
describe(df$price_of_unit_area,type=1)
mx <- mean(df$price_of_unit_area)
# Histogram of Dependent Variable
hist(df$price_of_unit_area,xlab="price per unit area",main = "Histogram of Price per unit area")
abline(v = mx, col = "blue", lwd = 2)


# Independent Variable
summary(df$distance_mrt)
res <- stat.desc(df$distance_mrt)
round(res, 2)
describe(df$distance_mrt,type=1)
mx <- mean(df$distance_mrt)
# Histogram of Independent Variable
hist(df$distance_mrt,xlab="Nearest distance to a MRT station",main = "Histogram of the neastest distance to a MRT Station")
abline(v = mx, col = "blue", lwd = 2)




# Linear Regression
plot(df$distance_mrt,df$price_of_unit_area , xlab="nearest distance to MRT", ylab="price per unit area") 
mod1 <- lm(price_of_unit_area ~ distance_mrt, data = df)
# Estimates
b1 <- coef(mod1)[[1]]
b2 <- coef(mod1)[[2]]
# Summary of the model
smod1 <- summary(mod1)
smod1 
# Scatter Plot along with regression
plot(df$distance_mrt, df$price_of_unit_area, xlab="nearest distance to MRT", ylab="price per unit area", type = "p")
abline(b1,b2,col = "red") 
# Residual Plot
plot(mod1$fit,mod1$residuals)


#Log transformations
hist(df$price_of_unit_area, col='grey')
hist(log(df$price_of_unit_area),xlab="price per unit area",main = "Histogram of Log transformed Price per unit area", col='grey')
hist(df$distance_mrt, col='grey')
hist(log(df$distance_mrt),xlab="Nearest distance to a MRT station",main = "Histogram of Log transformed neastest distance to a MRT Station", col='grey')

plot(log(df$distance_mrt),df$price_of_unit_area , xlab="nearest distance to MRT", ylab="price per unit area") 
plot(df$distance_mrt,log(df$price_of_unit_area) , xlab="nearest distance to MRT", ylab="price per unit area") 
plot(log(df$distance_mrt),log(df$price_of_unit_area) , xlab="nearest distance to MRT", ylab="price per unit area", main = "Log-Log transformed scatter plot") 

#Linear-Log Model
mod2 <- lm(df$price_of_unit_area~log(df$distance_mrt), data=df) 
summary(mod2)
b1 <- coef(mod2)[[1]]
b2 <- coef(mod2)[[2]]

# Log-Linear Model
mod3 <- lm(log(df$price_of_unit_area)~df$distance_mrt, data=df) 
summary(mod3)
b1 <- coef(mod3)[[1]]
b2 <- coef(mod3)[[2]]


#Log-Log Model
#This is used for this data
mod4 <- lm(log(df$price_of_unit_area)~log(df$distance_mrt), data=df) 
summary(mod4)
b1 <- coef(mod4)[[1]]
b2 <- coef(mod4)[[2]]
se_b1 <- summary(mod4)$coefficients[1,2]
se_b2 <- summary(mod4)$coefficients[2,2]

# Regression line on the scatter plot 
plot(df$distance_mrt, df$price_of_unit_area, xlab="nearest distance to MRT", ylab="price per unit area", type = "p", main = "Scatter plot with Regression Line", col = "darkgrey")
f1 <- function(t) exp(b1)*t^(b2)
curve(f1, from = 0, to = 7000,add = TRUE, col = "red", lwd = 1.2)
f2 <- function(t) exp(b1+1.96*se_b1)*t^(b2+1.96*se_b2)
curve(f2, from = 0, to = 7000,add = TRUE, col = "red", lwd = 1.2, lty = 'dotted')
f3 <- function(t) exp(b1-1.96*se_b1)*t^(b2-1.96*se_b2)
curve(f3, from = 0, to = 7000,add = TRUE, col = "red", lwd = 1.2, lty = 'dotted')
polygon(f2,f3, col = "skyblue")


# Prediction on the median Value
med <- median(df$distance_mrt)
med
newdf <- filter(df,df$distance_mrt == med)
mxn <- mean(newdf$price_of_unit_area)
mxn
yest <- exp(b1)*med^(b2)
yest
plot(df$distance_mrt, df$price_of_unit_area, xlab="nearest distance to MRT",
     ylab="price per unit area", col = "darkgrey",yaxt = 'n',
     main = "Prediction based on the median value of the nearest distance to MRT variable")
abline(yest,0,col = "lightgrey")
abline(v=med,col = "lightgrey")
ticks = c(492)
at1 <- c(20,37.26682,60,80,100,120)
l <- format(at1, format = "f", digits = 2)
axis(side = 1, at = ticks)
axis(side = 2, at1, labels = l)
points(x = newdf$distance_mrt, y = newdf$price_of_unit_area,col = "red", pch = 20)
f1 <- function(t) exp(b1)*t^(b2)
curve(f1, from = 0, to = 7000,add = TRUE, col = "red", lwd = 1.2)
f2 <- function(t) exp(b1+1.96*se_b1)*t^(b2+1.96*se_b2)
curve(f2, from = 0, to = 7000,add = TRUE, col = "red", lwd = 1.2, lty = 'dotted')
f3 <- function(t) exp(b1-1.96*se_b1)*t^(b2-1.96*se_b2)
curve(f3, from = 0, to = 7000,add = TRUE, col = "red", lwd = 1.2, lty = 'dotted')
points(x = med, y = yest,col = "black", pch = 20)
points(x = med, y = mxn,col = "green", pch = 20)

# Residual Anaylsis
res <- resid(mod4)
plot(df$distance_mrt, res, xlab="Distane from MRT", ylab="residuals",main ="Residual Plot") 
abline(0,0)
qqnorm(res)
qqline(res) 
plot(density(res), main = "Density Plot of the residuals")
acf(res, main = "ACF of residuals")
resbar <- mean(res)
sde <- sd(res)
hist(res, col="grey", freq=FALSE, main="", ylab="density", xlab="Residuals")
curve(dnorm(x, resbar, sde), col=2, add=TRUE, ylab="density", xlab="Residuals")
jarque.bera.test(res) 

# Calculation of SSE,SSR,SST
anov <- anova(mod4)
dfr <- data.frame(anov)
kable(dfr, caption="Output generated by the `anova` function") 
SSE <- anov[2,2]
SSE
SSR <- anov[1,2]
SSR
SST <- SSR + SSE
SST


# SST <- sum((mean(df$price_of_unit_area)-df$price_of_unit_area )^2)
# SSR <- sum((predict(mod4)-mean(df$price_of_unit_area))^2)
# SSR_exp <- sum((exp(predict(mod4))-mean(df$price_of_unit_area))^2)
# SSE <- sum((predict(mod4)-df$price_of_unit_area)^2)
# SSE_exp <- sum((exp(predict(mod4))-df$price_of_unit_area)^2)



plot(df$transaction_date,df$price_of_unit_area , xlab="Transaction Date", ylab="price per unit area") 
abline(60,0,col = "lightgrey")

plot(df$no_of_stores,df$price_of_unit_area , xlab="No of stores nearby", ylab="price per unit area") 
abline(60,0,col = "lightgrey")
abline(40,0,col = "lightgrey")
abline(20,0,col = "lightgrey")


points = plt.scatter(df$latitude, df$longitude, c=df$price_of_unit_area,cmap="jet", lw=0)
plt.colorbar(points)




