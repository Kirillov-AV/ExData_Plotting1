# --- Plot 3 --------------------------------------------------------
# read txt datafile from the same directory as this R script, 
# extract data for 2007-02-01 and 2007-02-02 dates 
# preprocess data for plotting
# plot directly to png dev (.png file)  

Sys.setlocale("LC_TIME", "English") # to get WeekDays and Month names in English
library("data.table")  # use data.table functionality for large dataset processing 

    ## set data classes for reading dataset
colclass<-c( "character", "character", "numeric", "numeric", 
             "numeric", "numeric", "numeric", "numeric", "numeric" )

    ## read the header
hdr <-fread("household_power_consumption.txt", header=TRUE, sep=";", nrows=1 )

    ## skip to line containing "1/2/2007" then read 3000 rows (our data + more)
    ## !! important to set "header=FALSE" 
    ## otherwise the first line of data will be treated as header
    ## and get missing from the dataset
    ## using 'skip' arg also skips original header data 
feb <-fread("household_power_consumption.txt", header=FALSE, sep=";", 
            nrows=5000, skip="1/2/2007", na.strings="?", colClasses=colclass )

    ##  copy header from 'hdr' to 'feb'
setnames(feb, names(hdr) ) 

feb$Date<-as.Date(feb$Date, "%d/%m/%Y") ## convert feb$Date to "Date" class

feb<-feb[Date<="2007-02-02"] ## keep only Feb 01 and 02 data for plotting

## ----------------------------------------------------------

    ## create separate vector of POSIXlt data&time for X-axis 
datetime <- strptime( paste (feb$Date,feb$Time, sep=" "), "%Y-%m-%d %H:%M:%S" )

    ## send Plot 3 directly to "plot3.png" file 
png("plot3.png")
    plot(datetime, feb$Sub_metering_1, type="n", xlab="", ylab="Energy sub metering")
    lines(datetime, feb$Sub_metering_1, col="black")
    lines(datetime, feb$Sub_metering_2, col="red")
    lines(datetime, feb$Sub_metering_3, col="blue")

    lnames<-c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
    legend("topright", legend=lnames, col=c(1, 2, 4), lty = c(1, 1, 1) )
dev.off()



