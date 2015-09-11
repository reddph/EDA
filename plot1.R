wd <- getwd()

if(!grepl("/ExploratoryAnalysis",wd))
{
    if(!file.exists(file.path("./ExploratoryAnalysis")))
    {
        dir.create("./ExploratoryAnalysis")    
    }

    setwd("./ExploratoryAnalysis/")
}

if(!file.exists(file.path("./powerConsumption.rda")))
{
    if(!file.exists(file.path("./exdata_data_household_power_consumption.zip")))
    {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                      destfile = "./exdata_data_household_power_consumption.zip")
    }
    
    if(!file.exists(file.path("./household_power_consumption.txt")))
    {
        unzip("./exdata_data_household_power_consumption.zip")        
    }
    
    household_power_consumption <- read.csv("./household_power_consumption.txt", sep=";", na.strings="?")
    save(household_power_consumption,file="./powerConsumption.rda") 
} else {
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

png(filename="plot1.png", width=480, height=480, units="px")

hist(filtHPC$Global_active_power,main="Global Active Power",xlab="Global Active Power (kilowatts)",ylab="Frequency",col="red")

# dev.copy(png, file = "plot1.png") ## Copy my plot to a PNG file
dev.off() 