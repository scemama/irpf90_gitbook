Tutorial : A molecular dynamics code
====================================

Molecular dynamics models the movement of atoms according to their initial
positions and velocities. In this tutorial, we will write a molecular dynamics
program to illustrate how to use IRPF90. This program will read the force field
parameters from an input file, as well as the initial positions of the atoms.
After each little displacement of the atoms according to their velocities, the
new set of coordinates will be printed into an output file such that a video
animation can easily be produced with an external tool.

Here is the list of what we will have to code:

* The potential energy of a couple of atoms (Lennard-Jones potential). This will
  will be a very simple introduction to IRPF90.
* The potential and kinetic energy of system of *N* atoms. We will have to create
  arrays dimensioned by other IRP entities.
* The acceleration of the particles using finite differences for the calculation
  of derivatives. This part will introduce the ``TOUCH`` keyword.
* The Verlet algorithm to make everything move.

The first thing you will have to do is download IRPF90 from the web site:
http://irpf90.ups-tlse.fr 


Physical Parameters
-------------------

For all this tutorial, we will use Argon atoms with the following parameters:

- mass : 39.948 g/mol
- epsilon : 0.0661 j/mol
- sigma : 0.3345 nm

The atom coordinates are given in nanometers.


