#!/bin/bash

# bash script to set env for R script, which calculates
# timeseries or ASCII data file.s

# This script set the following args for main.R interactively,
# by using ENVIRONMENT varaibles.

# ${R_CMD} main.R \
# "outputType='${SEWOCS_OUTPUT_TYPE}'" \
# "stationId='${SEWOCS_STATION_ID}'" \
# "countryId='NOT_USED'" \
# "stationName='TEST'" \
# "climateIndex='${SEWOCS_CLIMATE_INDEX}'" \
# "startYear=${SEWOCS_START_YEAR}" \
# "endYear=${SEWOCS_END_YEAR}" \
# "season='${SEWOCS_SEASON}'" \
# "stationFilePath='${SEWOCS_DATA_PATH}'" \
# "outputFilePath='${SEWOCS_OUTFILE_PATH}'"
#
#
# Yoichi Takayama @ 08 Jan 2013
# y.takayama@unsw.edu.au
# Copyright: CLIMDEX 2013

echo
echo "Script to set parameters and run sewocs_functions.R script"
echo "ctrl-c to exit at any time"
echo

# ------------------------------------------------------------------------
echo "Try the following"
echo "Sucess: Sydney Observatory : ASN00066062 : TXx"
echo "Fail: Sydney Observatory : ASN00066062 : Rx5day (possibly missing data)"
echo "Fail: BALLANDOOL: ASN00017008 : CDD (file exists but no data)"
echo "Fail: RANDWICK RACECOURCE : ASN00066073 : TXx (file does not exist)"
echo
read -p "Station ID> =? " SEWOCS_STATION_ID

echo
echo $SEWOCS_STATION_ID
export SEWOCS_STATION_ID

# ------------------------------------------------------------------------
echo
echo "Data Set"
echo
PS3='> =? '
options=("GHCNDEX" "HADEX2")
#select opt in "${options[@]}"
select choice in "${options[@]}" "Quit"
do
    case $choice in
        "GHCNDEX")
		break
            ;;
        "HADEX2")
		break
            ;;
        "Quit")
            exit
            ;;
        *) echo invalid option;;
    esac
done
echo $choice
export SEWOCS_DATA_SET=$choice

# ------------------------------------------------------------------------
# set initial values
if [ "$SEWOCS_DATA_SET" == "HADEX2" ]; then
    SEWOCS_START_YEAR=1901
    SEWOCS_END_YEAR=2011
elif [ "$SEWOCS_DATA_SET" == "GHCNDEX" ]; then
    SEWOCS_START_YEAR=1851
    SEWOCS_END_YEAR=2011
fi

# ------------------------------------------------------------------------
echo
echo "Climate Index"
echo
PS3='> =?  '
options=("TXx" "TNn" "TNx" "TXn" "DTR" "ETR" "TX10p" "TN10p" "TX90p" "TN90p" "TX50p" "TN50p" "R99p" "R95p" "Rx1day" "Rx5day" "PRCPTOT" "SDII" "TR" "SU" "ID" "FD" "GSL" "CSDI" "WSDI" "R10mm" "R20mm" "Rnnmm" "CDD" "CWD")
select choice in "${options[@]}" "Quit"
do
for opt in ${ARRAY[@]}
do
if [ "$choice" = "$opt" ]
then break
fi
done

if [ $choice == "Quit" ]; then
exit
else
break
fi

echo invalid option
done
echo $choice
export SEWOCS_CLIMATE_INDEX=$choice

# ------------------------------------------------------------------------
echo
echo "Year range"
echo
echo "START and END can be the same year,"
echo "except that Trend and Time Series can't be"
echo "calculated unless some long enough period is given."
echo "GHCNDEX 1951-current"
echo "HADEX2 1901-2012 (2012 is not a full year)"

# If the current year is chosen, the period requested
# should not exceed existing data range.

echo
read -p "Start Year (${SEWOCS_START_YEAR}=RETURN) =? " startYear
read -p "End Year (${SEWOCS_END_YEAR}=RETURN) =? " endYear

if [ -z "$startYear" ]; then # it is empty
    startYear="${SEWOCS_START_YEAR}"
fi
if [ $startYear -lt ${SEWOCS_START_YEAR} ]; then
	startYear="${SEWOCS_START_YEAR}"
fi

if [ -z "$endYear" ]; then # it is empty
    endYear="${SEWOCS_END_YEAR}"
fi  
if [ $endYear -gt ${SEWOCS_END_YEAR} ]; then
    endYear="${SEWOCS_END_YEAR}"
fi

export SEWOCS_START_YEAR=$startYear
export SEWOCS_END_YEAR=$endYear

# ------------------------------------------------------------------------
echo
echo "ANN/MONTH/SEASON"
echo
PS3='> =? '
options=("ANN" "JAN" "FEB" "MAR" "APR" "MAY" "JUN" "JUL" "AUG" "SEP" "OCT" "NOV" "DEC")
select choice in "${options[@]}" "Quit"
do
	for opt in ${ARRAY[@]}
	do
		if [ "$choice" = "$opt" ]
        	then break
        	fi
	done

	if [ $choice == "Quit" ]; then
 		exit
	else
		break
	fi

        echo invalid option
done
echo $choice
export SEWOCS_SEASON=$choice

# season: JAN, ..., DEC, DJF, MAM, JJA, SON, or ANN.

# Some indices have only annual output.
# GHCNDEX/HADEX2 do not calculate seasons at this time.

# HADEX1 has seasons/ANN but not months.

# ------------------------------------------------------------------------
echo
echo "Output Type"
echo
PS3='> =? '
options=("Plot" "ASCII")
select choice in "${options[@]}" "Quit"
do
	for opt in ${ARRAY[@]}
	do
		if [ "$choice" = "$opt" ]
        	then break
        	fi
	done

	if [ $choice == "Quit" ]; then
 		exit
	else
		break
	fi

        echo invalid option
done
echo $choice
export SEWOCS_OUTPUT_TYPE=$choice

# ------------------------------------------------------------------------
echo
echo "--------------------------------------"
echo "You have chosen to caluculate:"
echo "--------------------------------------"
echo "Station ID: $SEWOCS_STATION_ID"
echo "Data Set: $SEWOCS_DATA_SET"
echo "Index:    $SEWOCS_CLIMATE_INDEX"
echo "Period:   $SEWOCS_START_YEAR - $SEWOCS_END_YEAR"
echo "Season:   $SEWOCS_SEASON"
echo "Output:   $SEWOCS_OUTPUT_TYPE"

# ------------------------------------------------------------------------
# SEWOCS_INPUT_DIR

ghcndex_markus="/srv/ccrc/data07/z3356123/GHCNDEX_2012/ghcndex/stn-indices"
ghcndex_yoichi="/scratch/climdex/ghcndex/current/stn-indices"

hadex2_markus="/srv/ccrc/data03/z3356123/HadEX2/stn-indices"
hadex2_yoichi="/scratch/climdex/hadex/HadEX2/current/stn-indices"

### change markus/yoichi here ###
if [ "$SEWOCS_DATA_SET" == "GHCNDEX" ]; then
	SEWOCS_INPUT_DIR="${ghcndex_yoichi}"
	#SEWOCS_INPUT_DIR="${ghcndex_markus}"
elif [ "$SEWOCS_DATA_SET" == "HADEX2" ]; then
	SEWOCS_INPUT_DIR="${hadex2_yoichi}"
	#SEWOCS_INPUT_DIR="${hadex2_markus}"
fi
export SEWOCS_INPUT_DIR

SEWOCS_DATA_PATH="${SEWOCS_INPUT_DIR}/${SEWOCS_CLIMATE_INDEX}/${SEWOCS_STATION_ID}_${SEWOCS_CLIMATE_INDEX}.txt"
export SEWOCS_DATA_PATH

echo
echo "DATA_PATH='$SEWOCS_DATA_PATH'"

# ------------------------------------------------------------------------
if [ "$SEWOCS_OUTPUT_TYPE" == "Plot" ]; then
    SEWOCS_SUFFIX="png"
elif [ "$SEWOCS_OUTPUT_TYPE" == "ASCII" ]; then
    SEWOCS_SUFFIX="txt"
fi
export SEWOCS_SUFFIX

if [ ! -d "results" ]; then
	mkdir "results"
	if [ $? -eq 0 ]; then
		echo "results dir created"
	else
		echo "failed to create results dir with $retval"
	fi
fi

wd=`pwd`
RESULTS_DIR="$wd/results"
echo "RESULTS_DIR='${RESULTS_DIR}'"

SEWOCS_OUTFILE_PATH="${RESULTS_DIR}"
SEWOCS_OUTFILE_PATH="${SEWOCS_OUTFILE_PATH}/${SEWOCS_STATION_ID}"
SEWOCS_OUTFILE_PATH="${SEWOCS_OUTFILE_PATH}_${SEWOCS_DATA_SET}"
SEWOCS_OUTFILE_PATH="${SEWOCS_OUTFILE_PATH}_${SEWOCS_CLIMATE_INDEX}"
SEWOCS_OUTFILE_PATH="${SEWOCS_OUTFILE_PATH}_${SEWOCS_START_YEAR}-${SEWOCS_END_YEAR}"
SEWOCS_OUTFILE_PATH="${SEWOCS_OUTFILE_PATH}_${SEWOCS_SEASON}"
SEWOCS_OUTFILE_PATH="${SEWOCS_OUTFILE_PATH}.${SEWOCS_SUFFIX}"

export SEWOCS_OUTFILE_PATH

# Comment out the following to test whether the script can overwrite the file
# Uncomment to test whether the script can create a new file
#if [ -f "${SEWOCS_OUTFILE_PATH}" ]; then
#    rm "${SEWOCS_OUTFILE_PATH}";
#    echo "deleted: ${SEWOCS_OUTFILE_PATH}";
#fi

echo "OUTFILE_PATH='${SEWOCS_OUTFILE_PATH}'"

read -p "> OK? "

# ------------------------------------------------------------------------
R_CMD="Rscript --vanilla --slave --quiet --no-save"

set -x
${R_CMD} main.R \
"outputType='${SEWOCS_OUTPUT_TYPE}'" \
"stationId='${SEWOCS_STATION_ID}'" \
"countryId='NOT_USED'" \
"stationName='TEST'" \
"climateIndex='${SEWOCS_CLIMATE_INDEX}'" \
"startYear=${SEWOCS_START_YEAR}" \
"endYear=${SEWOCS_END_YEAR}" \
"season='${SEWOCS_SEASON}'" \
"stationFilePath='${SEWOCS_DATA_PATH}'" \
"outputFilePath='${SEWOCS_OUTFILE_PATH}'"
set +x

# --- END ----------------------------------------------------------------

