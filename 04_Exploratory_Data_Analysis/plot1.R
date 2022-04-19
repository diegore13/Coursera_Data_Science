library(tidyverse)

pw <- read_delim("household_power_consumption.txt", delim = ";", na="?")

pw$Date <- dmy(pw$Date)

pw2 <- pw[pw$Date >= "2007-02-01" & pw$Date <= "2007-02-02",]

pw2$Global_active_power <- as.numeric(pw2$Global_active_power)

png("plot1.png", width=480, height=480)

hist(pw2$Global_active_power, main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", col = "red")

dev.off()
