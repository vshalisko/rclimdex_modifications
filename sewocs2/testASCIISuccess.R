# main R script to test the plotOrASCII function
# defined in sewocs_functions_2.R
#
# Use: Rscript --no-save testASCIISuccess.R
#
# The resulting image may be branded with a logo, e.g. using ImageMagick 6.x,
# convert plotTimeseries.png -composite logo_unsw_small.png -geometry +20+555 -composite composite.png
# 
# Author: yoichi
###############################################################################

outputType<-"ASCII"
stationId<-"ASN00066062"
countryId<-"AS"
stationName<-"SYDNEY (OBSERVATORY HILL)"
climateIndex<-"TXx" #choose from the 29? indices
startYear<-1930
endYear<-2010
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

