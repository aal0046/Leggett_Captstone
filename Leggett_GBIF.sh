#!/bin/bash/

# Check that file was specified
if [ $# != 1 ] ; then  
	echo " Include file name when running script"
	exit
fi

# Check that file exists
if [ -e  $1 ] ; then
	echo "input file exists"
	else
	echo "ERROR:input file does not exist"
	exit 
fi

#count number of species 
species_number=`cat $1 | wc -l`
echo "There are $species_number species"

#create file and add two column headers
touch Filtered.txt
printf "Species Name\tPercent Filtered\n" > Filtered.txt

# define array
species_files=(`cat $1`)
#echo "${species_files[@]}"

#initialize variable
count=1

#Create for loop
for file in ${species_files[@]}
do

# Create species variable 
species=$(awk -F'\t' 'NR==2 {print $10, $11}' $file | awk '{print $NF}')
echo "Processing $species"

# Copy header into new file and remove the header
head -1 $file > $file.header.txt
sed -i '1d' $file

# Sort the file by latitude then remove duplicates
sort -nk22,22 $file |uniq > $file.lat_uniq.txt

# Sorting the previous file by longitude, then remove duplicates
sort -nk23,23 $file.lat_uniq.txt |uniq > $file.lat_long_uniq.txt

# Counting number of lines in sorted files
SLC=$(cat $file.lat_long_uniq.txt| wc -l )
#echo $SLC

# Getting columns (fields) 22 and 23, which should be lat and long using a tab as the field-separator (\t)
awk 'FS="\t" {print $22, $23}' $file.lat_long_uniq.txt >$file.lat_long_only.txt

# Grabbing only records that DO NOT (-v) begin (^)with a space (\s), repeated zero or more times (*), until the end of the line ($) [A blank line!] 
grep -v "^\s*$" $file.lat_long_only.txt > $file.lat_long_cleaned.txt

# Count number of lines with locality data
LDLC=$(cat $file.lat_long_cleaned.txt| wc -l)
#echo $LDLC

# Calculate percentage with locality data
percent=$(echo "scale=4; 100 * ($LDLC / $SLC)" |bc)
#echo $percent

# Print species and percent to Filtered.txt file
printf '%s\t' "$species" >> Filtered.txt
printf '%s%%t\n' "$percent" >> Filtered.txt

# Progress check
echo "$species Processing Complete"
done

# Concatenate locality data
cat *.lat_long_cleaned.txt > lat_long_combined.txt

# Remove intermediate files
rm *.csv.*

# Print filtered.txt to command line
cat Filtered.txt


