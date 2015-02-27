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


1. Prepare the working environment
----------------------------------

Create a new directory for the project. Inside this directory, initialize the
IRPF90 environment using:

``` shell
$ irpf90 --init
```

Two directories were created

``` shell
$ ls
IRPF90_man  IRPF90_temp  Makefile
```

and a Makefile containing default parameters for the gfortran compiler

``` makefile
IRPF90 = irpf90  #-a -d
FC     = gfortran
FCFLAGS= -O2 -ffree-line-length-none

SRC=
OBJ=
LIB=

include irpf90.make

irpf90.make: $(filter-out IRPF90_temp/%, $(wildcard */*.irp.f)) $(wildcard *.irp.f) $(wildcard *.inc.f) Makefile
        $(IRPF90)
```

In the Makefile, activate the asserts and the debug options by uncommenting ``-a``
and ``-d`` in the definition of the ``IRPF90`` variable.


2. The Lennard-Jones potential
------------------------------

### Exercise

Write a program which computes the Lennard-Jones potential :

![](EqLennardJones.svg)

The user will be asked for the values of the Lennard-Jones parameters ``sigma_lj``
and ``epsilon_lj``, as well as the ``interatomic_distance``.

Create the main program in a file named ``test.irp.f``, and the providers in
a file named ``potential.irp.f``. You don't need to modify the ``Makefile``.

To compile the program, run

``` shell
$ make
Makefile:9: irpf90.make: No such file or directory
irpf90  -a -d
IRPF90_temp/potential.irp.module.F90
IRPF90_temp/potential.irp.F90
IRPF90_temp/test.irp.module.F90
IRPF90_temp/test.irp.F90
gfortran -I IRPF90_temp/  -O2 -ffree-line-length-none -c IRPF90_temp/test.irp.module.F90 -o IRPF90_temp/test.irp.module.o
gfortran -I IRPF90_temp/  -O2 -ffree-line-length-none -c IRPF90_temp/potential.irp.module.F90 -o IRPF90_temp/potential.irp.module.o
gfortran -I IRPF90_temp/  -O2 -ffree-line-length-none -c IRPF90_temp/test.irp.F90 -o IRPF90_temp/test.irp.o
gfortran -I IRPF90_temp/  -O2 -ffree-line-length-none -c IRPF90_temp/irp_stack.irp.F90 -o IRPF90_temp/irp_stack.irp.o
gfortran -I IRPF90_temp/  -O2 -ffree-line-length-none -c IRPF90_temp/potential.irp.F90 -o IRPF90_temp/potential.irp.o
gfortran -I IRPF90_temp/  -O2 -ffree-line-length-none -c IRPF90_temp/irp_touches.irp.F90 -o IRPF90_temp/irp_touches.irp.o
gfortran -I IRPF90_temp/  -o test IRPF90_temp/test.irp.o IRPF90_temp/test.irp.module.o IRPF90_temp/irp_stack.irp.o  IRPF90_temp/potential.irp.o IRPF90_temp/potential.irp.module.o  IRPF90_temp/irp_touches.irp.o  
```

The warning ``Makefile:9: irpf90.make: No such file or directory``
can be ignored: the missing ``irpf90.make`` will be created by applying
the rule in the ``Makefile`` that calls IRPF90.

A binary file named ``test`` will be created.

``` shell
$ ls
irpf90_entities  IRPF90_man   Makefile         tags  test.irp.f
irpf90.make      IRPF90_temp  potential.irp.f  test
```

### Expected Output

``` shell
$ ./test 
           0 : -> provide_v_lj
           0 :  -> provide_epsilon_lj
           0 :   -> epsilon_lj
 Epsilon?
0.0661
 Sigma?
0.3345
           0 :   <- epsilon_lj  3.63000000000000041E-004
           0 :  <- provide_epsilon_lj  5.41999999999999947E-004
           0 :  -> provide_interatomic_distance
           0 :   -> interatomic_distance
 Inter-atomic distance?
0.3
           0 :   <- interatomic_distance  1.70499999999999992E-003
           0 :  <- provide_interatomic_distance  1.71499999999999994E-003
           0 :  -> v_lj
           0 :  <- v_lj   0.0000000000000000     
           0 : <- provide_v_lj  2.34399999999999973E-003
           0 : -> test
  0.46819241808782769
           0 : <- test   0.0000000000000000   
```

### Solution

File ``test.irp.f``
``` irpf90
program test
  implicit none
  BEGIN_DOC
  ! Test program
  END_DOC
  print *,  V_lj
end
```

File ``potential.irp.f``
``` irpf90
BEGIN_PROVIDER [ double precision, V_lj ]
  implicit none
  BEGIN_DOC
  ! Lennard Jones potential energy.
  END_DOC
  double precision               :: sigma_over_r
  sigma_over_r = sigma_lj / interatomic_distance
  V_lj = 4.d0 * epsilon_lj * ( sigma_over_r**12 - sigma_over_r**6 )
END_PROVIDER

 BEGIN_PROVIDER [ double precision, epsilon_lj ]
&BEGIN_PROVIDER [ double precision, sigma_lj   ]
  implicit none
  BEGIN_DOC
  ! Parameters of the Lennard-Jones potential
  END_DOC
  print *, 'Epsilon?'
  read(*,*) epsilon_lj
  ASSERT (epsilon_lj > 0.)

  print *, 'Sigma?'
  read(*,*) sigma_lj
  ASSERT (sigma_lj > 0.)
END_PROVIDER

BEGIN_PROVIDER [ double precision, interatomic_distance ]
  implicit none
  BEGIN_DOC
  ! Distance between the atoms
  END_DOC
  print *, 'Inter-atomic distance?'
  read (*,*) interatomic_distance
  ASSERT (interatomic_distance >= 0.)
END_PROVIDER
```

3. Describing the atoms
-----------------------

### Exercise

In the same directory, create a program which reads in the standard input:

- The number of atoms
- For each atom: the mass and the *x*, *y*, *z* coordinates

The program will the print the matrix of the distances between atom pairs.

You will have to create :

- A provider for ``Natoms``, the number of atoms
- A provider for ``coord`` and ``mass``, the atom coordinates and mass. These
  are arrays with dimensions ``(3,Natoms)`` and ``(Natoms)`` respectively.
- A provider for ``distance``, the distance matrix. Its dimension is
  ``(Natoms,Natoms)``.

You can check that your code is well documented using the ``irpman`` command:

``` text
$ irpman coord
IRPF90 entities(l)                   coord                   IRPF90 entities(l)

Declaration
       double precision, allocatable :: coord  (3,Natoms)
       double precision, allocatable :: mass   (Natoms)

Description
       Atomic data, input in atomic units.

File
       atoms.irp.f

Needs
       natoms

Needed by
       distance

Instability factor
        50.0 %

IRPF90 entities                      coord                   IRPF90 entities(l)
```

### Expected output

``` shell
$ ./test2 
           0 : -> provide_distance
           0 :  -> provide_natoms
           0 :   -> natoms
 Number of atoms?
3
           0 :   <- natoms  1.59999999999999986E-004
           0 :  <- provide_natoms  3.38000000000000193E-004
           0 :  -> provide_coord
           0 :   -> coord
 For each atom: x, y, z, mass?
0. 0. 0. 40.
1. 2. 3. 10.
-1. 0. 2. 20.
           0 :   <- coord  2.03999999999999754E-004
           0 :  <- provide_coord  3.09999999999999946E-004
           0 :  -> distance
           0 :  <- distance  1.99999999999983177E-006
           0 : <- provide_distance  7.83999999999999975E-004
           0 : -> test2
   0.0000000000000000        3.7416573867739413        2.2360679774997898     
   3.7416573867739413        0.0000000000000000        3.0000000000000000     
   2.2360679774997898        3.0000000000000000        0.0000000000000000     
           0 : <- test2  5.90000000000000246E-005
```

### Solution

File ``test2.irp.f``
``` irpf90
program test2
  implicit none
  BEGIN_DOC
  ! Second test : distance matrix
  END_DOC
  integer                        :: i
  do i=1,Natoms
    print *, distance(1:3,i)
  enddo
end program
```

File ``atoms.irp.f``
``` irpf90
BEGIN_PROVIDER [ integer, Natoms ]
  implicit none
  BEGIN_DOC
  ! Number of atoms
  END_DOC
  print *, 'Number of atoms?'
  read(*,*) Natoms
  ASSERT (Natoms > 0)
END_PROVIDER

 BEGIN_PROVIDER [ double precision, coord, (3,Natoms) ]
&BEGIN_PROVIDER [ double precision, mass , (Natoms)   ]
  implicit none
  BEGIN_DOC
  ! Atomic data, input in atomic units.
  END_DOC
  print *, 'For each atom: x, y, z, mass?'
  integer                        :: i,j  ! <-- Variables can be declared
                                         !     anywhere
  do i=1,Natoms
    read(*,*) (coord(j,i), j=1,3), mass(i)
    ASSERT (mass(i) > 0.d0)
  enddo
END_PROVIDER

BEGIN_PROVIDER [ double precision, distance, (Natoms,Natoms) ]
  implicit none
  BEGIN_DOC
  ! distance : Distance matrix 
  END_DOC
  integer                        :: i,j,k
  do i=1,Natoms
    do j=1,Natoms
      distance(j,i) = 0.d0
      do k=1,3
        distance(j,i) += (coord(k,i)-coord(k,j))**2  ! <-- Note the increment
                                                     !     operator +=
      enddo
      distance(j,i) = dsqrt(distance(j,i))
    enddo
  enddo
END_PROVIDER
```

4. Potential for multiple particles
-----------------------------------

### Exercise

Change the provider of ``V_lj`` of the first program. Now, instead of computing
the Lennard-Jones potential of a single inter-atomic distance *r*, you will
compute the total potential energy which is the sum of the potential energies
due to each pair of atoms:

![](EqLennardJones2.svg)

The dependencies have changed now, as your new version of ``V_lj`` needs the
previously defined distance matrix ``distance``. You can now run again the
first program.

### Expected output

``` text
$ ./test
           0 : -> provide_v_lj
           0 :  -> provide_epsilon_lj
           0 :   -> epsilon_lj
 Epsilon?
0.0661
 Sigma?
0.3345
           0 :   <- epsilon_lj  3.06000000000000022E-003
           0 :  <- provide_epsilon_lj  3.07300000000000021E-003
           0 :  -> provide_natoms
           0 :   -> natoms
 Number of atoms?
3
           0 :   <- natoms   0.0000000000000000     
           0 :  <- provide_natoms   0.0000000000000000     
           0 :  -> provide_distance
           0 :   -> provide_coord
           0 :    -> coord
 For each atom: x, y, z, mass?
0 0 0 10
0 0 .3 20
.1 .2 -.3 15
           0 :    <- coord   0.0000000000000000     
           0 :   <- provide_coord   0.0000000000000000     
           0 :   -> distance
           0 :   <- distance   0.0000000000000000     
           0 :  <- provide_distance   0.0000000000000000     
           0 :  -> v_lj
           0 :  <- v_lj   0.0000000000000000     
           0 : <- provide_v_lj  3.08900000000000017E-003
           0 : -> test
  0.39685690695535791     
           0 : <- test   0.0000000000000000 
```

### Solution

File ``potential.irp.f``
``` irpf90
BEGIN_PROVIDER [ double precision, V ]
  implicit none
  BEGIN_DOC
  ! Potential energy.
  END_DOC
  V = V_lj
END_PROVIDER

BEGIN_PROVIDER [ double precision, V_lj ]
  implicit none
  BEGIN_DOC
  ! Lennard Jones potential energy.
  END_DOC
  integer                        :: i,j
  double precision               :: sigma_over_r
  V_lj = 0.d0
  do i=1,Natoms
    do j=i+1,Natoms
      ASSERT (distance(j,i) > 0.d0)   ! <-- Avoid a possible division by zero
      sigma_over_r = sigma_lj / distance(j,i)
      V_lj += sigma_over_r**12 - sigma_over_r**6
    enddo
  enddo
  V_lj *= 4.d0 * epsilon_lj  ! <-- Note the *= operator
END_PROVIDER

 BEGIN_PROVIDER [ double precision, epsilon_lj ]
&BEGIN_PROVIDER [ double precision, sigma_lj   ]
  implicit none
  BEGIN_DOC
  ! Parameters of the Lennard-Jones potential
  END_DOC
  print *, 'Epsilon?'
  read(*,*) epsilon_lj
  ASSERT (epsilon_lj > 0.)

  print *, 'Sigma?'
  read(*,*) sigma_lj
  ASSERT (sigma_lj > 0.)
END_PROVIDER
```

5. Total energy
---------------

### Exercise

Write a program which prints the total energy of the system.

![](EqEtot.svg)

``V`` is the potential (Lennard-Jones here) and ``T`` is the kinetic energy

![](EqKinetic.svg)

Write the providers for the kinetic energy and for the total energy. All the velocities
will be chosen to be initialized equal to zero in the ``velocities`` provider.
Remember you already have the provider for the masses of the atoms.

### Expected output

``` text
$ ./test3 
           0 : -> provide_e_tot
           0 :  -> provide_t
           0 :   -> provide_velocity2
           0 :    -> provide_velocity
           0 :     -> provide_natoms
           0 :      -> natoms
 Number of atoms?
3
           0 :      <- natoms  1.58999999999999853E-004
           0 :     <- provide_natoms  3.39000000000000325E-004
           0 :     -> velocity
           0 :     <- velocity  5.99999999999992900E-006
           0 :    <- provide_velocity  4.89000000000000285E-004
           0 :    -> velocity2
           0 :    <- velocity2  5.00000000000022995E-006
           0 :   <- provide_velocity2  6.57000000000000032E-004
           0 :   -> provide_coord
           0 :    -> coord
 For each atom: x, y, z, mass?
0 0 0 10
0 0 .3 20
.1 .2 -.3 15
           0 :    <- coord  1.97999999999999825E-004
           0 :   <- provide_coord  2.89999999999999893E-004
           0 :   -> t
           0 :   <- t  9.99999999999699046E-007
           0 :  <- provide_t  1.04999999999999972E-003
           0 :  -> provide_v
           0 :   -> provide_v_lj
           0 :    -> provide_epsilon_lj
           0 :     -> epsilon_lj
 Epsilon?
0.0661
 Sigma?
.3345
           0 :     <- epsilon_lj  2.07999999999999852E-004
           0 :    <- provide_epsilon_lj  3.02000000000000185E-004
           0 :    -> provide_distance
           0 :     -> distance
           0 :     <- distance  2.00000000000026545E-006
           0 :    <- provide_distance  3.69999999999997067E-005
           0 :    -> v_lj
           0 :    <- v_lj  1.00000000000013273E-006
           0 :   <- provide_v_lj  4.32999999999999791E-004
           0 :   -> v
           0 :   <- v  1.00000000000013273E-006
           0 :  <- provide_v  4.75000000000000595E-004
           0 :  -> e_tot
           0 :  <- e_tot  1.00000000000013273E-006
           0 : <- provide_e_tot  1.60399999999999996E-003
           0 : -> test3
  0.39685690695535791     
           0 : <- test3  1.19999999999998580E-005
```

### Solution

File ``test3.irp.f``
``` irpf90
program test3
  implicit none
  BEGIN_DOC
  ! Prints the total energy
  END_DOC
  print *,  E_tot
end program
```

File ``energy.irp.f``
```irpf90
BEGIN_PROVIDER [ double precision, E_tot ]
  implicit none
  BEGIN_DOC
  ! Total energy of the system
  END_DOC
  E_tot = T + V
END_PROVIDER
```

File ``velocity.irp.f``
``` irpf90
BEGIN_PROVIDER [ double precision, T ]
  implicit none
  BEGIN_DOC
  ! Kinetic energy per atom
  END_DOC
  T = 0.d0
  integer                        :: i
  do i=1,Natoms
    T += mass(i) * velocity2(i)
  enddo
  T *= 0.5d0
END_PROVIDER

BEGIN_PROVIDER [ double precision, velocity2, (Natoms) ]
  implicit none
  BEGIN_DOC
  ! Square of the norm of the velocity per atom
  END_DOC
  integer                        :: i, k
  do i=1,Natoms
    velocity2(i) = 0.d0
    do k=1,3
      velocity2(i) += velocity(k,i)*velocity(k,i)
    enddo
  enddo
END_PROVIDER

BEGIN_PROVIDER [ double precision, velocity, (3,Natoms) ]
  implicit none
  BEGIN_DOC
  ! Velocity vector per atom
  END_DOC
  integer                        :: i, k
  do i=1,Natoms
    do k=1,3
      velocity(k,i) = 0.d0
    enddo
  enddo
END_PROVIDER
```

