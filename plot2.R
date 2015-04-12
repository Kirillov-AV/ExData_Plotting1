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

        ## send Plot 2 directly to "plot2.png" file 
png("plot2.png")
    ## png default width = 480, height = 480
    plot(datetime, feb$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()

