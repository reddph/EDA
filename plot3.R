wd <- getwd()

if(!grepl("/ExploratoryAnalysis",wd))
{
    if(!file.exists(file.path("./ExploratoryAnalysis")))
    {
        dir.create("./ExploratoryAnalysis")    
    }
    
    setwd("./ExploratoryAnalysis/")
}

if(!file.exists(file.path("./exdata_data_household_power_consumption.zip")))
{
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                  destfile = "./exdata_data_household_power_consumption.zip")
}

if(!file.exists(file.path("./household_power_consumption.txt")))
{
    unzip("./exdata_data_household_power_consumption.zip")        
}

if(!file.exists(file.path("./powerConsumption.rda")))
{
    household_power_consumption <- read.csv("./household_power_consumption.txt", sep=";", na.strings="?")
    save(household_power_consumption,file="./powerConsumption.rda")    
} else
{
    load(file="./powerConsumption.rda")
}

#Filter data samples between 2007-02-01 and 2007-02-02 is used

library(lubridate)
library(dplyr)
library(png)

names(household_power_consumption)
summary(household_power_consumption)

household_power_consumption <- mutate(household_power_consumption,DMY=dmy(Date))

filtHPC <- filter(household_power_consumption, year(DMY) == 2007 & month(DMY) == 2 & day(DMY) %in% c(1,2))

filtHPC <- mutate(filtHPC, WDAY=wday(DMY))

# Compile a integer sequence for consecutive time sample ids
tbase <- 1:length(filtHPC$Time)

# Compile a static vector of week day labels abbreviated to three letters
WeekDays <- c("Sun","Mon","Tue","Wed","Thu","Fri","Sat")

# Get 1-based week day enumeration 
myDays <- unique(filtHPC$WDAY)
numDays <- length(unique(filtHPC$WDAY))

# To get the last day in x-axis label, we need 0-based week day enumeration to use 
# modulus operator
myDays <- myDays - 1 
dayN <- myDays[length(myDays)]

# Compute 1-based last day label for x-axis 
lastDay <- (dayN + 1) %% 7 + 1

wdaySeq <- unique(filtHPC$WDAY)
wdaySeq <- append(wdaySeq,lastDay)

wdayLabelSeq <- WeekDays[wdaySeq]

# Compute x-axis break points for inserting wday x-axis labels
axisBreaks <- seq(from=1,to=length(tbase),by=(length(tbase)/numDays)-1)

png(filename="plot3.png", width=480, height=480, units="px")

plot(tbase, filtHPC$Sub_metering_1, ylab="Energy sub metering", type='l', xaxt="n", xlab="", ylim=c(min(filtHPC$Sub_metering_1),max(filtHPC$Sub_metering_1)))
par(new=TRUE)
plot(tbase, filtHPC$Sub_metering_2, ylab="Energy sub metering", type='l', xaxt="n", xlab="", ylim=c(min(filtHPC$Sub_metering_1),max(filtHPC$Sub_metering_1)),col="Red")
par(new=TRUE)
plot(tbase, filtHPC$Sub_metering_3, ylab="Energy sub metering", type='l', xaxt="n", xlab="", ylim=c(min(filtHPC$Sub_metering_1),max(filtHPC$Sub_metering_1)),col="Blue")
axis(1, c(1,1439,2879), c("Thu","Fri","Sat"))
legend.size <- legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1),lwd=c(1.5,1.5,1.5),col=c("black","red","blue"))

dev.off() 