#!/bin/sh
INFILE=$1
OUTFILE=/tmp/dailyreport.md
SCRIPT=`dirname $0`/ConvertLog.ps1

powershell $SCRIPT -inFile $INFILE -out $OUTFILE && cat $OUTFILE
