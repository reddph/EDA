setwd("./ExploratoryDataAnalysis/")
unzip("./exdata_data_household_power_consumption.zip")

household_power_consumption <- read.csv("~/R_Practice/ExploratoryDataAnalysis/household_power_consumption.txt", sep=";", na.strings="?")

#Only data between 2007-02-01 and 2007-02-02 is used

library(lubridate)
library(dplyr)
library(png)

names(household_power_consumption)
summary(household_power_consumption)

household_power_consumption <- mutate(household_power_consumption,DMY=dmy(Date))

filtHPC <- filter(household_power_consumption, year(DMY) == 2007 & month(DMY) == 2 & day(DMY) %in% c(1,2))

filtHPC <- mutate(filtHPC, WDAY=wday(DMY))
tbase <- 1:length(filtHPC$Time)

png(filename="plot3.png", width=480, height=480, units="px")

plot(tbase, filtHPC$Sub_metering_1, ylab="Energy sub metering", type='l', xaxt="n", xlab="", ylim=c(min(filtHPC$Sub_metering_1),max(filtHPC$Sub_metering_1)))
par(new=TRUE)
plot(tbase, filtHPC$Sub_metering_2, ylab="Energy sub metering", type='l', xaxt="n", xlab="", ylim=c(min(filtHPC$Sub_metering_1),max(filtHPC$Sub_metering_1)),col="Red")
par(new=TRUE)
plot(tbase, filtHPC$Sub_metering_3, ylab="Energy sub metering", type='l', xaxt="n", xlab="", ylim=c(min(filtHPC$Sub_metering_1),max(filtHPC$Sub_metering_1)),col="Blue")
axis(1, c(1,1439,2879), c("Thu","Fri","Sat"))
legend.size <- legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1),lwd=c(1.5,1.5,1.5),col=c("black","red","blue"))

dev.off() 