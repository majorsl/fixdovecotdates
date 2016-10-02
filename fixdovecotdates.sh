#!/bin/sh
# version 1.0
# fix the file date stamp for Dovecot email if year is 2020.

STARTDIR=$1

if [ "$STARTDIR" = "" ] || [ "$STARTDIR" = "?" ] || [[ "$STARTDIR" = *-h* ]]; then
	ECHO ""
	ECHO "Usage: fixdovecotdates.sh <directorypath> to parse."
	ECHO ""
	exit
fi

cd $1

#Here we set BASHs internal IFS variable so directories/filenames are not broken into new lines when a space is found.
IFS=$'\n'
cd $STARTDIR
FILES="*"
for F in $FILES
do
	WORK=`cat $F`
	FILESTAMP=`ls -l $F | awk -F" " '{print $(NF-1)}'`

if [[ "$FILESTAMP" = "2020" ]]; then
	DAY=`echo "$WORK" | grep -m1 "Date: " | sed 's/^[^-]*, //' | sed 's/Date: //' | cut -d " " -f1`
	DAY=`printf "%02d" $DAY`
	MON_STR=`echo "$WORK" | grep -m1 "Date: " | sed 's/^[^-]*, //' | sed 's/Date: //' | cut -d " " -f2`
		if [[ "$MON_STR" = "Jan" ]]; then
		MONTH="01"
		elif [[ "$MON_STR" = "Feb" ]]; then
		MONTH="02"
		elif [[ "$MON_STR" = "Mar" ]]; then
		MONTH="03"
		elif [[ "$MON_STR" = "Apr" ]]; then
		MONTH="04"
		elif [[ "$MON_STR" = "May" ]]; then
		MONTH="05"
		elif [[ "$MON_STR" = "Jun" ]]; then
		MONTH="06"
		elif [[ "$MON_STR" = "Jul" ]]; then
		MONTH="07"
		elif [[ "$MON_STR" = "Aug" ]]; then
		MONTH="08"
		elif [[ "$MON_STR" = "Sep" ]]; then
		MONTH="09"
		elif [[ "$MON_STR" = "Oct" ]]; then
  		MONTH="10"
		elif [[ "$MON_STR" = "Nov" ]]; then
  		MONTH="11"
		elif [[ "$MON_STR" = "Dec" ]]; then
  		MONTH="12"
		fi
	YEAR=`echo "$WORK" | grep -m1 "Date: " | sed 's/^[^-]*, //' | sed 's/Date: //' | cut -d " " -f3`
	HOUR=`echo "$WORK" | grep -m1 "Date: " | sed 's/^[^-]*, //' | sed 's/Date: //' | cut -d " " -f4 | cut -d ":" -f1`
	MIN=`echo "$WORK" | grep -m1 "Date: " | sed 's/^[^-]*, //' | sed 's/Date: //' | cut -d " " -f4 | cut -d ":" -f2`
	OFFSET=`echo "$WORK" | grep -m1 "Date: " | sed 's/^[^-]*, //' | sed 's/Date: //' | cut -d " " -f5`
	
	TIMESTAMP="$YEAR""$MONTH""$DAY""$HOUR""$MIN"

	echo "Processing $F file..."
	echo "$TIMESTAMP"
	touch -t "$TIMESTAMP" $F
elif [[ "$FILESTAMP" != "2020" ]]; then
	echo "Skipping $F file..."
fi
touch $STARTDIR
done
cd ..
rm dovecot.index.cache
unset IFS
