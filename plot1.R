# --- Plot 1 --------------------------------------------------------
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
## send Plot 1 directly to "plot1.png" file 

png("plot1.png")  
    ## png default width = 480, height = 480
    hist( feb$Global_active_power, main="Global active power", 
          xlab="Global Active Power (kilowatts)", col="red" )
dev.off()

