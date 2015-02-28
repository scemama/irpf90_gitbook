Potential for multiple particles
--------------------------------

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

