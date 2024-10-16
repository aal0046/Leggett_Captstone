# Leggett_Capstone_2
## Function and Motivation
This script loops through biological data files and calculates the percentage of unduplicated entries in those files that contain latitude and longitude data. At the end, a table will be provided containing the species and percent with locality data from each file. 
To run the script enter
```
bash .\Leggett_GBIF.sh your_entry_file
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


