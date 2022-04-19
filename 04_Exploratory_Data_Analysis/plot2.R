
library(tidyverse)

pw <- read_delim("household_power_consumption.txt", delim = ";", na="?")

pw$Date <- dmy(pw$Date)

pw3 <- pw[pw$Date >= "2007-02-01" & pw$Date <= "2007-02-02",]

pw3$Global_active_power <- as.numeric(pw3$Global_active_power)

pw3$dateTime <- paste(pw3$Date, pw3$Time)

pw3 <- mutate(pw3, dateTime = ymd_hms(pw3$dateTime))

png("plot2.png", width=480, height=480)

plot(pw3$dateTime, pw3$Global_active_power, 
     ylab = "Global Active Power (kilowatts)", xlab ="", type = "l")

dev.off()
