# load packages
library(quantmod)
library(xts)
library(PerformanceAnalytics)

# Pull Microsoft and Facebook stock data

MSFT <- getSymbols('MSFT', auto.assign = F)
FB <- getSymbols('FB', auto.assign = F)

# convert our data frame into time series
msft <- as.xts(MSFT)
fb <- as.xts(FB) 

# store our data into a csv file
write.csv(msft, "newdata_msft.csv") 
write.csv(fb, "newdata_msft.csv") 

# get adjusted returns that are adjusted for any corporate action by the company
MSFT_ad <- Ad(msft)
FB_ad <- Ad(fb)

# get daily simple returns of the adjusted closed price
daily_MSFT <- dailyReturn(MSFT_ad, type = 'arithmetic') 
daily_FB <- dailyReturn(FB_ad, type = 'arithmetic') 

#plot(daily_MSFT, type = 'l') 
#plot(daily_FB, type = 'l') 

# Merge both data frames
# we want to show the data only when both companies were traded(to avoid NA values) as microsoft came before facebook
comb <- merge(daily_MSFT, daily_MSFT, all = F) 
charts.PerformanceSummary(comb, main = 'FB vs MSFT')
