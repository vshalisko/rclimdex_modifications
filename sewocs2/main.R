###############################################################################
# main R script to test the plotOrASCII function
# that is defined in sewocs_functions.R
#
# Usage (gnome): Rscript main.R --vanilla --slave --quiet --no-save \
#              'outputType="..."' 'stationId=....' ...

# args can be set interactively by using testSewocs.sh

# args required are:
#				outputType,
#				stationId,
#				countryId,
#				stationName,
#				climateIndex,
#				startYear,
#				endYear,
#				season,
#				stationFilePath

# Use (ssh): DISPLAY=:200.0 Rscript main.R --vanilla --slave --quiet --no-save ...
# For ssh, Xvfb must be running with screen :200.0
# It requires GTK+, libcairo, freeType
#
# The resulting image may be branded with a logo, e.g. using ImageMagick 6.x
# convert plotTimeseries.png -composite logo_unsw_small.png \
#  -geometry +20+555 \
#  -composite composite.png
# 
# Author: yoichi
###############################################################################

# This processes cmd line args that are in the form "argx=X"
args <- commandArgs(TRUE); 
for(i in 1:length(args))
{ eval(parse(text=args[[i]])) }

print(outputType)
print(stationId)
print(countryId)
print(stationName)
print(climateIndex)
print(startYear)
print(endYear)
print(season)
print(stationFilePath)
print(outputFilePath)

source('sewocs_functions.R')

output <- try(
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

if (class(output) == "try-error"){
	msg <- geterrmessage()
	print(substr(msg,9,1000000L)) 
} else if (outputType=="Plot") {
	print("got data") 
	zz <- file(outputFilePath,"wb") # write-binary
	writeBin(output,zz)
	close(zz)
} else if (outputType=="ASCII") {
	print("got data")
	print(output) # Print the raw output to the console
	write.table(output, file=outputFilePath, row.names=F)
}


