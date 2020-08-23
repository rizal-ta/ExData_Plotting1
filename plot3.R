## Loading library
library(dplyr)                  
library(lubridate)

## Checking if necessary file exists. If not downloading it
if(!file.exists("household_power_consumption.txt")){
    fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileurl, destfile = "data.zip", method = "curl")
    unzip("data.zip")
    file.remove("data.zip")
}

## Reading the dataset into a table and subseting what we only need
dat <- read.table("household_power_consumption.txt", sep = ";"
                  , na.strings = "?", header = TRUE)
dat <- subset(dat, Date == "1/2/2007" | Date == "2/2/2007")

## Combing both date and time and converting it to date time class. 
## This will make plotting easy
dat <- mutate(dat, Time = dmy_hms(paste(Date, Time)))
dat <- dat[,-1]
names(dat)[1] <- "datetime"

## Plotting three sub metering readings vs datetime as a line plot
dev.new(height = 480, width = 480, units = "px")
par(bg = NA)
with(dat, plot(datetime, Sub_metering_1, type = "l", 
               xlab = "", ylab = "Energy sub metering"))
with(dat, points(datetime, Sub_metering_2, type = "l", col = "red"))
with(dat, points(datetime, Sub_metering_3, type = "l", col = "blue"))
legend("topright", lwd = c(1,1,1), col = c("black", "red", "blue"), 
       legend = c("Sub metering 1", "Sub metering 2", "Sub metering 3"))

## Copying it to a png device
dev.copy(png, "plot3.png", width = 480, height = 480, units = "px")
dev.off()