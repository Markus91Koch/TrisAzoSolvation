#!/bin/sh
# create psf files for correct display of molecular trajectories in VMD
# correct the atom types so the proper CPK colors are displayed immediately

if [ -z "$1" ]
  then
    echo "Please provide the filename of the original lammps file as the 1st input parameter. It should start with the No. of clustered molecules."
    exit 1
fi

# filename should begin with number of clustered molecules
# extract number of molecules in cluster
Nazo=$(echo $1 | cut -d "_" -f1)

# split filename
extension="${1##*.}"
filename="${1%.*}"

echo "$Nazo"

##### generate psf files (I should also provide these scripts probably)

# makes a psf file including all solvent atoms
sh /home/markus/psf "$1"
mv topo.psf "$Nazo"t.psf
cp "$Nazo"t.psf "$Nazo"t_real.psf

# generate psf file without solvent atoms
# only the cluster is visible
Natoms=$((Nazo*114))
echo "$Natoms"

sh /home/markus/psf0 "$1" "$Natoms"
mv topo0.psf "$Nazo"t0.psf
cp "$Nazo"t0.psf "$Nazo"t0_real.psf


##### exchange atom type number in psf file with element name for correct display in VMD

# from the header of the LAMMPS data file:
#1 12.011000 C
#2 12.011000 C
#3 15.999400 O
#4 14.006700 N
#5 14.006700 N
#6 12.011000 C
#7 1.0080000 H
#8 1.0080000 H
#9 1.0080000 H
#10 15.999400 O

sed -i "s%      10   10    %      O    O     %g" "$Nazo"t_real.psf
sed -i "s%      1    1     %      C    C     %g" "$Nazo"t_real.psf
sed -i "s%      2    2     %      C    C     %g" "$Nazo"t_real.psf
sed -i "s%      3    3     %      O    O     %g" "$Nazo"t_real.psf
sed -i "s%      4    4     %      N    N     %g" "$Nazo"t_real.psf
sed -i "s%      5    5     %      N    N     %g" "$Nazo"t_real.psf
sed -i "s%      6    6     %      C    C     %g" "$Nazo"t_real.psf
sed -i "s%      7    7     %      H    H     %g" "$Nazo"t_real.psf
sed -i "s%      8    8     %      H    H     %g" "$Nazo"t_real.psf
sed -i "s%      9    9     %      H    H     %g" "$Nazo"t_real.psf

sed -i "s%      10   10    %      O    O     %g" "$Nazo"t0_real.psf
sed -i "s%      1    1     %      C    C     %g" "$Nazo"t0_real.psf
sed -i "s%      2    2     %      C    C     %g" "$Nazo"t0_real.psf
sed -i "s%      3    3     %      O    O     %g" "$Nazo"t0_real.psf
sed -i "s%      4    4     %      N    N     %g" "$Nazo"t0_real.psf
sed -i "s%      5    5     %      N    N     %g" "$Nazo"t0_real.psf
sed -i "s%      6    6     %      C    C     %g" "$Nazo"t0_real.psf
sed -i "s%      7    7     %      H    H     %g" "$Nazo"t0_real.psf
sed -i "s%      8    8     %      H    H     %g" "$Nazo"t0_real.psf
sed -i "s%      9    9     %      H    H     %g" "$Nazo"t0_real.psf
