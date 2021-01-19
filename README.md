# Numerical computation of interval distributions
MATLAB code for the paper "A numerical method for computing interval distributions 
for an inhomogeneous Poisson point process modified by random dead times".

------------------------------------------------------------------------------------
Contents:
------------------------------------------------------------------------------------
(1) "configure_method.m" can be used to define and run the numerical method.

(2) "CODE" directory contains the MATLAB code used in the method. It contains:
     (a) "execute_method.m", which manages each step of the method.
     (b) "COMPARE IMPLEMENTATIONS" directory contains code for showing that the 
         optimized implementations are equivalent to the implementations given in
         the paper.
     (c) "COMPUTE" directory contains code for computing each step given in the
         paper.
     (d) "LIBRARY" directory includes miscellaneous functions for various simple
         tasks.
     (e) "MEX" directory includes the C file and MEX files for implementating one
         particularly demanding step.
     (f) "DEFINED FUNCTIONS" directory includes the defined rate functions and 
         dead-time distributions. New ones can easily be added in the same format.
     (g) "PLOT" directory includes code used for plotting the results of the method.
     (h) "SETUP" directory includes code for setting up various prerequisites.
     (i) "SIMULATIONS" directory includes code for simulating homogeneous and 
         inhomogeneous Poisson point processes and applying random dead times.

(3) The "RESULTS (Peterson 2021)" directory contains figures and MAT files resulting
    for the three example point processes shown in the paper. Note that the
    simulation results shown are for different random realizations than those in the 
    paper, but they are equivalent.
