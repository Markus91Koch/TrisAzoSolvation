#!/bin/sh

# call this script with two parameters:
# 1) original lammps file 
# 2) file containing the correctly formated new header with all parameters
# script to replace the header section of a LAMMPS data file with a different one
# sh insert_params.sh oldfile.data newparams.txt

if [ -z "$1" ]
  then
    echo "Please provide the filename of the original lammps file as the 1st input parameter."
    exit 1
fi

if [ -z "$2" ]
  then
    echo "Please provide the filename of the file containing the parameters as 2nd input parameter."
    exit 1
fi

# split filename for later editing
extension="${1##*.}"
filename="${1%.*}"

# find lines in file for splitting
# line number where "Masses" keyword is found
nm=$(grep -n Masses $1 |cut -f1 -d:)
na=$(grep -n Atoms $1 |cut -f1 -d:)

# total line number of original lammps file
#nl=$(wc -l $1 | awk '{print $1}')

# split orig. file into header, footer and atoms section
head -n+$((nm-1)) $1 > header.txt
tail -n+$((na)) $1 > footer.txt

cat header.txt "$2"  footer.txt > "$filename"_param.data

rm header.txt footer.txt
