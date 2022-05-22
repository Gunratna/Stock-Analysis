# load packages
library(quantmod)
library(xts)
library(dplyr)

# Pull Tesla stock data

TSLA <- getSymbols('TSLA', auto.assign = F)

# convert our data frame into time series
tsla <- as.xts(TSLA)

# store our data into a csv file
write.csv(tsla, "newdata_tsla.csv") 

# get adjusted returns that are adjusted for any corporate action by the company
TSLA_ad <- Ad(tsla)

# get daily simple returns of the adjusted closed price
daily_ret <- dailyReturn(TSLA_ad, type = 'arithmetic') 

# for daily returns we need the present day price and previous day price
# previous day price can be obtained from lag function
options(scipen = 999)
lag <- stats::lag(TSLA_ad,1)
daily_change = 100*((TSLA_ad / lag) - 1)

hist(daily_change, 40, col = 'green')

# Creating a signal using for loop
# if daily change is greater than 4% or less than -4% and  then send us a signal

buy_signal <- 4
sell_signal <- -4 
signal <- c(NULL) # empty object

for (i in 2:length(TSLA_ad))
{
  if (daily_change[i] > buy_signal)
  {
    signal[i] <- 1 # BUY signal
  }
  else if (daily_change[i] > sell_signal)
  {
    signal[i] <- -1 # SELL signal
  }
  else
  {
    signal[i] <- 0
  }
}

signal <- reclass(signal, TSLA_ad) # change class of signal to the class of TSLA_ad i.e xts

#Plot the adjusted close value with the buy/sell filter
chartSeries(TSLA_ad, subset = '2020-01::2022-01', theme = chartTheme('white'))
addTA(signal, type = 's', col = 'red')
