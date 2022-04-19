
library(tidyverse)

pw <- read_delim("household_power_consumption.txt", delim = ";", na="?")

pw$Date <- dmy(pw$Date)

pw3 <- pw[pw$Date >= "2007-02-01" & pw$Date <= "2007-02-02",]

pw3$Global_active_power <- as.numeric(pw3$Global_active_power)

pw3$dateTime <- paste(pw3$Date, pw3$Time)

pw3 <- mutate(pw3, dateTime = ymd_hms(pw3$dateTime))

png("plot4.png", width=480, height=480)

par(mfrow=c(2,2))

# Plot 1
plot(pw3$dateTime, pw3$Global_active_power, type="l", xlab="", ylab="Global Active Power")

# Plot 2
plot(pw3$dateTime, pw3$Voltage, type="l", xlab="datetime", ylab="Voltage")

# Plot 3
plot(pw3$dateTime, pw3$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(pw3$dateTime, pw3$Sub_metering_2,col="red")
lines(pw3$dateTime, pw3$Sub_metering_3,col="blue")
legend("topright"
       , col=c("black","red","blue")
       , c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  ")
       ,lty=c(1,1), lwd=c(1,1))

# Plot 4
plot(pw3$dateTime, pw3$Global_reactive_power, 
     type="l", xlab="datetime", ylab="Global_reactive_power")

dev.off()
