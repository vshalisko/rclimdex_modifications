###############################################################################
# sewocs_functions.R

# It makes a time series plot in PNG format
# of a given climate index for the stationId.
# If the index data does not exist, it returns an error.

# USAGE: See testPlotSuccess.R and testPlotFail.R
#
# Requires: RGtk2, cairoDevice
# These have to be loaded into R only once.
# cairoDevice is required by the R script to output image as in-memory binary
# RGtk2 is required by the R script to manipulate image in-memory
# For R console:
#	install.packages('cairoDevice')
#	install.packages('RGtk2')
# For site-wise install, run it as root.

# TODO: Use a compiled version of the script when it is complete
#
# Author: Markus Donat <m.donat @ unsw.edu.au>, Yoichi Takayama <y.takayama @ unsw.edu.au
###############################################################################

## define function for binomial filter
binfil <- function(x,npt) {
  # x  = data series, nx = length of series
  # npt = length of filter, must be odd (npt=21 for a 21 point filter)
  # nf = number of times filter is applied
  # xf = filtered series (output)
  nx <- length(x)
  nf <- floor(npt/2)
  xf <- x
  x1 <- numeric(nx)
  x2 <- numeric(nx)
  for (i in 1:nf) {
    xmod <- xf
    x1 <- c( NA, xmod[-nx] )
    x2 <- c( xmod[-1], NA )
    xf <- (x1 + 2*xmod + x2)*0.25
  }
  xf
}

## function to determine unit of ClimateIndex
unit <- function(index) {
	if (is.element(index, c("TXn","TXx","TNn","TNx"))) {
		ounit<-"degC"}
	else if (is.element(index, c("DTR","GSL","CSDI","WSDI","SU","TR","ID","FD","R10mm","R20mm","Rnnmm","CDD","CWD"))) {
		ounit<-"days"}
	else if (is.element(index, c("TN10p","TX10p","TN90p","TX90p","TN50p","TX50p"))) {
		ounit<-"% of days" }
	else if (is.element(index, c("Rx1day","Rx5day","SDII","R95p","R99p","PRCPTOT"))) {
		ounit<-"mm" }

	return(ounit)
}

plotOrASCII<-function(
		outputType,
		stationId,
		countryId,
		stationName,
		climateIndex,
		startYear,
		endYear,
		season,
		stationFile
)
{
	#print(outputType)
	#print(stationId)
	#print(countryId)
	#print(stationName)
	#print(climateIndex)
	#print(startYear)
	#print(endYear)
	#print(season)
	#print(stationFile)

	missingValue<-"-99.9"
	
	if(!file.exists(stationFile)) {
		stop("Station does not provide the data for the index", call. = FALSE, domain = NULL)
	}
	
	dd<-read.table(stationFile, header=F, skip=1, na.strings=missingValue)
	year1<-dd[1,1]
	yearx<-dd[dim(dd)[1],1]

	if (endYear < year1 || yearx < startYear) stop("Station does not provide the data within the range", call. = FALSE, domain = NULL)

	## Re-adjustment of the data range is prohibited.
	## May need to generate years and data between startYear and year1 and between yearx and endYear
	
	## adjust the start and end to the existing data range
	#if (year1 > startYear) startYear=year1
	#if (yearx < endYear) endYear=yearx	lines(xyf2,lwd=2,lty=1,col="blue")

	year<-dd$V1[dd$V1>=startYear & dd$V1<=endYear]

	# ANN only indices
	# Note: the Web page does not request Rnnmm
	indices1 = c(
		"CDD",
		"CSDI",
		"CWD",
		"FD",
		"GSL",
		"ID",
		"PRCPTOT",
		"R10mm",
		"R20mm",
		"R95p",
		"R99p",
		"Rnnmm",
		"SDII",
		"SU",
		"TR",
		"WSDI"
	)
	# These indices have seasonal and monthly data
	# Note: the Web page requests neither TN50p or TX50p
	indices2 = c(
		"DTR",
		"RX1day",
		"RX5day",
		"TN10p",
		"TN50p",
		"TN90p",
		"TNn",
		"TNx",
		"TX10p",
		"TX50p",
		"TX90p",
		"TXn",
		"TXx"
	)	

	# Data in columns 2..14 (depending on input format provides annual / monthly values)
	# 1 data column
	if (is.element(climateIndex, indices1)) {
		data<-dd$V2[dd$V1>=startYear & dd$V1<=endYear]
	} else if (is.element(climateIndex, indices2)) {
		# 13 data columns
		if (season=="JAN") data<-dd$V2[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="FEB") data<-dd$V3[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="MAR") data<-dd$V4[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="APR") data<-dd$V5[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="MAY") data<-dd$V6[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="JUN") data<-dd$V7[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="JUL") data<-dd$V8[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="AUG") data<-dd$V9[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="SEP") data<-dd$V10[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="OCT") data<-dd$V11[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="NOV") data<-dd$V12[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="DEC") data<-dd$V13[dd$V1>=startYear & dd$V1<=endYear]
		else if (season=="ANN") data<-dd$V14[dd$V1>=startYear & dd$V1<=endYear]
		# seasons are not handled with yet
		# else if (season=="DJF") 
		# else if (season=="MAM") 
		# else if (season=="JJA") 
		# else if (season=="SON") 
	}
dd$V1
dd$V2
dd$V14
data
	
	if (outputType=="ASCII") {
		## ASCII-Table
		dataMatrix<-matrix(c(year,data),ncol=2)
		dimnames(dataMatrix)<-list(NULL,c("year",paste(climateIndex,"_",season,sep="")))
  		dataFrame<-as.data.frame(dataMatrix)
  		# it can only return the data matrix at present
  		return(dataMatrix)
  	}

	if (outputType!="Plot") {
		stop(paste("Unknown outputType",outputType,sep=":") , call. = FALSE, domain = NULL)
	}

	## otherwise, make a plot
	 
	library(RGtk2) 
	library(cairoDevice)	

	# create a pixmap and tell cairoDevice to draw to it 
	pixmap <- gdkPixmapNew(w=800, h=600, depth=24) 
	asCairoDevice(pixmap) 

	# adjust y-axis +/- 20% of data range to avoid collision w legend
	yrange=max(data, na.rm = TRUE)-min(data, na.rm = TRUE)
	ymargin=0.2*yrange
	ymin=min(data,na.rm = TRUE)-ymargin
	ymax=max(data,na.rm = TRUE)+ymargin
	
	plot(year, data, xlab="Year", xlim=c(startYear,endYear), ylim=c(ymin,ymax), ylab=paste(climateIndex,"[",unit(climateIndex),"]"), type="b", col="darkred")

	## calculate trend only if at least 10yrs with data?!
	if(sum(is.na(data)) >= (endYear - startYear + 1 - 10)) 
	{
		betahat<-NA
		betastd<-NA
		pvalue<-NA
		fit<-NA
		r2<-NA
		pvalue<-NA
		error<-TRUE
		errMsg<-"Trend requires at least 10 years of data points."
	} else {
		fit<-lsfit(year,data)
		out<-ls.print(fit,print.it=F)
		r2<-round(100*as.numeric(out$summary[1,2]),1)
		pvalue<-round(as.numeric(out$summary[1,6]),3)
		betahat<-round(as.numeric(out$coef.table[[1]][2,1]),3)
		betastd<-round(as.numeric(out$coef.table[[1]][2,2]),3)
		error<-FALSE
		#abline(fit, lwd=3)
	}
	
	## smooth line (cubic spline)
	#xy<-cbind(year,data)
	#xy<-na.omit(xy)
	#xy.spl<-smooth.spline(xy[,1],xy[,2],df=20)
	#lines(xy.spl,lwd=3,lty=2)
	#lines(lowess(xy[,1],xy[,2]),lwd=3,lty=2)

	## binomial filter
	dataf <- binfil(data,21)
	xyf<-cbind(year,dataf)
	lines(xyf,lwd=3,lty=2)

	maintit=paste(climateIndex, stationId, stationName, paste(startYear, endYear, sep="-"), season, sep=" ")
	title(main=maintit)
	title(sub="Note: These data are not quality-controlled!",cex=0.5)
	
	if (!error){
		legend(
				"bottomleft",
				legend=c(paste("Data", climateIndex,"( unit:",unit(climateIndex),")"),
						"21-yr binomial filter",
						"Linear trend (least squares):",
						paste("Slope estimate=",betahat*10,"/10 yrs (p=",pvalue,")",sep="")),
				col=c("darkred","black","white","white"),
				lty=c(1,2,0,0),
				pch=c('o','-',3,3),lwd=c(1,3,0,0)
		)
	} else {
		legend(
				"bottomleft",
				legend=c(paste("Data",index),errMsg), 
				col=c("darkred","black","white"),
				pch=c('o','-',3),lwd=c(1,3,0))
	}
		
	# convert the pixmap to a pixbuf 
	plot_pixbuf <- gdkPixbufGetFromDrawable(NULL, pixmap, pixmap$getColormap(), 0, 0, 0, 0, 800, 600) 
	
	# save the pixbuf to a raw vector 
	buffer <- gdkPixbufSaveToBufferv(plot_pixbuf, "png", character(0), character(0))$buffer
	
	return(buffer)
}

