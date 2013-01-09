# main R script to test the stationTimeSeries functon
# defined in stationTimeSeries.R
#
# Use (gnome): R < testPlotFail2.R --no-save
# Use (ssh): DISPLAY=:200.0 R < testPlotFail2.R --no-save
# For ssh, Xvfb must be running with screen :200.0
#
# Author: yoichi
###############################################################################

# ASN00066073_TXx.txt does not exist

outputType<-"Plot"
stationId<-"ASN00066073"
countryId<-"AS"
stationName<-"RANDWICK RACECOURCE"
climateIndex<-"TXx" #choose from the 29? indices
startYear<-1951
endYear<-2003
season<-"ANN" #choose from "JAN","FEB",...,"DEC","ANN","DJF","MAM","JJA","SON"

indexFileName = paste(stationId,"_", climateIndex,".txt",sep="")

inputDataDir<-"/scratch/climdex/ghcndex/current/stn-indices"
stationFilePath<-paste(inputDataDir,climateIndex,indexFileName,sep="/")

source('sewocs_functions.R')

buffer <- try(
		plotOrASCII(
		outputType,
		stationId,
		countryId,
		stationName,
		climateIndex,
		startYear,
		endYear,
		season,
		stationFilePath),
		silent = TRUE
)

if (class(buffer) == "try-error"){
	msg <- geterrmessage()
	print(substr(msg,9,1000000L)) 
} else {
	print("got data") 
	zz <- file("plotTimeseries.png","wb") # write-binary
	writeBin(buffer,zz)
	close(zz)
}


