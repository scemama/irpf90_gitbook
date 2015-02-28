The Lennard-Jones potential
---------------------------

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
