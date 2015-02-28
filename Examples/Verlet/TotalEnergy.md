Computing the total energy
--------------------------

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

