#!/bin/bash
# Full pipeline of multiple scripts, which performs the following:
# 1) creating a columnar cluster of azo-star molecules,
# 2) solvating it in spc/e water,
# 3) saving it to LAMMPS data files, and
# 4) creating psf files for correct display of trajectories in LAMMPS
#### Execute this via: bash Create_Solvate.sh
#### not with sh Create_Solvate.sh!

# input parameters
Nazo=36         # number of molecules in the cluster
lx=100.0        # box dimensions
ly=100.0
lz=200.0
tolerance=2.00  # tolerance (min. distance between atoms of solvent molecules)

# create folders to execute different steps
mkdir -p create_initial solvate 2lmp

# copy relevant files into the folders
cp create.lt azostar.lt create_initial
cp calc_number.py mixture-solvate.inp water.pdb solvate 
cp header_azo_spce.txt insert_params.sh solvate.lt spce.lt azostar.lt 2lmp 

# start in folder create_initial to make some structure of azo stars
cd create_initial

sed -i s/LX/"$lx"/g create.lt
sed -i s/LY/"$ly"/g create.lt
sed -i s/LZ/"$lz"/g create.lt

# execute MOLTEMPLATE Script to create dry cluster
moltemplate.sh create.lt
ash /home/markus/pdbtopo create.data ## REPLACE THIS!
mv topo.pdb create.pdb

cp create.pdb ../solvate/
cd ..

# continue in folder solvate to solvate the supramolecular structures
cd solvate

# calculate number of water atoms to fill the box up to a density 1 g/cm**3
python calc_number.py "$Nazo" "$lx" "$ly" "$lz"
N_h2o=$(cat nwater.txt)
echo "$N_h2o"

# edit the PACKMOL script, add input parameters
sed -i s/NWATER/"$N_h2o"/g mixture-solvate.inp
sed -i s/INPUT/create/g mixture-solvate.inp
sed -i s/OUTPUT/create_solv/g mixture-solvate.inp
sed -i s/MYTOL/"$tolerance"/g mixture-solvate.inp
 
smallx=$(bc <<<"scale=5; $lx - 1")
smally=$(bc <<<"scale=5; $ly - 1")
smallz=$(bc <<<"scale=5; $lz - 1")

sed -i s/LX/"$smallx"/g mixture-solvate.inp
sed -i s/LY/"$smally"/g mixture-solvate.inp
sed -i s/LZ/"$smallz"/g mixture-solvate.inp

halfx=$(bc <<<"scale=5; $lx / 2")
halfy=$(bc <<<"scale=5; $ly / 2")
halfz=$(bc <<<"scale=5; $lz / 2 ")

echo $halfx
echo $halfy
echo $halfz

sed -i s/HALFX/"$halfx"/g mixture-solvate.inp
sed -i s/HALFY/"$halfy"/g mixture-solvate.inp
sed -i s/HALFZ/"$halfz"/g mixture-solvate.inp

# execute PACKMOL to perform the solvation
packmol < mixture-solvate.inp
cp create_solv.pdb ../2lmp
cd ..

# move to folder 2lmp to assign correct parameters again with MOLTEMPLATE
# and to convert to LAMMPS format
cd 2lmp
sed -i s/LX/"$lx"/g solvate.lt
sed -i s/LY/"$ly"/g solvate.lt
sed -i s/LZ/"$lz"/g solvate.lt
sed -i s/NUMWATER/"$N_h2o"/g solvate.lt
sed -i s/NUMAZO/"$Nazo"/g solvate.lt

moltemplate.sh -pdb create_solv.pdb solvate.lt

# insert correct parameters in header of LAMMPS file
sh insert_params.sh solvate.data header_azo_spce.txt
mv solvate_param.data "$Nazo"_solvate_param.data
cp "$Nazo"_solvate_param.data ..

cd ..

