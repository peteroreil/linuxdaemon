#!/bin/bash

# Peter O'Reilly
# peter.oreilly6@student.dit.ie
# DT340A - Linux System Administartion - Assignment

# Script to download the movie list file and filters by movie name, 
# year and a rating >= 7.0. Pipes the outputted file (formattedList.txt) to a directory called "movie-data"
# 
 

ZIP_FILE="ratings.list.gz"
EXTRACTED_FILE="ratings.dat"
URL="ftp://ftp.fu-berlin.de/pub/misc/movies/database/$ZIP_FILE"
DIRECTORY="movie_data"
OTHER_DIRECTORY="movie-data"

# if directory exists delete it and its contents
if [ -d "$DIRECTORY" ];then
    rm -rf $DIRECTORY
    echo "removing directory $DIRECTORY"
fi

# if other directory exists delete it and its contents
if [ -d "$OTHER_DIRECTORY" ];then
    rm -rf $DIRECTORY
    echo "removing directory $OTHER_DIRECTORY"
fi


# create directory
echo "creating directory $DIRECTORY"
mkdir $DIRECTORY

echo "creating directory $OTHER_DIRECTORY"
mkdir $OTHER_DIRECTORY
# download from the url to Directory
echo "downloading file from $URL to $DIRECTORY"
wget -P "$DIRECTORY/" $URL

# extracting and text processing
zcat "$DIRECTORY/$ZIP_FILE" > $EXTRACTED_FILE
cat $EXTRACTED_FILE | grep -v "(1[0-9][0-9][0-9]" | grep -v "(20[1-9][1-9]" |  sed -e's/  */ /g' | cut -d" " --complement  -f1-3 | cut -d"{" -f1 | grep -v "\"" | awk 'int($1)>=7' | cut -d" " --complement -f1 >> $OTHER_DIRECTORY/formattedList.txt

rm -rf $DIRECTORY 
rm $EXTRACTED_FILE
