# Leggett Capstone 2
## Function and Motivation
This script loops through biological data files and calculates the percentage of unduplicated entries in those files that contain latitude and longitude data. At the end, a table will be provided containing the species and percent with locality data from each file. This can be edited to calculate percentages of other data by changing column numbers. 
To run the script enter
``` bash
bash ./Leggett_GBIF.sh your_entry_file
``` 
In place of your_entry_file, enter your text file containing the names of the files to be looped through
## The Script
### Confidence Checks
First, a confidence check is run to ensure that a file was specified.
Then a confidence check is run to ensure the specified file exists. 
### Set Up
The number of lines in the provided file are counted to provide the number of species. 
An empty file called Filtered.txt is created, and two headers lines are pushed into that file. 
An array is defined as the contents listed in the provided file.
### The Loop
A for loop is set up to go through the previously assigned array. 
The species variable is assigned to pull the name of the species targeted in the current file. That species name is echoed while the script runs, so the user can know what the script is currently processing.
``` bash 
species=$(awk -F'\t' 'NR==2 {print $10, $11}' $file | awk '{print $NF}')
echo "Processing $species"
```
*If using a file with the species names in different columns, $10, $11 may be changed.*

The header is copied into a new file and then removed using *sed*. 
The file is sorted by latitude and then longitude, and duplicates are removed.
``` bash
sort -nk22,22 $file |uniq > $file.lat_uniq.txt
sort -nk23,23 $file.lat_uniq.txt |uniq > $file.lat_long_uniq.txt
```
Then the lines in the sorted files are counted and stored in a variable called **SLC**. This stands for *sorted line count*.
Awk is then used to pull only columns 22 and 23 into a new file. 
Any lines not containing latitude or longitude data are removed.
``` bash
awk 'FS="\t" {print $22, $23}' $file.lat_long_uniq.txt >$file.lat_long_only.txt
grep -v "^\s*$" $file.lat_long_only.txt > $file.lat_long_cleaned.txt
```
*If using a file with latitude and longitude data in a different column, or filtering for a different type of data; $22, $23 may be changed.*

The number of lines in the cleaned filed are counted and stored in the variable **LDLC**. This stands for *locality data line count*.
Percentage of data with locality data is calculated and stored in the variable **percent**
``` bash
percent=$(echo "scale=4; 100 * ($LDLC / $SLC)" |bc)
```
Percent and Species variables are printed to Filtered.txt. A progress check is printed to the command line, announcing that the current file has finished processing.
This process is repeated for as many files specified in the initial entry file.
### Wrap Up
All locality data is combined into one file. 
Any intermediate files made during the loop are deleted. 
The finished table is printed to the command line.

## Results
This table gives results obtained using this code for the file Species_list.txt, and all the files listed in Species_list.txt

| Species | Percent |
|---------|---------|
| Castaneus | 18.14% |
| Domesticus | 98.97% |
| Musculus | 83.18% |
| Molossinus | 30.76% |
| Spretus | 94.78% |




