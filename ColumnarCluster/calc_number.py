import math
import numpy as np
import sys


print('Number of arguments:', len(sys.argv), 'arguments.')
print('Argument List:', str(sys.argv))

# goal density
rho = 1.0000 # g / cm**3

# volume
Lx = float(sys.argv[2]) # \AA
Ly = float(sys.argv[3]) # \AA 
Lz = float(sys.argv[4]) # \AA
V  = Lx*Ly*Lz

#centi -> 10 ->  milli -> 1000 -> mikro -> 1000 -> nano -> 10-> angstrom 
#         10**(3+9+9+3) = 10**24
vfactor = 1./1e+24 # from \AA**3 to cm**3


# solutes = Azostars

#N_azo = 32 
#N_azo = np.fromstring(sys.argv[1], dtype=int)
N_azo = float(sys.argv[1])
print("N_azo: ", N_azo)
m_azo = 877.026 # g / mol


# solvent = water
m_h2o = 18.0150 # g / mol


mfactor = 1./6.02214086e+23 # from g / mol to g   = 1/N_A = one over Avogadro constant

N_h2o = (rho*V*vfactor - m_azo*mfactor*N_azo)/(m_h2o*mfactor)
N_h2o_int = np.around(N_h2o).astype(np.int)


#print(N_h2o)
#print(np.rint(N_h2o))
#print(np.around(N_h2o).astype(np.int))
print(N_h2o_int)

#np.savetxt('nmolecules.txt', )
#np.savetxt('nmolecules.txt', np.array([N_h2o_int]))

f = open("nwater.txt", "w")
#f.write("Woops! I have deleted the content!")
f.write("%d" % (N_h2o_int) )
f.close()


