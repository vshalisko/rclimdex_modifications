# main R script to test the plotOrASCII function
# defined in sewocs_functions.R
#
# Use (gnome): R < testPlotSuccess.R --no-save
# Use (ssh): DISPLAY=:200.0 R < testPlotSuccess.R --no-save
# For ssh, Xvfb must be running with screen :200.0
# It requires GTK+, libcairo, freeType
#
# The resulting image may be branded with a logo, e.g. using ImageMagick 6.x,
# convert plotTimeseries.png -composite logo_unsw_small.png -geometry +20+555 -composite composite.png
# 
# Author: yoichi
###############################################################################

outputType<-"Plot"
stationId<-"ASN00066062"
countryId<-"AS"
stationName<-"SYDNEY (OBSERVATORY HILL)"
climateIndex<-"TXx" #choose from the 29? indices
startYear<-1851
endYear<-2012
season<-"ANN" #choose from "JAN","FEB",...,"DEC","ANN","DJF","MAM","JJA","SON"

indexFileName = paste(stationId,"_", climateIndex,".txt",sep="")

inputDataDir<-"/scratch/climdex/ghcn/current/sewocs"
stationFilePath<-paste(inputDataDir,countryId,stationId,indexFileName,sep="/")
#inputDataDir<-"./data"
#stationFilePath<-paste(inputDataDir,indexFileName,sep="/")

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

