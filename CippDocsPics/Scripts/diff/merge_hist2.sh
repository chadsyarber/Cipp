 #!/bin/bash
 # Clean up image histogram outputs
 
 # $1 is the base file name for the histograms
 # $2 is the base file name for the file containing the file numbers and file names.
 
 # change delimiter to comma
  tr ';' ',' <$1.txt >$1.csv
 
 # copy file number onto the front of the record
  awk 'BEGIN{ FS="]" ; } {print $2 "," $1 }' $1.csv | tr -d '[' >${1}2.csv
 
 # Number the input filenames in their file for merge
  awk '{print (NR-1) "," $1}' < $2.txt >${2}2.txt
 
 # Merge filenames with data
  join -t, -j1 ${1}2.csv ${2}2.txt >${1}3.csv

 # Get rid of the .jpg, and the _ to make a single timestamp out of the jpg filename
  awk 'BEGIN{ FS=",";} { print $NF "," $0}'  ${1}3.csv | sed 's/.jpg//' | sed 's/_//' >${1}4.csv
 
 # Zap the seconds on the timestamp to zero to faciliate merge
  awk 'BEGIN{ FS=",";} {print substr($1,1, 12) "00," $0}' ${1}4.csv >${1}5.csv
 
 # Now merge the new image data onto the existing file.
  join -t, -j1 merged.csv ${1}5.csv >${1}_merge.csv
 
 # Sum up the histogram contents
  awk -f sum_hist.awk ${1}_merge.csv >${1}_merge2.csv
 
 # Make a more manageable subset by dropping raw historgram bins and keeping sum
  awk 'BEGIN{FS=",";} {print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $266}' ${1}_merge2.csv > ${1}_merge3.csv