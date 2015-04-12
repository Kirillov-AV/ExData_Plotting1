##-----------------------------------------------------------
## read from file and preprocess data 

Sys.setlocale("LC_TIME", "English")
library("data.table")

    ## set data classes
colclass<-c( "character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric" )

    ## read the header
hdr <-fread("household_power_consumption.txt", header=TRUE, sep=";", nrows=1 )

    ## skip to "1/2/2007" then read 5000 rows (includes our data)
    ## !! important to set "header=FALSE" 
    ## or the first line of data will be treated as header
    ## and be missing from the dataset
    ## using 'skip' arg also skips original header data 
feb <-fread("household_power_consumption.txt", header=FALSE, sep=";", nrows=5000, skip="1/2/2007", na.strings="?", colClasses=colclass )

    ##  assign header from 'ht' to 'feb'
setnames(feb, names(hdr) ) 

    ## convert feb$Date column to "Date" class
    #####feb$Date<-feb[, as.Date(Date, "%d/%m/%Y")]  
feb$Date<-as.Date(feb$Date, "%d/%m/%Y")

    ## leave only our data (Feb 01 and 02)
feb<-feb[Date<="2007-02-02"]

## ----------------------------------------------------------

    ## create separate vector of POSIXlt data&time for X-axis 
datetime <- strptime( paste (feb$Date,feb$Time, sep=" "), "%Y-%m-%d %H:%M:%S", tz = "EST5EDT" )

    ## send Plot 4 directly to "plot4.png" file 
png("plot4.png")
    ## png default width = 480, height = 480
    
    par( mfrow=c(2,2))

    ## plot Top-L 
    plot(datetime, feb$Global_active_power, type="l", xlab="", ylab="Global Active Power")

    ## plot Top-R (fix y axis values)
    plot(datetime, feb$Voltage, type="l", xlab="datetime", ylab="Voltage")

    ## plot Bott-L
    plot(datetime, feb$Sub_metering_1, type="n", xlab="", ylab="Energy sub metering")
    lines(datetime, feb$Sub_metering_1, col="black")
    lines(datetime, feb$Sub_metering_2, col="red")
    lines(datetime, feb$Sub_metering_3, col="blue")
    lnames<-c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
    legend("topright", legend=lnames, col=c(1, 2, 4), lty = c(1, 1, 1), bty="n")

    ## plot Bott-R
    plot(datetime, feb$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")

dev.off()


