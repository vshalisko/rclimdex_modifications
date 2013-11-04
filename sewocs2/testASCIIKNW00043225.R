#!/usr/bin/Rscript --vanilla --slave --quiet --no-save

###############################################################################
# R script to test the plotOrASCII() functon, which is
# defined in sewocs_functions.R (loaded by this script).
#
# Usage (gnome): ./testPlotKNW00043225.R
# Usage (ssh)  : DISPLAY=:200.0 ./testPlotKNW00043225.R
# For ssh, Xvfb must be running with screen :200.0
#
# Author: yoichi
###############################################################################

# KNW00043225

outputType<-"ASCII"
stationId<-"KNW00043225"
countryId<-"KNW"
stationName<-"SOKCHORI"
climateIndex<-"TXx" #choose from the 29? indices
startYear<-1951
endYear<-2003
season<-"ANN" #choose from "JAN","FEB",...,"DEC","ANN","DJF","MAM","JJA","SON"

indexFileName = paste(stationId,"_", climateIndex,".txt",sep="")

inputDataDir<-"/scratch/climdex/ghcndex/current/stn-indices"
stationFilePath<-paste(inputDataDir,climateIndex,indexFileName,sep="/")

source('sewocs_functions.R')

out <- try(
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

if (class(out) == "try-error"){
	msg <- geterrmessage()
	print(substr(msg,9,1000000L)) 
} else {
	print("got data")
	print(out)
	outfile<-paste(stationId,"_",climateIndex,".ascii",sep="")
	write.table(out, file=outfile, row.names=F)	
}


